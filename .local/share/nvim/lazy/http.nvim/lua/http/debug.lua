local mod = "http"

local function reload()
    for k, _ in pairs(package.loaded) do
        if k:match(mod:gsub("-", "%%-")) then
            package.loaded[k] = nil
        end
    end
    vim.notify(("reload completed %s"):format(mod))
    vim.cmd([[messages clear]])
end

local function test()
    local http = require("http")

    http.post("http://127.0.0.1:5000/index/", { timeout = 3 })
        :add_done_callback(
            ---@param future http.Future
            function(future)
                local res = future:exception()
                vim.print(res)
            end
        )
end

vim.keymap.set(
    { "n" },
    "<leader>pr",
    reload,
    { silent = true, desc = "Reload plugin in debug mode" }
)

vim.keymap.set(
    { "n" },
    "<leader>pt",
    test,
    { silent = true, desc = "Send Request" }
)
