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
   * Please note: the SpoonInstall spoon (used in this configuration)
     requires the `hs.spoons` extension, which is unavailable in
     versions before Hammerspoon 0.9.55. In the meantime, the
     `hs.spoons` extension is included in this repository and loaded
     by hand at the top of `init.lua`.
2. Clone this repository into your `~/.hammerspoon` directory:
   ```
   git clone https://github.com/zzamboni/oh-my-hammerspoon.git ~/.hammerspoon
   ```
3. Review
   [`init.lua`](https://github.com/zzamboni/dot-hammerspoon/blob/master/init.lua) and
   change or disable any Spoons as needed.
4. Run Hammerspoon.
5. All the necessary Spoons will be downloaded, installed and
   configured.
6. Have fun!

