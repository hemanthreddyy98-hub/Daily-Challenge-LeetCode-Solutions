=begin
Brute Force

def shortest_path(n, edges, labels, k)
  inf = Float::INFINITY
  dist = Array.new(n) { Array.new(k + 1, inf) }
  dist[0][1] = 0
  changed = true
  while changed
    changed = false
    edges.each do |u, v, w|
      (1..k).each do |run|
        next if dist[u][run] == inf
        nxt = labels[v] == labels[u] ? run + 1 : 1
        if nxt <= k && dist[u][run] + w < dist[v][nxt]
          dist[v][nxt] = dist[u][run] + w
          changed = true
        end
      end
    end
  end
  ans = dist[n - 1][1..].min
  ans == inf ? -1 : ans
end
=end

=begin
Better Approach

def shortest_path(n, edges, labels, k)
  g = Array.new(n) { [] }
  edges.each { |u, v, w| g[u] << [v, w] }
  dist = Array.new(n) { Array.new(k + 1, Float::INFINITY) }
  heap = []
  push = lambda do |item|
    heap << item
    i = heap.size - 1
    while i > 0
      p = (i - 1) / 2
      break if heap[p][0] <= item[0]
      heap[i] = heap[p]
      i = p
    end
    heap[i] = item
  end
  pop = lambda do
    top = heap[0]
    last = heap.pop
    unless heap.empty?
      i = 0
      while 2 * i + 1 < heap.size
        c = 2 * i + 1
        c += 1 if c + 1 < heap.size && heap[c + 1][0] < heap[c][0]
        break if heap[c][0] >= last[0]
        heap[i] = heap[c]
        i = c
      end
      heap[i] = last
    end
    top
  end
  dist[0][1] = 0
  push.([0, 0, 1])
  until heap.empty?
    d, u, run = pop.()
    return d if u == n - 1
    next if d > dist[u][run]
    g[u].each do |v, w|
      nxt = labels[v] == labels[u] ? run + 1 : 1
      if nxt <= k && d + w < dist[v][nxt]
        dist[v][nxt] = d + w
        push.([d + w, v, nxt])
      end
    end
  end
  -1
end
=end

def shortest_path(n, edges, labels, k)
  g = Array.new(n) { [] }
  edges.each { |u, v, w| g[u] << [v, w] }
  best = Array.new(n, k + 1)
  heap = []
  push = lambda do |item|
    heap << item
    i = heap.size - 1
    while i > 0
      p = (i - 1) / 2
      break if heap[p][0] <= item[0]
      heap[i] = heap[p]
      i = p
    end
    heap[i] = item
  end
  pop = lambda do
    top = heap[0]
    last = heap.pop
    unless heap.empty?
      i = 0
      while 2 * i + 1 < heap.size
        c = 2 * i + 1
        c += 1 if c + 1 < heap.size && heap[c + 1][0] < heap[c][0]
        break if heap[c][0] >= last[0]
        heap[i] = heap[c]
        i = c
      end
      heap[i] = last
    end
    top
  end
  push.([0, 0, 1])
  until heap.empty?
    d, u, run = pop.()
    next if run >= best[u]
    return d if u == n - 1
    best[u] = run
    g[u].each do |v, w|
      nxt = labels[v] == labels[u] ? run + 1 : 1
      push.([d + w, v, nxt]) if nxt <= k && nxt < best[v]
    end
  end
  -1
end