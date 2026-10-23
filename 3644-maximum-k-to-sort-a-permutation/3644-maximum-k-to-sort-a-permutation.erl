%% Brute Force
%%
%% -spec sort_permutation(Nums :: [integer()]) -> integer().
%% sort_permutation(Nums) ->
%%     N = length(Nums),
%%     Idx = lists:zip(lists:seq(0, N - 1), Nums),
%%     case lists:all(fun({I, V}) -> I =:= V end, Idx) of
%%         true -> 0;
%%         false -> try_k(N - 1, Nums, Idx, N)
%%     end.
%%
%% try_k(K, Nums, Idx, N) ->
%%     P0 = maps:from_list([{V, V} || V <- lists:seq(0, N - 1)]),
%%     P = lists:foldl(fun({A, B}, Acc) -> union(A, B, Acc) end, P0,
%%                     [{A, B} || A <- Nums, B <- Nums, A < B, A band B =:= K]),
%%     case lists:all(fun({I, V}) -> find(I, P) =:= find(V, P) end, Idx) of
%%         true -> K;
%%         false -> try_k(K - 1, Nums, Idx, N)
%%     end.
%%
%% find(X, P) ->
%%     case maps:get(X, P) of
%%         X -> X;
%%         Y -> find(Y, P)
%%     end.
%%
%% union(A, B, P) -> P#{find(A, P) => find(B, P)}.

%% Better Approach
%%
%% -spec sort_permutation(Nums :: [integer()]) -> integer().
%% sort_permutation(Nums) ->
%%     N = length(Nums),
%%     Misplaced = [V || {I, V} <- lists:zip(lists:seq(0, N - 1), Nums), I =/= V],
%%     case Misplaced of
%%         [] -> 0;
%%         _ -> try_k(N - 1, Misplaced)
%%     end.
%%
%% try_k(K, Misplaced) ->
%%     case lists:all(fun(V) -> V band K =:= K end, Misplaced) of
%%         true -> K;
%%         false -> try_k(K - 1, Misplaced)
%%     end.

-spec sort_permutation(Nums :: [integer()]) -> integer().
sort_permutation(Nums) ->
    max(go(Nums, 0, -1), 0).

go([], _I, Ans) -> Ans;
go([V | Rest], I, Ans) when V =:= I -> go(Rest, I + 1, Ans);
go([V | Rest], I, Ans) -> go(Rest, I + 1, Ans band V).