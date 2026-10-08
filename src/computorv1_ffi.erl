-module(computorv1_ffi).

-export([read_stdin/0]).

read_stdin() ->
    case io:get_line(standard_io, "") of
        eof -> {error, <<"No input provided">>};
        Line -> {ok, unicode:characters_to_binary(string:trim(Line))}
    end.
