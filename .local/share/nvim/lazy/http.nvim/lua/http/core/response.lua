---@class HttpResponseOpts
---@field status_code integer
---@field headers table<string, string>
---@field url string
---@field reason string
---@field version string
---@field request http.HttpRequest
---@field content string

---@class HttpResponse
---@field status_code integer
---@field headers table<string, string>
---@field reason string
---@field version string
---@field content string
---@field url string
---@field request http.HttpRequest
local HttpResponse = {}
HttpResponse.__index = HttpResponse

---@param opts HttpResponseOpts
---@return HttpResponse
function HttpResponse.new(opts)
    local self = setmetatable({}, HttpResponse)

    for key, value in pairs(opts) do
        self[key] = value
    end

    return self
end

function HttpResponse:text()
    if self:ok() then
        return self.content
    end
end

function HttpResponse:json()
    if self:ok() then
        local ok, data = pcall(vim.json.decode, self.content)

        assert(
            ok,
            ("Json Parser Error: %s for url: %s, content: %s"):format(
                ok,
                self.url,
                self.content
            )
        )

        return data
    end
end

function HttpResponse:ok()
    local http_error_message = ""
    if 400 <= self.status_code and 500 > self.status_code then
        http_error_message = ("%s Client Error: %s for url: %s, content: %s"):format(
            self.status_code,
            self.reason,
            self.url,
            self.content
        )
    elseif 500 <= self.status_code and 600 > self.status_code then
        http_error_message = ("%s Server Error: %s for url: %s content: %s"):format(
            self.status_code,
            self.reason,
            self.url,
            self.content
        )
    end

    if http_error_message:len() > 0 then
        vim.api.nvim_echo({
            {
                http_error_message,
                "ErrorMsg",
            },
        }, true, {})
        return false
    end

    return true
end

function HttpResponse:is_redirect()
    return vim.tbl_contains(self.headers, "location")
        and vim.tbl_contains({
            301,
            302,
            303,
            307,
            308,
        }, self.status_code)
end

function HttpResponse:is_permanent_redirect()
    return vim.tbl_contains(self.headers, "location")
        and vim.tbl_contains({
            301,
            308,
        }, self.status_code)
end

return HttpResponse
