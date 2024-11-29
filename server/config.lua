--[[
     ____   ____ _____ _____   _   _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ 
    |  _ \ / __ \_   _|_   _| | | |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __|
    | |_) | |  | || |   | |   | | | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | |   
    |  _ <| |  | || |   | |   | | | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |   
    | |_) | |__| || |_ _| |_  | | | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |   
    |____/ \____/_____|_____| | | |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_|   
                              | |                                                                                
                              |_|                 FISHING
]]

config = config or {}

--- Debug toggle; true = enabled, false = disabled
config.debug = false

--- Use target toggle; true = will use a target system for store interactions | false = will use `boii_interact` dui 
-- Supported target resources: 'boii_target', 'ox_target' or 'qb-target'; This is chosen automatically depending on what you have installed
config.use_target = true

--- Store validation
config.validation = {
    distance = 10.0, --- Maximum distance allowed from stores to buy or sell.
    drop_player = true --- Toggle if a player should be dropped if trying to buy or sell from outside the distance.
}

--- Toggle skills; true = enabled players will earn xp for actions, false = disabled
config.skills_enabled = true

--- Store settings
--- You can add as many stores as you like.
--- Store item categories can be whatever you want, store ui will support as many as you like.
config.stores = {
    fishing = {
        mode = 'buy', -- Store mode: 'buy' = a store players can buy from | 'sell' = a store players can sell items to
        blip = { type = 'fishing', label = 'Fishing Store', category = 'boii_fishing', sprite = 762, colour = 0, scale = 0.6 },
        ped = { type = 'fishing', label = 'Fishing Store', model = 'a_m_y_sunbathe_01', scenario = 'WORLD_HUMAN_CLIPBOARD', category = 'boii_fishing', networked = false, distance = 2.0 },
        locations = {
            { id = 'tonga_valley', coords = vector4(-1507.36, 1504.46, 115.29, 241.33), show_blip = true, opening_times = { open = 10, close = 18} --[[remove opening_times section to disable time locks]]},
            -- Add more fishing store locations here..
        },
        items = {
            water = { id = 'water', label = 'Water', image = 'water.png', price = 3, categories = { 'consumables' } },
            burger = { id = 'burger', label = 'Burger', image = 'burger.png', price = 5, categories = { 'consumables' } },
            fishing_rod = { id = 'fishing_rod', label = 'Fishing Rod', image = 'fishing_rod.png', price = 150, categories = { 'gear' } },
            fishing_boilie = { id = 'fishing_boilie', label = 'Boilie', image = 'fishing_boilie.png', price = 1, categories = { 'bait' } },
            fishing_worms = { id = 'fishing_worms', label = 'Worms', image = 'fishing_worms.png', price = 1, categories = { 'bait' } },
            -- Add more fishing store items here..
        }
    },
    fish = {
        mode = 'sell',
        blip = { type = 'fish', label = 'Fish Buyer', category = 'boii_fishing', sprite = 762, colour = 0, scale = 0.6 },
        ped = { type = 'fish', label = 'Fish Buyer', model = 'a_m_y_sunbathe_01', scenario = 'WORLD_HUMAN_CLIPBOARD', category = 'boii_fishing', networked = false, distance = 2.0 },
        locations = {
            { id = 'pearls', coords = vector4(-1842.09, -1199.5, 14.3, 234.43), show_blip = true, opening_times = { open = 10, close = 18} --[[remove opening_times section to disable time locks]]},
            -- Add more fishing store locations here..
        },
        items = {
            -- Freshwater
            stickleback = { id = 'stickleback', label = 'Stickleback', image = 'stickleback.png', price = 2, categories = { 'freshwater' } },
            bluegill = { id = 'bluegill', label = 'Bluegill', image = 'bluegill.png', price = 5, categories = { 'freshwater' } },
            sunfish = { id = 'sunfish', label = 'Sunfish', image = 'sunfish.png', price = 10, categories = { 'freshwater' } },
            brown_trout = { id = 'brown_trout', label = 'Brown Trout', image = 'brown_trout.png', price = 18, categories = { 'freshwater' } },
            striped_bass = { id = 'striped_bass', label = 'Striped Bass', image = 'striped_bass.png', price = 32, categories = { 'freshwater' } },

            -- Saltwater
            jacksmelt = { id = 'jacksmelt', label = 'Jacksmelt', image = 'jacksmelt.png', price = 2, categories = { 'saltwater' } },
            queenfish = { id = 'queenfish', label = 'Queenfish', image = 'queenfish.png', price = 5, categories = { 'saltwater' } },
            rockfish = { id = 'rockfish', label = 'Rockfish', image = 'rockfish.png', price = 10, categories = { 'saltwater' } },
            halibut = { id = 'halibut', label = 'Halibut', image = 'halibut.png', price = 18, categories = { 'saltwater' } },
            guitarfish = { id = 'guitarfish', label = 'Guitarfish', image = 'guitarfish.png', price = 32, categories = { 'saltwater' } },
            -- Add more fish buyer items here..
        }
    },
}

