# BOII Development - Fishing

![fishing_thumb](https://github.com/user-attachments/assets/17c23bfd-4d00-4204-9409-59f3b39cbf5d)


## 🌍 Overview

Introducing BOII Fishing!

Just a straight forward fishing script for your citizens to enjoy.
Define zones around the map where players can fish as either fresh or saltwater for player to catch or release.
Pre-setup with 10 different types of fish, 5 fresh water, 5 saltwater.
Utilises boii_utils skill system to provide a cross framework toggleable leveling system.
Simple clean UI throughout. 

Enjoy!

## 🌐 Features

- **Multi-Framework Compatibility:** Works with multiple frameworks out of the box, any frameworks not covered can be added into boii_utils.
- **Customizable UI:** Clean and simple UI with customizable root CSS files for easy theming and adjustments.
- **Multiple Store Locations:** Each store type can support multiple locations. The config allows for easy addition of new store types, making the script highly extensible.
- **In Built Progress Timer:** A progress circle timer has replaced progressbar. This keeps the resource closer to standalone, minimizing dependencies.
- **Catch & Release:** Players can choose to either catch their fish or release them, this opens up for having illegal fish players can only catch & release.
- **Skill System:** Includes a full toggleable skill system players can work through to progress.

## 💹 Dependencies

- **[boii_utils](https://github.com/boiidevelopment/boii_utils)**
- **[boii_minigames](https://github.com/boiidevelopment/boii_minigames)**

## 💹 Optional Dependencies

- **[boii_interact](https://github.com/boiidevelopment/boii_interact)**
- You must have either `boii_interact` or one of the listed target resources installed.

- **[boii_ui](https://github.com/boiidevelopment/boii_interact)**
- If `boii_ui` is installed stores will use a dialogue conversation before opening.

- **[boii_target](https://github.com/boiidevelopment/boii_target)**
- **[ox_target](https://github.com/overextended/ox_target)**
- **[qb-target](https://github.com/qbcore-framework/qb-target)**
- You must have either `boii_interact` or one of the listed target resources installed.

## 📦 Dependencies Installation

### `boii_utils`:

1. Download the utility library from one of our platforms; 

- https://github.com/boiidevelopment/boii_utils
- https://boiidevelopment.tebex.io/package/5972340

2. Edit `server/config.lua` to suite your liking:

- Set your ui choices choice under `config.ui`
- Insert the skills into `config.skills` if they do not exist already. 

```lua
    fishing = { -- Used by: boii_fishing
        id = 'fishing',
        category = 'civilian',
        label = 'fishing',
        level = 1,
        start_xp = 0,
        first_level_xp = 1000,
        growth_factor = 1.5,
        max_level = 20
    },
```

3. Add `boii_utils` into your server resource and ensure it.

- Add the `boii_utils` resource folder into your server resource.
- Add `ensure boii_utils` into your servers `server.cfg` above any resources that require it.

## 📦 Resource Installation

1. Customise the config.

- You can find this in `server/config.lua`

2. Add `boii_fishing` to your server resources.

- Add the `boii_fishing` resource folder into your server resource.
- Add `ensure boii_fishing` into your servers `server.cfg` below the dependencies.

## 📦 Adding Items

### QBCore

Insert the following items into your `qb-core/shared/items.lua`

```lua
    --- boii_fishing
    -- Baits
    fishing_boilie = { name = 'fishing_boilie', label = 'Boilie', weight = 1, type = 'item', image = 'fishing_boilie.png', unique = false, useable = false, shouldClose = false, description = 'Fishing Bait: Boilie.' },
    fishing_worms = { name = 'fishing_worms', label = 'Worms', weight = 1, type = 'item', image = 'fishing_worms.png', unique = false, useable = false, shouldClose = false, description = 'Fishing Bait: Worms.' },

    -- Gear
    fishing_rod = { name = 'fishing_rod', label = 'Fishing Rod', weight = 1, type = 'item', image = 'fishing_rod.png', unique = true, useable = true, shouldClose = true, description = 'A basic fishing rod.' },

    -- Freshwater fish
	stickleback = { name = 'stickleback', label = 'Threespine Stickleback', weight = 5, type = 'item', image = 'stickleback.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Threespine Stickleback.' },
    bluegill = { name = 'bluegill', label = 'Bluegill', weight = 500, type = 'item', image = 'bluegill.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Bluegill.' },
    sunfish = { name = 'sunfish', label = 'Sunfish', weight = 500, type = 'item', image = 'sunfish.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Sunfish.' },
    brown_trout = { name = 'brown_trout', label = 'Brown Trout', weight = 950, type = 'item', image = 'brown_trout.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Brown Trout.' },
    striped_bass = { name = 'striped_bass', label = 'Striped Bass', weight = 3000, type = 'item', image = 'striped_bass.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Striped Bass.' },

    -- Saltwater fish
    jacksmelt = { name = 'jacksmelt', label = 'Jacksmelt', weight = 500, type = 'item', image = 'jacksmelt.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Jacksmelt.' },
    queenfish = { name = 'queenfish', label = 'Queenfish', weight = 5000, type = 'item', image = 'queenfish.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Queenfish.' },
    rockfish = { name = 'rockfish', label = 'Rockfish', weight = 2500, type = 'item', image = 'rockfish.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Rockfish.' },
    halibut = { name = 'halibut', label = 'Halibut', weight = 3000, type = 'item', image = 'halibut.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Halibut.' },
    guitarfish = { name = 'guitarfish', label = 'Guitarfish', weight = 17000, type = 'item', image = 'guitarfish.png', unique = false, useable = false, shouldClose = false, description = 'A line caught Guitarfish.' },
```

# OX Inventory

```lua
    --- boii_fishing
    ['fishing_boilie'] = {
        label = 'Boilie',
        weight = 1,
    },
    ['fishing_worms'] = {
        label = 'Worms',
        weight = 1,
    },
    ...
```

## 📝 Notes

-> Documentation has not yet been completed, this will be done in due course.

## 📝 Documentation

[Documentation](https://docs.boii.dev/)

## 📹 Preview

[YouTube](https://www.youtube.com/watch?v=pOY8ncgoQbA)

## 📩 Support

https://discord.gg/MUckUyS5Kq
