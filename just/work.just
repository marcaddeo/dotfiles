# Prep a site for D10 upgrade
prep-site-for-d10 site-name:
    yes | terminus drush "{{ site-name }}" config:set system.theme admin gin
    terminus drush "{{ site-name }}" theme:uninstall bartik seven stable classy
    terminus drush "{{ site-name }}" pm:install ckeditor5
    terminus drush "{{ site-name }}" pm:uninstall ckeditor_codemirror ckeditor_config ckeditor_responsive_plugin ckeditor

# Run normal post deploy steps on a D10 upgrade testing site
run-post-deploy-d10-steps site-name:
    yes | terminus drush "{{ site-name }}" updb
    yes | terminus drush "{{ site-name }}" config:import
    yes | terminus drush "{{ site-name }}" config:import
    yes | terminus drush "{{ site-name }}" cache:rebuild
