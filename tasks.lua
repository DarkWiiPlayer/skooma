local spooder = require 'spooder'

spooder.task "install" {
	description = "Installs the rock";
	depends = {"test"};
	function(helper)
		helper.run("luarocks make")
	end;
}

spooder.task "clean" {
	description = "Deletes buildt leftovers";
	'rm -rf luacov-html';
	'rm -f luacov.report.out';
	'rm -f luacov.stats.out';
}

spooder.task "test" {
	description = "Runs tests";
	'rm luacov.stats.out || true';
	'luacheck .';
	'busted --coverage --lpath "?/init.lua;?.lua"';
	'luacov -r html skooma.lua';
}

spooder.task "documentation" {
	description = "Builds and pushes the documentation";
	depends = { "test"};
	[[
		hash=$(git log -1 --format=%h)
		mkdir -p doc/coverage
		cp -r luacov-html/* doc/coverage
		rm -r doc/*
		ldoc .
		cd doc
			find . | treh -c
			git add --all
			if git log -1 --format=%s | grep "$hash$"
			then git commit --amend --no-edit
			else git commit -m "Update documentation to $hash"
			fi
			git push --force origin doc
		cd ../
		git stash pop || true
	]]
}
