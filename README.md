# Oh-my-Hammerspoon!

## A configuration framework for [Hammerspoon](http://www.hammerspoon.org)

Very early work in progress, feedback very welcome.

### Instructions

1. Check out this repository onto your `~/.hammerspoon` directory:

   ```
   git clone https://github.com/zzamboni/oh-my-hammerspoon.git ~/.hammerspoon
   ```
2. Edit `init.lua` to enable/disable the plugins you want (at the
   moment they are all enabled by default).
3. Copy `init-local-sample.lua` to `init-local.lua` and modify to
   change plugin configuration parameters or add your own arbitrary code.

### Functionality included

This config has already replaced my use of the following apps:

- [ClipMenu](http://www.clipmenu.com) - clipboard history, supporting
  both text and image entries. See 
  [clipboard.lua](plugins/misc/clipboard.lua).
  - `Shift-Cmd-v` shows the clipboard menu.
- [Choosy](https://www.choosyosx.com) and other URL dispatchers -
  allows opening URLs in different applications depending on regular
  expression matching. Great if you use site-specific browsers created
  with [Epichrome](https://github.com/dmarmor/epichrome) or
  [Fluid](http://fluidapp.com). See
  [url_handling.lua](plugins/misc/url_handling.lua).
- [Breakaway](http://www.macupdate.com/app/mac/23361/breakaway) -
  automatically pause/unpause music when headphones are
  unplugged/replugged. Only for Spotify app at the moment, and it
  needs latest Hammerspoon built from source (which includes the audio
  device watcher). See
  [headphones_watcher.lua](plugins/audio/headphones_watcher.lua).
- [Spectacle](https://www.spectacleapp.com) - window
  manipulation. Only some shortcuts implemented, those that I use, but
  others should be easy to add.  See
  [manipulation.lua](plugins/windows/manipulation.lua).
  - `Ctrl-Cmd-left/right/up/down` - resize the current window to the
    corresponding half of the screen.
  - `Ctrl-Alt-left/right/up/down` - resize and move the current window
    to the previous/next horizontal/vertical third of the screen.
  - `Ctrl-Alt-Cmd-F` or `Ctrl-Alt-Cmd-up` - maximize the current window.
  - `Ctrl-Alt-Cmd-left/right` - move the current window to the
    previous/next screen (if more than one monitor is plugged in).
- [ShowyEdge](https://pqrs.org/osx/ShowyEdge/index.html.en) - menu bar
  coloring to indicate the currently selected keyboard layout (again,
  only the indicators I use are implemented, but others are very easy
  to add). See
  [menubar_indicator.lua](plugins/keyboard/menubar_indicator.lua).

It additionally provides the following functionality:

- "Universal Archive"
  ([universal_archive.lua](plugins/apps/universal_archive.lua)) for
  archiving the current item in different applications. At the moment
  Evernote and Mail.app are supported.
- Automatic/manual configuration reloading ([hammerspoon_config_reload.lua](plugins/apps/hammerspoon_config_reload.lua))
  - `Ctrl-Alt-Cmd-r` - manual reload, or when any `*.lua` file in
    `~/.hammerspoon/` changes.
- A color sampler/picker ([colorpicker.lua](plugins/misc/colorpicker.lua))
  - `Ctrl-Alt-Cmd-c` toggles a full-screen color picker of the colors in
    `hs.drawing.color` (this is more impressive with a larger list of
    colors, like the one in
    [PR#611](https://github.com/Hammerspoon/hammerspoon/pull/611/files)). Clicking
    on any color will copy its name to the clipboard, Cmd-clicking
    copies its RGB code.
- Mouse locator ([mouse/locator.lua](plugins/mouse/locator.lua)).
  - `Ctrl-Alt-Cmd-d` draws a red circle around the mouse for 3 seconds.
- Skype mute/unmute ([skype_mute.lua](plugins/apps/skype_mute.lua))
  - `Ctrl-Alt-Cmd-Shift-v` mutes/unmutes Skype, regardless of whether
    it's the frontmost application.

It has drawn inspiration and code from many other places, including:

- [victorso's clipboard manager](http://github.com/victorso/.hammerspoon)
- [cmsj's hammerspoon config](http://github.com/cmsj/hammerspoon-config)
- [Hammerspoon's sample configurations page](https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations)
- [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) and
  [oh-my-fish](http://github.com/oh-my-fish/oh-my-fish) for the name inspiration :)
