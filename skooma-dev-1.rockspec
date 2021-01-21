package = "skooma"
version = "dev-1"
source = {
	url = "git+ssh://git@github.com/darkwiiplayer/skooma"
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
		["skooma.ast"] = "skooma/ast.lua",
		["skooma.env"] = "skooma/env.lua",
		["skooma.serialize"] = "skooma/serialize.lua"
	}
}
