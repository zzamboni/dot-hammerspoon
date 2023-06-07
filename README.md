
# Table of Contents

1.  [My Hammerspoon configuration](#orgd4e35a6)
    1.  [How to use it](#org65c6462)


<a id="orgd4e35a6"></a>

# My Hammerspoon configuration

[Hammerspoon](http://www.hammerspoon.org/) is one of the most-used utilities on my Mac. This repository contains my personal configuration, which you can use as a starting point and modify to suit your needs and preferences.


<a id="org65c6462"></a>

## How to use it

1.  Install [Hammerspoon](http://www.hammerspoon.org/) (minimum version required: 0.9.55, which introduced the `hs.spoons` module)

2.  Clone this repository into your `~/.hammerspoon` directory:
    
        git clone https://github.com/zzamboni/oh-my-hammerspoon.git ~/.hammerspoon

3.  Review [init.lua](init.lua) and change or disable any Spoons as needed. Note that this file is generated from [init.org](init.md), where you can read also a full description of the code. If you are an Emacs org-mode user, you can edit `init.org` and generate `init.lua` by tangling the file (`M-x org-babel-tangle`).

4.  Run Hammerspoon.

5.  All the necessary Spoons will be downloaded, installed and configured.

6.  Have fun!

