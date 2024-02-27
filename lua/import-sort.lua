-- Function to sort lines based on import statement
--
-- @param lines an array of lines
-- @param import_statement the name of the import statement that is used to
--   detect code lines using the import statement.
-- @return the import sorted version of @c lines
local function sort_lines(lines, import_statement)
    -- enumeration for states
    local BEFORE = 0
    local IMPORTS = 1
    local AFTER = 2

    local mode = BEFORE
    local before_lines = {}
    local import_blocks = { {} }
    local after_lines = {}

    local function array_for()
        if mode == BEFORE then
            return before_lines
        elseif mode == IMPORTS then
            return import_blocks[#import_blocks]
        elseif mode == AFTER then
            return after_lines
        end
    end

    for _, line in ipairs(lines) do
        if line:find(import_statement, 1, true) == 1 then
            if mode == AFTER then
                table.insert(after_lines, line)
            else
                mode = IMPORTS
                table.insert(array_for(), line)
            end
        elseif line:match("^%s*$") then
            if mode == IMPORTS then
                table.insert(import_blocks, {})
            end
            table.insert(array_for(), line)
        else
            if mode == IMPORTS then
                mode = AFTER
            end
            table.insert(array_for(), line)
        end
    end

    local final_contents = before_lines
    for _, import_block in ipairs(import_blocks) do
        table.sort(import_block)
        vim.list_extend(final_contents, import_block)
    end
    vim.list_extend(final_contents, after_lines)

    return final_contents
end

-- Function to guess import statement based on file extension
local function guess_import_statement(language)
    if language == "c" or language == "cpp" then
        return "#include"
    elseif language == "cs" then
        return "using"
    else
        return "import"
    end
end


-- The actual main function attached to :SortImports
local function sort_imports_in_current_buffer()
    local buffer_contents = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    local language = vim.bo.filetype
    local import_statement = guess_import_statement(language)

    local final = sort_lines(buffer_contents, import_statement)
    vim.api.nvim_buf_set_lines(0, 0, vim.api.nvim_buf_line_count(0), true, final)
end

-- Setup plugin
local function setup()
    vim.api.nvim_create_user_command("SortImports", sort_imports_in_current_buffer, {})
end

setup()

return {}
