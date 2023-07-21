--> Lune v0.6.5

--[=[
	@class Task

	Built-in task scheduler & thread spawning

	### Example usage

	```lua
	local task = require("@lune/task")

	-- Waiting for a certain amount of time
	task.wait(1)
	print("Waited for one second")

	-- Running a task after a given amount of time
	task.delay(2, function()
		print("Ran after two seconds")
	end)

	-- Spawning a new task that runs concurrently
	task.spawn(function()
		print("Running instantly")
		task.wait(1)
		print("One second passed inside the task")
	end)

	print("Running after task.spawn yields")
	```
]=]
declare task: {
	--[=[
		@within Task

		Stops a currently scheduled thread from resuming.

		@param thread The thread to cancel
	]=]
	cancel: (thread: thread) -> (),
	--[=[
		@within Task

		Defers a thread or function to run at the end of the current task queue.

		@param functionOrThread The function or thread to defer
		@return The thread that will be deferred
	]=]
	defer: <T...>(functionOrThread: thread | (T...) -> ...any, T...) -> thread,
	--[=[
		@within Task

		Delays a thread or function to run after `duration` seconds.

		@param functionOrThread The function or thread to delay
		@return The thread that will be delayed
	]=]
	delay: <T...>(duration: number?, functionOrThread: thread | (T...) -> ...any, T...) -> thread,
	--[=[
		@within Task

		Instantly runs a thread or function.

		If the spawned task yields, the thread that spawned the task
		will resume, letting the spawned task run in the background.

		@param functionOrThread The function or thread to spawn
		@return The thread that was spawned
	]=]
	spawn: <T...>(functionOrThread: thread | (T...) -> ...any, T...) -> thread,
	--[=[
		@within Task

		Waits for *at least* the given amount of time.

		The minimum wait time possible when using `task.wait` is limited by the underlying OS sleep implementation.
		For most systems this means `task.wait` is accurate down to about 5 milliseconds or less.

		@param duration The amount of time to wait
		@return The exact amount of time waited
	]=]
	wait: (duration: number?) -> number,
}










type StdioColor = "reset" | "black" | "red" | "green" | "yellow" | "blue" | "purple" | "cyan" | "white"
type StdioStyle = "reset" | "bold" | "dim"

--[=[
	@class Stdio

	Built-in standard input / output & utility functions

	### Example usage

	```lua
	local stdio = require("@lune/stdio")

	-- Prompting the user for basic input
	local text: string = stdio.prompt("text", "Please write some text")
	local confirmed: boolean = stdio.prompt("confirm", "Please confirm this action")

	-- Writing directly to stdout or stderr, without the auto-formatting of print/warn/error
	stdio.write("Hello, ")
	stdio.write("World! ")
	stdio.write("All on the same line")
	stdio.ewrite("\nAnd some error text, too")
	```
]=]
declare stdio: {
	--[=[
		@within Stdio
		@must_use

		Return an ANSI string that can be used to modify the persistent output color.

		Pass `"reset"` to get a string that can reset the persistent output color.

		### Example usage

		```lua
		stdio.write(stdio.color("red"))
		print("This text will be red")
		stdio.write(stdio.color("reset"))
		print("This text will be normal")
		```

		@param color The color to use
		@return A printable ANSI string
	]=]
	color: (color: StdioColor) -> string,
	--[=[
		@within Stdio
		@must_use

		Return an ANSI string that can be used to modify the persistent output style.

		Pass `"reset"` to get a string that can reset the persistent output style.

		### Example usage

		```lua
		stdio.write(stdio.style("bold"))
		print("This text will be bold")
		stdio.write(stdio.style("reset"))
		print("This text will be normal")
		```

		@param style The style to use
		@return A printable ANSI string
	]=]
	style: (style: StdioStyle) -> string,
	--[=[
		@within Stdio
		@must_use

		Formats arguments into a human-readable string with syntax highlighting for tables.

		@param ... The values to format
		@return The formatted string
	]=]
	format: (...any) -> string,
	--[=[
		@within Stdio

		Writes a string directly to stdout, without any newline.

		@param s The string to write to stdout
	]=]
	write: (s: string) -> (),
	--[=[
		@within Stdio

		Writes a string directly to stderr, without any newline.

		@param s The string to write to stderr
	]=]
	ewrite: (s: string) -> (),
	--[=[
		@within Stdio
		@must_use

		Prompts for user input using the wanted kind of prompt:

		* `"text"` - Prompts for a plain text string from the user
		* `"confirm"` - Prompts the user to confirm with y / n (yes / no)
		* `"select"` - Prompts the user to select *one* value from a list
		* `"multiselect"` - Prompts the user to select *one or more* values from a list
		* `nil` - Equivalent to `"text"` with no extra arguments

		@param kind The kind of prompt to use
		@param message The message to show the user
		@param defaultOrOptions The default value for the prompt, or options to choose from for selection prompts
	]=]
	prompt: (
		(() -> string)
		& ((kind: "text", message: string?, defaultOrOptions: string?) -> string)
		& ((kind: "confirm", message: string, defaultOrOptions: boolean?) -> boolean)
		& ((kind: "select", message: string?, defaultOrOptions: { string }) -> number?)
		& ((kind: "multiselect", message: string?, defaultOrOptions: { string }) -> { number }?)
	),
}










