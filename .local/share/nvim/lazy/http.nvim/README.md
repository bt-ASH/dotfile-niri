# http.nvim

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)

A Neovim HTTP client using `curl` as backend, designed with Python's `requests`-like API. Primarily used as a dependency for other plugins.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'askfiy/http.nvim',
}
```

## user

simple request

```lua
local http = require("http")

local future = http.get("https://api.example.com/data", {
  params = { page = 2 },
  headers = { ["X-Client"] = "nvim" }
})

future:add_done_callback(function(fut)
  if fut:done() then
    local res = fut:result()
    print(res:text())
  end
end)
```

## Core API

Http Methods:

```lua
http.head(url, opts?)
http.get(url, opts?)
http.post(url, opts?)
http.put(url, opts?)
http.patch(url, opts?)
http.delete(url, opts?)
http.options(url, opts?)
```

Request options:

```lua
---@field headers? table<string, string>  # Custom headers
---@field params?  table<string, any>     # URL query parameters
---@field data?    table<string, any>     # Form-encoded data
---@field json?    table<string, any>     # JSON request body
---@field files?   table<string, string>  # File uploads {form_name = "/path/to/file"}
---@field timeout? integer                # Timeout in seconds
---@field allow_redirects boolean         # automatically jump, default true
```

## Future object

A Future object represents the result of an asynchronous operation, and it can be in one of the following states:

- `PENDING` — The request is awaiting execution.
- `RUNNING` — The request is currently executing.
- `CANCELLED` — The request has been cancelled.
- `FINISHED` — The request has completed.
- `CANCELLED_AND_NOTIFIED` — The request was cancelled and all callbacks have been executed.

Methods support:

- `cancelled()` — Returns true if the future has been cancelled.
- `cancel()` — Cancels the future and runs all registered callbacks.
- `running()` — Returns true if the future is running.
- `done()` — Returns true if the future is finished.
- `add_done_callback()` — Registers a callback to be run when the future is completed.
- `result()` — Retrieves the final result of the future.
- `exception()` — Retrieves any exception associated with the future.
- `set_running_or_notify_cancel()` — Marks the future as RUNNING, or as CANCELLED_AND_NOTIFIED if it's already cancelled.
- `set_result()` — Sets the result of the future.
- `set_exception()` — Sets an exception for the future.

## Response object

The HttpResponse object contains the following properties:

```lua
---@class http.HttpResponse
---@field status_code integer    -- The HTTP status code
---@field headers table<string, string>  -- Response headers
---@field reason string         -- The reason phrase in the response
---@field version string        -- The HTTP version
---@field content string        -- The response body
---@field url string            -- The URL of the request
---@field request HttpRequest   -- The associated request object
```

Method support:

- `HttpResponse:text()` — Returns the response body as plain text.
- `HttpResponse:json()` — Parses and returns the response body as JSON.
- `HttpResponse:ok()` — Checks if the response status code is 200 (OK).
- `HttpResponse:is_redirect()` — Checks if the response is a redirect.
- `HttpResponse:is_permanent_redirect()` — Checks if the response is a permanent redirect (HTTP 301).
