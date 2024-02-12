local M = {}
function M.dump(object, depth)
	depth = depth or ""
	if type(object) == 'table' then
		local string = '{ '
		for key, value in pairs(object) do
			local newKey = key
			local newDepth = depth
			if type(key) ~= 'number' then newKey = '"' .. key .. '"' end

			if type(key) == "number" then
				newDepth = depth .. key
				newKey = newDepth:gsub(".", "%1."):sub(1, -2)
			end

			string = string .. '[' .. newKey .. '] = ' .. M.dump(value, newDepth) .. ', '
		end
		return string .. '} '
	else
		return '"' .. tostring(object) .. '"'
	end
end

function M.printf(...)
	print(require('vim.inspect').inspect(...))
end

return M
