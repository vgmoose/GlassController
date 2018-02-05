# GlassController
WIP virtual controller using regions of the macOS touchpad

Currently all this repository does is show a preview of regions of the touchpad that are currently being touched. It does this by linking against Apple's private MutlitouchSupport.framework, and using a bridging header to access the functions from Swift.

![Preview](https://i.imgur.com/4mVa72o.gif)

The end goal is to allow regions of the touchpad to be assigned keyboard/controller buttons, so that the touchpad can be used in place of the keys on a keyboard or an external device. This is my third attempt at trying to create something like this, my old attempts are [Fpad 2](https://github.com/vgmoose/fpad2) and [Fingerpad](https://github.com/vgmoose/fingerpad).

The previous implementations used the position of the mouse cursor and an overlay to control only the arrow keys, whereas this project reads the direct location of the fingers on touchpad, ignorign the mouse cursor completely.
