=begin
Brute Force

def get_food(grid)
  m = grid.length
  n = grid[0].length
  best = Float::INFINITY

  dfs = lambda do |r, c, steps|
    return if r < 0 || c < 0 || r >= m || c >= n
    ch = grid[r][c]
    return if ch == 'X' || ch == 'V'
    if ch == '#'
      best = steps if steps < best
      return
    end
    grid[r][c] = 'V'
    dfs.(r + 1, c, steps + 1)
    dfs.(r - 1, c, steps + 1)
    dfs.(r, c + 1, steps + 1)
    dfs.(r, c - 1, steps + 1)
    grid[r][c] = ch
  end

  m.times do |i|
    n.times do |j|
      dfs.(i, j, 0) if grid[i][j] == '*'
    end
  end
  best == Float::INFINITY ? -1 : best
end
=end

=begin
Basic Approach

def get_food(grid)
  m = grid.length
  n = grid[0].length
  queue = []
  visited = Array.new(m) { Array.new(n, false) }
  (0...m).each do |i|
    (0...n).each do |j|
      if grid[i][j] == '*'
        queue << [i, j]
        visited[i][j] = true
      end
    end
  end
  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  steps = 0
  until queue.empty?
    queue.size.times do
      r0, c0 = queue.shift
      return steps if grid[r0][c0] == '#'
      dirs.each do |dr, dc|
        r = r0 + dr
        c = c0 + dc
        if r >= 0 && c >= 0 && r < m && c < n && !visited[r][c] && grid[r][c] != 'X'
          visited[r][c] = true
          queue << [r, c]
        end
      end
    end
    steps += 1
  end
  -1
end
=end

def get_food(grid)
  m = grid.length
  n = grid[0].length

  start = -1
  grid.each_with_index do |row, i|
    j = row.index('*')
    if j
      start = i * n + j
      break
    end
  end
  return -1 if start < 0

  q = Array.new(m * n, 0)
  q[0] = start
  head = 0
  tail = 1
  dr = [1, -1, 0, 0]
  dc = [0, 0, 1, -1]
  steps = 0

  while head < tail
    steps += 1
    level_end = tail
    while head < level_end
      r, c = q[head].divmod(n)
      head += 1
      4.times do |k|
        nr = r + dr[k]
        nc = c + dc[k]
        next if nr < 0 || nc < 0 || nr >= m || nc >= n
        ch = grid[nr][nc]
        return steps if ch == '#'
        if ch == 'O'
          grid[nr][nc] = 'X'
          q[tail] = nr * n + nc
          tail += 1
        end
      end
    end
  end
  -1
end