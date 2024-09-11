self := "just --justfile '" + justfile() + "'"
parallel := "parallel --shebang --tag --linebuffer --jobs " + env('JOB_COUNT', num_cpus()) + " -r"
pantheon_org := "brown-university-web-services"

alias t := terminus
# Run Terminus in parallel on site envs, e.g. `just terminus -t canary -d dev upstream:updates:apply`. Use `-s` to run sequentially. [options: --tag|-t, --env|-e, --seq|-s]
[positional-arguments]
@terminus *args:
    eval "$({{ self }} _build-taggable-command _terminus {{ args }})"

alias d := drush
# Run Drush in parallel on site envs, e.g. `just drush -t canary -d dev status`. Use `-s` to run sequentially. [options: --tag|-t, --env|-e, --seq|-s]
[positional-arguments]
@drush *args:
    eval "$({{ self }} _build-taggable-command _drush {{ args }})"

# Get a list of sites tagged with `tag`
@sites-with-tag tag:
    echo "$(terminus org:sites "{{ pantheon_org }}" --tag="{{ tag }}" --format=list --field=name)"

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
run-post-deploy-d10-steps site-env:
    yes | terminus drush "{{ site-env }}" updb
    yes | terminus drush "{{ site-env }}" config:import
    yes | terminus drush "{{ site-env }}" config:import
    yes | terminus drush "{{ site-env }}" cache:rebuild

# Upgrade a single `site-env` to D10, e.g. `just upgrade-site-to-d10 brownu-dcloud.dev`
upgrade-site-to-d10 site-env: (prep-site-for-d10 site-env) && (run-post-deploy-d10-steps site-env)
    terminus upstream:updates:apply --accept-upstream "{{ site-env }}"

# Upgrade a list of `sites` to D10 in parallel. `sites` is a list of site names with an environment, e.g. brownu-dcloud.dev
# @TODO -n here makes this operate in dry run mode
upgrade-sites-to-d10 sites: (_parallel (self + " -n upgrade-site-to-d10") sites)

# Upgrade all `env` sites in `tag` to D10 in parallel, e.g. `just upgrade-tag-to-d10 canary dev`
[confirm("Are you sure you want to upgrade all sites in tag to D10?")]
@upgrade-tag-to-d10 tag env="dev":
    sites="$({{ self }} site-envs-with-tag "{{ tag }}" "{{ env }}")"; \
    {{ self }} upgrade-sites-to-d10 "$sites"

# Get the site name and it's current HEAD revision hash for sites in `tag` on their `env` environment
@get-current-head-hash tag env:
    #!/usr/bin/env bash
    sites="$({{ self }} site-envs-with-tag "{{ tag }}" "{{ env }}")"
    for site in $sites; do
        hash="$(terminus env:code-log "$site" --field=hash | head -1)"
        echo "Site: $site Hash: $hash"
    done

_parallel command args:
    #!/usr/bin/env -S {{ parallel }} {{ command }}
    {{ args }}

@_terminus sites +args: (_parallel ("terminus -- " + args) sites)
@_terminus-by-tag tag env +args:
    sites="$({{ self }} site-envs-with-tag "{{ tag }}" "{{ env }}")"; \
    {{ self }} _terminus "$sites" {{ args }}

@_drush sites +args: (_terminus sites "drush {}" args)
@_drush-by-tag tag env +args:
    sites="$({{ self }} site-envs-with-tag "{{ tag }}" "{{ env }}")"; \
    {{ self }} _drush "$sites" {{ args }}

@_ensure-npm-dependency package:
    if ! npm list -g --depth 1 "{{ package }}" > /dev/null; then npm install -g "{{ package }}"; fi

export NODE_PATH := `npm root -g`
[positional-arguments]
_build-taggable-command recipe *args: (_ensure-npm-dependency "minimist")
    #!/usr/bin/env node
    const argv = require("minimist")(process.argv.slice(3), {
        alias: { seq: "s", tag: "t", env: "e" },
        boolean: ["s", "seq"],
    });
    let command = "";

    if (argv.seq) {
        command += "JOB_COUNT=1 "
    }
    command += "{{ self }} "

    if (argv.tag) {
        if (!argv.env) {
            console.error("{{ error }} You must use --env|-e when using --tag|-t")
        } else {
            command += `{{ recipe }}-by-tag ${argv.tag} ${argv.env} ${argv._.join(" ")}`;
        }
    } else {
        command += `{{ recipe }} ${argv._.join(" ")}`;
    }

    console.log(command);
