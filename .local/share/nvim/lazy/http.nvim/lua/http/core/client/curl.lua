---@class http.Client
local client = {}

---@param request http.HttpRequest
---@return table<string>
function client.parser_request(request)
    local cmd = {
        "curl",
        "-i",
        request.url,
    }
    local content_type = nil

    if request.allow_redirects then
        table.insert(cmd, "-L")
    end

    if request.headers then
        for key, value in pairs(request.headers) do
            table.insert(cmd, "-H")
            table.insert(cmd, ("%s:%s"):format(key, value))
            if key == "content-type" then
                content_type = value
            end
        end
    end

    if request.json then
        table.insert(cmd, "-d")
        table.insert(cmd, vim.json.encode(request.json))
    end

    if request.files then
        for file_name, file_path in pairs(request.files) do
            table.insert(cmd, "-F")
            table.insert(cmd, ("%s=@%s"):format(file_name, file_path))
        end
    end

    if request.data then
        if type(request.data) == "string" then
            table.insert(cmd, "-d")
            table.insert(cmd, request.data)
        elseif type(request.data) == "table" then
            if
                ---@diagnostic disable-next-line: param-type-mismatch
                vim.isarray(request.data)
            then
                ---@diagnostic disable-next-line: param-type-mismatch
                for _, form_item in ipairs(request.data) do
                    for form_key, form_value in pairs(form_item) do
                        table.insert(cmd, "-F")
                        table.insert(
                            cmd,
                            ("%s=%s"):format(form_key, form_value)
                        )
                    end
                end
            else
                if content_type == "application/x-www-form-urlencoded" then
                    ---@diagnostic disable-next-line: param-type-mismatch
                    for k, v in pairs(request.data) do
                        table.insert(cmd, "-d")
                        table.insert(
                            cmd,
                            ---@diagnostic disable-next-line: param-type-mismatch
                            string.format("%s=%s", k, v)
                        )
                    end
                else
                    ---@diagnostic disable-next-line: param-type-mismatch
                    for form_key, form_value in pairs(request.data) do
                        table.insert(cmd, "-F")
                        table.insert(
                            cmd,
                            ("%s=%s"):format(form_key, form_value)
                        )
                    end
                end
            end
        end
    end

    return cmd
end

---@param completed vim.SystemCompleted
---@return string | nil
function client.is_err(completed)
    return completed.stderr:match("(curl: %(%d+%) .*)")
end

---@param completed vim.SystemCompleted
---@return HttpResponseOpts
function client.parser_response(completed)
    local parts = vim.split(completed.stdout, "\r?\n\r?\n", { plain = false })

    local headers_content = parts[#parts - 1]
    local body_content = parts[#parts]

    local version, status, reason

    local status_line, headers_line = headers_content:match("^(.-)\r?\n(.*)")

    if status_line then
        version, status, reason =
            status_line:match("^(HTTP/%d%.?%d?) (%d%d%d) ?(.*)$")
    end

    local headers_dict = {}

    for line in headers_line:gmatch("[^\r?\n]+") do
        local key, value = line:match("^(.-):%s*(.+)$")
        if key and value then
            headers_dict[key] = value
        end
    end

    return {
        status_code = tonumber(status),
        headers = headers_dict,
        reason = reason,
        version = version,
        content = body_content,
    }
end

return client
