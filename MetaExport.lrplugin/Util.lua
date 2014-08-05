--[[----------------------------------------------------------------------------
Utilities for various things
------------------------------------------------------------------------------]]

local LrLogger = import 'LrLogger'

local LrLogger = LrLogger( 'Util' )
LrLogger:enable( "print" ) -- or "logfile"

function log (s)
	LrLogger:trace(s)
end
--[[----------------------------------------------------------------------------
interp implementation heavily modified from here: 
http://lua-users.org/wiki/StringInterpolation
Credited to Rici Lake
http://lua-users.org/wiki/RiciLake
------------------------------------------------------------------------------]]
function interp(s, tab, default, nonexist, sr, rvalue)
	function gfunc(w) 
		local key, sstart, send = getsplicepoint(w:sub(3, -2))
		
		local element = tab[key]
		if element then
			if sstart and send then
				element = element:sub(sstart, send)
			end
			if sr == "strip" then
				element = element:gsub('/', '')
				element = element:gsub('\\', '')
			elseif sr == "replace" then
				element = element:gsub('/', rvalue)
				element = element:gsub('\\', rvalue)
			end
		end
		if element == "" then
			return default
		end
		if (not element) and nonexist == "" then
			nonexist = key
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


--[[----------------------------------------------------------------------------
Convert table to string:
http://lua-users.org/wiki/TableUtils
------------------------------------------------------------------------------]]
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end


--[[----------------------------------------------------------------------------
String split
http://lua-users.org/wiki/SplitJoin
------------------------------------------------------------------------------]]
-- Compatibility: Lua-5.1
function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end
