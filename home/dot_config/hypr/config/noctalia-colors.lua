-- Noctalia Colors Configuration (Dynamic Sourcing)

local function parse_hyprlang(filepath)
    local file = io.open(filepath, "r")
    if not file then
        print("[Noctalia] Warning: Could not open " .. filepath)
        return nil
    end

    local vars = {}
    local config = {}
    local section_stack = {}

    for line in file:lines() do
        -- Remove comments and trim whitespace
        local l = line:gsub("#.*", ""):gsub("//.*", "")
        l = l:match("^%s*(.-)%s*$")

        if l ~= "" then
            -- Check for variable definition: $var = value
            local var_name, var_val = l:match("^%$(%w+)%s*=%s*(.+)$")
            if var_name then
                -- Resolve any existing variables in the value
                for k, v in pairs(vars) do
                    var_val = var_val:gsub("%$" .. k, function() return v end)
                end
                vars[var_name] = var_val
            elseif l:match("{%s*$") then
                -- Section start, e.g. "general {"
                local sec_name = l:match("^(%w+)%s*{")
                if sec_name then
                    table.insert(section_stack, sec_name)
                end
            elseif l == "}" then
                -- Section end
                if #section_stack > 0 then
                    table.remove(section_stack)
                end
            else
                -- Key-value pair, e.g. "col.active_border = $primary"
                local key, val = l:match("^([%w%.]+)%s*=%s*(.+)$")
                if key and val then
                    -- Resolve variables in value
                    for k, v in pairs(vars) do
                        val = val:gsub("%$" .. k, function() return v end)
                    end

                    -- Construct table path using section stack and key dot-notation
                    local path = {}
                    for _, s in ipairs(section_stack) do
                        table.insert(path, s)
                    end
                    for part in key:gmatch("[^%.]+") do
                        table.insert(path, part)
                    end

                    -- Insert into config table
                    local curr = config
                    for i = 1, #path - 1 do
                        local part = path[i]
                        if not curr[part] then
                            curr[part] = {}
                        end
                        curr = curr[part]
                    end
                    curr[path[#path]] = val
                end
            end
        end
    end
    file:close()
    return config
end

local home = os.getenv("HOME")
local config_path = home .. "/.config/hypr/noctalia/noctalia-colors.conf"
local parsed_config = parse_hyprlang(config_path)

if parsed_config then
    hl.config(parsed_config)
end
