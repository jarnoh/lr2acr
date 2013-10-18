
function ZSTR(s) 
	print(s)
	return s
end

local function loadlrtemplate(s)
	if s:sub(1,5)=="s = {" then

		s = "return "..s:sub(4)
		
		-- add some level for hacking -- TODO secure this
		s = "local _G=nil local print=nil local setfenv=nil local require=nil local io=nil local os=nil local coroutine=nil local debug=nil local table=nil local loadfile=nil local loadstring=nil local load=nil local dofile=nil local setmetatable=nil local xpcall=nil local pcall=nil local package=nil "..s
		local c = loadstring(s)
		return c and c()
	end

	return nil -- not lrtemplate
end


return 
{
	loadlrtemplate = loadlrtemplate
}
