local state_file = vim.fn.stdpath("data") .. "/format_disabled_dirs.json"
local disabled_dirs = nil

local function load_disabled_dirs()
	if disabled_dirs then
		return disabled_dirs
	end

	local dir = vim.fn.fnamemodify(state_file, ":h")
	vim.fn.mkdir(dir, "p")

	local ok, content = pcall(vim.fn.readfile, state_file)
	if ok and content[1] then
		disabled_dirs = vim.json.decode(content[1])
	else
		disabled_dirs = {}
	end
	return disabled_dirs
end

local function save_disabled_dirs(dirs)
	vim.fn.writefile({ vim.json.encode(dirs) }, state_file)
end

local function is_format_disabled(cwd)
	local dirs = load_disabled_dirs()

	-- Check if current directory or any parent is disabled
	for disabled_path, _ in pairs(dirs) do
		if cwd:find(disabled_path, 1, true) == 1 then
			return true
		end
	end

	return false
end

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixpkgs_fmt" },
		typescript = { "biome" },
		astro = { "prettierd", "biome", stop_after_first = true },
	},
	format_on_save = function()
		if is_format_disabled(vim.fn.getcwd()) then
			return nil
		end
		return { timeout = 500, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("Format", function()
	require("conform").format({ async = true }, function(err, did_edit)
		if not err and did_edit then
			vim.notify("Formatted", vim.log.levels.INFO, { title = "Conform" })
		end
	end)
end, { range = true })

vim.api.nvim_create_user_command("FormatDisable", function()
	local cwd = vim.fn.getcwd()
	local dirs = load_disabled_dirs()
	dirs[cwd] = true
	save_disabled_dirs(dirs)
	vim.notify("Autoformat disabled for " .. cwd, vim.log.levels.INFO, { title = "Conform" })
end, {})

vim.api.nvim_create_user_command("FormatEnable", function()
	local cwd = vim.fn.getcwd()
	local dirs = load_disabled_dirs()
	dirs[cwd] = nil
	save_disabled_dirs(dirs)
	vim.notify("Autoformat enabled for " .. cwd, vim.log.levels.INFO, { title = "Conform" })
end, {})
