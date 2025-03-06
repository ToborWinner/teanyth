local M = {}

-- Load JSON data from a file
local function load_options(filename)
	local file = io.open(filename, "r")
	if not file then return {} end
	local content = file:read("*a")
	file:close()
	local data, _, err = vim.json.decode(content)
	if err then return {} end
	return data
end

-- Create the Markdown preview
local function format_preview(option)
	local preview_lines = {}
	if option.description == vim.NIL then
		table.insert(preview_lines, "# Description\nNo description provided.\n")
	else
		table.insert(preview_lines, "# Description\n" .. option.description .. "\n")
	end
	table.insert(preview_lines, "# Type\n`" .. option.type .. "`\n")
	table.insert(preview_lines, "**Internal:** " .. tostring(option.internal))
	table.insert(preview_lines, "**Visible:** " .. tostring(option.visible))
	table.insert(preview_lines, "**ReadOnly:** " .. tostring(option.readOnly))

	if option.default == nil then
		table.insert(preview_lines, "**Default**: No default specified.\n")
	elseif option.default._type == "literalExpression" then
		table.insert(preview_lines, "\n# Default\n```nix\n" .. option.default.text .. "\n```\n")
	elseif option.default._type == "literalMD" then
		table.insert(preview_lines, "\n# Default\n" .. option.default.text .. "\n")
	else
		error("Unknown default type: " .. tostring(option.default))
	end

	table.insert(preview_lines, "\n# Declarations")

	for _, decl in ipairs(option.declarations or {}) do
		local newFile = decl.file:gsub("^/nix/store/[^/]+/", "")
		if decl.line == vim.NIL then
			table.insert(preview_lines, "- `" .. newFile .. "` - Unknown Line")
		else
			table.insert(preview_lines, "- `" .. newFile .. "` - Line " .. decl.line)
		end
	end

	return table.concat(preview_lines, "\n")
end

-- Jump to the source code location of the Nix option
local function jump_to_declaration(file, line)
	if file ~= nil then
		vim.cmd("edit " .. file)
		if line ~= nil then
			vim.cmd("call cursor(" .. line .. ",1)")
		end
	end
end

-- Start the picker with the specified JSON file
function M.nix_options_picker(filename)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local previewers = require("telescope.previewers")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local options = load_options(filename)

	pickers.new({}, {
		prompt_title = "Nix Options",
		finder = finders.new_table {
			results = vim.tbl_keys(options),
			entry_maker = function(entry)
				local option = options[entry]
				local declaration = option.declarations[1] or nil
				local file = nil
				local line = nil
				if declaration ~= nil then
					file = declaration.file
					line = declaration.line
				end
				return {
					value = entry,
					display = entry,
					ordinal = entry,
					preview = format_preview(option),
					file = file,
					line = line
				}
			end,
		},
		sorter = conf.generic_sorter({}),
		previewer = previewers.new_buffer_previewer {
			define_preview = function(self, entry, status)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.preview, "\n"))
				vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "markdown")
			end,
		},
		attach_mappings = function(prompt_bufnr, map)
			local function on_select()
				actions.close(prompt_bufnr)
				local entry = action_state.get_selected_entry()
				if entry then
					jump_to_declaration(entry.file, entry.line)
				end
			end

			map("i", "<CR>", on_select)
			map("n", "<CR>", on_select)
			return true
		end,
	}):find()
end

return M
