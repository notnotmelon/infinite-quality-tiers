local quality_names = require "quality-names"

local colors = {
    ["mythic"] = {255, 0, 237},
    ["fabled"] = {0, 232, 255},
    ["divine"] = {166, 0, 255},
    ["exalted"] = {255, 255, 255},
    ["supreme"] = {255, 0, 0},
    ["marvelous"] = {255, 0, 237},
    ["reality-bending"] = {0, 0, 0}
}

local function random_color()
    return {
        math.random(),
        math.random(),
        math.random(),
    }
end

local function get_color(quality_name)
    if not colors[quality_name] then
        colors[quality_name] = random_color()
    end
    return colors[quality_name]
end

local function get_quality_icon(level)
    local quality_name = quality_names[level]
    if colors[quality_name] then
        return {
            {
                icon = "__infinite-quality-tiers__/graphics/icons/quality-pips-background.png",
                icon_size = 64
            },
            {
                icon = "__infinite-quality-tiers__/graphics/icons/quality-pips.png",
                icon_size = 64,
                tint = get_color(quality_name)
            },
        }
    end

    return {
        {
            icon = "__infinite-quality-tiers__/graphics/icons/quality-pips-background.png",
            icon_size = 64
        },
        {
            icon = "__infinite-quality-tiers__/graphics/icons/quality-pips-1.png",
            icon_size = 64,
            tint = get_color(quality_names[level - 0])
        },
        {
            icon = "__infinite-quality-tiers__/graphics/icons/quality-pips-2.png",
            icon_size = 64,
            tint = get_color(quality_names[level - 1])
        },
        {
            icon = "__infinite-quality-tiers__/graphics/icons/quality-pips-3.png",
            icon_size = 64,
            tint = get_color(quality_names[level - 2])
        },
        {
            icon = "__infinite-quality-tiers__/graphics/icons/quality-pips-4.png",
            icon_size = 64,
            tint = get_color(quality_names[level - 3])
        },
        {
            icon = "__infinite-quality-tiers__/graphics/icons/quality-pips-5.png",
            icon_size = 64,
            tint = get_color(quality_names[level - 4])
        }
    }
end

for level = 6, 999 do
    local quality_name = quality_names[level]
    if not quality_name then break end
    local icons = get_quality_icon(level)
    local color = get_color(quality_name)
    
    local quality = {
        type = "quality",
        name = quality_name,
        level = level,
        icons = icons,
        draw_sprite_by_default = true,
        color = color,
        next = quality_names[level - 1],
        next_probability = 0.1,
        order = "f" .. string.format("%03d", level),
        beacon_power_usage_multiplier = 1 / 6 / (level - 4),
        mining_drill_resource_drain_multiplier = 1 / 6 / (level - 4),
        science_pack_drain_multiplier = (100 - level) / 100,
    }
    if quality.science_pack_drain_multiplier <= 0 then
        quality.science_pack_drain_multiplier = (1 / 100) / (level - 98)
    end

    local technology = {
        type = "technology",
        name = quality_name .. "-quality",
        localised_name = {"technology-name.infinite-quality", {"quality-name." .. quality_name}},
        icon = data.raw.technology["legendary-quality"].icon,
        icon_size = data.raw.technology["legendary-quality"].icon_size,
        effects = {
            {
                type = "unlock-quality",
                quality = quality_name
            }
        },
        unit = {
            count = (1.10 ^ level * 100000),
            ingredients = {
                {"automation-science-pack",      1},
                {"logistic-science-pack",        1},
                {"military-science-pack",        1},
                {"chemical-science-pack",        1},
                {"production-science-pack",      1},
                {"utility-science-pack",         1},
                {"space-science-pack",           1},
                {"metallurgic-science-pack",     1},
                {"electromagnetic-science-pack", 1},
                {"agricultural-science-pack",    1},
                {"cryogenic-science-pack",       1},
                {"promethium-science-pack",      1}
            },
            time = 120
        },
        prerequisites = level == 5 and {"promethium-science-pack", "legendary-quality"} or {quality_names[level - 1] .. "-quality"},
        order = "f" .. string.format("%03d", level)
    }

    data:extend {quality, technology}
end

local legendary = data.raw.quality["legendary"]
legendary.level = 4
legendary.next = "mythic"
legendary.beacon_power_usage_multiplier = 2 / 6
legendary.mining_drill_resource_drain_multiplier = 2 / 6
legendary.science_pack_drain_multiplier = 96 / 100
