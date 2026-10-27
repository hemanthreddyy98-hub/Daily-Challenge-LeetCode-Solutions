=begin
Brute Force

def create_grid(m, n)
  g = Array.new(m) { Array.new(n, '.') }
  reach = lambda do |r, c|
    return false if r >= m || c >= n || g[r][c] == '#'
    return true if r == m - 1 && c == n - 1
    reach.(r + 1, c) || reach.(r, c + 1)
  end
  (0...m).each do |i|
    (0...n).each do |j|
      next if (i == 0 && j == 0) || (i == m - 1 && j == n - 1)
      g[i][j] = '#'
      g[i][j] = '.' unless reach.(0, 0)
    end
  end
  g.map(&:join)
end
=end

=begin
Better Approach

def create_grid(m, n)
  g = Array.new(m) { Array.new(n, '.') }
  reach = lambda do
    ok = Array.new(m) { Array.new(n, false) }
    (0...m).each do |i|
      (0...n).each do |j|
        next if g[i][j] == '#'
        ok[i][j] = (i == 0 && j == 0) || (i > 0 && ok[i - 1][j]) || (j > 0 && ok[i][j - 1])
      end
    end
    ok[m - 1][n - 1]
  end
  (0...m).each do |i|
    (0...n).each do |j|
      next if (i == 0 && j == 0) || (i == m - 1 && j == n - 1)
      g[i][j] = '#'
      g[i][j] = '.' unless reach.()
    end
  end
  g.map(&:join)
end
=end

def create_grid(m, n)
  ['.' * n] + ['#' * (n - 1) + '.'] * (m - 1)
end