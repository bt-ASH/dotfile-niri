---@class http.HttpRequest
---@field method string
---@field url string
---@field headers? table<string, string>
---@field params? table<string, any>
---@field files? table<string, string>
---@field data? string | table<string, any> | table<table<string, any>>
---@field json? table<string, any> | table<string>
---@field timeout? float
---@field allow_redirects boolean
local HttpRequest = {}
HttpRequest.__index = HttpRequest

---@param opts http.HttpRequestOpts
---@return http.HttpRequestOpts
local function with_defaults(opts, defaults)
    local headers = {}

    for key, value in pairs(opts.headers or {}) do
        headers[key:lower()] = value
    end

    opts.headers = headers

    local result = {}

    for k, v in pairs(defaults) do
        result[k] = v
    end

    for k, v in pairs(opts) do
        result[k] = v
    end

    return result
end

---@param method string
---@param url string
---@param opts? http.HttpRequestOpts
---@return http.HttpRequest
function HttpRequest.new(method, url, opts)
    local self = setmetatable({}, HttpRequest)

    opts = with_defaults(opts or {}, {
        allow_redirects = true,
    })

    self.method = method
    self.url = url

    for key, value in pairs(opts) do
        self[key] = value
    end

    return self
end

return HttpRequest
