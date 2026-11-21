# Synergy BO4 GSC Menu

A Black Ops 4 Zombies GSC Mod Menu that uses [Project BO4 / Shield](https://shield-client.gitbook.io/shield-documentation/launcher-guide/how-to-install)

#### Youtube Showcase:

[![Showcase](https://syndishanx.github.io/Synergy-GSC-Menu/BO4/Youtube-Thumbnail.png)](https://www.youtube.com/watch?v=peRC3ax1mEI "Synergy GSC Mod Menu Showcase")

#### Preview:

![Mod Menu](https://syndishanx.github.io/Synergy-GSC-Menu/BO4/Synergy-GSC-Menu.png)

### Requirements: [Project BO4 / Shield](https://shield-client.gitbook.io/shield-documentation/launcher-guide/how-to-install)

#### Installation:

* You can install the Mod Menu ingame on the Mod Manager Page

##### Manual Installation:

* Download the Latest [Synergy.zip](https://syndishanx.github.io/Synergy-GSC-Menu/BO4/Synergy.zip)

* Place the Synergy Folder in the ZIP into `project-bo4/mods`

##### Gun Game Installation:

* Download the Latest [Gun_Game.zip](https://syndishanx.github.io/Synergy-GSC-Menu/BO4/Gun_Game.zip)

* Place the Gun_Game Folder in the ZIP into `project-bo4/mods`

##### Timer Installation:

* Download the Latest [Timer.zip](https://syndishanx.github.io/Synergy-GSC-Menu/BO4/Timer.zip)

* Place the `mods` and `saved` Folders in the ZIP into `project-bo4`

##### Timer Settings:

A Host only setting is in `project-bo4\saved\server\timer.json`

- Start on Load: Whether the Timer starts as soon as you load in or when the HUD is Visible
  - 1: Start on Load
  - 0: Start when the HUD is Visible

There are a few options for each player in `project-bo4\saved\client\timer.json`
- Show Uninitialized: Whether to show Hours/Minutes when they are equal to 0
  - 1: 00:01:23
  - 0: 01:23

- Timer Padding: Whether to add a 0 to the start of numbers less than 10 on the first value (Disabling this also disables the Show Uninitialized Setting)
  - 1: 01:02:03 | 00:01:02
  - 0: 1:02:03 | 1:02

- Timer X & Y Positions
  - Any Integer to define the on-screen position of the Timer

- Timer Scale
  - Any Float larger than 0

- Timer Colors (Red, Green, and Blue)
  - Any Integer between 0-255

## Credits

Some functions are from [Atian Menu](https://github.com/ate47/t8-atian-menu) by [ate47](https://github.com/ate47)