-module(vo_write).
-export([add/0]).
-include("vo_recs.hrl").

add() ->
	vo_db:save(
		vo_db:load() ++
		[
			#note {
				body = io:get_line("void> ") -- "\n"
			}
		]
	),
	erlang:halt().
