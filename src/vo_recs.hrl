-record(note, {
	id = begin random:seed(now()), random:uniform(10000000000) end,
	body,
	ts = erlang:localtime()
}).
