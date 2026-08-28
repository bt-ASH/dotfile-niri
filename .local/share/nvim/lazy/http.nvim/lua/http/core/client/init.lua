---@class http.HttpClientProxy
---@field client http.Client
---@field request http.HttpRequest
local ClientProxy = {}
ClientProxy.__index = ClientProxy

---@param name string
---@param request http.HttpRequest
function ClientProxy.new(name, request)
    local self = setmetatable({}, ClientProxy)

    ---@type http.Client
    self.client = require(("http.core.client.%s"):format(name))
    self.request = request

    return self
end

---@param request http.HttpRequest
---@return table<string>
function ClientProxy:command(request)
    return self.client.parser_request(request)
end

---@param completed vim.SystemCompleted
function ClientProxy:analyze(completed)
    local response_opts = self.client.parser_response(completed)
    response_opts.request = self.request
    response_opts.url = self.request.url
    return response_opts
end

---@param completed vim.SystemCompleted
function ClientProxy:is_err(completed)
    return self.client.is_err(completed)
end

return ClientProxy
