~S"""
Brute Force

defmodule Solution do
  @spec count_days_together(arrive_alice :: String.t, leave_alice :: String.t, arrive_bob :: String.t, leave_bob :: String.t) :: integer
  def count_days_together(arrive_alice, leave_alice, arrive_bob, leave_bob) do
    days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    for {count, m} <- Enum.with_index(days, 1),
        d <- 1..count,
        date = pad(m) <> "-" <> pad(d),
        date >= arrive_alice and date <= leave_alice and date >= arrive_bob and date <= leave_bob,
        reduce: 0 do
      acc -> acc + 1
    end
  end

  def pad(n), do: n |> Integer.to_string() |> String.pad_leading(2, "0")
end
"""

~S"""
Better Approach

defmodule Solution do
  @spec count_days_together(arrive_alice :: String.t, leave_alice :: String.t, arrive_bob :: String.t, leave_bob :: String.t) :: integer
  def count_days_together(arrive_alice, leave_alice, arrive_bob, leave_bob) do
    start = max(to_day(arrive_alice), to_day(arrive_bob))
    finish = min(to_day(leave_alice), to_day(leave_bob))
    max(0, finish - start + 1)
  end

  def to_day(date) do
    days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    [month, day] = date |> String.split("-") |> Enum.map(&String.to_integer/1)
    (days |> Enum.take(month - 1) |> Enum.sum()) + day
  end
end
"""

defmodule Solution do
  @spec count_days_together(arrive_alice :: String.t, leave_alice :: String.t, arrive_bob :: String.t, leave_bob :: String.t) :: integer
  def count_days_together(arrive_alice, leave_alice, arrive_bob, leave_bob) do
    start = max(arrive_alice, arrive_bob)
    finish = min(leave_alice, leave_bob)
    if start > finish, do: 0, else: day_of_year(finish) - day_of_year(start) + 1
  end

  def day_of_year(<<m1, m2, ?-, d1, d2>>) do
    month = (m1 - ?0) * 10 + (m2 - ?0)
    day = (d1 - ?0) * 10 + (d2 - ?0)
    elem({0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334}, month - 1) + day
  end
end