type SerdeEncodeDecodeFormat = "json" | "yaml" | "toml"

--[=[
	@class Serde

	Built-in serialization/deserialization & encoding/decoding functions

	### Example usage

	```lua
	local fs = require("@lune/fs")
	local serde = require("@lune/serde")

	-- Parse different file formats into lua tables
	local someJson = serde.decode("json", fs.readFile("myFile.json"))
	local someToml = serde.decode("toml", fs.readFile("myFile.toml"))
	local someYaml = serde.decode("yaml", fs.readFile("myFile.yaml"))

	-- Write lua tables to files in different formats
	fs.writeFile("myFile.json", serde.encode("json", someJson))
	fs.writeFile("myFile.toml", serde.encode("toml", someToml))
	fs.writeFile("myFile.yaml", serde.encode("yaml", someYaml))
	```
]=]
declare serde: {
	--[=[
		@within Serde
		@must_use

		Encodes the given value using the given format.

		@param format The format to use
		@param value The value to encode
		@param pretty If the encoded string should be human-readable, including things such as newlines and spaces. Only supported for json and toml formats, and defaults to false
		@return The encoded string
	]=]
	encode: (format: SerdeEncodeDecodeFormat, value: any, pretty: boolean?) -> string,
	--[=[
		@within Serde
		@must_use

		Decodes the given string using the given format into a lua value.

		@param format The format to use
		@param encoded The string to decode
		@return The decoded lua value
	]=]
	decode: (format: SerdeEncodeDecodeFormat, encoded: string) -> any,
}










export type Instance = {}

--[=[
	@class Roblox

	Built-in library for manipulating Roblox place & model files

	### Example usage

	```lua
	local roblox = require("@lune/roblox")

	-- Reading & writing a place file
	local game = roblox.readPlaceFile("myPlaceFile.rbxl")
	local workspace = game:GetService("Workspace")

	for _, child in workspace:GetChildren() do
		print("Found child " .. child.Name .. " of class " .. child.ClassName)
	end

	roblox.writePlaceFile("myPlaceFile.rbxl", game)
	```
]=]
declare roblox: {
	--[=[
		@within Roblox
		@must_use

		Reads a place file into a DataModel instance.

		### Example usage

		```lua
		local roblox = require("@lune/roblox")
		local game = roblox.readPlaceFile("filePath.rbxl")
		```

		@param filePath The file path to read from
	]=]
	readPlaceFile: (filePath: string) -> Instance,
	--[=[
		@within Roblox
		@must_use

		Reads a model file into a table of instances.

		### Example usage

		```lua
		local roblox = require("@lune/roblox")
		local instances = roblox.readModelFile("filePath.rbxm")
		```

		@param filePath The file path to read from
	]=]
	readModelFile: (filePath: string) -> { Instance },
	--[=[
		@within Roblox

		Writes a DataModel instance to a place file.

		### Example usage

		```lua
		local roblox = require("@lune/roblox")
		roblox.writePlaceFile("filePath.rbxl", game)
		```

		@param filePath The file path to write to
		@param dataModel The DataModel to write to the file
	]=]
	writePlaceFile: (filePath: string, dataModel: Instance) -> (),
	--[=[
		@within Roblox

		Writes one or more instances to a model file.

		### Example usage

		```lua
		local roblox = require("@lune/roblox")
		roblox.writeModelFile("filePath.rbxm", { instance1, instance2, ... })
		```

		@param filePath The file path to write to
		@param instances The array of instances to write to the file
	]=]
	writeModelFile: (filePath: string, instances: { Instance }) -> (),
	--[=[
		@within Roblox
		@must_use

		Gets the current auth cookie, for usage with Roblox web APIs.

		Note that this auth cookie is formatted for use as a "Cookie" header,
		and that it contains restrictions so that it may only be used for
		official Roblox endpoints. To get the raw cookie value without any
		additional formatting, you can pass `true` as the first and only parameter.

		### Example usage

		```lua
		local roblox = require("@lune/roblox")
		local net = require("@lune/net")

		local cookie = roblox.getAuthCookie()
		assert(cookie ~= nil, "Failed to get roblox auth cookie")

		local myPrivatePlaceId = 1234567890

		local response = net.request({
			url = "https://assetdelivery.roblox.com/v2/assetId/" .. tostring(myPrivatePlaceId),
			headers = {
				Cookie = cookie,
			},
		})

		local responseTable = net.jsonDecode(response.body)
		local responseLocation = responseTable.locations[1].location
		print("Download link to place: " .. responseLocation)
		```

		@param raw If the cookie should be returned as a pure value or not. Defaults to false
	]=]
	getAuthCookie: (raw: boolean?) -> string?,
}










