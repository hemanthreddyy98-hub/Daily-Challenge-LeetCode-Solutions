/*
Brute Force

impl Solution {
    pub fn count_islands(grid: Vec<Vec<i32>>, k: i32) -> i32 {
        let (m, n) = (grid.len() as i32, grid[0].len() as i32);
        let dirs: [(i32, i32); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
        let mut count = 0;
        for i in 0..m {
            for j in 0..n {
                if grid[i as usize][j as usize] == 0 {
                    continue;
                }
                let mut seen = vec![vec![false; n as usize]; m as usize];
                let mut stack = vec![(i, j)];
                seen[i as usize][j as usize] = true;
                let (mut sum, mut first) = (0i64, true);
                while let Some((r, c)) = stack.pop() {
                    sum += grid[r as usize][c as usize] as i64;
                    if r * n + c < i * n + j {
                        first = false;
                    }
                    for &(dr, dc) in dirs.iter() {
                        let (nr, nc) = (r + dr, c + dc);
                        if nr < 0 || nc < 0 || nr >= m || nc >= n {
                            continue;
                        }
                        let (ur, uc) = (nr as usize, nc as usize);
                        if grid[ur][uc] > 0 && !seen[ur][uc] {
                            seen[ur][uc] = true;
                            stack.push((nr, nc));
                        }
                    }
                }
                if first && sum % k as i64 == 0 {
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

use std::collections::VecDeque;

impl Solution {
    pub fn count_islands(grid: Vec<Vec<i32>>, k: i32) -> i32 {
        let (m, n) = (grid.len(), grid[0].len());
        let mut visited = vec![vec![false; n]; m];
        let dirs: [(i32, i32); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
        let mut count = 0;
        for i in 0..m {
            for j in 0..n {
                if grid[i][j] == 0 || visited[i][j] {
                    continue;
                }
                let mut queue = VecDeque::new();
                queue.push_back((i, j));
                visited[i][j] = true;
                let mut sum: i64 = 0;
                while let Some((r0, c0)) = queue.pop_front() {
                    sum += grid[r0][c0] as i64;
                    for &(dr, dc) in dirs.iter() {
                        let (r, c) = (r0 as i32 + dr, c0 as i32 + dc);
                        if r < 0 || c < 0 || r >= m as i32 || c >= n as i32 {
                            continue;
                        }
                        let (r, c) = (r as usize, c as usize);
                        if grid[r][c] > 0 && !visited[r][c] {
                            visited[r][c] = true;
                            queue.push_back((r, c));
                        }
                    }
                }
                if sum % k as i64 == 0 {
                    count += 1;
                }
            }
        }
        count
    }
}
*/

impl Solution {
    pub fn count_islands(mut grid: Vec<Vec<i32>>, k: i32) -> i32 {
        let (m, n) = (grid.len(), grid[0].len());
        let mut q = vec![0usize; m * n];
        let dirs: [(i32, i32); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
        let mut count = 0;
        for i in 0..m {
            for j in 0..n {
                if grid[i][j] == 0 {
                    continue;
                }
                let mut sum = grid[i][j] % k;
                grid[i][j] = 0;
                q[0] = i * n + j;
                let (mut head, mut tail) = (0, 1);
                while head < tail {
                    let (r, c) = (q[head] / n, q[head] % n);
                    head += 1;
                    for &(dr, dc) in dirs.iter() {
                        let (nr, nc) = (r as i32 + dr, c as i32 + dc);
                        if nr < 0 || nc < 0 || nr >= m as i32 || nc >= n as i32 {
                            continue;
                        }
                        let (nr, nc) = (nr as usize, nc as usize);
                        if grid[nr][nc] > 0 {
                            sum = (sum + grid[nr][nc]) % k;
                            grid[nr][nc] = 0;
                            q[tail] = nr * n + nc;
                            tail += 1;
                        }
                    }
                }
                if sum == 0 {
                    count += 1;
                }
            }
        }
        count
    }
}