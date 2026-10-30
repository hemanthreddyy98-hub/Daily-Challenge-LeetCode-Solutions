%% Brute Force
%%
%% -spec shortest_path(N :: integer(), Edges :: [[integer()]], Labels :: unicode:unicode_binary(), K :: integer()) -> integer().
%% shortest_path(N, Edges, Labels, K) ->
%%     Dist = relax_all(#{{0, 1} => 0}, Edges, Labels, K),
%%     case [D || R <- lists:seq(1, K), {ok, D} <- [maps:find({N - 1, R}, Dist)]] of
%%         [] -> -1;
%%         Ds -> lists:min(Ds)
%%     end.
%%
%% relax_all(Dist, Edges, Labels, K) ->
%%     New = lists:foldl(fun([U, V, W], Acc0) ->
%%                           Same = binary:at(Labels, U) =:= binary:at(Labels, V),
%%                           lists:foldl(fun(R, Acc) ->
%%                                           Next = case Same of
%%                                                      true -> R + 1;
%%                                                      false -> 1
%%                                                  end,
%%                                           case maps:find({U, R}, Acc) of
%%                                               {ok, D} when Next =< K ->
%%                                                   case maps:find({V, Next}, Acc) of
%%                                                       {ok, Old} when Old =< D + W -> Acc;
%%                                                       _ -> Acc#{{V, Next} => D + W}
%%                                                   end;
%%                                               _ ->
%%                                                   Acc
%%                                           end
%%                                       end, Acc0, lists:seq(1, K))
%%                       end, Dist, Edges),
%%     case New =:= Dist of
%%         true -> Dist;
%%         false -> relax_all(New, Edges, Labels, K)
%%     end.

%% Better Approach
%%
%% -spec shortest_path(N :: integer(), Edges :: [[integer()]], Labels :: unicode:unicode_binary(), K :: integer()) -> integer().
%% shortest_path(N, Edges, Labels, K) ->
%%     G = lists:foldl(fun([U, V, W], Acc) -> maps:update_with(U, fun(L) -> [{V, W} | L] end, [{V, W}], Acc) end,
%%                     #{}, Edges),
%%     loop(gb_sets:singleton({0, 0, 1}), #{{0, 1} => 0}, G, Labels, N, K).
%%
%% loop(Q, Dist, G, Labels, N, K) ->
%%     case gb_sets:is_empty(Q) of
%%         true ->
%%             -1;
%%         false ->
%%             {{D, U, R}, Q1} = gb_sets:take_smallest(Q),
%%             if
%%                 U =:= N - 1 ->
%%                     D;
%%                 true ->
%%                     case D > maps:get({U, R}, Dist) of
%%                         true ->
%%                             loop(Q1, Dist, G, Labels, N, K);
%%                         false ->
%%                             C = binary:at(Labels, U),
%%                             {Q2, Dist2} = lists:foldl(fun({V, W}, {Qa, Da}) ->
%%                                                           Next = case binary:at(Labels, V) of
%%                                                                      C -> R + 1;
%%                                                                      _ -> 1
%%                                                                  end,
%%                                                           ND = D + W,
%%                                                           case Next =< K andalso ND < maps:get({V, Next}, Da, infinity) of
%%                                                               true -> {gb_sets:add({ND, V, Next}, Qa), Da#{{V, Next} => ND}};
%%                                                               false -> {Qa, Da}
%%                                                           end
%%                                                       end, {Q1, Dist}, maps:get(U, G, [])),
%%                             loop(Q2, Dist2, G, Labels, N, K)
%%                     end
%%             end
%%     end.

-spec shortest_path(N :: integer(), Edges :: [[integer()]], Labels :: unicode:unicode_binary(), K :: integer()) -> integer().
shortest_path(N, Edges, Labels, K) ->
    M = length(Edges),
    Start = atomics:new(N + 1, []),
    To = atomics:new(max(1, M), []),
    Wt = atomics:new(max(1, M), []),
    lists:foreach(fun([U, _, _]) -> atomics:add(Start, U + 2, 1) end, Edges),
    lists:foreach(fun(I) -> atomics:add(Start, I, atomics:get(Start, I - 1)) end, lists:seq(2, N + 1)),
    lists:foreach(fun([U, V, W]) ->
                      P = atomics:add_get(Start, U + 1, 1),
                      atomics:put(To, P, V),
                      atomics:put(Wt, P, W)
                  end, Edges),
    Best = atomics:new(N, []),
    dijkstra(gb_sets:singleton({0, 0, 1}), {Start, To, Wt}, Best, Labels, N, K).

dijkstra(Q, G, Best, Labels, N, K) ->
    case gb_sets:is_empty(Q) of
        true ->
            -1;
        false ->
            {{D, U, R}, Q1} = gb_sets:take_smallest(Q),
            B = atomics:get(Best, U + 1),
            if
                B =/= 0, R >= B ->
                    dijkstra(Q1, G, Best, Labels, N, K);
                U =:= N - 1 ->
                    D;
                true ->
                    atomics:put(Best, U + 1, R),
                    {Start, _, _} = G,
                    From = case U of
                               0 -> 1;
                               _ -> atomics:get(Start, U) + 1
                           end,
                    Q2 = relax(G, From, atomics:get(Start, U + 1), D, R, binary:at(Labels, U), Best, Labels, K, Q1),
                    dijkstra(Q2, G, Best, Labels, N, K)
            end
    end.

relax(_G, I, E, _D, _R, _C, _Best, _Labels, _K, Q) when I > E -> Q;
relax({_, To, Wt} = G, I, E, D, R, C, Best, Labels, K, Q) ->
    V = atomics:get(To, I),
    Next = case binary:at(Labels, V) of
               C -> R + 1;
               _ -> 1
           end,
    B = atomics:get(Best, V + 1),
    Q1 = if
             Next > K -> Q;
             B =/= 0, Next >= B -> Q;
             true -> gb_sets:add({D + atomics:get(Wt, I), V, Next}, Q)
         end,
    relax(G, I + 1, E, D, R, C, Best, Labels, K, Q1).