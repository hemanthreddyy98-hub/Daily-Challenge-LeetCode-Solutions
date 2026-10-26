/*
Brute Force

func countIslands(grid [][]int, k int) int {
	m, n := len(grid), len(grid[0])
	dr := []int{1, -1, 0, 0}
	dc := []int{0, 0, 1, -1}
	count := 0
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] == 0 {
				continue
			}
			seen := make([]bool, m*n)
			seen[i*n+j] = true
			stack := []int{i*n + j}
			sum, first := 0, true
			for len(stack) > 0 {
				id := stack[len(stack)-1]
				stack = stack[:len(stack)-1]
				r, c := id/n, id%n
				sum += grid[r][c]
				if id < i*n+j {
					first = false
				}
				for d := 0; d < 4; d++ {
					nr, nc := r+dr[d], c+dc[d]
					if nr < 0 || nc < 0 || nr >= m || nc >= n {
						continue
					}
					if grid[nr][nc] > 0 && !seen[nr*n+nc] {
						seen[nr*n+nc] = true
						stack = append(stack, nr*n+nc)
					}
				}
			}
			if first && sum%k == 0 {
				count++
			}
		}
	}
	return count
}
*/

/*
Better Approach

func countIslands(grid [][]int, k int) int {
	m, n := len(grid), len(grid[0])
	visited := make([][]bool, m)
	for i := range visited {
		visited[i] = make([]bool, n)
	}
	dirs := [][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
	count := 0
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] == 0 || visited[i][j] {
				continue
			}
			queue := [][2]int{{i, j}}
			visited[i][j] = true
			sum := 0
			for len(queue) > 0 {
				cur := queue[0]
				queue = queue[1:]
				sum += grid[cur[0]][cur[1]]
				for _, d := range dirs {
					r, c := cur[0]+d[0], cur[1]+d[1]
					if r >= 0 && c >= 0 && r < m && c < n && grid[r][c] > 0 && !visited[r][c] {
						visited[r][c] = true
						queue = append(queue, [2]int{r, c})
					}
				}
			}
			if sum%k == 0 {
				count++
			}
		}
	}
	return count
}
*/

func countIslands(grid [][]int, k int) int {
	m, n := len(grid), len(grid[0])
	q := make([]int, m*n)
	dr := [4]int{1, -1, 0, 0}
	dc := [4]int{0, 0, 1, -1}
	count := 0
	for i := 0; i < m; i++ {
		for j := 0; j < n; j++ {
			if grid[i][j] == 0 {
				continue
			}
			head, tail := 0, 0
			sum := grid[i][j] % k
			grid[i][j] = 0
			q[tail] = i*n + j
			tail++
			for head < tail {
				id := q[head]
				head++
				r, c := id/n, id%n
				for d := 0; d < 4; d++ {
					nr, nc := r+dr[d], c+dc[d]
					if nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0 {
						sum = (sum + grid[nr][nc]) % k
						grid[nr][nc] = 0
						q[tail] = nr*n + nc
						tail++
					}
				}
			}
			if sum == 0 {
				count++
			}
		}
	}
	return count
}