### Description

Formats any valid Lua 5.3 code.

Lines with code are wrapped to fit inside given margins.

Files with invalid Lua syntax may lose the content after the syntax
error! If this is a problem - verify the correctness of the file before
running reformatter. For example via `$ luac -p <lua_file>`.

Installation script deploys three command-line scripts:

  * `lua.reformat`
  * `lua.get_ast`
  * `lua.get_formatter_ast`

Last two for people who love tinkering.

---

### Requirements

* [LuaRocks](https://luarocks.org/). For easy installation.
* [Lua interpreter](https://lua.org). Version 5.3 is preferred. Another options described
in a following table.

| Lua version required | Syntax supported | Branch | Notes |
|        :---:         |       :---:      |   ---  |  ---  |
| 5.3 | 5.3 | [master]         | may contain experimental features |
| 5.3 | 5.3 | [5.3]            |                                   |
| 5.1 | 5.3 | [5.1]            |                                   |
| 5.1 | 5.1 | [5.1-syntax_5.1] |                                   |

[master]: https://github.com/martin-eden/lua_code_formatter/tree/master
[5.3]: https://github.com/martin-eden/lua_code_formatter/tree/5.3
[5.1]: https://github.com/martin-eden/lua_code_formatter/tree/5.1
[5.1-syntax_5.1]: https://github.com/martin-eden/lua_code_formatter/tree/5.1-syntax_5.1

It may or may not work under Windows. I've not tested it there.


### Installation

* `$ git clone https://github.com/martin-eden/lua_code_formatter`
* `$ cd ./lua_code_formatter`
* `$ sudo luarocks make lcf-scm-1.rockspec`

Alternatively, you may just `$ sudo luarocks install lcf` to get
stable version.


### Deinstallation

* `$ sudo luarocks remove lcf`
* Delete `lua_code_formatter` directory.

---

### Usage

#### From command-line

`$ lua.reformat <lua_file>`

For available options call it without arguments: `$ lua.reformat`.


#### From Lua interpreter

Suppose you have a string with Lua code and wish to get another string
with formatted code.

```lua
do
  local lua_code_str = 'do return end' -- < fill it

  require('lcf.workshop.base')
  local get_ast = request('!.lua.code.get_ast')
  local get_formatted_code = request('!.lua.code.ast_as_code')

  return get_formatted_code(get_ast(lua_code_str))
end
```

##### Passing formatting parameters

You may override default parameters by passing a table with new values
of changed parameters:

```lua
get_formatted_code(
  get_ast(lua_code_str),
  {
    indent_chunk = '  ',
    right_margin = 96,
    max_text_width = math.huge,
    keep_unparsed_tail = true,
    keep_comments = true,
  }
)
```

| Parameter | Default | Description | Notes |
| --- |:---:| --- | --- |
| `indent_chunk` | ` ` ` ` | String used for building one indent. | You may try value `\|..` to see it's effect. |
| `right_margin` | 96 | Maximum line length with indent. | Setting it makes sense for printing. |
| `max_text_width` | +inf | Maximum line length without indent. | Setting it makes sense for viewing in editor. |
| `keep_unparsed_tail` | true | Keep text after point where we failed to parse source. | Syntactically incorrect code may lose significant parts even with this flag. For example `f() = a` is formatted as `f()`. (Because it's parsed as assignment but formatted as function call.) But text like `1; f() = a` will fail to parse and will remain intact. |
| `keep_comments` | true | Keep comments. | Comment text is not changed so comments may last beyond right margin. |

Comments are "sinked-up" to statements level. So text
  ```lua
  function(a, --parameter "a"
    b) --parameter "b"
  end
  ```
is formatted as
  ```lua
  --parameter "a"
  function(a, b)
    --parameter "b"
  end
  ```
This is done to keep formatting routines simple.

---

### Contributors

* Several people were asking to keep comments. This was done and `--keep-comments` option was added.
* `Peter Melnichenko` showed me how to write cross-platform `.rockspec` file.
* `Oliver Jan Krylow` added cautions in `readme.md` that file with invalid syntax
loses tail. I've mentioned `$ luac -p` workaround and added `--keep-unparsed-tail`
option to detect and prevent this.
* `keneanung` adoped formatter to Lua 5.1 syntax and pushed branch `5.1-syntax_5.1`. Which is probably all what LuaJIT guys need.


### Further development

I feel this project is done. Original goal - reformat ugly code from
World of Warcraft addons - accomplished.

* I'll plan to keep it compatible with current PuC-Lua version.
* Someday I'll add more documentation about inner mechanics.
* Maybe I'll add more advanced formatting like empty lines before
  long `for` blocks.

---

### See also 
  * [Command-line builder](https://github.com/martin-eden/lcf_params_gui) for this.
  * [My other repositories](https://github.com/martin-eden/contents).

---
```
2016-08-16
2017-01-28
2017-09-26
2018-02-23
```
