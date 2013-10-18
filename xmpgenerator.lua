


local function toattribute(k, v)
	if type(v)=="number" or type(v)=="string" or type(v)=="boolean" then
		return string.format("    crs:%s=%q",k,tostring(v))
	end
	return nil
end

local function tonode(k, v)
	if k=="ToneCurve" or k=="ToneCurvePV2012" or k=="ToneCurvePV2012Red" or k=="ToneCurvePV2012Green" or k=="ToneCurvePV2012Blue" then
	
		local a = ""
		for i=1,#v,2 do
			a=a..string.format("      <rdf:li>%d, %d</rdf:li>\n", v[i], v[i+1])
		end
		return string.format("    <crs:%s>\n     <rdf:Seq>\n%s     </rdf:Seq>\n    </crs:%s>", k, a, k)

	end
	return nil
end



function generatepreset(uuid, title, developsettings)
	local t = {}

	table.insert(t, [[<x:xmpmeta xmlns:x="adobe:ns:meta/" 
	x:xmptk="http://github.com/jarnoh/lr2acr"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:crs="http://ns.adobe.com/camera-raw-settings/1.0/"
	xmlns:conv="http://github.com/jarnoh/lr2acr">
 <rdf:RDF>
  <rdf:Description rdf:about=""]])

	table.insert(t, string.format("    conv:title=%q", title)) -- mostly same as title but no ZSTR required
	table.insert(t, string.format("    conv:uuid=%q", uuid))

	-- simple attributes
	for k,v in pairs(developsettings) do
		local a = toattribute(k, v)
		if a then
			table.insert(t, a)
		end
	end

	table.insert(t, "    >")

	-- nodes
	for k,v in pairs(developsettings) do
		local n = tonode(k, v)
		if n then
			table.insert(t, n)
		end
	end

	table.insert(t, [[
  </rdf:Description>
 </rdf:RDF>
</x:xmpmeta>]])

	return (table.concat(t, "\n"))
end
	
return {
	generatepreset = generatepreset
}