type ProcessSpawnOptionsStdio = "inherit" | "default"

--[=[
	@type ProcessSpawnOptions
	@within Process

	A dictionary of options for `process.spawn`, with the following available values:

	* `cwd` - The current working directory for the process
	* `env` - Extra environment variables to give to the process
	* `shell` - Whether to run in a shell or not - set to `true` to run using the default shell, or a string to run using a specific shell
	* `stdio` - How to treat output and error streams from the child process - set to "inherit" to pass output and error streams to the current process
]=]
export type ProcessSpawnOptions = {
	cwd: string?,
	env: { [string]: string }?,
	shell: (boolean | string)?,
	stdio: ProcessSpawnOptionsStdio?,
}

--[=[
	@type ProcessSpawnResult
	@within Process

	Result type for child processes in `process.spawn`.

	This is a dictionary containing the following values:

	* `ok` - If the child process exited successfully or not, meaning the exit code was zero or not set
	* `code` - The exit code set by the child process, or 0 if one was not set
	* `stdout` - The full contents written to stdout by the child process, or an empty string if nothing was written
	* `stderr` - The full contents written to stderr by the child process, or an empty string if nothing was written
]=]
export type ProcessSpawnResult = {
	ok: boolean,
	code: number,
	stdout: string,
	stderr: string,
}

--[=[
	@class Process

	Built-in functions for the current process & child processes

	### Example usage

	```lua
	local process = require("@lune/process")

	-- Getting the arguments passed to the Lune script
	for index, arg in process.args do
		print("Process argument #" .. tostring(index) .. ": " .. arg)
	end

	-- Getting the currently available environment variables
	local PORT: string? = process.env.PORT
	local HOME: string? = process.env.HOME
	for name, value in process.env do
		print("Environment variable " .. name .. " is set to " .. value)
	end

	-- Getting the current os and processor architecture
	print("Running " .. process.os .. " on " .. process.arch .. "!")

	-- Spawning a child process
	local result = process.spawn("program", {
		"cli argument",
		"other cli argument"
	})
	if result.ok then
		print(result.stdout)
	else
		print(result.stderr)
	end
	```
]=]
declare process: {
	--[=[
		@within Process
		@read_only

		The current operating system being used.

		Possible values:

		* `"linux"`
		* `"macos"`
		* `"windows"`
	]=]
	os: "linux" | "macos" | "windows",
	--[=[
		@within Process
		@read_only

		The architecture of the processor currently being used.

		Possible values:

		* `"x86_64"`
		* `"aarch64"`
	]=]
	arch: "x86_64" | "aarch64",
	--[=[
		@within Process
		@read_only

		The arguments given when running the Lune script.
	]=]
	args: { string },
	--[=[
		@within Process
		@read_only

		The current working directory in which the Lune script is running.
	]=]
	cwd: string,
	--[=[
		@within Process
		@read_write

		Current environment variables for this process.

		Setting a value on this table will set the corresponding environment variable.
	]=]
	env: { [string]: string? },
	--[=[
		@within Process

		Exits the currently running script as soon as possible with the given exit code.

		Exit code 0 is treated as a successful exit, any other value is treated as an error.

		Setting the exit code using this function will override any otherwise automatic exit code.

		@param code The exit code to set
	]=]
	exit: (code: number?) -> (),
	--[=[
		@within Process

		Spawns a child process that will run the program `program`, and returns a dictionary that describes the final status and ouput of the child process.

		The second argument, `params`, can be passed as a list of string parameters to give to the program.

		The third argument, `options`, can be passed as a dictionary of options to give to the child process.
		Refer to the documentation for `ProcessSpawnOptions` for specific option keys and their values.

		@param program The program to spawn as a child process
		@param params Additional parameters to pass to the program
		@param options A dictionary of options for the child process
		@return A dictionary representing the result of the child process
	]=]
	spawn: (
		program: string,
		params: { string }?,
		options: ProcessSpawnOptions?
	) -> ProcessSpawnResult,
}










