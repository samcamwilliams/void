-module(vo).
-export([console/0, add/0]).

console() ->
	vo_console:loop().

add() -> vo_write:add().
