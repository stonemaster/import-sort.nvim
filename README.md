# import-sort.nvim

## Purpose

This [Neovim](https://neovim.io/) plugin provides a basic, programming language
agnostic way to sort import statements through the user-defined command
`:SortImports`.

The plugin is **entirely** written in Lua, so no other dependencies are
required.

## Requirements

This plugin should work with any *Neovim* version.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim) in LUA:

```lua
{
	-- amongst your other plugins
	{
		'stonemaster/import-sort.nvim',
		event = 'BufEnter',
		config = function ()
			require('import-sort')
		end
	}
}
```
## Usage

Type `:SortImports` and the current buffer is magically replaced with your
imports properly sorted.

## Supported Languages & Logic

The logic is extremely simple: the fallback import statement is to look for
`import` statements at the beginning of the code file. This is the common
import statement for a lot of languages. There are special cases for C/C++
(`#include`) as well as C# (`using`) and Rust (`use`). Other special cases can
easily be added (open either an issue or a PR).

Import statements that are divided into blocks by blank lines are sorted
individually.

Sorting of imports is only supported at the beginning of a file.
