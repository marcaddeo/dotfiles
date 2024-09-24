self := "just --justfile '" + justfile() + "'"
parallel := "parallel --shebang --tag --linebuffer --jobs " + env('JOB_COUNT', num_cpus()) + " -r"
pantheon_org := "brown-university-web-services"
get_backup_command := 'backup:list {} --filter="file*=database&&file*=' + `gdate -d "yesterday" +"%F"` + '" --format=string --fields=file'

alias t := terminus
# Run Terminus in parallel on site envs, e.g. `just terminus -t canary -d dev upstream:updates:apply`. Use `-s` to run sequentially. [options: --tag|-t, --env|-e, --seq|-s]
[positional-arguments]
@terminus *args:
    eval "$({{ self }} _build-taggable-command _terminus {{ args }})"

alias d := drush
# Run Drush in parallel on site envs, e.g. `just drush -t canary -d dev status`. Use `-s` to run sequentially. [options: --tag|-t, --env|-e, --seq|-s]
[positional-arguments]
@drush *args:
    eval "$({{ self }} _build-taggable-command _drush $(printf ' "%q"' "$@" | cut -b2-))"

# Get a list of sites tagged with `tag`
@sites-with-tag tag:
    echo "$(terminus org:sites "{{ pantheon_org }}" --filter="framework=drupal8" {{ if tag == "all" { "" } else { "--tag=" + tag } }} --format=list --field=name)"

# Get a list of sites tagged with `tag` with .env appended, e.g. brownu-dcloud.dev
@site-envs-with-tag tag env="dev":
    sites="$({{ self }} sites-with-tag "{{ tag }}")"; \
    sites="$(echo "$sites" | sed 's/$/.{{ env }}/')"; \
    echo "$sites"

# Prep a site for D10 upgrade
prep-site-for-d10 site-env:
    yes | terminus drush "{{ site-env }}" config:set system.theme admin gin
    terminus drush "{{ site-env }}" theme:uninstall bartik seven stable classy
    terminus drush "{{ site-env }}" pm:install ckeditor5
    terminus drush "{{ site-env }}" pm:uninstall ckeditor_codemirror ckeditor_config ckeditor_responsive_plugin ckeditor

# Run normal post deploy steps on a D10 upgrade testing site
run-post-deploy-steps site-env:
    yes | terminus drush "{{ site-env }}" updb
    yes | terminus drush "{{ site-env }}" config:import
    yes | terminus drush "{{ site-env }}" config:import
    yes | terminus drush "{{ site-env }}" cache:rebuild

# Upgrade a single `site-env` to D10, e.g. `just upgrade-site-to-d10 brownu-dcloud.dev`
#upgrade-site-to-d10 site-env: (prep-site-for-d10 site-env) && (run-post-deploy-d10-steps site-env)
upgrade-site-to-d10 site-env: && (run-post-deploy-steps site-env)
    terminus upstream:updates:apply --accept-upstream "{{ site-env }}"

# Upgrade a list of `sites` to D10 in parallel. `sites` is a list of site names with an environment, e.g. brownu-dcloud.dev
# @TODO -n here makes this operate in dry run mode
upgrade-sites-to-d10 sites: (_parallel (self + " -n upgrade-site-to-d10") sites)

# Upgrade all `env` sites in `tag` to D10 in parallel, e.g. `just upgrade-tag-to-d10 canary dev`
[confirm("Are you sure you want to upgrade all sites in tag to D10?")]
@upgrade-tag-to-d10 tag env="dev":
    sites="$({{ self }} site-envs-with-tag "{{ tag }}" "{{ env }}")"; \
    {{ self }} upgrade-sites-to-d10 "$sites"

# Get the latest commit hash on site environment `env` in `tag`.
@latest-commit-by-tag tag env="dev": (_terminus-by-tag tag env "env:code-log {} --field=hash | head -n1")

# Get the latest db backup on site environment `env` in `tag`.
@latest-db-backup-by-tag tag env="live": (_terminus-by-tag tag env get_backup_command)

cmd := quote('sql:query "SHOW TABLES LIKE \"%ACQUIA%\"" 2>/dev/null | awk NF')
@find-acquia-tables-by-tag tag env="live": (_drush-by-tag tag env cmd)

cmd2 := quote('sql:query "select COUNT(*) from menu_link_content_data where menu_name = \"alternative-sidebar\";" 2>/dev/null | awk NF | cat')
@find-alternative-sidebar-usage tag env="live": (_drush-by-tag tag env cmd2)

_parallel command args:
    #!/usr/bin/env -S {{ parallel }} '{{ command }}'
    {{ args }}

@_terminus sites +args: (_parallel ("terminus " + args + " -- ") sites)
@_terminus-by-tag tag env +args:
    sites="$({{ self }} site-envs-with-tag "{{ tag }}" "{{ env }}")"; \
    {{ self }} _terminus "$sites" {{ quote(args) }}

@_drush sites +args: (_terminus sites "drush {}" args)
@_drush-by-tag tag env +args:
    sites="$({{ self }} site-envs-with-tag "{{ tag }}" "{{ env }}")"; \
    {{ self }} _drush "$sites" {{ args }}

@_ensure-npm-dependency package:
    if ! npm list -g --depth 1 "{{ package }}" > /dev/null; then npm install -g "{{ package }}"; fi

export NODE_PATH := `npm root -g`
[no-exit-message]
[positional-arguments]
_build-taggable-command recipe *args: (_ensure-npm-dependency "minimist") (_ensure-npm-dependency "shell-quote")
    #!/usr/bin/env node
    const quote = require("shell-quote/quote");
    const argv = require("minimist")(process.argv.slice(3), {
        alias: { seq: "s", tag: "t", env: "e" },
        default: { env: "dev" },
        boolean: ["s", "seq"],
        stopEarly: true,
    });

    let command = "";
    if (argv.seq) {
        command += "JOB_COUNT=1 ";
    }
    command += "{{ self }} {{ recipe }}";

    if (argv.tag && argv.env) {
        command += `-by-tag ${argv.tag} ${argv.env}`;
    }

    command += ` ${argv._.join(" ")}`;

    console.log(command);
