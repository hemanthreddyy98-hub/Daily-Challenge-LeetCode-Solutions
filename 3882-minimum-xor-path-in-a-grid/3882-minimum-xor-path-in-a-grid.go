/*
Brute Force

func minCost(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	var dfs func(i, j, x int) int
	dfs = func(i, j, x int) int {
		if i == m-1 && j == n-1 {
			return x
		}
		best := 1 << 30
		if i+1 < m {
			if r := dfs(i+1, j, x^grid[i+1][j]); r < best {
				best = r
			}
		}
		if j+1 < n {
			if r := dfs(i, j+1, x^grid[i][j+1]); r < best {
				best = r
			}
		}
		return best
	}
	return dfs(0, 0, grid[0][0])
}
*/

/*
Better Approach

func minCost(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	memo := make([]int, m*n*1024)
	for k := range memo {
		memo[k] = -1
	}
	var dfs func(i, j, x int) int
	dfs = func(i, j, x int) int {
		if i == m-1 && j == n-1 {
			return x
		}
		key := (i*n+j)*1024 + x
		if memo[key] != -1 {
			return memo[key]
		}
		best := 1 << 30
		if i+1 < m {
			if r := dfs(i+1, j, x^grid[i+1][j]); r < best {
				best = r
			}
		}
		if j+1 < n {
			if r := dfs(i, j+1, x^grid[i][j+1]); r < best {
				best = r
			}
		}
		memo[key] = best
		return best
	}
	return dfs(0, 0, grid[0][0])
}
*/

func minCost(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	dp := make([][1024]bool, n)
	var tmp [1024]bool
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			for x := 0; x < 1024; x++ {
				tmp[x] = (i == 0 && j == 0 && x == 0) || (i > 0 && dp[j][x]) || (j > 0 && dp[j-1][x])
			}
			for x := 0; x < 1024; x++ {
				dp[j][x^grid[i][j]] = tmp[x]
			}
		}
	}
	x := 0
	for !dp[n-1][x] {
		x++
	}
	return x
}