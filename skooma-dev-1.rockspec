package = "skooma"
version = "dev-1"
source = {
	url = "git+http://git@github.com/darkwiiplayer/skooma"
}
description = {
	homepage = "https://github.com/darkwiiplayer/skooma",
	license = "Public Domain"
}
dependencies = {
}
build = {
	type = "builtin",
	modules = {
		["skooma"] = "skooma/init.lua",
		["skooma.ast"] = "skooma/ast.lua",
		["skooma.env"] = "skooma/env.lua",
		["skooma.load"] = "skooma/load.lua",
		["skooma.serialize"] = "skooma/serialize.lua",
	}
}
