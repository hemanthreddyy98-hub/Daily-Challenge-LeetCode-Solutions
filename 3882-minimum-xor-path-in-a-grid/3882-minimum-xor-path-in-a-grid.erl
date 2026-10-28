%% Brute Force
%%
%% -spec min_cost(Grid :: [[integer()]]) -> integer().
%% min_cost(Grid) ->
%%     G = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
%%     dfs(G, tuple_size(G), tuple_size(element(1, G)), 1, 1, cell(G, 1, 1)).
%%
%% cell(G, I, J) -> element(J, element(I, G)).
%%
%% dfs(_G, M, N, M, N, X) -> X;
%% dfs(G, M, N, M, J, X) -> dfs(G, M, N, M, J + 1, X bxor cell(G, M, J + 1));
%% dfs(G, M, N, I, N, X) -> dfs(G, M, N, I + 1, N, X bxor cell(G, I + 1, N));
%% dfs(G, M, N, I, J, X) ->
%%     min(dfs(G, M, N, I + 1, J, X bxor cell(G, I + 1, J)),
%%         dfs(G, M, N, I, J + 1, X bxor cell(G, I, J + 1))).

%% Better Approach
%%
%% -spec min_cost(Grid :: [[integer()]]) -> integer().
%% min_cost(Grid) ->
%%     G = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
%%     {Best, _} = dfs(G, tuple_size(G), tuple_size(element(1, G)), 1, 1, cell(G, 1, 1), #{}),
%%     Best.
%%
%% cell(G, I, J) -> element(J, element(I, G)).
%%
%% dfs(_G, M, N, M, N, X, Memo) -> {X, Memo};
%% dfs(G, M, N, I, J, X, Memo) ->
%%     case maps:find({I, J, X}, Memo) of
%%         {ok, Best} ->
%%             {Best, Memo};
%%         error ->
%%             {Down, Memo1} = if I < M -> dfs(G, M, N, I + 1, J, X bxor cell(G, I + 1, J), Memo);
%%                                true -> {infinity, Memo}
%%                             end,
%%             {Right, Memo2} = if J < N -> dfs(G, M, N, I, J + 1, X bxor cell(G, I, J + 1), Memo1);
%%                                 true -> {infinity, Memo1}
%%                              end,
%%             Best = min(Down, Right),
%%             {Best, Memo2#{{I, J, X} => Best}}
%%     end.

-spec min_cost(Grid :: [[integer()]]) -> integer().
min_cost(Grid) ->
    N = length(hd(Grid)),
    {Last, _} = lists:foldl(fun(Row, {Prev, I}) -> {row(Row, Prev, I), I + 1} end,
                            {lists:duplicate(N, #{}), 0}, Grid),
    lists:min(maps:keys(lists:last(Last))).

row(Row, Prev, I) ->
    Cells = lists:zip3(Row, Prev, lists:seq(0, length(Row) - 1)),
    {Cur, _} = lists:mapfoldl(fun({V, Up, J}, Left) ->
                                  From = case I + J of
                                             0 -> #{0 => true};
                                             _ -> maps:merge(Up, Left)
                                         end,
                                  Set = maps:from_list([{X bxor V, true} || X <- maps:keys(From)]),
                                  {Set, Set}
                              end, #{}, Cells),
    Cur.