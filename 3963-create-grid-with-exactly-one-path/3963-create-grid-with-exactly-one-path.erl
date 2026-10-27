%% Brute Force
%%
%% -spec create_grid(M :: integer(), N :: integer()) -> [unicode:unicode_binary()].
%% create_grid(M, N) ->
%%     Cells = [{I, J} || I <- lists:seq(0, M - 1), J <- lists:seq(0, N - 1),
%%                        {I, J} =/= {0, 0}, {I, J} =/= {M - 1, N - 1}],
%%     Blocked = lists:foldl(fun(Cell, B) ->
%%                               Trial = B#{Cell => true},
%%                               case reach(Trial, M, N, 0, 0) of
%%                                   true -> Trial;
%%                                   false -> B
%%                               end
%%                           end, #{}, Cells),
%%     [list_to_binary([case maps:is_key({I, J}, Blocked) of true -> $#; false -> $. end
%%                      || J <- lists:seq(0, N - 1)]) || I <- lists:seq(0, M - 1)].
%%
%% reach(_B, M, N, R, C) when R >= M; C >= N -> false;
%% reach(B, M, N, R, C) ->
%%     case maps:is_key({R, C}, B) of
%%         true -> false;
%%         false when R =:= M - 1, C =:= N - 1 -> true;
%%         false -> reach(B, M, N, R + 1, C) orelse reach(B, M, N, R, C + 1)
%%     end.

%% Better Approach
%%
%% -spec create_grid(M :: integer(), N :: integer()) -> [unicode:unicode_binary()].
%% create_grid(M, N) ->
%%     Cells = [{I, J} || I <- lists:seq(0, M - 1), J <- lists:seq(0, N - 1),
%%                        {I, J} =/= {0, 0}, {I, J} =/= {M - 1, N - 1}],
%%     Blocked = lists:foldl(fun(Cell, B) ->
%%                               Trial = B#{Cell => true},
%%                               case reach(Trial, M, N) of
%%                                   true -> Trial;
%%                                   false -> B
%%                               end
%%                           end, #{}, Cells),
%%     [list_to_binary([case maps:is_key({I, J}, Blocked) of true -> $#; false -> $. end
%%                      || J <- lists:seq(0, N - 1)]) || I <- lists:seq(0, M - 1)].
%%
%% reach(B, M, N) ->
%%     Last = lists:foldl(fun(I, Prev) -> row(B, I, N, Prev) end,
%%                        lists:duplicate(N, false), lists:seq(0, M - 1)),
%%     lists:last(Last).
%%
%% row(B, I, N, Prev) ->
%%     {Row, _} = lists:mapfoldl(fun({J, Up}, Left) ->
%%                                   Ok = not maps:is_key({I, J}, B) andalso
%%                                        ((I =:= 0 andalso J =:= 0) orelse Up orelse Left),
%%                                   {Ok, Ok}
%%                               end, false, lists:zip(lists:seq(0, N - 1), Prev)),
%%     Row.

-spec create_grid(M :: integer(), N :: integer()) -> [unicode:unicode_binary()].
create_grid(M, N) ->
    Top = binary:copy(<<".">>, N),
    Rest = <<(binary:copy(<<"#">>, N - 1))/binary, ".">>,
    [Top | lists:duplicate(M - 1, Rest)].