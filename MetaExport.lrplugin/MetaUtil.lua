--[[----------------------------------------------------------------------------

interp implementation modified from here: 
http://lua-users.org/wiki/StringInterpolation

Credited to Rici Lake
http://lua-users.org/wiki/RiciLake

------------------------------------------------------------------------------]]

function interp(s, tab, default, nonexist, sr, rvalue)
	function gfunc(w) 
		local element = tab[w:sub(3, -2)]
		if sr == "strip" then
			element = element:gsub('/', '')
			element = element:gsub('\\', '')
		elseif sr == "replace" then
			element = element:gsub('/', rvalue)
			element = element:gsub('\\', rvalue)
		end
		
		if element == "" then
			return default
		end
		if (not element) and nonexist == "" then
			nonexist = w:sub(3, -2)
		end
		return element or nonexist
	end
	
	return (s:gsub('($%b{})', gfunc))
end

function round(num) 
	if num >= 0 then return math.floor(num) 
	else return math.ceil(num) end
end

function tzstring(tz)
	return string.format("%+03d%02d", round(tz / 3600), tz/60%60)
end