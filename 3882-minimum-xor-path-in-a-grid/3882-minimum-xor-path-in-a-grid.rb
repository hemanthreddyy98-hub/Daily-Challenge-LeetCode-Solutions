=begin
Brute Force

def min_cost(grid)
  m, n = grid.size, grid[0].size
  dfs = lambda do |i, j, x|
    return x if i == m - 1 && j == n - 1
    best = Float::INFINITY
    best = [best, dfs.(i + 1, j, x ^ grid[i + 1][j])].min if i + 1 < m
    best = [best, dfs.(i, j + 1, x ^ grid[i][j + 1])].min if j + 1 < n
    best
  end
  dfs.(0, 0, grid[0][0])
end
=end

=begin
Better Approach

def min_cost(grid)
  m, n = grid.size, grid[0].size
  memo = Array.new(m * n * 1024, -1)
  dfs = lambda do |i, j, x|
    return x if i == m - 1 && j == n - 1
    key = (i * n + j) * 1024 + x
    return memo[key] if memo[key] != -1
    best = Float::INFINITY
    best = [best, dfs.(i + 1, j, x ^ grid[i + 1][j])].min if i + 1 < m
    best = [best, dfs.(i, j + 1, x ^ grid[i][j + 1])].min if j + 1 < n
    memo[key] = best
  end
  dfs.(0, 0, grid[0][0])
end
=end

def min_cost(grid)
  n = grid[0].size
  dp = Array.new(n) { [] }
  grid.each_with_index do |row, i|
    row.each_with_index do |v, j|
      from = i == 0 && j == 0 ? [0] : dp[j] | (j > 0 ? dp[j - 1] : [])
      dp[j] = from.map { |x| x ^ v }
    end
  end
  dp[n - 1].min
end