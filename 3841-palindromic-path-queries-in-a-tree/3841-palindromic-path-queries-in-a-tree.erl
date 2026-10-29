%% Brute Force
%%
%% -spec palindrome_path(N :: integer(), Edges :: [[integer()]], S :: unicode:unicode_binary(), Queries :: [unicode:unicode_binary()]) -> [boolean()].
%% palindrome_path(N, Edges, S, Queries) ->
%%     G = graph(N, Edges),
%%     Ch0 = maps:from_list(lists:zip(lists:seq(0, N - 1), [Byte - $a || Byte <- binary_to_list(S)])),
%%     {Ans, _} = lists:foldl(fun(Q, {Acc, Ch}) ->
%%                                case binary:split(Q, <<" ">>, [global]) of
%%                                    [<<"update">>, A, <<C>>] ->
%%                                        {Acc, Ch#{binary_to_integer(A) := C - $a}};
%%                                    [<<"query">>, A, B] ->
%%                                        U = binary_to_integer(A),
%%                                        Par = search(G, [U], #{U => U}),
%%                                        Mask = walk(Par, Ch, binary_to_integer(B), U, 0),
%%                                        {[(Mask band (Mask - 1)) =:= 0 | Acc], Ch}
%%                                end
%%                            end, {[], Ch0}, Queries),
%%     lists:reverse(Ans).
%%
%% graph(N, Edges) ->
%%     lists:foldl(fun([A, B], G) ->
%%                     G#{A := [B | maps:get(A, G)], B := [A | maps:get(B, G)]}
%%                 end, maps:from_list([{I, []} || I <- lists:seq(0, N - 1)]), Edges).
%%
%% search(_G, [], Par) -> Par;
%% search(G, [X | Rest], Par) ->
%%     New = [Y || Y <- maps:get(X, G), not maps:is_key(Y, Par)],
%%     search(G, New ++ Rest, lists:foldl(fun(Y, P) -> P#{Y => X} end, Par, New)).
%%
%% walk(_Par, Ch, U, U, Mask) -> Mask bxor (1 bsl maps:get(U, Ch));
%% walk(Par, Ch, X, U, Mask) -> walk(Par, Ch, maps:get(X, Par), U, Mask bxor (1 bsl maps:get(X, Ch))).

%% Better Approach
%%
%% -spec palindrome_path(N :: integer(), Edges :: [[integer()]], S :: unicode:unicode_binary(), Queries :: [unicode:unicode_binary()]) -> [boolean()].
%% palindrome_path(N, Edges, S, Queries) ->
%%     G = graph(N, Edges),
%%     {Par, Depth} = root(G, [0], #{0 => 0}, #{0 => 0}),
%%     Ch0 = maps:from_list(lists:zip(lists:seq(0, N - 1), [Byte - $a || Byte <- binary_to_list(S)])),
%%     {Ans, _} = lists:foldl(fun(Q, {Acc, Ch}) ->
%%                                case binary:split(Q, <<" ">>, [global]) of
%%                                    [<<"update">>, A, <<C>>] ->
%%                                        {Acc, Ch#{binary_to_integer(A) := C - $a}};
%%                                    [<<"query">>, A, B] ->
%%                                        Mask = climb(Par, Depth, Ch, binary_to_integer(A), binary_to_integer(B), 0),
%%                                        {[(Mask band (Mask - 1)) =:= 0 | Acc], Ch}
%%                                end
%%                            end, {[], Ch0}, Queries),
%%     lists:reverse(Ans).
%%
%% graph(N, Edges) ->
%%     lists:foldl(fun([A, B], G) ->
%%                     G#{A := [B | maps:get(A, G)], B := [A | maps:get(B, G)]}
%%                 end, maps:from_list([{I, []} || I <- lists:seq(0, N - 1)]), Edges).
%%
%% root(_G, [], Par, Depth) -> {Par, Depth};
%% root(G, [X | Rest], Par, Depth) ->
%%     New = [Y || Y <- maps:get(X, G), not maps:is_key(Y, Par)],
%%     D = maps:get(X, Depth) + 1,
%%     root(G, New ++ Rest,
%%          lists:foldl(fun(Y, P) -> P#{Y => X} end, Par, New),
%%          lists:foldl(fun(Y, P) -> P#{Y => D} end, Depth, New)).
%%
%% climb(_Par, _Depth, Ch, X, X, Mask) -> Mask bxor (1 bsl maps:get(X, Ch));
%% climb(Par, Depth, Ch, U, V, Mask) ->
%%     case maps:get(U, Depth) < maps:get(V, Depth) of
%%         true -> climb(Par, Depth, Ch, V, U, Mask);
%%         false -> climb(Par, Depth, Ch, maps:get(U, Par), V, Mask bxor (1 bsl maps:get(U, Ch)))
%%     end.

-spec palindrome_path(N :: integer(), Edges :: [[integer()]], S :: unicode:unicode_binary(), Queries :: [unicode:unicode_binary()]) -> [boolean()].
palindrome_path(N, Edges, S, Queries) ->
    Self = self(),
    {Pid, Ref} = spawn_opt(fun() -> Self ! {self(), solve(N, Edges, S, Queries)} end,
                           [monitor, {min_heap_size, 40 * (N + length(Queries))}]),
    receive
        {Pid, Ans} ->
            erlang:demonitor(Ref, [flush]),
            Ans;
        {'DOWN', Ref, process, Pid, Reason} ->
            erlang:error(Reason)
    end.

solve(N, Edges, S, Queries) ->
    lists:foreach(fun(X) -> put(-X - 1, []) end, lists:seq(0, N - 1)),
    lists:foreach(fun([A, B]) -> put(-A - 1, [B | get(-A - 1)]), put(-B - 1, [A | get(-B - 1)]) end, Edges),
    Off = -N,
    CO = -2 * N - 1,
    lists:foldl(fun(Byte, X) -> put(CO - X, Byte - $a), X + 1 end, 0, binary_to_list(S)),
    {PosL, OutL, ParL, Ms, MaxD} = dfs([{0, 0, 0, 0}], CO, 0, [], [], [], [], 0),
    Ids = lists:seq(1, N),
    lists:foreach(fun(I) -> put(Off - I, 0) end, Ids),
    build(lists:reverse(Ms), Off, N, 1, 0),
    PosT = erlang:make_tuple(N, 0, PosL),
    OutT = erlang:make_tuple(N, 0, OutL),
    Up0 = erlang:make_tuple(N, 0, ParL),
    Levels = lists:foldl(fun(_, [Prev | _] = Acc) ->
                             [list_to_tuple([element(element(I, Prev) + 1, Prev) || I <- Ids]) | Acc]
                         end, [Up0], lists:seq(2, max(1, bits(MaxD)))),
    Up = list_to_tuple(lists:reverse(Levels)),
    Ans = lists:foldl(fun(Q, Acc) -> step(Q, Acc, N, Off, CO, Up, PosT, OutT) end, [], Queries),
    lists:reverse(Ans).

step(<<"update ", Rest/binary>>, Acc, N, Off, CO, _Up, PosT, OutT) ->
    [A, <<C>>] = binary:split(Rest, <<" ">>),
    U = binary_to_integer(A),
    D = (1 bsl put(CO - U, C - $a)) bxor (1 bsl (C - $a)),
    add(Off, N, element(U + 1, PosT), D),
    add(Off, N, element(U + 1, OutT), D),
    Acc;
step(<<"query ", Rest/binary>>, Acc, _N, Off, CO, Up, PosT, OutT) ->
    [A, B] = binary:split(Rest, <<" ">>),
    U = binary_to_integer(A),
    V = binary_to_integer(B),
    Mask = prefix(Off, element(U + 1, PosT), 0) bxor prefix(Off, element(V + 1, PosT), 0)
           bxor (1 bsl get(CO - lca(Up, PosT, OutT, U, V))),
    [(Mask band (Mask - 1)) =:= 0 | Acc].

dfs([], _CO, _T, PosL, OutL, ParL, Ms, MaxD) ->
    {PosL, OutL, ParL, Ms, MaxD};
dfs([{X} | Stack], CO, T, PosL, OutL, ParL, Ms, MaxD) ->
    dfs(Stack, CO, T, PosL, [{X + 1, T + 1} | OutL], ParL, Ms, MaxD);
dfs([{X, P, D, M} | Stack], CO, T, PosL, OutL, ParL, Ms, MaxD) ->
    M1 = M bxor (1 bsl get(CO - X)),
    Stack1 = push(erase(-X - 1), P, X, D + 1, M1, [{X} | Stack]),
    dfs(Stack1, CO, T + 1, [{X + 1, T + 1} | PosL], OutL, [{X + 1, P} | ParL], [M1 | Ms], max(D, MaxD)).

push([], _P, _X, _D, _M, Stack) -> Stack;
push([P | Ys], P, X, D, M, Stack) -> push(Ys, P, X, D, M, Stack);
push([Y | Ys], P, X, D, M, Stack) -> push(Ys, P, X, D, M, [{Y, X, D, M} | Stack]).

build([], _Off, _N, _I, _Prev) -> ok;
build([A | Rest], Off, N, I, Prev) ->
    V = get(Off - I) bxor A bxor Prev,
    put(Off - I, V),
    J = I + (I band (-I)),
    if
        J =< N -> put(Off - J, get(Off - J) bxor V);
        true -> ok
    end,
    build(Rest, Off, N, I + 1, A).

add(_Off, N, I, _D) when I > N -> ok;
add(Off, N, I, D) ->
    put(Off - I, get(Off - I) bxor D),
    add(Off, N, I + (I band (-I)), D).

prefix(_Off, 0, Acc) -> Acc;
prefix(Off, I, Acc) -> prefix(Off, I band (I - 1), Acc bxor get(Off - I)).

bits(0) -> 0;
bits(D) -> 1 + bits(D bsr 1).

lca(Up, PosT, OutT, U, V) ->
    PU = element(U + 1, PosT),
    PV = element(V + 1, PosT),
    if
        PU =< PV, PV < element(U + 1, OutT) -> U;
        PV =< PU, PU < element(V + 1, OutT) -> V;
        true -> element(climb(Up, tuple_size(Up), U, PV, PosT, OutT) + 1, element(1, Up))
    end.

climb(_Up, 0, U, _PV, _PosT, _OutT) -> U;
climb(Up, K, U, PV, PosT, OutT) ->
    X = element(U + 1, element(K, Up)),
    case element(X + 1, PosT) =< PV andalso PV < element(X + 1, OutT) of
        true -> climb(Up, K - 1, U, PV, PosT, OutT);
        false -> climb(Up, K - 1, X, PV, PosT, OutT)
    end.