# CheeseMenu
Cheese menu is a UI made for the 2take1 lua api, it is supposed to be as close as possible in usage to the 2t1 api to support luas not made for it.

## Preview
![GTA5_kzYH52SWMf](https://user-images.githubusercontent.com/71855034/176974636-6d80196e-fd48-47d6-8767-f18206ce5b81.png)

## Usage
If you are a lua dev then using this is quite close to using the 2t1 api

If you aren't a lua dev then simply put `cheesemenu x.x.x.lua` and `cheesemenu` folder in the scripts folder for 2t1 and load it, any scripts loaded after will be embedded in cheesemenu

Controls will show up in a notification on load, they aren't changeable yet.

## Customizability
Cheese menu is quite customizable, it allows mutli frame headers, backgrounds and changing just about any color
If you wish to use multi frame headers I added an example, fps can go below 1 if you want the header to change every now and then


![GTA5_p6I2g4HpkE](https://user-images.githubusercontent.com/71855034/176974874-7b72c742-fdbc-4cb9-a7b3-3fa0f9efd431.png)
![GTA5_gAofqF8R8a](https://user-images.githubusercontent.com/71855034/176974877-9fc5c686-910d-4448-966c-2670bf4fa8ee.png)

## Hotkey system
Since this is separate from 2t1 and many lua scripts rely on 2t1's hotkeys I've made an extremely similar hotkey system for cheese menu.
- F11 on a feature will allow you to set a hotkey
- Shift + F11 will remove a hotkey if it exists
- Ctrl + F11 will show a hotkey if it exists

Hotkeys will be saved automatically
