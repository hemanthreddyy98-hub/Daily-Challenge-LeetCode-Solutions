%% Brute Force
%%
%% -spec count_islands(Grid :: [[integer()]], K :: integer()) -> integer().
%% count_islands(Grid, K) ->
%%     G = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
%%     M = tuple_size(G),
%%     N = tuple_size(element(1, G)),
%%     length([1 || R <- lists:seq(0, M - 1), C <- lists:seq(0, N - 1),
%%                  cell(G, R, C) > 0,
%%                  {Sum, First} <- [explore(G, M, N, [{R, C}], #{{R, C} => true}, 0, true, R * N + C)],
%%                  First, Sum rem K =:= 0]).
%%
%% explore(_G, _M, _N, [], _Seen, Sum, First, _Id) -> {Sum, First};
%% explore(G, M, N, [{R, C} | Stack], Seen, Sum, First, Id) ->
%%     Next = [{NR, NC} || {NR, NC} <- [{R + 1, C}, {R - 1, C}, {R, C + 1}, {R, C - 1}],
%%                         NR >= 0, NC >= 0, NR < M, NC < N,
%%                         cell(G, NR, NC) > 0, not maps:is_key({NR, NC}, Seen)],
%%     Seen2 = lists:foldl(fun(P, S) -> S#{P => true} end, Seen, Next),
%%     explore(G, M, N, Next ++ Stack, Seen2, Sum + cell(G, R, C), First andalso R * N + C >= Id, Id).
%%
%% cell(G, R, C) -> element(C + 1, element(R + 1, G)).

%% Better Approach
%%
%% -spec count_islands(Grid :: [[integer()]], K :: integer()) -> integer().
%% count_islands(Grid, K) ->
%%     G = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
%%     M = tuple_size(G),
%%     N = tuple_size(element(1, G)),
%%     Cells = [{R, C} || R <- lists:seq(0, M - 1), C <- lists:seq(0, N - 1)],
%%     {Count, _} = lists:foldl(
%%         fun({R, C}, {Cnt, Visited}) ->
%%             case cell(G, R, C) > 0 andalso not maps:is_key({R, C}, Visited) of
%%                 true ->
%%                     {Sum, Visited2} = bfs(G, M, N, queue:from_list([{R, C}]), Visited#{{R, C} => true}, 0),
%%                     {Cnt + (case Sum rem K of 0 -> 1; _ -> 0 end), Visited2};
%%                 false ->
%%                     {Cnt, Visited}
%%             end
%%         end, {0, #{}}, Cells),
%%     Count.
%%
%% bfs(G, M, N, Queue, Visited, Sum) ->
%%     case queue:out(Queue) of
%%         {empty, _} -> {Sum, Visited};
%%         {{value, {R, C}}, Q1} ->
%%             {Q2, V2} = lists:foldl(
%%                 fun({NR, NC}, {Q, V}) ->
%%                     case NR >= 0 andalso NC >= 0 andalso NR < M andalso NC < N
%%                          andalso not maps:is_key({NR, NC}, V) andalso cell(G, NR, NC) > 0 of
%%                         true -> {queue:in({NR, NC}, Q), V#{{NR, NC} => true}};
%%                         false -> {Q, V}
%%                     end
%%                 end, {Q1, Visited}, [{R + 1, C}, {R - 1, C}, {R, C + 1}, {R, C - 1}]),
%%             bfs(G, M, N, Q2, V2, Sum + cell(G, R, C))
%%     end.
%%
%% cell(G, R, C) -> element(C + 1, element(R + 1, G)).

-spec count_islands(Grid :: [[integer()]], K :: integer()) -> integer().
count_islands(Grid, K) ->
    M = length(Grid),
    N = length(hd(Grid)),
    Cells = atomics:new(M * N, []),
    lists:foldl(fun(V, I) -> atomics:put(Cells, I, V), I + 1 end, 1, lists:append(Grid)),
    Q = atomics:new(M * N, []),
    scan(0, M * N, Cells, Q, M, N, K, 0).

scan(Id, Total, _Cells, _Q, _M, _N, _K, Count) when Id >= Total -> Count;
scan(Id, Total, Cells, Q, M, N, K, Count) ->
    case atomics:get(Cells, Id + 1) of
        0 ->
            scan(Id + 1, Total, Cells, Q, M, N, K, Count);
        V ->
            atomics:put(Cells, Id + 1, 0),
            atomics:put(Q, 1, Id),
            Add = case bfs(0, 1, Cells, Q, M, N, K, V rem K) of 0 -> 1; _ -> 0 end,
            scan(Id + 1, Total, Cells, Q, M, N, K, Count + Add)
    end.

bfs(Head, Tail, _Cells, _Q, _M, _N, _K, Sum) when Head >= Tail -> Sum;
bfs(Head, Tail, Cells, Q, M, N, K, Sum) ->
    Id = atomics:get(Q, Head + 1),
    R = Id div N,
    C = Id rem N,
    {Tail2, Sum2} = lists:foldl(
        fun({NR, NC}, {T, S}) ->
            V = case NR >= 0 andalso NC >= 0 andalso NR < M andalso NC < N of
                    true -> atomics:get(Cells, NR * N + NC + 1);
                    false -> 0
                end,
            case V > 0 of
                true ->
                    atomics:put(Cells, NR * N + NC + 1, 0),
                    atomics:put(Q, T + 1, NR * N + NC),
                    {T + 1, (S + V) rem K};
                false -> {T, S}
            end
        end, {Tail, Sum}, [{R + 1, C}, {R - 1, C}, {R, C + 1}, {R, C - 1}]),
    bfs(Head + 1, Tail2, Cells, Q, M, N, K, Sum2).