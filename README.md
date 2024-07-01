# GlassController
Virtual controller using regions of the macOS touchpad

This app allows you to configure different actions (such as key bindings) depending on gestures/input from the touchpad. It does this by linking against Apple's private MutlitouchSupport.framework, and using a bridging header to access the functions from Swift.

![Custom](https://i.imgur.com/CkoG0HI.png)

## Usage
Profiles can be imported via the UI. Profiles are JSON files, for some pre-built ones, see the `examples` directory. In the future, the UI should allow the creation of the various types of Actions.

An action is a marriage of three components: Result, Activator, and Context. There are different types within each component, and each type can take different arguments to configure it. For JSON syntax, see `examples` directory.

### Result
A **Result** is the output of whatever Activator+Context occurs. This can be one of three things:
- KeyBinding: Press a given key, while holding zero or more modifier keys (like Cmd)
- LaunchApp: Start an app given the full path to the .app file
- MouseClick: Perform a mouse click with the given mouse button, while holding modifiers, at the current coordinates
- Shortcut: Run an installed Apple Shortcuts "Shortcut" by name

### Activator
Activators are inputs that occur on the Touchpad that must occur in order for the given Result to fire.

There are three types of Activators:
- Swipe: Moving in a direction (up/down/left/right) past a certain treshold with a given number of fingers
- Tap: Pressing briefly for a given number of fingers
- Region: Having any number of fingers over a region defined by a given x/y, width/height percentile coordinates

### Context
A Context is some criteria that should be met for the Activator to qualify

There are two Contexts:
- AppBundle: Only listen when an app with the given bundle ID is in the foreground
- Region: Similar to the Region Activator, enough touches need to be in the specified region in order to fire

## About
The goal of this project is to allow regions of the touchpad to be assigned keyboard/controller buttons, so that the touchpad can be used in place of the keys on a keyboard or an external device. This is my third attempt at trying to create something like this, my old attempts are [Fpad 2](https://github.com/vgmoose/fpad2) and [Fingerpad](https://github.com/vgmoose/fingerpad).

The previous implementations used the position of the mouse cursor and an overlay to control only the arrow keys, whereas this project reads the direct location of the fingers on touchpad, ignoring the mouse cursor completely.

## Screen shots
![Fpad](https://i.imgur.com/Je1c5A2.png)

![Preview](https://i.imgur.com/4mVa72o.gif)
