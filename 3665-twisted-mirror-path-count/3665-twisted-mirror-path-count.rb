=begin
Brute Force

def unique_paths(grid)
  m, n = grid.size, grid[0].size
  dfs = lambda do |i, j, d|
    return 0 if i >= m || j >= n
    return 1 if i == m - 1 && j == n - 1
    if grid[i][j] == 1
      d == 0 ? dfs.(i + 1, j, 1) : dfs.(i, j + 1, 0)
    else
      (dfs.(i, j + 1, 0) + dfs.(i + 1, j, 1)) % 1_000_000_007
    end
  end
  dfs.(0, 0, 0)
end
=end

=begin
Better Approach

def unique_paths(grid)
  m, n = grid.size, grid[0].size
  memo = Array.new(m * n * 2, -1)
  dfs = lambda do |i, j, d|
    return 0 if i >= m || j >= n
    return 1 if i == m - 1 && j == n - 1
    key = (i * n + j) * 2 + d
    return memo[key] if memo[key] != -1
    memo[key] = if grid[i][j] == 0
                  (dfs.(i, j + 1, 0) + dfs.(i + 1, j, 1)) % 1_000_000_007
                elsif d == 0
                  dfs.(i + 1, j, 1)
                else
                  dfs.(i, j + 1, 0)
                end
  end
  dfs.(0, 0, 0)
end
=end

def unique_paths(grid)
  mod = 1_000_000_007
  m, n = grid.size, grid[0].size
  r = Array.new(n, 0)
  d = Array.new(n, 0)
  m.times do |i|
    n.times do |j|
      if i == 0 && j == 0
        r[0] = 1
        next
      end
      nd = i == 0 ? 0 : grid[i - 1][j] == 0 ? (r[j] + d[j]) % mod : r[j]
      nr = j == 0 ? 0 : grid[i][j - 1] == 0 ? (r[j - 1] + d[j - 1]) % mod : d[j - 1]
      r[j] = nr
      d[j] = nd
    end
  end
  (r[n - 1] + d[n - 1]) % mod
end