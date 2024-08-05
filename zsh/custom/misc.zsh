alias work="cd ~/dev/oomph"
alias dotfiles="cd ~/dotfiles"
alias php5="brew unlink php72; brew link --force php@5.6"
alias php7="brew unlink php@5.6; brew link php72"

# Ignore .retry ansible files
zstyle ':completion:*:*:nvim:*:*files' ignored-patterns '*.retry'

function dsf() {
    diff -u "$@" | diff-so-fancy
}

function phpactor-enable() {
    lando composer config --json extra.autoload-drupal.modules '["app/modules/contrib", "app/modules/custom", "app/core/modules"]' \
        && lando composer config --json allow-plugins.fenetikm/autoload-drupal true \
        && lando composer require fenetikm/autoload-drupal \
        && lando composer dump-autoload
}

function phpactor-disable() {
    lando composer remove fenetikm/autoload-drupal \
        && lando composer --unset extra.autoload-drupal \
        && lando composer --unset allow-plugins.fenetikm/autoload-drupal \
        && lando composer dump-autoload
}
