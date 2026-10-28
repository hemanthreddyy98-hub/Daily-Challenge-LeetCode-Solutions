/*
Brute Force

impl Solution {
    pub fn min_cost(grid: Vec<Vec<i32>>) -> i32 {
        fn dfs(grid: &Vec<Vec<i32>>, i: usize, j: usize, x: i32) -> i32 {
            let (m, n) = (grid.len(), grid[0].len());
            if i == m - 1 && j == n - 1 {
                return x;
            }
            let mut best = i32::MAX;
            if i + 1 < m {
                best = best.min(dfs(grid, i + 1, j, x ^ grid[i + 1][j]));
            }
            if j + 1 < n {
                best = best.min(dfs(grid, i, j + 1, x ^ grid[i][j + 1]));
            }
            best
        }

        dfs(&grid, 0, 0, grid[0][0])
    }
}
*/

/*
Better Approach

impl Solution {
    pub fn min_cost(grid: Vec<Vec<i32>>) -> i32 {
        fn dfs(grid: &Vec<Vec<i32>>, memo: &mut Vec<i32>, i: usize, j: usize, x: i32) -> i32 {
            let (m, n) = (grid.len(), grid[0].len());
            if i == m - 1 && j == n - 1 {
                return x;
            }
            let key = (i * n + j) * 1024 + x as usize;
            if memo[key] != -1 {
                return memo[key];
            }
            let mut best = i32::MAX;
            if i + 1 < m {
                best = best.min(dfs(grid, memo, i + 1, j, x ^ grid[i + 1][j]));
            }
            if j + 1 < n {
                best = best.min(dfs(grid, memo, i, j + 1, x ^ grid[i][j + 1]));
            }
            memo[key] = best;
            best
        }

        let mut memo = vec![-1; grid.len() * grid[0].len() * 1024];
        dfs(&grid, &mut memo, 0, 0, grid[0][0])
    }
}
*/

impl Solution {
    pub fn min_cost(grid: Vec<Vec<i32>>) -> i32 {
        let (m, n) = (grid.len(), grid[0].len());
        let mut dp = vec![[false; 1024]; n];
        let mut tmp = [false; 1024];
        for i in 0..m {
            for j in 0..n {
                for x in 0..1024 {
                    tmp[x] = (i == 0 && j == 0 && x == 0) || (i > 0 && dp[j][x]) || (j > 0 && dp[j - 1][x]);
                }
                for x in 0..1024 {
                    dp[j][x ^ grid[i][j] as usize] = tmp[x];
                }
            }
        }
        let mut x = 0;
        while !dp[n - 1][x] {
            x += 1;
        }
        x as i32
    }
}