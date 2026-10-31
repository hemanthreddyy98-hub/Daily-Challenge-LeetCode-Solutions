/*
Brute Force

impl Solution {
    pub fn unique_paths(grid: Vec<Vec<i32>>) -> i32 {
        fn dfs(grid: &Vec<Vec<i32>>, i: usize, j: usize, d: usize) -> i32 {
            let (m, n) = (grid.len(), grid[0].len());
            if i >= m || j >= n {
                return 0;
            }
            if i == m - 1 && j == n - 1 {
                return 1;
            }
            if grid[i][j] == 1 {
                return if d == 0 { dfs(grid, i + 1, j, 1) } else { dfs(grid, i, j + 1, 0) };
            }
            (dfs(grid, i, j + 1, 0) + dfs(grid, i + 1, j, 1)) % 1_000_000_007
        }
        dfs(&grid, 0, 0, 0)
    }
}
*/

/*
Better Approach

impl Solution {
    pub fn unique_paths(grid: Vec<Vec<i32>>) -> i32 {
        fn dfs(grid: &Vec<Vec<i32>>, memo: &mut Vec<i32>, i: usize, j: usize, d: usize) -> i32 {
            let (m, n) = (grid.len(), grid[0].len());
            if i >= m || j >= n {
                return 0;
            }
            if i == m - 1 && j == n - 1 {
                return 1;
            }
            let key = (i * n + j) * 2 + d;
            if memo[key] != -1 {
                return memo[key];
            }
            let res = if grid[i][j] == 0 {
                (dfs(grid, memo, i, j + 1, 0) + dfs(grid, memo, i + 1, j, 1)) % 1_000_000_007
            } else if d == 0 {
                dfs(grid, memo, i + 1, j, 1)
            } else {
                dfs(grid, memo, i, j + 1, 0)
            };
            memo[key] = res;
            res
        }
        let mut memo = vec![-1; grid.len() * grid[0].len() * 2];
        dfs(&grid, &mut memo, 0, 0, 0)
    }
}
*/

impl Solution {
    pub fn unique_paths(grid: Vec<Vec<i32>>) -> i32 {
        const MOD: i32 = 1_000_000_007;
        let (m, n) = (grid.len(), grid[0].len());
        let mut r = vec![0; n];
        let mut d = vec![0; n];
        for i in 0..m {
            for j in 0..n {
                if i == 0 && j == 0 {
                    r[0] = 1;
                    continue;
                }
                let nd = if i == 0 { 0 } else if grid[i - 1][j] == 0 { (r[j] + d[j]) % MOD } else { r[j] };
                let nr = if j == 0 { 0 } else if grid[i][j - 1] == 0 { (r[j - 1] + d[j - 1]) % MOD } else { d[j - 1] };
                r[j] = nr;
                d[j] = nd;
            }
        }
        (r[n - 1] + d[n - 1]) % MOD
    }
}