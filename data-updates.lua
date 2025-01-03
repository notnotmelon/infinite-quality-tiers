if settings.startup["double-quality-module-effects"].value then
	for _, quality in pairs(data.raw.quality) do
		if quality.next_probability then
			quality.next_probability = quality.next_probability * 2
		end
	end
end