type NetMethod = "GET" | "POST" | "PUT" | "DELETE" | "HEAD" | "OPTIONS" | "PATCH"

--[=[
	@type NetFetchParams
	@within Net

	Parameters for sending network requests with `net.request`.

	This is a dictionary that may contain one or more of the following values:

	* `url` - The URL to send a request to. This is always required
	* `method` - The HTTP method verb, such as `"GET"`, `"POST"`, `"PATCH"`, `"PUT"`, or `"DELETE"`. Defaults to `"GET"`
	* `query` - A table of key-value pairs representing query parameters in the request path
	* `headers` - A table of key-value pairs representing headers
	* `body` - The request body
]=]
export type NetFetchParams = {
	url: string,
	method: NetMethod?,
	query: { [string]: string }?,
	headers: { [string]: string }?,
	body: string?,
}

--[=[
	@type NetFetchResponse
	@within new

	Response type for sending network requests with `net.request`.

	This is a dictionary containing the following values:

	* `ok` - If the status code is a canonical success status code, meaning within the range 200 -> 299
	* `statusCode` - The status code returned for the request
	* `statusMessage` - The canonical status message for the returned status code, such as `"Not Found"` for status code 404
	* `headers` - A table of key-value pairs representing headers
	* `body` - The request body, or an empty string if one was not given
]=]
export type NetFetchResponse = {
	ok: boolean,
	statusCode: number,
	statusMessage: string,
	headers: { [string]: string },
	body: string,
}

--[=[
	@type NetRequest
	@within Net

	Data type for requests in `net.serve`.

	This is a dictionary containing the following values:

	* `path` - The path being requested, relative to the root. Will be `/` if not specified
	* `query` - A table of key-value pairs representing query parameters in the request path
	* `method` - The HTTP method verb, such as `"GET"`, `"POST"`, `"PATCH"`, `"PUT"`, or `"DELETE"`. Will always be uppercase
	* `headers` - A table of key-value pairs representing headers
	* `body` - The request body, or an empty string if one was not given
]=]
export type NetRequest = {
	path: string,
	query: { [string]: string? },
	method: NetMethod,
	headers: { [string]: string },
	body: string,
}

--[=[
	@type NetRequest
	@within Net

	Response type for requests in `net.serve`.

	This is a dictionary that may contain one or more of the following values:

	* `status` - The status code for the request, in the range `100` -> `599`
	* `headers` - A table of key-value pairs representing headers
	* `body` - The response body
]=]
export type NetResponse = {
	status: number?,
	headers: { [string]: string }?,
	body: string?,
}

type NetServeHttpHandler = (request: NetRequest) -> string | NetResponse
type NetServeWebSocketHandler = (socket: NetWebSocket) -> ()

--[=[
	@type NetServeConfig
	@within Net

	Configuration for `net.serve`.

	This may contain one of, or both of the following callbacks:

	* `handleRequest` for handling normal http requests, equivalent to just passing a function to `net.serve`
	* `handleWebSocket` for handling web socket requests, which will receive a `NetWebSocket` object as its first and only parameter
]=]
export type NetServeConfig = {
	handleRequest: NetServeHttpHandler?,
	handleWebSocket: NetServeWebSocketHandler?,
}

--[=[
	@type NetServeHandle
	@within Net

	A handle to a currently running web server, containing a single `stop` function to gracefully shut down the web server.
]=]
export type NetServeHandle = {
	stop: () -> (),
}

