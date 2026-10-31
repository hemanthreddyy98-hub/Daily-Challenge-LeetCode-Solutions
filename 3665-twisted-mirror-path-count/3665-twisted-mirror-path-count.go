/*
Brute Force

func uniquePaths(grid [][]int) int {
	const mod = 1_000_000_007
	m, n := len(grid), len(grid[0])
	var dfs func(i, j, d int) int
	dfs = func(i, j, d int) int {
		if i >= m || j >= n {
			return 0
		}
		if i == m-1 && j == n-1 {
			return 1
		}
		if grid[i][j] == 1 {
			if d == 0 {
				return dfs(i+1, j, 1)
			}
			return dfs(i, j+1, 0)
		}
		return (dfs(i, j+1, 0) + dfs(i+1, j, 1)) % mod
	}
	return dfs(0, 0, 0)
}
*/

/*
Better Approach

func uniquePaths(grid [][]int) int {
	const mod = 1_000_000_007
	m, n := len(grid), len(grid[0])
	memo := make([][][2]int, m)
	for i := range memo {
		memo[i] = make([][2]int, n)
		for j := range memo[i] {
			memo[i][j] = [2]int{-1, -1}
		}
	}
	var dfs func(i, j, d int) int
	dfs = func(i, j, d int) int {
		if i >= m || j >= n {
			return 0
		}
		if i == m-1 && j == n-1 {
			return 1
		}
		if memo[i][j][d] != -1 {
			return memo[i][j][d]
		}
		res := 0
		if grid[i][j] == 0 {
			res = (dfs(i, j+1, 0) + dfs(i+1, j, 1)) % mod
		} else if d == 0 {
			res = dfs(i+1, j, 1)
		} else {
			res = dfs(i, j+1, 0)
		}
		memo[i][j][d] = res
		return res
	}
	return dfs(0, 0, 0)
}
*/

func uniquePaths(grid [][]int) int {
	const mod = 1_000_000_007
	m, n := len(grid), len(grid[0])
	r, d := make([]int, n), make([]int, n)
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if i == 0 && j == 0 {
				r[0] = 1
				continue
			}
			nd, nr := 0, 0
			if i > 0 {
				if grid[i-1][j] == 0 {
					nd = (r[j] + d[j]) % mod
				} else {
					nd = r[j]
				}
			}
			if j > 0 {
				if grid[i][j-1] == 0 {
					nr = (r[j-1] + d[j-1]) % mod
				} else {
					nr = d[j-1]
				}
			}
			r[j], d[j] = nr, nd
		}
	}
	return (r[n-1] + d[n-1]) % mod
}