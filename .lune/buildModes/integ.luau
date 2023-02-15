return function(path, final, version)
	console.info("Installing Wally Packages in", path)
	process.spawn("wally", { "install" }, { cwd = path })

	console.info("Creating Release.project.json", path)
	local projectJSONPath = string.format("%*/Release.project.json", path)
	local projectName = string.split(path, "/")
	projectName = projectName[#projectName]

	fs.writeFile(
		projectJSONPath,
		string.format(
			'{"name": "%*","tree" : {"$path" : "Packages","%*" : {"$path" : "%*"}}}',
			projectName,
			projectName,
			final
		)
	)

	console.info("Building the RBXM for", projectName)
	process.spawn(
		"rojo",
		{ "build", ("-o %*@%*.rbxm"):format(projectName, version), "Release.project.json" },
		{ cwd = path }
	)

	console.info("Removing the Release.project.file")
	fs.removeFile(projectJSONPath)
end
