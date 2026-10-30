/*
Brute Force

func shortestPath(n int, edges [][]int, labels string, k int) int {
	const inf = math.MaxInt64
	dist := make([][]int, n)
	for i := range dist {
		dist[i] = make([]int, k+1)
		for j := range dist[i] {
			dist[i][j] = inf
		}
	}
	dist[0][1] = 0
	for changed := true; changed; {
		changed = false
		for _, e := range edges {
			u, v, w := e[0], e[1], e[2]
			for run := 1; run <= k; run++ {
				if dist[u][run] == inf {
					continue
				}
				next := 1
				if labels[v] == labels[u] {
					next = run + 1
				}
				if next <= k && dist[u][run]+w < dist[v][next] {
					dist[v][next] = dist[u][run] + w
					changed = true
				}
			}
		}
	}
	ans := inf
	for run := 1; run <= k; run++ {
		if dist[n-1][run] < ans {
			ans = dist[n-1][run]
		}
	}
	if ans == inf {
		return -1
	}
	return ans
}
*/

/*
Better Approach

type item struct{ d, u, run int }
type hp []item

func (h hp) Len() int           { return len(h) }
func (h hp) Less(i, j int) bool { return h[i].d < h[j].d }
func (h hp) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(x any)        { *h = append(*h, x.(item)) }
func (h *hp) Pop() any {
	old := *h
	x := old[len(old)-1]
	*h = old[:len(old)-1]
	return x
}

func shortestPath(n int, edges [][]int, labels string, k int) int {
	g := make([][][2]int, n)
	for _, e := range edges {
		g[e[0]] = append(g[e[0]], [2]int{e[1], e[2]})
	}
	dist := make([][]int, n)
	for i := range dist {
		dist[i] = make([]int, k+1)
		for j := range dist[i] {
			dist[i][j] = math.MaxInt64
		}
	}
	dist[0][1] = 0
	pq := &hp{{0, 0, 1}}
	for pq.Len() > 0 {
		t := heap.Pop(pq).(item)
		if t.u == n-1 {
			return t.d
		}
		if t.d > dist[t.u][t.run] {
			continue
		}
		for _, e := range g[t.u] {
			v, next := e[0], 1
			if labels[v] == labels[t.u] {
				next = t.run + 1
			}
			if next <= k && t.d+e[1] < dist[v][next] {
				dist[v][next] = t.d + e[1]
				heap.Push(pq, item{t.d + e[1], v, next})
			}
		}
	}
	return -1
}
*/

type item struct{ d, u, run int }
type hp []item

func (h hp) Len() int           { return len(h) }
func (h hp) Less(i, j int) bool { return h[i].d < h[j].d }
func (h hp) Swap(i, j int)      { h[i], h[j] = h[j], h[i] }
func (h *hp) Push(x any)        { *h = append(*h, x.(item)) }
func (h *hp) Pop() any {
	old := *h
	x := old[len(old)-1]
	*h = old[:len(old)-1]
	return x
}

func shortestPath(n int, edges [][]int, labels string, k int) int {
	g := make([][][2]int, n)
	for _, e := range edges {
		g[e[0]] = append(g[e[0]], [2]int{e[1], e[2]})
	}
	best := make([]int, n)
	for i := range best {
		best[i] = k + 1
	}
	pq := &hp{{0, 0, 1}}
	for pq.Len() > 0 {
		t := heap.Pop(pq).(item)
		if t.run >= best[t.u] {
			continue
		}
		if t.u == n-1 {
			return t.d
		}
		best[t.u] = t.run
		for _, e := range g[t.u] {
			v, next := e[0], 1
			if labels[v] == labels[t.u] {
				next = t.run + 1
			}
			if next <= k && next < best[v] {
				heap.Push(pq, item{t.d + e[1], v, next})
			}
		}
	}
	return -1
}