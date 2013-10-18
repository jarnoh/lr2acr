#!/usr/local/bin/lua
--[[

lr2acr

Convert Lightroom .lrtemplate to Adobe Bridge .xmp format

jarnoh@komplex.org	October 2013


Notes:
- this is not secure, loadstring will execute code
- Gradients, Brushes, Redeye, Paints etc are not supported
]]


function ZSTR(s) 
	print(s)
	return s
end

local s = io.read("*a")
if s:sub(1,5)=="s = {" then
  s = "return "..s:sub(4)
  s = loadstring(s) -- TODO secure this
else
  os.exit(3)
end

function toattribute(k, v)
	if type(v)=="number" or type(v)=="string" or type(v)=="boolean" then
		return string.format("    crs:%s=%q",k,tostring(v))
	end
	return ""
end

function tonode(k, v)

	if k=="ToneCurve" or k=="ToneCurvePV2012" or k=="ToneCurvePV2012Red" or k=="ToneCurvePV2012Green" or k=="ToneCurvePV2012Blue" then
		
		local a = ""
		for i=1,#v,2 do
			a=a..string.format("      <rdf:li>%d, %d</rdf:li>\n", v[i], v[i+1])
		end
		return string.format("    <crs:%s>\n     <rdf:Seq>\n%s     </rdf:Seq>\n    </crs:%s>", k, a, k)
	
	end

	return ""
end

local lr = s()

local ds = lr.value.settings

print([[<x:xmpmeta 
	xmlns:x="adobe:ns:meta/" 
	x:xmptk="http://github.com/jarnoh/lr2acr"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:crs="http://ns.adobe.com/camera-raw-settings/1.0/"
	xmlns:conv="http://github.com/jarnoh/lr2acr">
 <rdf:RDF>
  <rdf:Description rdf:about=""]])

-- simple attributes
for k,v in pairs(ds) do
	local a = toattribute(k, v)
	if a~="" then
		print(a)
	else
    	--io.stderr:write(string.format("Unsupported type %s in %q\n", type(v), k))
	end
end

print(string.format("    conv:title=%q", lr.internalName)) -- mostly same as title but no ZSTR required
print(string.format("    conv:uuid=%q", lr.value.uuid))

print("    >")

-- nodes
for k,v in pairs(ds) do
	local n = tonode(k, v)
	if n~="" then
		print(n)
--    	io.stderr:write(string.format("Unsupported type %s in %q\n", type(v), k))
	end
end



print([[
  </rdf:Description>
 </rdf:RDF>
</x:xmpmeta>]])
