return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`ranaldsblessing` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("ranaldsblessing", {
			mod_script       = "scripts/mods/ranaldsblessing/ranaldsblessing",
			mod_data         = "scripts/mods/ranaldsblessing/ranaldsblessing_data",
			mod_localization = "scripts/mods/ranaldsblessing/ranaldsblessing_localization",
		})
	end,
	packages = {
		"resource_packages/ranaldsblessing/ranaldsblessing",
	},
}