--[=[
	@type NetWebSocket
	@within Net

	A reference to a web socket connection.

	The web socket may be in either an "open" or a "closed" state, changing its current behavior.

	When open:

	* Any function on the socket such as `send`, `next` or `close` can be called without erroring
	* `next` can be called to yield until the next message is received or the socket becomes closed

	When closed:

	* `next` will no longer return any message(s) and instead instantly return nil
	* `send` will throw an error stating that the socket has been closed

	Once the websocket has been closed, `closeCode` will no longer be nil, and will be populated with a close
	code according to the [WebSocket specification](https://www.iana.org/assignments/websocket/websocket.xhtml).
	This will be an integer between 1000 and 4999, where 1000 is the canonical code for normal, error-free closure.
]=]
export type NetWebSocket = {
	closeCode: number?,
	close: (code: number?) -> (),
	send: (message: string, asBinaryMessage: boolean?) -> (),
	next: () -> string?,
}

--[=[
	@class Net


	Built-in library for network access

	### Example usage

	```lua
	local net = require("@lune/net")

	-- Sending a web request
	local response = net.request("https://www.google.com")
	print(response.ok)
	print(response.statusCode, response.statusMessage)
	print(response.headers)

	-- Using a JSON web API
	local response = net.request({
		url = "https://dummyjson.com/products/add",
		method = "POST",
  		headers = { ["Content-Type"] = "application/json" },
		body = net.jsonEncode({
			title = "Cool Pencil",
		})
	})
	local product = net.jsonDecode(response.body)
	print(product.id, "-", product.title)

	-- Starting up a webserver
	net.serve(8080, function(request)
		return {
			status = 200,
			body = "Echo:\n" .. request.body,
		}
	end)
	```
]=]
declare net: {
	--[=[
		@within Net

		Sends an HTTP request using the given url and / or parameters, and returns a dictionary that describes the response received.

		Only throws an error if a miscellaneous network or I/O error occurs, never for unsuccessful status codes.

		@param config The URL or request config to use
		@return A dictionary representing the response for the request
	]=]
	request: (config: string | NetFetchParams) -> NetFetchResponse,
	--[=[
		@within Net
		@must_use

		Connects to a web socket at the given URL.

		Throws an error if the server at the given URL does not support
		web sockets, or if a miscellaneous network or I/O error occurs.

		@param url The URL to connect to
		@return A web socket handle
	]=]
	socket: (url: string) -> NetWebSocket,
	--[=[
		@within Net

		Creates an HTTP server that listens on the given `port`.

		This will ***not*** block and will keep listening for requests on the given `port`
		until the `stop` function on the returned `NetServeHandle` has been called.

		@param port The port to use for the server
		@param handlerOrConfig The handler function or config to use for the server
	]=]
	serve: (port: number, handlerOrConfig: NetServeHttpHandler | NetServeConfig) -> NetServeHandle,
	--[=[
		@within Net
		@must_use

		Encodes the given value as JSON.

		@param value The value to encode as JSON
		@param pretty If the encoded JSON string should include newlines and spaces. Defaults to false
		@return The encoded JSON string
	]=]
	jsonEncode: (value: any, pretty: boolean?) -> string,
	--[=[
		@within Net
		@must_use

		Decodes the given JSON string into a lua value.

		@param encoded The JSON string to decode
		@return The decoded lua value
	]=]
	jsonDecode: (encoded: string) -> any,
	--[=[
		@within Net
		@must_use

		Encodes the given string using URL encoding.

		@param s The string to encode
		@param binary If the string should be treated as binary data and/or is not valid utf-8. Defaults to false
		@return The encoded string
	]=]
	urlEncode: (s: string, binary: boolean?) -> string,
	--[=[
		@within Net
		@must_use

		Decodes the given string using URL decoding.

		@param s The string to decode
		@param binary If the string should be treated as binary data and/or is not valid utf-8. Defaults to false
		@return The decoded string
	]=]
	urlDecode: (s: string, binary: boolean?) -> string,
}










--[=[
	@type FsWriteOptions
	@within FS

	Options for filesystem APIs what write to files and/or directories.

	This is a dictionary that may contain one or more of the following values:

	* `overwrite` - If the target path should be overwritten or not, in the case that it already exists
]=]
export type FsWriteOptions = {
	overwrite: boolean?,
}

--[=[
	@class FS

	Built-in library for filesystem access

	### Example usage

	```lua
	local fs = require("@lune/fs")

	-- Reading a file
	local myTextFile: string = fs.readFile("myFileName.txt")

	-- Reading entries (files & dirs) in a directory
	for _, entryName in fs.readDir("myDirName") do
		if fs.isFile("myDirName/" .. entryName) then
			print("Found file " .. entryName)
		elseif if fs.isDir("myDirName/" .. entryName) then
			print("Found subdirectory " .. entryName)
		end
	end
	```
]=]
declare fs: {
	--[=[
		@within FS
		@must_use

		Reads a file at `path`.

		An error will be thrown in the following situations:

		* `path` does not point to an existing file.
		* The current process lacks permissions to read the file.
		* The contents of the file cannot be read as a UTF-8 string.
		* Some other I/O error occurred.

		@param path The path to the file to read
		@return The contents of the file
	]=]
	readFile: (path: string) -> string,
	--[=[
		@within FS
		@must_use

		Reads entries in a directory at `path`.

		An error will be thrown in the following situations:

		* `path` does not point to an existing directory.
		* The current process lacks permissions to read the contents of the directory.
		* Some other I/O error occurred.

		@param path The directory path to search in
		@return A list of files & directories found
	]=]
	readDir: (path: string) -> { string },
	--[=[
		@within FS

		Writes to a file at `path`.

		An error will be thrown in the following situations:

		* The file's parent directory does not exist.
		* The current process lacks permissions to write to the file.
		* Some other I/O error occurred.

		@param path The path of the file
		@param contents The contents of the file
	]=]
	writeFile: (path: string, contents: string) -> (),
	--[=[
		@within FS

		Creates a directory and its parent directories if they are missing.

		An error will be thrown in the following situations:

		* `path` already points to an existing file or directory.
		* The current process lacks permissions to create the directory or its missing parents.
		* Some other I/O error occurred.

		@param path The directory to create
	]=]
	writeDir: (path: string) -> (),
	--[=[
		@within FS

		Removes a file.

		An error will be thrown in the following situations:

		* `path` does not point to an existing file.
		* The current process lacks permissions to remove the file.
		* Some other I/O error occurred.

		@param path The file to remove
	]=]
	removeFile: (path: string) -> (),
	--[=[
		@within FS

		Removes a directory and all of its contents.

		An error will be thrown in the following situations:

		* `path` is not an existing and empty directory.
		* The current process lacks permissions to remove the directory.
		* Some other I/O error occurred.

		@param path The directory to remove
	]=]
	removeDir: (path: string) -> (),
	--[=[
		@within FS
		@must_use

		Checks if a given path is a file.

		An error will be thrown in the following situations:

		* The current process lacks permissions to read at `path`.
		* Some other I/O error occurred.

		@param path The file path to check
		@return If the path is a file or not
	]=]
	isFile: (path: string) -> boolean,
	--[=[
		@within FS
		@must_use

		Checks if a given path is a directory.

		An error will be thrown in the following situations:

		* The current process lacks permissions to read at `path`.
		* Some other I/O error occurred.

		@param path The directory path to check
		@return If the path is a directory or not
	]=]
	isDir: (path: string) -> boolean,
	--[=[
		@within FS

		Moves a file or directory to a new path.

		Throws an error if a file or directory already exists at the target path.
		This can be bypassed by passing `true` as the third argument, or a dictionary of options.
		Refer to the documentation for `FsWriteOptions` for specific option keys and their values.

		An error will be thrown in the following situations:

		* The current process lacks permissions to read at `from` or write at `to`.
		* The new path exists on a different mount point.
		* Some other I/O error occurred.

		@param from The path to move from
		@param to The path to move to
		@param overwriteOrOptions Options for the target path, such as if should be overwritten if it already exists
	]=]
	move: (from: string, to: string, overwriteOrOptions: (boolean | FsWriteOptions)?) -> (),
}










--[=[
	Prints given value(s) to stdout.

	This will format and prettify values such as tables, numbers, booleans, and more.
]=]
declare print: <T...>(T...) -> ()

--[=[
	Prints given value(s) to stdout with a leading `[INFO]` tag.

	This will format and prettify values such as tables, numbers, booleans, and more.
]=]
declare printinfo: <T...>(T...) -> ()

--[=[
	Prints given value(s) to stdout with a leading `[WARN]` tag.

	This will format and prettify values such as tables, numbers, booleans, and more.
]=]
declare warn: <T...>(T...) -> ()

--[=[
	Throws an error and prints a formatted version of it with a leading `[ERROR]` tag.

	@param message The error message to throw
	@param level The stack level to throw the error at, defaults to 0
]=]
declare error: <T>(message: T, level: number?) -> ()
