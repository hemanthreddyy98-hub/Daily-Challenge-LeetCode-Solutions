/*
Brute Force

impl Solution {
    pub fn closed_island(grid: Vec<Vec<i32>>) -> i32 {
        let (m, n) = (grid.len() as i32, grid[0].len() as i32);
        let dirs: [(i32, i32); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
        let mut count = 0;
        for i in 0..m {
            for j in 0..n {
                if grid[i as usize][j as usize] != 0 {
                    continue;
                }
                let mut seen = vec![vec![false; n as usize]; m as usize];
                let mut stack = vec![(i, j)];
                seen[i as usize][j as usize] = true;
                let (mut closed, mut first) = (true, true);
                while let Some((r, c)) = stack.pop() {
                    if r == 0 || c == 0 || r == m - 1 || c == n - 1 {
                        closed = false;
                    }
                    if r * n + c < i * n + j {
                        first = false;
                    }
                    for &(dr, dc) in dirs.iter() {
                        let (nr, nc) = (r + dr, c + dc);
                        if nr < 0 || nc < 0 || nr >= m || nc >= n {
                            continue;
                        }
                        let (ur, uc) = (nr as usize, nc as usize);
                        if grid[ur][uc] == 0 && !seen[ur][uc] {
                            seen[ur][uc] = true;
                            stack.push((nr, nc));
                        }
                    }
                }
                if closed && first {
                    count += 1;
                }
            }
        }
        count
    }
}
*/

/*
Better Approach

impl Solution {
    pub fn closed_island(mut grid: Vec<Vec<i32>>) -> i32 {
        fn sink(grid: &mut Vec<Vec<i32>>, r: i32, c: i32) {
            if r < 0 || c < 0 || r >= grid.len() as i32 || c >= grid[0].len() as i32 {
                return;
            }
            if grid[r as usize][c as usize] != 0 {
                return;
            }
            grid[r as usize][c as usize] = 1;
            sink(grid, r + 1, c);
            sink(grid, r - 1, c);
            sink(grid, r, c + 1);
            sink(grid, r, c - 1);
        }

        let (m, n) = (grid.len() as i32, grid[0].len() as i32);
        for i in 0..m {
            sink(&mut grid, i, 0);
            sink(&mut grid, i, n - 1);
        }
        for j in 0..n {
            sink(&mut grid, 0, j);
            sink(&mut grid, m - 1, j);
        }
        let mut count = 0;
        for i in 0..m {
            for j in 0..n {
                if grid[i as usize][j as usize] == 0 {
                    sink(&mut grid, i, j);
                    count += 1;
                }
            }
        }
        count
    }
}
*/

impl Solution {
    pub fn closed_island(mut grid: Vec<Vec<i32>>) -> i32 {
        let (m, n) = (grid.len(), grid[0].len());
        let mut q = vec![0usize; m * n];
        let dirs: [(i32, i32); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
        let mut count = 0;
        for i in 0..m {
            for j in 0..n {
                if grid[i][j] != 0 {
                    continue;
                }
                grid[i][j] = 1;
                q[0] = i * n + j;
                let (mut head, mut tail) = (0, 1);
                let mut closed = true;
                while head < tail {
                    let (r, c) = (q[head] / n, q[head] % n);
                    head += 1;
                    if r == 0 || c == 0 || r == m - 1 || c == n - 1 {
                        closed = false;
                    }
                    for &(dr, dc) in dirs.iter() {
                        let (nr, nc) = (r as i32 + dr, c as i32 + dc);
                        if nr < 0 || nc < 0 || nr >= m as i32 || nc >= n as i32 {
                            continue;
                        }
                        let (nr, nc) = (nr as usize, nc as usize);
                        if grid[nr][nc] == 0 {
                            grid[nr][nc] = 1;
                            q[tail] = nr * n + nc;
                            tail += 1;
                        }
                    }
                }
                if closed {
                    count += 1;
                }
            }
        }
        count
    }
}