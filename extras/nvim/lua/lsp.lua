local lk = {
	{ keys = "<leader>a", func = vim.lsp.buf.code_action, desc = "Code action" },
	{ keys = "<leader>r", func = vim.lsp.buf.rename, desc = "Rename" },
	{ keys = "<leader>k", func = vim.lsp.buf.hover, desc = "Hover", has = "hoverProvider" },
	{ keys = "gd", func = vim.lsp.buf.definition, desc = "Goto definition", has = "definitionProvider" },
}

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local c = vim.lsp.get_client_by_id(args.data.client_id)
		if not c then
			return
		end
		for _, k in ipairs(lk) do
			if not k.has or c.server_capabilities[k.has] then
				vim.keymap.set(k.mode or "n", k.keys, k.func, { buffer = args.buf, desc = "LSP" .. k.desc })
			end
		end
		c.server_capabilities.semanticTokensProvider = nil
		if c:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, c.id, args.buf, { autotrigger = false })
		end
	end,
})

vim.lsp.config("lua_ls", {
	on_init = function(c)
		local config_path = vim.fn.stdpath("config")
		local ws_folders = c.workspace_folders or {}
		local is_nvim_config = false

		for _, folder in ipairs(ws_folders) do
			if folder.name:find(config_path, 1, true) == 1 then
				is_nvim_config = true
				break
			end
		end

		c.config.settings.Lua.runtime.version = "LuaJIT"
		c.config.settings.Lua.diagnostics.globals = { "vim" }
		c.config.settings.Lua.workspace.library = is_nvim_config and vim.api.nvim_get_runtime_file("", true) or {}
		c:notify("workspace/didChangeConfiguration", { settings = c.config.settings })
	end,
	settings = {
		Lua = {
			runtime = {},
			diagnostics = {},
			workspace = { library = {} },
		},
	},
})

vim.lsp.enable({ "lua_ls", "rust_analyzer", "html", "ts_ls", "astro" })
