# My Hammerspoon configuration

[Hammerspoon](http://www.hammerspoon.org/) is one of the most-used
utilities on my Mac. This repository contains my personal configuration,
which you can use as a starting point and modify to suit your needs
and preferences.

## What happened to Oh-My-Hammerspoon?

With the arrival of
[Spoons](https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md) in
[Hammerspoon 0.9.53](http://www.hammerspoon.org/releasenotes/0.9.53.html),
the oh-my-hammerspoon plugin mechanism became obsolete. I have
converted all the old plugins into Spoons, so this repository offers
the same (and some new) functionality, but much easier to understand
and configure. Some of them have been merged already in
the [official Spoons repository](http://www.hammerspoon.org/Spoons/),
and others are available in
[my personal zzSpoons repository](http://zzamboni.org/zzSpoons/).

If you still want it, the old oh-my-hammerspoon code has been archived in the
[`old-oh-my-hammerspoon` branch](https://github.com/zzamboni/oh-my-hammerspoon/tree/old-oh-my-hammerspoon).

## How to use it

1. Install [Hammerspoon](http://www.hammerspoon.org/).
   * Please note: until Hammerspoon 0.9.55 is released, you also need to download the files from https://github.com/Hammerspoon/hammerspoon/tree/master/extensions/spoons and store them under your `~/.hammerspoon/hs/spoons/` directory (create the directories as needed) for the SpoonInstall spoon to work properly.
1. Clone this repository into your `~/.hammerspoon` directory:
   ```
   git clone https://github.com/zzamboni/oh-my-hammerspoon.git ~/.hammerspoon
   ```
2. Review [`init.lua`](https://github.com/zzamboni/dot-hammerspoon/blob/master/init.lua) and change or disable any Spoons as needed.
2. Run Hammerspoon.
3. All the necessary Spoons will be downloaded, installed and configured.
4. Have fun!

