script.on_event(defines.events.on_research_finished, function(event)
    local tech = event.research
    local tech_name = tech.name
    if not tech_name:match('%-infinite%-quality$') then return end

    for _, next_upgrade in pairs(tech.successors) do
        next_upgrade.enabled = true
    end
end)
