=begin
Brute Force

def count_islands(grid, k)
  m = grid.length
  n = grid[0].length
  count = 0
  (0...m).each do |i|
    (0...n).each do |j|
      next if grid[i][j] == 0
      seen = Array.new(m) { Array.new(n, false) }
      seen[i][j] = true
      stack = [[i, j]]
      sum = 0
      first = true
      until stack.empty?
        r, c = stack.pop
        sum += grid[r][c]
        first = false if r * n + c < i * n + j
        [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]].each do |nr, nc|
          next if nr < 0 || nc < 0 || nr >= m || nc >= n
          next if grid[nr][nc] == 0 || seen[nr][nc]
          seen[nr][nc] = true
          stack << [nr, nc]
        end
      end
      count += 1 if first && sum % k == 0
    end
  end
  count
end
=end

=begin
Better Approach

def count_islands(grid, k)
  m = grid.length
  n = grid[0].length
  visited = Array.new(m) { Array.new(n, false) }
  count = 0
  (0...m).each do |i|
    (0...n).each do |j|
      next if grid[i][j] == 0 || visited[i][j]
      visited[i][j] = true
      queue = [[i, j]]
      head = 0
      sum = 0
      while head < queue.length
        r, c = queue[head]
        head += 1
        sum += grid[r][c]
        [[r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]].each do |nr, nc|
          next if nr < 0 || nc < 0 || nr >= m || nc >= n
          next if grid[nr][nc] == 0 || visited[nr][nc]
          visited[nr][nc] = true
          queue << [nr, nc]
        end
      end
      count += 1 if sum % k == 0
    end
  end
  count
end
=end

def count_islands(grid, k)
  m = grid.length
  n = grid[0].length
  q = Array.new(m * n, 0)
  dr = [1, -1, 0, 0]
  dc = [0, 0, 1, -1]
  count = 0
  (0...m).each do |i|
    (0...n).each do |j|
      next if grid[i][j] == 0
      sum = grid[i][j] % k
      grid[i][j] = 0
      q[0] = i * n + j
      head = 0
      tail = 1
      while head < tail
        r, c = q[head].divmod(n)
        head += 1
        4.times do |d|
          nr = r + dr[d]
          nc = c + dc[d]
          next if nr < 0 || nc < 0 || nr >= m || nc >= n || grid[nr][nc] == 0
          sum = (sum + grid[nr][nc]) % k
          grid[nr][nc] = 0
          q[tail] = nr * n + nc
          tail += 1
        end
      end
      count += 1 if sum == 0
    end
  end
  count
end