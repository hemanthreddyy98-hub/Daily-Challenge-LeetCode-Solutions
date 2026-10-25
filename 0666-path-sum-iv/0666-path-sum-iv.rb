=begin
Brute Force

def path_sum(nums)
  total = 0
  nums.each do |x|
    d = x / 100
    pos = x / 10 % 10
    next if nums.any? { |y| y / 100 == d + 1 && [2 * pos - 1, 2 * pos].include?(y / 10 % 10) }
    while d >= 1
      node = nums.find { |y| y / 100 == d && y / 10 % 10 == pos }
      total += node % 10
      d -= 1
      pos = (pos + 1) / 2
    end
  end
  total
end
=end

=begin
Better Approach

def path_sum(nums)
  tree = {}
  nums.each { |x| tree[x / 10] = x % 10 }
  dfs = lambda do |d, pos, sum|
    return 0 unless tree.key?(d * 10 + pos)
    sum += tree[d * 10 + pos]
    left = (d + 1) * 10 + 2 * pos - 1
    return sum unless tree.key?(left) || tree.key?(left + 1)
    dfs.(d + 1, 2 * pos - 1, sum) + dfs.(d + 1, 2 * pos, sum)
  end
  dfs.(1, 1, 0)
end
=end

def path_sum(nums)
  leaves = Array.new(16, 0)
  ans = 0
  nums.reverse_each do |x|
    d = x / 100
    pos = x / 10 % 10
    idx = (1 << (d - 1)) + pos - 1
    leaves[idx] = 1 if leaves[idx] == 0
    ans += (x % 10) * leaves[idx]
    leaves[idx / 2] += leaves[idx] if idx > 1
  end
  ans
end