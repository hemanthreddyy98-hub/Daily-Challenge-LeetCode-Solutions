%% Brute Force
%%
%% -spec path_sum(Nums :: [integer()]) -> integer().
%% path_sum(Nums) ->
%%     lists:sum([climb(Nums, X div 100, X div 10 rem 10) || X <- Nums, not has_child(Nums, X)]).
%%
%% has_child(Nums, X) ->
%%     D = X div 100,
%%     P = X div 10 rem 10,
%%     lists:any(fun(Y) -> Y div 100 =:= D + 1 andalso lists:member(Y div 10 rem 10, [2 * P - 1, 2 * P]) end, Nums).
%%
%% climb(_Nums, 0, _P) -> 0;
%% climb(Nums, D, P) ->
%%     [Node | _] = [Y || Y <- Nums, Y div 100 =:= D, Y div 10 rem 10 =:= P],
%%     Node rem 10 + climb(Nums, D - 1, (P + 1) div 2).

%% Better Approach
%%
%% -spec path_sum(Nums :: [integer()]) -> integer().
%% path_sum(Nums) ->
%%     Tree = maps:from_list([{X div 10, X rem 10} || X <- Nums]),
%%     dfs(Tree, 1, 1, 0).
%%
%% dfs(Tree, D, P, Sum) ->
%%     case maps:find(D * 10 + P, Tree) of
%%         error -> 0;
%%         {ok, V} ->
%%             Total = Sum + V,
%%             Left = (D + 1) * 10 + 2 * P - 1,
%%             case maps:is_key(Left, Tree) orelse maps:is_key(Left + 1, Tree) of
%%                 false -> Total;
%%                 true -> dfs(Tree, D + 1, 2 * P - 1, Total) + dfs(Tree, D + 1, 2 * P, Total)
%%             end
%%     end.

-spec path_sum(Nums :: [integer()]) -> integer().
path_sum(Nums) ->
    {Ans, _} = lists:foldl(fun step/2, {0, erlang:make_tuple(16, 0)}, lists:reverse(Nums)),
    Ans.

step(X, {Ans, Leaves}) ->
    Idx = (1 bsl (X div 100 - 1)) + X div 10 rem 10 - 1,
    Count = max(element(Idx + 1, Leaves), 1),
    Parent = Idx div 2 + 1,
    Leaves2 = case Idx > 1 of
                  true -> setelement(Parent, Leaves, element(Parent, Leaves) + Count);
                  false -> Leaves
              end,
    {Ans + X rem 10 * Count, Leaves2}.