/*
Brute Force

func createGrid(m int, n int) []string {
	g := make([][]byte, m)
	for i := range g {
		g[i] = make([]byte, n)
		for j := range g[i] {
			g[i][j] = '.'
		}
	}
	var reach func(r, c int) bool
	reach = func(r, c int) bool {
		if r >= m || c >= n || g[r][c] == '#' {
			return false
		}
		if r == m-1 && c == n-1 {
			return true
		}
		return reach(r+1, c) || reach(r, c+1)
	}
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if (i == 0 && j == 0) || (i == m-1 && j == n-1) {
				continue
			}
			g[i][j] = '#'
			if !reach(0, 0) {
				g[i][j] = '.'
			}
		}
	}
	ans := make([]string, m)
	for i := range g {
		ans[i] = string(g[i])
	}
	return ans
}
*/

/*
Better Approach

func createGrid(m int, n int) []string {
	g := make([][]byte, m)
	for i := range g {
		g[i] = make([]byte, n)
		for j := range g[i] {
			g[i][j] = '.'
		}
	}
	reach := func() bool {
		ok := make([][]bool, m)
		for i := range ok {
			ok[i] = make([]bool, n)
			for j := range ok[i] {
				if g[i][j] == '#' {
					continue
				}
				ok[i][j] = (i == 0 && j == 0) || (i > 0 && ok[i-1][j]) || (j > 0 && ok[i][j-1])
			}
		}
		return ok[m-1][n-1]
	}
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if (i == 0 && j == 0) || (i == m-1 && j == n-1) {
				continue
			}
			g[i][j] = '#'
			if !reach() {
				g[i][j] = '.'
			}
		}
	}
	ans := make([]string, m)
	for i := range g {
		ans[i] = string(g[i])
	}
	return ans
}
*/

func createGrid(m int, n int) []string {
	top := make([]byte, n)
	rest := make([]byte, n)
	for j := 0; j < n; j++ {
		top[j] = '.'
		rest[j] = '#'
	}
	rest[n-1] = '.'
	ans := make([]string, m)
	ans[0] = string(top)
	for i := 1; i < m; i++ {
		ans[i] = string(rest)
	}
	return ans
}