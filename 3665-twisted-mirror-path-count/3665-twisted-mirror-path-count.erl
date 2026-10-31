%% Brute Force
%%
%% -spec unique_paths(Grid :: [[integer()]]) -> integer().
%% unique_paths(Grid) ->
%%     G = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
%%     dfs(G, tuple_size(G), tuple_size(element(1, G)), 0, 0, 0).
%%
%% dfs(_G, M, N, I, J, _D) when I >= M; J >= N -> 0;
%% dfs(_G, M, N, I, J, _D) when I =:= M - 1, J =:= N - 1 -> 1;
%% dfs(G, M, N, I, J, D) ->
%%     case element(J + 1, element(I + 1, G)) of
%%         0 -> (dfs(G, M, N, I, J + 1, 0) + dfs(G, M, N, I + 1, J, 1)) rem 1000000007;
%%         _ when D =:= 0 -> dfs(G, M, N, I + 1, J, 1);
%%         _ -> dfs(G, M, N, I, J + 1, 0)
%%     end.

%% Better Approach
%%
%% -spec unique_paths(Grid :: [[integer()]]) -> integer().
%% unique_paths(Grid) ->
%%     G = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
%%     {Ans, _} = dfs(G, tuple_size(G), tuple_size(element(1, G)), 0, 0, 0, #{}),
%%     Ans.
%%
%% dfs(_G, M, N, I, J, _D, Memo) when I >= M; J >= N -> {0, Memo};
%% dfs(_G, M, N, I, J, _D, Memo) when I =:= M - 1, J =:= N - 1 -> {1, Memo};
%% dfs(G, M, N, I, J, D, Memo) ->
%%     Key = (I * N + J) * 2 + D,
%%     case Memo of
%%         #{Key := V} ->
%%             {V, Memo};
%%         _ ->
%%             {V, Memo1} = case element(J + 1, element(I + 1, G)) of
%%                              0 ->
%%                                  {A, Ma} = dfs(G, M, N, I, J + 1, 0, Memo),
%%                                  {B, Mb} = dfs(G, M, N, I + 1, J, 1, Ma),
%%                                  {(A + B) rem 1000000007, Mb};
%%                              _ when D =:= 0 ->
%%                                  dfs(G, M, N, I + 1, J, 1, Memo);
%%                              _ ->
%%                                  dfs(G, M, N, I, J + 1, 0, Memo)
%%                          end,
%%             {V, Memo1#{Key => V}}
%%     end.

-spec unique_paths(Grid :: [[integer()]]) -> integer().
unique_paths([G0 | _] = Grid) ->
    N = length(G0),
    {R, D} = lists:last(rows(Grid, lists:duplicate(N, 1), lists:duplicate(N, {0, 0}), 0, 1)),
    (R + D) rem 1000000007.

rows([], _Prev, Up, _LG, _LR) -> Up;
rows([G | Gs], Prev, Up, LG, LR) -> rows(Gs, G, cells(G, Prev, Up, LG, LR, 0, []), 1, 0).

cells([], _Prev, _Up, _LG, _LR, _LD, Acc) -> lists:reverse(Acc);
cells([C | Cs], [P | Ps], [{UR, UD} | Us], LG, LR, LD, Acc) ->
    R = case LG of
            0 -> (LR + LD) rem 1000000007;
            _ -> LD
        end,
    D = case P of
            0 -> (UR + UD) rem 1000000007;
            _ -> UR
        end,
    cells(Cs, Ps, Us, C, R, D, [{R, D} | Acc]).