=begin
Brute Force

def count_days_together(arrive_alice, leave_alice, arrive_bob, leave_bob)
  days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  count = 0
  (1..12).each do |m|
    (1..days[m - 1]).each do |d|
      date = format('%02d-%02d', m, d)
      count += 1 if date.between?(arrive_alice, leave_alice) && date.between?(arrive_bob, leave_bob)
    end
  end
  count
end
=end

=begin
Better Approach

def count_days_together(arrive_alice, leave_alice, arrive_bob, leave_bob)
  days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  to_day = ->(date) { days[0, date[0, 2].to_i - 1].sum + date[3, 2].to_i }
  start = [to_day.(arrive_alice), to_day.(arrive_bob)].max
  finish = [to_day.(leave_alice), to_day.(leave_bob)].min
  [0, finish - start + 1].max
end
=end

def count_days_together(arrive_alice, leave_alice, arrive_bob, leave_bob)
  start = [arrive_alice, arrive_bob].max
  finish = [leave_alice, leave_bob].min
  return 0 if start > finish
  prefix = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
  day_of_year = ->(d) { prefix[d[0, 2].to_i - 1] + d[3, 2].to_i }
  day_of_year.(finish) - day_of_year.(start) + 1
end