%% Brute Force
%%
%% -spec count_days_together(ArriveAlice :: unicode:unicode_binary(), LeaveAlice :: unicode:unicode_binary(), ArriveBob :: unicode:unicode_binary(), LeaveBob :: unicode:unicode_binary()) -> integer().
%% count_days_together(ArriveAlice, LeaveAlice, ArriveBob, LeaveBob) ->
%%     Days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
%%     length([1 || {M, Count} <- lists:zip(lists:seq(1, 12), Days),
%%                  D <- lists:seq(1, Count),
%%                  Date <- [list_to_binary(io_lib:format("~2..0B-~2..0B", [M, D]))],
%%                  Date >= ArriveAlice, Date =< LeaveAlice,
%%                  Date >= ArriveBob, Date =< LeaveBob]).

%% Better Approach
%%
%% -spec count_days_together(ArriveAlice :: unicode:unicode_binary(), LeaveAlice :: unicode:unicode_binary(), ArriveBob :: unicode:unicode_binary(), LeaveBob :: unicode:unicode_binary()) -> integer().
%% count_days_together(ArriveAlice, LeaveAlice, ArriveBob, LeaveBob) ->
%%     Start = max(to_day(ArriveAlice), to_day(ArriveBob)),
%%     End = min(to_day(LeaveAlice), to_day(LeaveBob)),
%%     max(0, End - Start + 1).
%%
%% to_day(<<M:2/binary, "-", D:2/binary>>) ->
%%     Days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
%%     Month = binary_to_integer(M),
%%     lists:sum(lists:sublist(Days, Month - 1)) + binary_to_integer(D).

-spec count_days_together(ArriveAlice :: unicode:unicode_binary(), LeaveAlice :: unicode:unicode_binary(), ArriveBob :: unicode:unicode_binary(), LeaveBob :: unicode:unicode_binary()) -> integer().
count_days_together(ArriveAlice, LeaveAlice, ArriveBob, LeaveBob) ->
    Start = max(ArriveAlice, ArriveBob),
    End = min(LeaveAlice, LeaveBob),
    case Start > End of
        true -> 0;
        false -> day_of_year(End) - day_of_year(Start) + 1
    end.

day_of_year(<<M1, M2, $-, D1, D2>>) ->
    Month = (M1 - $0) * 10 + (M2 - $0),
    Day = (D1 - $0) * 10 + (D2 - $0),
    element(Month, {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334}) + Day.