/*
Brute Force

func palindromePath(n int, edges [][]int, s string, queries []string) []bool {
	g := make([][]int, n)
	for _, e := range edges {
		g[e[0]] = append(g[e[0]], e[1])
		g[e[1]] = append(g[e[1]], e[0])
	}
	ch := []byte(s)
	ans := []bool{}
	for _, q := range queries {
		p := strings.Fields(q)
		u, _ := strconv.Atoi(p[1])
		if p[0] == "update" {
			ch[u] = p[2][0]
			continue
		}
		v, _ := strconv.Atoi(p[2])
		par := make([]int, n)
		for i := range par {
			par[i] = -1
		}
		par[u] = u
		bfs := []int{u}
		for i := 0; i < len(bfs); i++ {
			for _, y := range g[bfs[i]] {
				if par[y] == -1 {
					par[y] = bfs[i]
					bfs = append(bfs, y)
				}
			}
		}
		mask := 1 << (ch[u] - 'a')
		for cur := v; cur != u; cur = par[cur] {
			mask ^= 1 << (ch[cur] - 'a')
		}
		ans = append(ans, mask&(mask-1) == 0)
	}
	return ans
}
*/

/*
Better Approach

func palindromePath(n int, edges [][]int, s string, queries []string) []bool {
	g := make([][]int, n)
	for _, e := range edges {
		g[e[0]] = append(g[e[0]], e[1])
		g[e[1]] = append(g[e[1]], e[0])
	}
	ch := []byte(s)
	par, depth := make([]int, n), make([]int, n)
	for i := range par {
		par[i] = -1
	}
	par[0] = 0
	bfs := []int{0}
	for i := 0; i < len(bfs); i++ {
		x := bfs[i]
		for _, y := range g[x] {
			if par[y] == -1 {
				par[y] = x
				depth[y] = depth[x] + 1
				bfs = append(bfs, y)
			}
		}
	}
	ans := []bool{}
	for _, q := range queries {
		p := strings.Fields(q)
		u, _ := strconv.Atoi(p[1])
		if p[0] == "update" {
			ch[u] = p[2][0]
			continue
		}
		v, _ := strconv.Atoi(p[2])
		mask := 0
		for u != v {
			if depth[u] < depth[v] {
				u, v = v, u
			}
			mask ^= 1 << (ch[u] - 'a')
			u = par[u]
		}
		mask ^= 1 << (ch[u] - 'a')
		ans = append(ans, mask&(mask-1) == 0)
	}
	return ans
}
*/

func palindromePath(n int, edges [][]int, s string, queries []string) []bool {
	g := make([][]int, n)
	for _, e := range edges {
		g[e[0]] = append(g[e[0]], e[1])
		g[e[1]] = append(g[e[1]], e[0])
	}
	ch := []byte(s)
	const LOG = 17
	up := make([][]int, LOG)
	for k := range up {
		up[k] = make([]int, n)
	}
	depth, tin, sz := make([]int, n), make([]int, n), make([]int, n)
	seen := make([]bool, n)
	order, st := []int{}, []int{0}
	seen[0] = true
	for len(st) > 0 {
		x := st[len(st)-1]
		st = st[:len(st)-1]
		tin[x] = len(order)
		order = append(order, x)
		for _, y := range g[x] {
			if !seen[y] {
				seen[y] = true
				up[0][y] = x
				depth[y] = depth[x] + 1
				st = append(st, y)
			}
		}
	}
	for i := range sz {
		sz[i] = 1
	}
	for i := n - 1; i > 0; i-- {
		sz[up[0][order[i]]] += sz[order[i]]
	}
	for k := 1; k < LOG; k++ {
		for x := 0; x < n; x++ {
			up[k][x] = up[k-1][up[k-1][x]]
		}
	}
	bit := make([]int, n+1)
	add := func(i, d int) {
		for ; i <= n; i += i & -i {
			bit[i] ^= d
		}
	}
	rangeXor := func(x, d int) {
		add(tin[x]+1, d)
		add(tin[x]+sz[x]+1, d)
	}
	prefix := func(x int) int {
		r := 0
		for i := tin[x] + 1; i > 0; i -= i & -i {
			r ^= bit[i]
		}
		return r
	}
	lca := func(a, b int) int {
		if depth[a] < depth[b] {
			a, b = b, a
		}
		for k := LOG - 1; k >= 0; k-- {
			if depth[a]-(1<<k) >= depth[b] {
				a = up[k][a]
			}
		}
		if a == b {
			return a
		}
		for k := LOG - 1; k >= 0; k-- {
			if up[k][a] != up[k][b] {
				a, b = up[k][a], up[k][b]
			}
		}
		return up[0][a]
	}
	for x := 0; x < n; x++ {
		rangeXor(x, 1<<(ch[x]-'a'))
	}
	ans := []bool{}
	for _, q := range queries {
		p := strings.Fields(q)
		u, _ := strconv.Atoi(p[1])
		if p[0] == "update" {
			rangeXor(u, 1<<(ch[u]-'a')^1<<(p[2][0]-'a'))
			ch[u] = p[2][0]
		} else {
			v, _ := strconv.Atoi(p[2])
			mask := prefix(u) ^ prefix(v) ^ 1<<(ch[lca(u, v)]-'a')
			ans = append(ans, mask&(mask-1) == 0)
		}
	}
	return ans
}