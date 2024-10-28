Config = {}
Config.Locale = 'fr' -- Langue du script ('fr' pour français, 'en' pour anglais, etc.)

-- Configuration des drogues
Config.Drugs = {
    Cannabis = {
        Blip = {
            Enabled = true,
            Sprite = 140,
            Color = 2,
            Scale = 0.6,
        },
        Harvest = {
            Coords = vector3(2224.34, 5577.07, 53.85),
            Radius = 5.0,
            Item = 'weed_leaf',
            Time = 5,
            Animation = {
                Scenario = "WORLD_HUMAN_GARDENER_PLANT"
            },
            Marker = {
                Enabled = true,
                Type = 1,
                Color = {r = 255, g = 255, b = 255, a = 50},
            },
        },
        Processing = {
            Coords = vector3(1122.47, -1313.32, 34.73),
            Radius = 4.5,
            InputItem = 'weed_leaf',
            InputAmount = 3,
            OutputItem = 'weed',
            OutputAmount = 1,
            Time = 5,
            Animation = {
                Scenario = "PROP_HUMAN_BUM_BIN"
            },
            Marker = {
                Enabled = true,
                Type = 1,
                Color = {r = 255, g = 0, b = 0, a = 50},
            },
        }
    },

    Meth = {
        Blip = {
            Enabled = true,
            Sprite = 499,
            Color = 1,
            Scale = 0.6,
        },
        Harvest = {
            Coords = vector3(-337.87, -2437.18, 6.00),
            Radius = 5.0,
            Item = 'phosphore',
            Time = 5,
            Animation = {
                Scenario = "WORLD_HUMAN_BUM_WASH"
            },
            Marker = {
                Enabled = true,
                Type = 1,
                Color = {r = 255, g = 255, b = 255, a = 50},
            },
        },
        Processing = {
            Coords = vector3(1390.37, 3606.13, 38.94),
            Radius = 4.0,
            InputItem = 'phosphore',
            InputAmount = 3,
            OutputItem = 'meth',
            OutputAmount = 1,
            Time = 5,
            Animation = {
                Scenario = "PROP_HUMAN_BUM_BIN"
            },
            Marker = {
                Enabled = true,
                Type = 1,
                Color = {r = 255, g = 0, b = 0, a = 50},
            },
        }
    },

    Cocaine = {
        Blip = {
            Enabled = true,
            Sprite = 51,
            Color = 3,
            Scale = 0.6,
        },
        Harvest = {
            Coords = vector3(1975.93, 4815.82, 43.40),
            Radius = 5.0,
            Item = 'cocaine_leaf',
            Time = 5,
            Animation = {
                Scenario = "WORLD_HUMAN_GARDENER_PLANT"
            },
            Marker = {
                Enabled = true,
                Type = 1,
                Color = {r = 255, g = 255, b = 255, a = 50},
            },
        },
        Processing = {
            Coords = vector3(464.48, -3235.82, 6.07),
            Radius = 6.0,
            InputItem = 'cocaine_leaf',
            InputAmount = 3,
            OutputItem = 'cocaine',
            OutputAmount = 1,
            Time = 5,
            Animation = {
                Scenario = "PROP_HUMAN_BUM_BIN"
            },
            Marker = {
                Enabled = true,
                Type = 1,
                Color = {r = 255, g = 0, b = 0, a = 50},
            },
        }
    }
}

Config.CraftEnabled = true -- Configuration du Craft (True pour activer, False pour désactiver)

Config.Craft = {
    PouchItem = 'pouch', -- L'item pochon nécessaire pour transformer l'item principal
    Animation = "WORLD_HUMAN_STAND_IMPATIENT", -- L'animation utilisée lors du craft
    Recipes = {
        Cannabis = {
            MainItem = 'weed', -- L'item principal nécessaire
            FinalItem = 'weed_pouch', -- L'item qui sera donné
        },
        Meth = {
            MainItem = 'meth',
            FinalItem = 'meth_pouch',
        },
        Cocaine = {
            MainItem = 'cocaine',
            FinalItem = 'cocaine_pouch',
        },
    }
}