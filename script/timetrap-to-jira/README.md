# Timetrap To JIRA

This is a simple utility to transfer your times logged via timetrap to JIRA. To
set it up, copy the file ```example.timetrap-to-jira.json``` to the following
location and fill in all values: ```~/.timetrap-to-jira.json```.

If you install this package from source, you must also run
```composer install``` to install all dependencies. After that, you can
additionally symlink the ```timetrap-to-jira.php``` executable to into a
```bin``` folder on your PATH.

## Time rounding
All times are automatically rounded to 15 minute blocks before transfer. Values
are rounded down when below 5 minutes and rounded up above. If a time entry is
small than 15 minutes, it is always rounded up.

## Automatic issue linking
This tool has automatic issue number recognition support. Simply place the
corresponding issue number prefixed with an ```@``` in your log messages. That
hint will be removed on transfer and the rest of the message used as the worklog
comment. If you don't place an issue hint in the log message, the tool will
prompt your for a ticket number on transfer.