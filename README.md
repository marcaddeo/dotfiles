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
$ git clone --recursive git@github.com:marcaddeo/dotfiles.git ~/dotfiles
$ ~/dotfiles/script/install
```

## Functionality

### Task tracking with a modified [`t`]
![](https://github.com/marcaddeo/dotfiles/blob/master/images/screenshots/t.png)

I modified [`t`] to add priorities and color coding based on priority. The number
of unfinished tasks is also shown in my tmux statusline.

#### tf: finish a task using [`fzf`] to select it
![](https://github.com/marcaddeo/dotfiles/blob/master/images/screenshots/tf.gif)

## TODO
- [ ] Document in the README what is included in these dotfiles
- [ ] Make my time tracking scripts more DRY
- [x] Separate the tasks and timetrap directories into their own repositories and add them as submodules
- [ ] Figure out how to handle idle time tracking when the computer sleeps
- [ ] Add "sensible defaults" for OS X in the bootstrap script
- [ ] Add more GIFs of the functions
- [ ] Add Alfred preferences
- [ ] Add Bartender preferences
- [ ] Add Caffeine preferences
- [ ] Add Spotify Notifcations preferences
- [ ] Look into using [`fasd`]

## License
dotfiles is copyright © 2015 Marc Addeo. It is free software, and may be
redistributed under the terms specified in the [`LICENSE`] file.

[`LICENSE`]: /LICENSE
[`t`]: https://github.com/sjl/t
[`fzf`]: https://github.com/junegunn/fzf
[`fasd`]: https://github.com/clvv/fasd
