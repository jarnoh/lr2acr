
function ZSTR(s) 
	print(s)
	return s
end

local function loadlrtemplate(s)
	if s:sub(1,5)=="s = {" then
		s = "return "..s:sub(4)
		local c = loadstring(s) -- TODO secure this
		return c()
	end

	return nil -- not lrtemplate
end


return 
{
	loadlrtemplate = loadlrtemplate
}
