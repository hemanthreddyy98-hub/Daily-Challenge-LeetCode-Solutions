=begin
Brute Force

def closed_island(grid)
  m = grid.length
  n = grid[0].length
  count = 0
  (0...m).each do |i|
    (0...n).each do |j|
      next if grid[i][j] != 0
      seen = Array.new(m) { Array.new(n, false) }
      seen[i][j] = true
      stack = [[i, j]]
      closed = true
      first = true
      until stack.empty?
        r, c = stack.pop
        closed = false if r == 0 || c == 0 || r == m - 1 || c == n - 1
        first = false if r * n + c < i * n + j
        [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]].each do |nr, nc|
          next if nr < 0 || nc < 0 || nr >= m || nc >= n
          next if grid[nr][nc] != 0 || seen[nr][nc]
          seen[nr][nc] = true
          stack << [nr, nc]
        end
      end
      count += 1 if closed && first
    end
  end
  count
end
=end

=begin
Better Approach

def closed_island(grid)
  m = grid.length
  n = grid[0].length
  (0...m).each do |i|
    sink(grid, i, 0)
    sink(grid, i, n - 1)
  end
  (0...n).each do |j|
    sink(grid, 0, j)
    sink(grid, m - 1, j)
  end
  count = 0
  (0...m).each do |i|
    (0...n).each do |j|
      next if grid[i][j] != 0
      sink(grid, i, j)
      count += 1
    end
  end
  count
end

def sink(grid, r, c)
  return if r < 0 || c < 0 || r >= grid.length || c >= grid[0].length || grid[r][c] != 0
  grid[r][c] = 1
  sink(grid, r + 1, c)
  sink(grid, r - 1, c)
  sink(grid, r, c + 1)
  sink(grid, r, c - 1)
end
=end

def closed_island(grid)
  m = grid.length
  n = grid[0].length
  q = Array.new(m * n, 0)
  dr = [1, -1, 0, 0]
  dc = [0, 0, 1, -1]
  count = 0
  (0...m).each do |i|
    (0...n).each do |j|
      next if grid[i][j] != 0
      grid[i][j] = 1
      q[0] = i * n + j
      head = 0
      tail = 1
      closed = true
      while head < tail
        r, c = q[head].divmod(n)
        head += 1
        closed = false if r == 0 || c == 0 || r == m - 1 || c == n - 1
        4.times do |k|
          nr = r + dr[k]
          nc = c + dc[k]
          next if nr < 0 || nc < 0 || nr >= m || nc >= n || grid[nr][nc] != 0
          grid[nr][nc] = 1
          q[tail] = nr * n + nc
          tail += 1
        end
      end
      count += 1 if closed
    end
  end
  count
end