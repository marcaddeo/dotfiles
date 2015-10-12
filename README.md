# dotfiles

## Bootstrapping OS X

### Requirements

First, install any OS X updates. Then install the Xcode Command Line Tools with
`xcode-select --install`.

### Bootstrapping

Paste this into the terminal

```bash
bash -c "$(curl -L https://raw.githubusercontent.com/marcaddeo/dotfiles/master/script/bootstrap)"
```

## Installing dotfiles
Note: this is only necessary when not using the bootstrap script.

```bash
$ git clone git@github.com:marcaddeo/dotfiles.git ~/dotfiles
$ ~/dotfiles/script/install
```

## License
dotfiles is copyright © 2015 Marc Addeo. It is free software, and may be
redistributed under the terms specified in the [`LICENSE`] file.

[`LICENSE`]: /LICENSE
