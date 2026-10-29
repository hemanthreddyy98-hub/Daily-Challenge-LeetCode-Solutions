=begin
Brute Force

def palindrome_path(n, edges, s, queries)
  g = Array.new(n) { [] }
  edges.each do |a, b|
    g[a] << b
    g[b] << a
  end
  ch = s.bytes.map { |c| c - 97 }
  ans = []
  queries.each do |q|
    t, a, b = q.split
    u = a.to_i
    if t == "update"
      ch[u] = b.ord - 97
      next
    end
    v = b.to_i
    par = Array.new(n, -1)
    par[u] = u
    bfs = [u]
    i = 0
    while i < bfs.size
      x = bfs[i]
      i += 1
      g[x].each do |y|
        next unless par[y] == -1
        par[y] = x
        bfs << y
      end
    end
    mask = 1 << ch[u]
    cur = v
    while cur != u
      mask ^= 1 << ch[cur]
      cur = par[cur]
    end
    ans << (mask & (mask - 1)).zero?
  end
  ans
end
=end

=begin
Better Approach

def palindrome_path(n, edges, s, queries)
  g = Array.new(n) { [] }
  edges.each do |a, b|
    g[a] << b
    g[b] << a
  end
  ch = s.bytes.map { |c| c - 97 }
  par = Array.new(n, -1)
  depth = Array.new(n, 0)
  par[0] = 0
  bfs = [0]
  i = 0
  while i < bfs.size
    x = bfs[i]
    i += 1
    g[x].each do |y|
      next unless par[y] == -1
      par[y] = x
      depth[y] = depth[x] + 1
      bfs << y
    end
  end
  ans = []
  queries.each do |q|
    t, a, b = q.split
    u = a.to_i
    if t == "update"
      ch[u] = b.ord - 97
      next
    end
    v = b.to_i
    mask = 0
    while u != v
      u, v = v, u if depth[u] < depth[v]
      mask ^= 1 << ch[u]
      u = par[u]
    end
    mask ^= 1 << ch[u]
    ans << (mask & (mask - 1)).zero?
  end
  ans
end
=end

def palindrome_path(n, edges, s, queries)
  g = Array.new(n) { [] }
  edges.each do |a, b|
    g[a] << b
    g[b] << a
  end
  ch = s.bytes.map { |c| c - 97 }
  log = 17
  up = Array.new(log) { Array.new(n, 0) }
  depth = Array.new(n, 0)
  tin = Array.new(n, 0)
  sz = Array.new(n, 1)
  seen = Array.new(n, false)
  order = []
  st = [0]
  seen[0] = true
  until st.empty?
    x = st.pop
    tin[x] = order.size
    order << x
    g[x].each do |y|
      next if seen[y]
      seen[y] = true
      up[0][y] = x
      depth[y] = depth[x] + 1
      st << y
    end
  end
  (n - 1).downto(1) { |i| sz[up[0][order[i]]] += sz[order[i]] }
  (1...log).each do |k|
    prev = up[k - 1]
    cur = up[k]
    n.times { |j| cur[j] = prev[prev[j]] }
  end
  bit = Array.new(n + 1, 0)
  add = lambda do |i, d|
    while i <= n
      bit[i] ^= d
      i += i & -i
    end
  end
  range_xor = lambda do |w, d|
    add.(tin[w] + 1, d)
    add.(tin[w] + sz[w] + 1, d)
  end
  prefix = lambda do |w|
    r = 0
    i = tin[w] + 1
    while i > 0
      r ^= bit[i]
      i -= i & -i
    end
    r
  end
  lca = lambda do |p, q|
    p, q = q, p if depth[p] < depth[q]
    (log - 1).downto(0) { |k| p = up[k][p] if depth[p] - (1 << k) >= depth[q] }
    return p if p == q
    (log - 1).downto(0) do |k|
      p, q = up[k][p], up[k][q] if up[k][p] != up[k][q]
    end
    up[0][p]
  end
  n.times { |j| range_xor.(j, 1 << ch[j]) }
  ans = []
  queries.each do |query|
    t, a, b = query.split
    u = a.to_i
    if t == "update"
      c = b.ord - 97
      range_xor.(u, (1 << ch[u]) ^ (1 << c))
      ch[u] = c
    else
      v = b.to_i
      mask = prefix.(u) ^ prefix.(v) ^ (1 << ch[lca.(u, v)])
      ans << (mask & (mask - 1)).zero?
    end
  end
  ans
end