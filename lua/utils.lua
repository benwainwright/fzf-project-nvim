local module = {}

function module.map(array, func)
	local newArray = {}
	for i, v in ipairs(array) do
		newArray[i] = func(v)
	end
	return newArray
end

function module.check_variable_type(name, variable, theType)
	if type(variable) ~= theType then
		error("'" .. name .. "' should have type '" .. theType .. "'")
	end
end

return module
