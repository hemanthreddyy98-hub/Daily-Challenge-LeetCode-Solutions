%% Brute Force
%%
%% -spec get_food(Grid :: [[char()]]) -> integer().
%% get_food(Grid) ->
%%     G = list_to_tuple([list_to_tuple([to_c(Ch) || Ch <- Row]) || Row <- Grid]),
%%     M = tuple_size(G),
%%     N = tuple_size(element(1, G)),
%%     Starts = [{R, C} || R <- lists:seq(1, M), C <- lists:seq(1, N), cell(G, R, C) =:= $*],
%%     case lists:min([dfs(G, M, N, R, C, 0, #{}) || {R, C} <- Starts] ++ [infinity]) of
%%         infinity -> -1;
%%         Best -> Best
%%     end.
%%
%% dfs(_G, M, N, R, C, _Steps, _Seen) when R < 1; C < 1; R > M; C > N -> infinity;
%% dfs(G, M, N, R, C, Steps, Seen) ->
%%     case {cell(G, R, C), maps:is_key({R, C}, Seen)} of
%%         {_, true} -> infinity;
%%         {$X, _} -> infinity;
%%         {$#, _} -> Steps;
%%         _ ->
%%             Seen2 = Seen#{{R, C} => true},
%%             lists:min([dfs(G, M, N, R + DR, C + DC, Steps + 1, Seen2)
%%                        || {DR, DC} <- [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]])
%%     end.
%%
%% cell(G, R, C) -> element(C, element(R, G)).
%%
%% to_c(C) when is_integer(C) -> C;
%% to_c(<<C>>) -> C.

%% Basic Approach
%%
%% -spec get_food(Grid :: [[char()]]) -> integer().
%% get_food(Grid) ->
%%     G = list_to_tuple([list_to_tuple([to_c(Ch) || Ch <- Row]) || Row <- Grid]),
%%     M = tuple_size(G),
%%     N = tuple_size(element(1, G)),
%%     Start = [{R, C} || R <- lists:seq(1, M), C <- lists:seq(1, N), cell(G, R, C) =:= $*],
%%     Visited = maps:from_list([{P, true} || P <- Start]),
%%     bfs(G, M, N, Start, Visited, 0).
%%
%% bfs(_G, _M, _N, [], _Visited, _Steps) -> -1;
%% bfs(G, M, N, Queue, Visited, Steps) ->
%%     case lists:any(fun({R, C}) -> cell(G, R, C) =:= $# end, Queue) of
%%         true -> Steps;
%%         false ->
%%             {Next, Visited2} = lists:foldl(
%%                 fun({R0, C0}, Acc) ->
%%                     lists:foldl(
%%                         fun({DR, DC}, {Nx, V}) ->
%%                             R = R0 + DR,
%%                             C = C0 + DC,
%%                             case R >= 1 andalso C >= 1 andalso R =< M andalso C =< N
%%                                  andalso not maps:is_key({R, C}, V)
%%                                  andalso cell(G, R, C) =/= $X of
%%                                 true -> {[{R, C} | Nx], V#{{R, C} => true}};
%%                                 false -> {Nx, V}
%%                             end
%%                         end, Acc, [{1, 0}, {-1, 0}, {0, 1}, {0, -1}])
%%                 end, {[], Visited}, Queue),
%%             bfs(G, M, N, Next, Visited2, Steps + 1)
%%     end.
%%
%% cell(G, R, C) -> element(C, element(R, G)).
%%
%% to_c(C) when is_integer(C) -> C;
%% to_c(<<C>>) -> C.

-spec get_food(Grid :: [[char()]]) -> integer().
get_food(Grid) ->
    M = length(Grid),
    N = length(hd(Grid)),
    Cells = atomics:new(M * N, []),
    case load(lists:append(Grid), Cells, 0, -1) of
        -1 -> -1;
        Start ->
            Q = atomics:new(M * N, []),
            atomics:put(Q, 1, Start),
            level(Cells, Q, M, N, 0, 1, 1)
    end.

load([], _Cells, _I, Start) -> Start;
load([Ch | Rest], Cells, I, Start) ->
    C = to_c(Ch),
    atomics:put(Cells, I + 1, C),
    load(Rest, Cells, I + 1, case C of $* -> I; _ -> Start end).

to_c(C) when is_integer(C) -> C;
to_c(<<C>>) -> C.

level(_Cells, _Q, _M, _N, Head, Tail, _Steps) when Head >= Tail -> -1;
level(Cells, Q, M, N, Head, Tail, Steps) ->
    case drain(Cells, Q, M, N, Head, Tail, Tail, Steps) of
        {found, S} -> S;
        NewTail -> level(Cells, Q, M, N, Tail, NewTail, Steps + 1)
    end.

drain(_Cells, _Q, _M, _N, Pos, LevelEnd, Tail, _Steps) when Pos >= LevelEnd -> Tail;
drain(Cells, Q, M, N, Pos, LevelEnd, Tail, Steps) ->
    Id = atomics:get(Q, Pos + 1),
    R = Id div N,
    C = Id rem N,
    case visit([{R + 1, C}, {R - 1, C}, {R, C + 1}, {R, C - 1}], Cells, Q, M, N, Tail, Steps) of
        {found, S} -> {found, S};
        NewTail -> drain(Cells, Q, M, N, Pos + 1, LevelEnd, NewTail, Steps)
    end.

visit([], _Cells, _Q, _M, _N, Tail, _Steps) -> Tail;
visit([{R, C} | Rest], Cells, Q, M, N, Tail, Steps)
  when R >= 0, C >= 0, R < M, C < N ->
    Id = R * N + C,
    case atomics:get(Cells, Id + 1) of
        $# -> {found, Steps};
        $O ->
            atomics:put(Cells, Id + 1, $X),
            atomics:put(Q, Tail + 1, Id),
            visit(Rest, Cells, Q, M, N, Tail + 1, Steps);
        _ -> visit(Rest, Cells, Q, M, N, Tail, Steps)
    end;
visit([_ | Rest], Cells, Q, M, N, Tail, Steps) ->
    visit(Rest, Cells, Q, M, N, Tail, Steps).