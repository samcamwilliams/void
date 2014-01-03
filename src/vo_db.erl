-module(vo_db).
-export([load/0, save/1]).
-define(DAT, "data/bank.dat").

load() ->
	case file:read_file_info(?DAT) of
		{ok, _} -> binary_to_term(element(2, {ok, _} = file:read_file(?DAT)));
		_ -> []
	end.

save(Data) ->
	file:write_file(?DAT, term_to_binary(Data)).
