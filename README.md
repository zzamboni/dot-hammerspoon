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
   change plugin configuration parameters or add your own arbitrary
   code. Refer to the configuration block of each plugin (near the top
   of its source file, usually) for the available configuration
   parameters.

### Functionality included

This config has already replaced my use of the following apps:

- [ClipMenu](http://www.clipmenu.com) - clipboard history, supporting
  only text entries for now. See 
  [clipboard.lua](plugins/misc/clipboard.lua).
  - `Shift-Cmd-v` shows the clipboard menu by default.
- [Choosy](https://www.choosyosx.com) and other URL dispatchers -
  allows opening URLs in different applications depending on regular
  expression matching. Great if you use site-specific browsers created
  with [Epichrome](https://github.com/dmarmor/epichrome) or
  [Fluid](http://fluidapp.com). See
  [url_handling.lua](plugins/misc/url_handling.lua).
- [Breakaway](http://www.macupdate.com/app/mac/23361/breakaway) -
  automatically pause/unpause music when headphones are
  unplugged/replugged. Supports Spotify and iTunes at the
  moment. See
  [headphones_watcher.lua](plugins/audio/headphones_watcher.lua).
- [Spectacle](https://www.spectacleapp.com) - window
  manipulation. Only some shortcuts implemented, those that I use, but
  others should be easy to
  add. See [manipulation.lua](plugins/windows/manipulation.lua)
  and [grid.lua](plugins/windows/grid.lua).
  - `Ctrl-Cmd-left/right/up/down` - resize the current window to the
    corresponding half of the screen.
  - `Ctrl-Alt-left/right/up/down` - resize and move the current window
    to the previous/next horizontal/vertical third of the screen.
  - `Ctrl-Alt-Cmd-F` or `Ctrl-Alt-Cmd-up` - maximize the current window.
  - `Ctrl-Alt-Cmd-left/right` - move the current window to the
    previous/next screen (if more than one monitor is plugged in).
  - `Ctrl-Alt-Cmd-g` overlays a grid on top of the current screen -
    press the keys corresponding to the top-left and bottom-right
    corners you want, and the current window will be resized to fit.
- [ShowyEdge](https://pqrs.org/osx/ShowyEdge/index.html.en) - menu bar
  coloring to indicate the currently selected keyboard layout (again,
  only the indicators I use are implemented, but others are very easy
  to add). See
  [menubar_indicator.lua](plugins/keyboard/menubar_indicator.lua).

It additionally provides the following functionality:

- "Universal Archive"
  ([universal_archive.lua](plugins/apps/universal_archive.lua)) for
  archiving the current item in different applications. At the moment
  Evernote, Spark, Microsoft Outlook and Mail.app are supported. For
  Evernote, you can set up multiple keybindings to file notes to
  different notebooks.
- Universal "send to OmniFocus"
  ([universal_omnifocus.lua](plugins/apps/universal_omnifocus.lua))
  for sending the current item to OmniFocus from different
  applications - it supports execution of AppleScript files or
  embedded code, Lua functions, and hard-coded support for certain
  types of applications. Scripts for Microsoft Outlook, Mail.app and
  Evernote are included under the [scripts/](scripts/) directory, and
  built-in support for Chrome and Chrome-based apps (for example, SSBs
  created using [https://github.com/dmarmor/epichrome](Epichrome)) by
  using the `apptype="chromeapp"` parameter. You can add your own and
  configure them in `init-local.lua`.
- Screen rotation shortcuts
  ([screen_rotate.lua](plugins/windows/screen_rotate.lua)) allows
  quickly toggling the rotation of the screen. It supports multiple
  screens, and you can associate keybindings with each one by name.
  - By default, `Ctrl-Cmd-Alt-F15` toggles the first external monitor
    connected. See `init-local-sample.lua` for examples of more
    complex configuration.
- Automatic/manual configuration reloading ([hammerspoon_config_reload.lua](plugins/apps/hammerspoon_config_reload.lua))
  - `Ctrl-Alt-Cmd-r` - manual reload, or when any `*.lua` file in
    `~/.hammerspoon/` changes.
- A color sampler/picker ([colorpicker.lua](plugins/misc/colorpicker.lua))
  - `Ctrl-Alt-Cmd-c` gives you a menu to choose a color palette, and
    toggles a full-screen color picker of the colors in
    `hs.drawing.color`. Clicking on any color will dismiss the picker
    and copy its name to the clipboard, Cmd-clicking copies its RGB
    code.
- Mouse locator ([mouse/locator.lua](plugins/mouse/locator.lua)).
  - `Ctrl-Alt-Cmd-d` draws a red circle around the mouse for 3 seconds.
- Skype mute/unmute ([skype_mute.lua](plugins/apps/skype_mute.lua))
  - `Ctrl-Alt-Cmd-Shift-v` mutes/unmutes Skype, regardless of whether
    it's the frontmost application.
- Evernote automation ([evernote.lua](plugins/apps/evernote.lua]) for
  automating certain actions within Evernote. Supported so far:
  - Key binding for opening current note in separate window.
    Configure in `open_note_key`.
  - Key bindings for opening current note in a window and setting tags
    (leaves the cursor in the tags field). Configure in `modifiers_for_tagging`
    and `keys_for_open_and_tag`.
  - Key bindings for tagging current note inline. Configure in `modifiers_for_tagging`
    and `keys_for_inline_tagging`.
- Install the Hammerspoon command line interface
  ([hammerspoon_install_cli.lua](plugins/apps/hammerspoon_install_cli.lua)).
- Set up a keybinding (Cmd-Alt-Ctrl-y) to open/close the Hammerspoon
  console
  ([hammerspoon_toggle_console.lua](plugins/apps/hammerspoon_toggle_console.lua))


It has drawn inspiration and code from many other places, including:

- [victorso's clipboard manager](http://github.com/victorso/.hammerspoon)
- [cmsj's hammerspoon config](http://github.com/cmsj/hammerspoon-config)
- [Hammerspoon's sample configurations page](https://github.com/Hammerspoon/hammerspoon/wiki/Sample-Configurations)
- [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) and
  [oh-my-fish](http://github.com/oh-my-fish/oh-my-fish) for the name inspiration :)
