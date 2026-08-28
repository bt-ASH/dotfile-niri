local Session = require("http.core.session")

-- require("http.debug")

local http = {}

http.Methods = {
    "HEAD",
    "OPTIONS",
    "GET",
    "POST",
    "PUT",
    "PATCH",
    "DELETE",
}

---@class http.HttpRequestOpts
---@field headers? table<string, any>
---@field params? table<string, any>
---@field data? table<string, any>
---@field json? table<string, any>
---@field files? table<string, string>
---@field timeout? float
---@field allow_redirects? boolean

---@param method string
---@param url string
---@param opts? http.HttpRequestOpts
---@return http.Future
function http.request(method, url, opts)
    assert(url, "Missing params `url`")
    assert(method, "Missing params `method`")

    method = method:upper()
    assert(
        vim.tbl_contains(http.Methods, method),
        ("Invalid method `%s`"):format(method)
    )

    local session = Session.new(method, url, opts)
    return session:send()
end

---@param url string
---@param opts? http.HttpRequestOpts
---@return http.Future
function http.head(url, opts)
    return http.request("HEAD", url, opts)
end

---@param url string
---@param opts? http.HttpRequestOpts
---@return http.Future
function http.options(url, opts)
    return http.request("OPTIONS", url, opts)
end

---@param url string
---@param opts? http.HttpRequestOpts
---@return http.Future
function http.get(url, opts)
    return http.request("GET", url, opts)
end

---@param url string
---@param opts? http.HttpRequestOpts
---@return http.Future
function http.post(url, opts)
    return http.request("POST", url, opts)
end

---@param url string
---@param opts? http.HttpRequestOpts
---@return http.Future
function http.put(url, opts)
    return http.request("PUT", url, opts)
end

---@param url string
---@param opts? http.HttpRequestOpts
---@return http.Future
function http.patch(url, opts)
    return http.request("PATCH", url, opts)
end

return http
