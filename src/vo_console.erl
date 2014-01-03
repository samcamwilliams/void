-module(vo_console).
-export([loop/0]).
-include("vo_recs.hrl").

loop() ->
	eval_com(read_com()),
	loop().

read_com() ->
	io:get_line("void$ ") -- "\n".

eval_com("") -> ok;
eval_com("exit") -> erlang:halt();
eval_com("stats") ->
	io:format("~w records stored.~n", [length(vo_db:load())]),
	io:format("~w words recorded.~n",
		[
			lists:sum(
				lists:map(
					fun(X) ->
						string:words(X#note.body)
					end,
					vo_db:load()
				)
			)
		]
	);
eval_com("database") ->
	io:format("~p~n", [vo_db:load()]);
eval_com("random") ->
	display(random_of(vo_db:load()));
eval_com("search " ++ Ref) ->
	case search(Ref) of
		[] -> no_results;
		Results -> lists:map(fun display/1, Results)
	end;
eval_com(_) ->
	io:format("ERROR: Unrecognised input.~n").

search(Ref) ->
	Tags = string:tokens(Ref, "/"),
	lists:filter(
		fun(X) ->
			lists:all(
				fun(Tag) ->
					case re:run(string:to_lower(X#note.body), ".*" ++ string:to_lower(Tag) ++ ".*") of
						nomatch -> false;
						{match, _} -> true
					end
				end,
				Tags
			)
		end,
		vo_db:load()
	).

random_of([]) -> nothing;
random_of(List) -> lists:nth(random:uniform(length(List)), List).

display(P) ->
	{{Yr, Mo, Da}, {Hr, Mi, _Se}} = P#note.ts,
	io:format("Post #~w~n~2.10.0B:~2.10.0B ~w/~w/~w~n~s~n",
		[
			P#note.id,
			Hr, Mi, Da, Mo, Yr,
			P#note.body
		]
	).
