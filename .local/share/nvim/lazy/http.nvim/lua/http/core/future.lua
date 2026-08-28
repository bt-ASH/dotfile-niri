---@class http.Future
---@field _state string
---@field _result nil | any
---@field _exception string
---@field _done_callbacks (fun(future: http.Future): nil)[]
local Future = {}
Future.__index = Future

local PENDING = "PENDING"
local RUNNING = "RUNNING"
local CANCELLED = "CANCELLED"
local FINISHED = "FINISHED"
local CANCELLED_AND_NOTIFIED = "CANCELLED_AND_NOTIFIED"

function Future.new()
    local self = setmetatable({}, Future)
    self._state = PENDING
    self._result = nil
    self._exception = nil
    self._done_callbacks = {}
    return self
end

function Future:_invoke_callbacks()
    for _, callback in ipairs(self._done_callbacks) do
        local ok, err = pcall(callback, self)
        if not ok then
            vim.api.nvim_echo({
                {
                    ("exception calling callback for Future: %s"):format(err),
                    "ErrorMsg",
                },
            }, true, {})
        end
    end
end

function Future:cancel()
    if vim.tbl_contains({ RUNNING, FINISHED }, self._state) then
        return false
    end

    if vim.tbl_contains({ CANCELLED, CANCELLED_AND_NOTIFIED }, self._state) then
        return true
    end

    self._state = CANCELLED
    self:_invoke_callbacks()
    return true
end

function Future:cancelled()
    return vim.tbl_contains({ CANCELLED, CANCELLED_AND_NOTIFIED }, self._state)
end

function Future:running()
    return self._state == RUNNING
end

function Future:done()
    return vim.tbl_contains(
        { CANCELLED, CANCELLED_AND_NOTIFIED, FINISHED },
        self._state
    )
end

function Future:add_done_callback(fn)
    if
        not vim.tbl_contains(
            { CANCELLED, CANCELLED_AND_NOTIFIED, FINISHED },
            self._state
        )
    then
        table.insert(self._done_callbacks, fn)
        return
    end
end

function Future:__get_result()
    if self._exception then
        vim.api.nvim_echo({
            {
                self._exception,
                "ErrorMsg",
            },
        }, true, {})
    end

    ---@diagnostic disable-next-line: need-check-nil
    return self._result
end

function Future:result()
    if vim.tbl_contains({ CANCELLED, CANCELLED_AND_NOTIFIED }, self._state) then
        vim.api.nvim_echo({
            {
                "Future CanceledError",
                "ErrorMsg",
            },
        }, true, {})
    end

    if self._state == FINISHED then
        return self:__get_result()
    end
end

function Future:exception()
    if vim.tbl_contains({ CANCELLED, CANCELLED_AND_NOTIFIED }, self._state) then
        vim.api.nvim_echo({
            {
                "Future CanceledError",
                "ErrorMsg",
            },
        }, true, {})
    end

    if self._state == FINISHED then
        return self._exception
    end
end

function Future:set_running_or_notify_cancel()
    if self._state == CANCELLED then
        self._state = CANCELLED_AND_NOTIFIED
        return false
    elseif self._state == PENDING then
        self._state = RUNNING
        return true
    else
        assert(false, "Future in unexpected state")
    end
end

function Future:set_result(result)
    if
        vim.tbl_contains(
            { CANCELLED, CANCELLED_AND_NOTIFIED, FINISHED },
            self._state
        )
    then
        assert(false, ("Future Invalid State %s"):format(self._state))
    end

    self._result = result
    self._state = FINISHED
    self:_invoke_callbacks()
end

function Future:set_exception(exception)
    if
        vim.tbl_contains(
            { CANCELLED, CANCELLED_AND_NOTIFIED, FINISHED },
            self._state
        )
    then
        assert(false, ("Future Invalid State %s"):format(self._state))
    end
    self._exception = exception
    self._state = FINISHED
    self:_invoke_callbacks()
end

return Future
