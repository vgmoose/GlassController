In this directory are example configuration files, which can be imported into the UI.

The `Fingerpad` configuration creates 4 regions to control the arrow keys, to mimic the functionality in [fpad2](https://github.com/vgmoose/fpad2).

The `Custom` profile has a few enhancements over the regular macOS UI, such as Five finger swipe closing windows, Four up/down for app expose / mission control (oppposite of what the System UI lets you set)

The two `SideDemo` json files demonstrate two different configs. `SideDemo_Regions` has 4 distinct, non-overlapping regions along the left and right edges of the touchpad (Upper left, lower left, upper right, lower right). Touching in any of the regions activates one of 4 shortcuts.

`SideDemo_Swipes` is similar with 4 total regions, but 2 are overlapping, and the primary activator are one finger swipes. The regions are almost the entire left and right edges, so that a swipe up/down changes volume/brightness depending on the edge.

These last two configs make use of the following iCloud shortcuts:
- [Increase Brightness (by 5%)](https://www.icloud.com/shortcuts/46404377ae564b1aa990de4cdb5013cd)
- [Decrease Brightness](https://www.icloud.com/shortcuts/2df5c6c820e64e8492b7c8f9f2d14faa)
- [Increase Volume (by 5%)](https://www.icloud.com/shortcuts/3e325d4ca6d84214932b30bdb651141d)
- [Decrease Volume](https://www.icloud.com/shortcuts/2f4c1610c683459e95c01e85f14e10e3)

And demonstrate combining Gesture swipes with Region contexts, as well as the new Shortcut result.