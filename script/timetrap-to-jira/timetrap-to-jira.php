#!/usr/bin/php
<?php
date_default_timezone_set('America/New_York');
require_once __DIR__ . '/vendor/autoload.php';

$configPath = str_replace('~', posix_getpwuid(posix_getuid())['dir'], '~/.timetrap-to-jira.json');

if (!file_exists($configPath)) {
    echo "Config file not found\n";
    exit(1);
}

$configReader = new Zend\Config\Reader\Json();
$config       = $configReader->fromFile($configPath);

$dbPath = str_replace('~', posix_getpwuid(posix_getuid())['dir'], $config['db']);

$db = new Zend\Db\Adapter\Adapter([
    'driver'   => 'Pdo_Sqlite',
    'database' => $dbPath,
]);

if ($argc === 1) {
    $date = new DateTimeImmutable();
} else {
    switch (trim($argv[1])) {
        case 'y':
        case 'yest':
        case 'yesterday':
            $date = new DateTimeImmutable('-1 day');
            break;
        default:
            $date = new DateTimeImmutable(trim($argv[1]));
            break;
    }
}

$entries = $db->query('SELECT * FROM entries WHERE ? BETWEEN DATE(start) AND DATE(end) ORDER BY start', [
    $date->format('Y-m-d')
])->toArray();

$console = Zend\Console\Console::getInstance();

echo "Transfering times to JIRA…\n";
$console->writeLine(str_repeat('-', 79), Zend\Console\ColorInterface::YELLOW);

$minTime = $date->setTime(0, 0, 0);
$maxTime = $date->setTime(23, 59, 59);

foreach ($entries as $entry) {
    if (!in_array($entry['sheet'], $config['sheets'])) {
        continue;
    }

    $start = new DateTime($entry['start']);
    $end   = new DateTime($entry['end']);

    if ($start < $minTime) {
        $start = clone $minTime;
    }

    if ($end > $maxTime) {
        $end = clone $maxTime;
    }

    list($hours, $minutes, $seconds) = explode(':', $start->diff($end)->format('%H:%I:%S'));

    if ($hours == 0 && $minutes < 15) {
        $minutes = 15;
    } else {
        $x = floor($minutes / 15) * 15;
        $y = $minutes % 15;

        if ($y >= 5) {
            $x += 15;
        }

        $minutes = $x;

        if ($minutes > 59) {
            $minutes = 0;
            $hours++;
        }
    }

    $timeSpent = sprintf('%dh %dm', $hours, $minutes);

    printf("%s - %s\n", $timeSpent, $entry['note']);

    $timeSpentSeconds = $hours * 3600;
    $timeSpentSeconds += $minutes * 60;

    if (preg_match('(([\d\w]{2,}-\d+))', $entry['note'], $matches)) {
        $issueNumber = $matches[1];
        $note        = trim(preg_replace('(([\d\w]{2,}-\d+))', '', $entry['note']));

        printf("Found issue number: %s\n", $issueNumber);
    } else {
        $note = $entry['note'];

        echo 'Please enter issue number: ';
        $issueNumber = trim($console->readLine());
    }

    if (strpos($issueNumber, 'OTT') === 0) {
        printf("Skipping OTT time...\n");
        continue;
    }

    while (true) {
        $client = new GuzzleHttp\Client();
        $response = $client->post($config['host'] . '/2/worklogs', [
            'headers' => [
                'Authorization' => 'Bearer ' . $config['tempo_token'],
            ],
            'json' => [
                'issueKey' => $issueNumber,
                'authorUsername' => $config['username'],
                'description' => $note,
                'startDate' => preg_replace('(\.(\d{3})\d+)', '.\1', $start->format('Y-m-d')),
                'timeSpentSeconds' => $timeSpentSeconds,
            ],
        ]);

        if (isset($result['errorMessages'][0])) {
            $console->writeLine($result['errorMessages'][0], Zend\Console\ColorInterface::RED);
            echo 'Please enter issue number: ';
            $issueNumber = trim($console->readLine());
        } else {
            break;
        }
    }

    $console->writeLine('Time transfered', Zend\Console\ColorInterface::GREEN);
    $console->writeLine(str_repeat('-', 79), Zend\Console\ColorInterface::YELLOW);
}
