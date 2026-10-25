/*
Brute Force

func closedIsland(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	dr := []int{1, -1, 0, 0}
	dc := []int{0, 0, 1, -1}
	count := 0
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] != 0 {
				continue
			}
			seen := make([]bool, m*n)
			seen[i*n+j] = true
			stack := []int{i*n + j}
			closed, first := true, true
			for len(stack) > 0 {
				id := stack[len(stack)-1]
				stack = stack[:len(stack)-1]
				r, c := id/n, id%n
				if r == 0 || c == 0 || r == m-1 || c == n-1 {
					closed = false
				}
				if id < i*n+j {
					first = false
				}
				for k := 0; k < 4; k++ {
					nr, nc := r+dr[k], c+dc[k]
					if nr < 0 || nc < 0 || nr >= m || nc >= n {
						continue
					}
					if grid[nr][nc] == 0 && !seen[nr*n+nc] {
						seen[nr*n+nc] = true
						stack = append(stack, nr*n+nc)
					}
				}
			}
			if closed && first {
				count++
			}
		}
	}
	return count
}
*/

/*
Better Approach

func closedIsland(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	var sink func(r, c int)
	sink = func(r, c int) {
		if r < 0 || c < 0 || r >= m || c >= n || grid[r][c] != 0 {
			return
		}
		grid[r][c] = 1
		sink(r+1, c)
		sink(r-1, c)
		sink(r, c+1)
		sink(r, c-1)
	}
	for i := 0; i < m; i++ {
		sink(i, 0)
		sink(i, n-1)
	}
	for j := 0; j < n; j++ {
		sink(0, j)
		sink(m-1, j)
	}
	count := 0
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] == 0 {
				sink(i, j)
				count++
			}
		}
	}
	return count
}
*/

func closedIsland(grid [][]int) int {
	m, n := len(grid), len(grid[0])
	q := make([]int, m*n)
	dr := [4]int{1, -1, 0, 0}
	dc := [4]int{0, 0, 1, -1}
	count := 0
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] != 0 {
				continue
			}
			head, tail := 0, 0
			closed := true
			grid[i][j] = 1
			q[tail] = i*n + j
			tail++
			for head < tail {
				id := q[head]
				head++
				r, c := id/n, id%n
				if r == 0 || c == 0 || r == m-1 || c == n-1 {
					closed = false
				}
				for k := 0; k < 4; k++ {
					nr, nc := r+dr[k], c+dc[k]
					if nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] == 0 {
						grid[nr][nc] = 1
						q[tail] = nr*n + nc
						tail++
					}
				}
			}
			if closed {
				count++
			}
		}
	}
	return count
}