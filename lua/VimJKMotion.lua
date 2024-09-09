local M = {}

local ns_id = vim.api.nvim_create_namespace("right_line_numbers")
local alphas = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "q", "r", "s", "t", "u", "v", "w",
    "x", "y", "z", ";a", ";b", ";c", ";d", ";e", ";f", ";g", ";h", ";i", ";j", ";k", ";l", ";m", ";n", ";q", ";r", ";s",
    ";t", ";u", ";v", ";w", ";x", ";y", ";z" }

local function findIndex(arr, element)
    for i, value in ipairs(arr) do
        if value == element then
            return i
        end
    end
    return nil
end

local function getMark(c)
    if #c > 1 then
        return string.sub(c, -1)
    end
    return c
end

M.motion = function()
    local c = vim.fn.nr2char(vim.fn.getchar())
    if c == ";" then
        c = c .. vim.fn.nr2char(vim.fn.getchar())
    end
    local index = findIndex(alphas, c)
    if index then
        local first_line = vim.fn.line('w0') - 1
        local target = first_line + index
        vim.cmd("normal " .. target .. "G")
    end
end

local function set_right_line_numbers(bufnr)
    local first_line = vim.fn.line('w0') - 1 -- 0-indexed
    local last_line = vim.fn.line('w$') - 1  -- 0-indexed

    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, first_line, last_line + 1)

    for i = first_line, last_line do
        local visible_line_num = i - first_line + 1
        vim.api.nvim_buf_set_extmark(bufnr, ns_id, i, 0, {
            virt_text = { { getMark(alphas[visible_line_num]), "MoreMsg" } },
            virt_text_win_col = -999,
            virt_text_pos = "overlay",
        })
    end
end

function M.show_target()
    vim.opt.foldcolumn = '1'
    local augroup = vim.api.nvim_create_augroup("RightLineNumbers", { clear = true })

    vim.api.nvim_create_autocmd({ "WinScrolled", "VimResized", "WinEnter", "BufEnter", "TextChanged" }, {
        group = augroup,
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            set_right_line_numbers(bufnr)
        end,
    })
end

return M
