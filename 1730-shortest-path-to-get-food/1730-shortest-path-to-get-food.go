/*
Brute Force

func getFood(grid [][]byte) int {
	m, n := len(grid), len(grid[0])
	best := -1
	var dfs func(r, c, steps int)
	dfs = func(r, c, steps int) {
		if r < 0 || c < 0 || r >= m || c >= n {
			return
		}
		ch := grid[r][c]
		if ch == 'X' || ch == 'V' {
			return
		}
		if ch == '#' {
			if best == -1 || steps < best {
				best = steps
			}
			return
		}
		grid[r][c] = 'V'
		dfs(r+1, c, steps+1)
		dfs(r-1, c, steps+1)
		dfs(r, c+1, steps+1)
		dfs(r, c-1, steps+1)
		grid[r][c] = ch
	}
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] == '*' {
				dfs(i, j, 0)
			}
		}
	}
	return best
}
*/

/*
Basic Approach

func getFood(grid [][]byte) int {
	m, n := len(grid), len(grid[0])
	queue := [][2]int{}
	visited := make([][]bool, m)
	for i := range visited {
		visited[i] = make([]bool, n)
	}
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] == '*' {
				queue = append(queue, [2]int{i, j})
				visited[i][j] = true
			}
		}
	}
	dirs := [][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
	steps := 0
	for len(queue) > 0 {
		size := len(queue)
		for k := 0; k < size; k++ {
			cur := queue[0]
			queue = queue[1:]
			if grid[cur[0]][cur[1]] == '#' {
				return steps
			}
			for _, d := range dirs {
				r, c := cur[0]+d[0], cur[1]+d[1]
				if r >= 0 && c >= 0 && r < m && c < n && !visited[r][c] && grid[r][c] != 'X' {
					visited[r][c] = true
					queue = append(queue, [2]int{r, c})
				}
			}
		}
		steps++
	}
	return -1
}
*/

func getFood(grid [][]byte) int {
	m, n := len(grid), len(grid[0])

	start := -1
	for i := 0; i < m && start < 0; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] == '*' {
				start = i*n + j
				break
			}
		}
	}
	if start < 0 {
		return -1
	}

	q := make([]int32, m*n)
	head, tail := 0, 0
	q[tail] = int32(start)
	tail++
	dr := [4]int{1, -1, 0, 0}
	dc := [4]int{0, 0, 1, -1}
	steps := 0

	for head < tail {
		steps++
		levelEnd := tail
		for ; head < levelEnd; head++ {
			id := int(q[head])
			r, c := id/n, id%n
			for k := 0; k < 4; k++ {
				nr, nc := r+dr[k], c+dc[k]
				if nr < 0 || nc < 0 || nr >= m || nc >= n {
					continue
				}
				ch := grid[nr][nc]
				if ch == '#' {
					return steps
				}
				if ch == 'O' {
					grid[nr][nc] = 'X'
					q[tail] = int32(nr*n + nc)
					tail++
				}
			}
		}
	}
	return -1
}