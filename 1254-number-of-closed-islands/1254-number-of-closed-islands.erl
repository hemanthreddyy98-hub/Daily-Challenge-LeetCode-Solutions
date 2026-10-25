%% Brute Force
%%
%% -spec closed_island(Grid :: [[integer()]]) -> integer().
%% closed_island(Grid) ->
%%     G = list_to_tuple([list_to_tuple(Row) || Row <- Grid]),
%%     M = tuple_size(G),
%%     N = tuple_size(element(1, G)),
%%     length([1 || R <- lists:seq(0, M - 1), C <- lists:seq(0, N - 1),
%%                  cell(G, R, C) =:= 0,
%%                  explore(G, M, N, [{R, C}], #{{R, C} => true}, true, true, R * N + C)]).
%%
%% explore(_G, _M, _N, [], _Seen, Closed, First, _Id) -> Closed andalso First;
%% explore(G, M, N, [{R, C} | Stack], Seen, Closed, First, Id) ->
%%     Closed2 = Closed andalso R > 0 andalso C > 0 andalso R < M - 1 andalso C < N - 1,
%%     First2 = First andalso R * N + C >= Id,
%%     Next = [{NR, NC} || {NR, NC} <- [{R + 1, C}, {R - 1, C}, {R, C + 1}, {R, C - 1}],
%%                         NR >= 0, NC >= 0, NR < M, NC < N,
%%                         cell(G, NR, NC) =:= 0, not maps:is_key({NR, NC}, Seen)],
%%     Seen2 = lists:foldl(fun(P, S) -> S#{P => true} end, Seen, Next),
%%     explore(G, M, N, Next ++ Stack, Seen2, Closed2, First2, Id).
%%
%% cell(G, R, C) -> element(C + 1, element(R + 1, G)).

%% Better Approach
%%
%% -spec closed_island(Grid :: [[integer()]]) -> integer().
%% closed_island(Grid) ->
%%     M = length(Grid),
%%     N = length(hd(Grid)),
%%     Land0 = sets:from_list([{R, C} || {R, Row} <- lists:zip(lists:seq(0, M - 1), Grid),
%%                                        {C, V} <- lists:zip(lists:seq(0, N - 1), Row), V =:= 0]),
%%     Border = [P || {R, C} = P <- sets:to_list(Land0),
%%                    R =:= 0 orelse C =:= 0 orelse R =:= M - 1 orelse C =:= N - 1],
%%     Land1 = lists:foldl(fun sink/2, Land0, Border),
%%     {_, Count} = lists:foldl(fun(P, {L, K}) ->
%%                                  case sets:is_element(P, L) of
%%                                      true -> {sink(P, L), K + 1};
%%                                      false -> {L, K}
%%                                  end
%%                              end, {Land1, 0}, sets:to_list(Land1)),
%%     Count.
%%
%% sink({R, C} = P, Land) ->
%%     case sets:is_element(P, Land) of
%%         false -> Land;
%%         true -> lists:foldl(fun sink/2, sets:del_element(P, Land),
%%                             [{R + 1, C}, {R - 1, C}, {R, C + 1}, {R, C - 1}])
%%     end.

-spec closed_island(Grid :: [[integer()]]) -> integer().
closed_island(Grid) ->
    M = length(Grid),
    N = length(hd(Grid)),
    Cells = atomics:new(M * N, []),
    lists:foldl(fun(V, I) -> atomics:put(Cells, I, V), I + 1 end, 1, lists:append(Grid)),
    Q = atomics:new(M * N, []),
    scan(0, M * N, Cells, Q, M, N, 0).

scan(Id, Total, _Cells, _Q, _M, _N, Count) when Id >= Total -> Count;
scan(Id, Total, Cells, Q, M, N, Count) ->
    case atomics:get(Cells, Id + 1) of
        0 ->
            atomics:put(Cells, Id + 1, 1),
            atomics:put(Q, 1, Id),
            Add = case bfs(0, 1, Cells, Q, M, N, true) of true -> 1; false -> 0 end,
            scan(Id + 1, Total, Cells, Q, M, N, Count + Add);
        _ ->
            scan(Id + 1, Total, Cells, Q, M, N, Count)
    end.

bfs(Head, Tail, _Cells, _Q, _M, _N, Closed) when Head >= Tail -> Closed;
bfs(Head, Tail, Cells, Q, M, N, Closed) ->
    Id = atomics:get(Q, Head + 1),
    R = Id div N,
    C = Id rem N,
    Closed2 = Closed andalso R > 0 andalso C > 0 andalso R < M - 1 andalso C < N - 1,
    Tail2 = lists:foldl(
              fun({NR, NC}, T) ->
                  case NR >= 0 andalso NC >= 0 andalso NR < M andalso NC < N
                       andalso atomics:get(Cells, NR * N + NC + 1) =:= 0 of
                      true ->
                          atomics:put(Cells, NR * N + NC + 1, 1),
                          atomics:put(Q, T + 1, NR * N + NC),
                          T + 1;
                      false -> T
                  end
              end, Tail, [{R + 1, C}, {R - 1, C}, {R, C + 1}, {R, C - 1}]),
    bfs(Head + 1, Tail2, Cells, Q, M, N, Closed2).