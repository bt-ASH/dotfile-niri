local Request = require("http.core.request")
local Response = require("http.core.response")
local Client = require("http.core.client")
local Future = require("http.core.future")

---@param session http.HttpSession
---@return uv_timer_t | nil
local function timer_timeout(session)
    if session.request.timeout then
        local timer = vim.loop.new_timer()

        timer:start(
            session.request.timeout * 1000,
            0,
            vim.schedule_wrap(function()
                if not session.future:done() then
                    session.future:set_exception("Request Timeout")
                end
                timer:stop()
            end)
        )
        return timer
    end
end

---@class http.HttpSession
---@field request http.HttpRequest
---@field response HttpResponse
---@field client http.HttpClientProxy
---@field future http.Future
local HttpSession = {}
HttpSession.__index = HttpSession

---@param method string
---@param url string
---@param opts? http.HttpRequestOpts
function HttpSession.new(method, url, opts)
    local self = setmetatable({}, HttpSession)

    self.request = Request.new(method, url, opts)
    self.client = Client.new("curl", self.request)
    self.response = nil

    self.future = Future.new()

    return self
end

---@return http.Future
function HttpSession:send()
    local command = self.client:command(self.request)
    self.future:set_running_or_notify_cancel()

    local timer = timer_timeout(self)

    vim.system(
        command,
        {
            text = true,
        },
        vim.schedule_wrap(function(completed)
            if timer then
                timer:stop()
            end

            local err = self.client:is_err(completed)

            if err then
                self.future:set_exception(err)
            end

            if not self.future:exception() then
                local response_opts = self.client:analyze(completed)
                self.response = Response.new(response_opts)
                self.future:set_result(self.response)
            end
        end)
    )

    return self.future
end

return HttpSession
