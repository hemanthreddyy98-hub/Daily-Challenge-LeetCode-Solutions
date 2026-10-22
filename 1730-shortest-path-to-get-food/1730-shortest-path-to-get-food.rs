/*
Brute Force

impl Solution {
    pub fn get_food(mut grid: Vec<Vec<char>>) -> i32 {
        fn dfs(grid: &mut Vec<Vec<char>>, r: i32, c: i32, steps: i32, best: &mut i32) {
            if r < 0 || c < 0 || r >= grid.len() as i32 || c >= grid[0].len() as i32 {
                return;
            }
            let (ru, cu) = (r as usize, c as usize);
            let ch = grid[ru][cu];
            if ch == 'X' || ch == 'V' {
                return;
            }
            if ch == '#' {
                *best = (*best).min(steps);
                return;
            }
            grid[ru][cu] = 'V';
            dfs(grid, r + 1, c, steps + 1, best);
            dfs(grid, r - 1, c, steps + 1, best);
            dfs(grid, r, c + 1, steps + 1, best);
            dfs(grid, r, c - 1, steps + 1, best);
            grid[ru][cu] = ch;
        }

        let mut best = i32::MAX;
        for i in 0..grid.len() {
            for j in 0..grid[0].len() {
                if grid[i][j] == '*' {
                    dfs(&mut grid, i as i32, j as i32, 0, &mut best);
                }
            }
        }
        if best == i32::MAX { -1 } else { best }
    }
}
*/

/*
Basic Approach

use std::collections::VecDeque;

impl Solution {
    pub fn get_food(grid: Vec<Vec<char>>) -> i32 {
        let (m, n) = (grid.len(), grid[0].len());
        let mut queue = VecDeque::new();
        let mut visited = vec![vec![false; n]; m];
        for i in 0..m {
            for j in 0..n {
                if grid[i][j] == '*' {
                    queue.push_back((i, j));
                    visited[i][j] = true;
                }
            }
        }
        let dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)];
        let mut steps = 0;
        while !queue.is_empty() {
            for _ in 0..queue.len() {
                let (r0, c0) = queue.pop_front().unwrap();
                if grid[r0][c0] == '#' {
                    return steps;
                }
                for &(dr, dc) in dirs.iter() {
                    let r = r0 as i32 + dr;
                    let c = c0 as i32 + dc;
                    if r >= 0 && c >= 0 && r < m as i32 && c < n as i32 {
                        let (r, c) = (r as usize, c as usize);
                        if !visited[r][c] && grid[r][c] != 'X' {
                            visited[r][c] = true;
                            queue.push_back((r, c));
                        }
                    }
                }
            }
            steps += 1;
        }
        -1
    }
}
*/

impl Solution {
    pub fn get_food(mut grid: Vec<Vec<char>>) -> i32 {
        let m = grid.len();
        let n = grid[0].len();

        let mut start = usize::MAX;
        for (i, row) in grid.iter().enumerate() {
            if let Some(j) = row.iter().position(|&ch| ch == '*') {
                start = i * n + j;
                break;
            }
        }
        if start == usize::MAX {
            return -1;
        }

        let mut q = vec![0usize; m * n];
        q[0] = start;
        let (mut head, mut tail) = (0usize, 1usize);
        let dirs: [(i32, i32); 4] = [(1, 0), (-1, 0), (0, 1), (0, -1)];
        let mut steps = 0;

        while head < tail {
            steps += 1;
            let level_end = tail;
            while head < level_end {
                let id = q[head];
                head += 1;
                let (r, c) = ((id / n) as i32, (id % n) as i32);
                for &(dr, dc) in dirs.iter() {
                    let (nr, nc) = (r + dr, c + dc);
                    if nr < 0 || nc < 0 || nr >= m as i32 || nc >= n as i32 {
                        continue;
                    }
                    let (nr, nc) = (nr as usize, nc as usize);
                    match grid[nr][nc] {
                        '#' => return steps,
                        'O' => {
                            grid[nr][nc] = 'X';
                            q[tail] = nr * n + nc;
                            tail += 1;
                        }
                        _ => {}
                    }
                }
            }
        }
        -1
    }
}