--- Fishing zones
config.zones = {
    freshwater = { 'CHIL', 'LACT', 'EAST_V', 'MTGORDO', 'TONGVAV' },
    saltwater = {'ALAMO', 'OCEANA', 'PALCOV'}
}

config.baits = {
    fishing_boilie = {
        id = 'fishing_boilie',
        label = 'Boilie',
        image = 'fishing_boilie.png'
    },
    fishing_worms = {
        id = 'fishing_worms',
        label = 'Worms',
        image = 'fishing_worms.png'
    },
    stickleback = {
        id = 'stickleback',
        label = 'Stickleback',
        image = 'stickleback.png'
    },
    jacksmelt = {
        id = 'jacksmelt',
        label = 'Jacksmelt',
        image = 'jacksmelt.png'
    }
    
}

--- Fish types
--- You can add as many fish here as you like, just follow the same format
config.fish = {
    --- Fresh water
    stickleback = {
        id = 'stickleback',
        label = 'Stickleback',
        zone = 'freshwater',
        image = 'stickleback.png',
        bait = { 'fishing_worms', 'fishing_boilie' },
        weight = { min = 1, max = 6 }, -- Grams (g)
        length = { min = 3, max = 8 }, -- Centimeters (cm)
        skills = {
            level_required = 1,
            xp_gain = { min = 2, max = 5 },
            xp_loss = { min = 1, max = 3 }
        }
    },

    bluegill = {
        id = 'bluegill',
        label = 'Bluegill',
        zone = 'freshwater',
        image = 'bluegill.png',
        bait = { 'fishing_worms', 'fishing_boilie', 'stickleback' },
        weight = { min = 280, max = 730 },
        length = { min = 19, max = 41 }, 
        skills = {
            level_required = 3,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    },

    sunfish = {
        id = 'sunfish',
        label = 'Sunfish',
        zone = 'freshwater',
        image = 'sunfish.png',
        bait = { 'stickleback' },
        weight = { min = 300, max = 780 },
        length = { min = 18, max = 43 }, 
        skills = {
            level_required = 5,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    },

    brown_trout = {
        id = 'brown_trout',
        label = 'Brown Trout',
        zone = 'freshwater',
        image = 'brown_trout.png',
        bait = { 'fishing_worms', 'stickleback' },
        weight = { min = 450, max = 1800 },
        length = { min = 19, max = 41 }, 
        skills = {
            level_required = 7,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    },

    striped_bass = {
        id = 'striped_bass',
        label = 'Striped Bass',
        zone = 'freshwater',
        image = 'striped_bass.png',
        bait = { 'fishing_worms', 'stickleback' },
        weight = { min = 2250, max = 7000 },
        length = { min = 50, max = 90 }, 
        skills = {
            level_required = 9,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    },

    --- Saltwater
    jacksmelt = {
        id = 'jacksmelt',
        label = 'Jacksmelt',
        zone = 'saltwater',
        image = 'jacksmelt.png',
        bait = { 'fishing_worms', 'fishing_boilie' },
        weight = { min = 450, max = 550 },
        length = { min = 25, max = 33 }, 
        skills = {
            level_required = 1,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    },

    queenfish = {
        id = 'queenfish',
        label = 'Queenfish',
        zone = 'saltwater',
        image = 'queenfish.png',
        bait = { 'fishing_worms', 'fishing_boilie', 'jacksmelt' },
        weight = { min = 4000, max = 8000 },
        length = { min = 20, max = 32 }, 
        skills = {
            level_required = 3,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    },

    rockfish = {
        id = 'rockfish',
        label = 'Rockfish',
        zone = 'saltwater',
        image = 'rockfish.png',
        bait = { 'jacksmelt' },
        weight = { min = 1300, max = 4000 },
        length = { min = 35, max = 55 }, 
        skills = {
            level_required = 5,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    },

    halibut = {
        id = 'halibut',
        label = 'Halibut',
        zone = 'saltwater',
        image = 'halibut.png',
        bait = { 'fishing_worms', 'jacksmelt' },
        weight = { min = 4500, max = 10000 },
        length = { min = 45, max = 61 }, 
        skills = {
            level_required = 7,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    },

    guitarfish = {
        id = 'guitarfish',
        label = 'Guitarfish',
        zone = 'saltwater',
        image = 'guitarfish.png',
        bait = { 'fishing_worms', 'jacksmelt' },
        weight = { min = 15000, max = 20000 },
        length = { min = 95, max = 120 }, 
        skills = {
            level_required = 9,
            xp_gain = { min = 4, max = 8 },
            xp_loss = { min = 2, max = 5 }
        }
    }
}