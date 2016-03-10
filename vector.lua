local vector = {}
vector.__index = vector

local function new(...)
	if #arg == 0 then
		return setmetatable({}, vector)
	end
	local vec = setmetatable({}, vector)
	for _, elem in ipairs({...}) do
		table.insert(vec, elem)
	end
	return vec
end

function vector:__tostring()
	local str = "("
	for _, elem in ipairs(self) do
		str = str .. tostring(elem) .. ", "
	end
	str = string.sub(str, 1, -3)
	str = str .. ")"
	return str
end

function vector.__add(a, b)
	local res = new()
	for i, _ in ipairs(a) do
		table.insert(res, a[i] + b[i])
	end
	return res
end

function vector.__sub(a, b)
	local res = new()
	for i, _ in ipairs(a) do
		table.insert(res, a[i] - b[i])
	end
	return res
end

function vector.__mul(a,b)
	local res = new()
	if type(a) == "number" then
		for i, _ in ipairs(b) do
			table.insert(res, b[i]*a)
		end
		return res
	end
	for i, _ in ipairs(a) do
		table.insert(res, a[i]*b)
	end
	return res
end

function vector.__div(a,b)
	local res = new()
	for i, _ in ipairs(a) do
		table.insert(res, a[i]/b)
	end
	return res
end

function vector:sqNorm()
	local res = 0
	for _, elem in ipairs(self) do
		res = res + elem * elem
	end
	return res
end

function vector:clone()
	local res = new()
	for _, elem in ipairs(self) do
		table.insert(res, elem)
	end
	return res
end


return setmetatable({}, {__call = function(_, ...) return new(...) end})