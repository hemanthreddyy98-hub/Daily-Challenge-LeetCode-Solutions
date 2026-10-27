/*
Brute Force

impl Solution {
    pub fn create_grid(m: i32, n: i32) -> Vec<String> {
        fn reach(g: &Vec<Vec<u8>>, r: usize, c: usize) -> bool {
            if r >= g.len() || c >= g[0].len() || g[r][c] == b'#' {
                return false;
            }
            if r == g.len() - 1 && c == g[0].len() - 1 {
                return true;
            }
            reach(g, r + 1, c) || reach(g, r, c + 1)
        }

        let (m, n) = (m as usize, n as usize);
        let mut g = vec![vec![b'.'; n]; m];
        for i in 0..m {
            for j in 0..n {
                if (i == 0 && j == 0) || (i == m - 1 && j == n - 1) {
                    continue;
                }
                g[i][j] = b'#';
                if !reach(&g, 0, 0) {
                    g[i][j] = b'.';
                }
            }
        }
        g.into_iter().map(|row| String::from_utf8(row).unwrap()).collect()
    }
}
*/

/*
Better Approach

impl Solution {
    pub fn create_grid(m: i32, n: i32) -> Vec<String> {
        fn reach(g: &Vec<Vec<u8>>) -> bool {
            let (m, n) = (g.len(), g[0].len());
            let mut ok = vec![vec![false; n]; m];
            for i in 0..m {
                for j in 0..n {
                    if g[i][j] == b'#' {
                        continue;
                    }
                    ok[i][j] = (i == 0 && j == 0) || (i > 0 && ok[i - 1][j]) || (j > 0 && ok[i][j - 1]);
                }
            }
            ok[m - 1][n - 1]
        }

        let (m, n) = (m as usize, n as usize);
        let mut g = vec![vec![b'.'; n]; m];
        for i in 0..m {
            for j in 0..n {
                if (i == 0 && j == 0) || (i == m - 1 && j == n - 1) {
                    continue;
                }
                g[i][j] = b'#';
                if !reach(&g) {
                    g[i][j] = b'.';
                }
            }
        }
        g.into_iter().map(|row| String::from_utf8(row).unwrap()).collect()
    }
}
*/

impl Solution {
    pub fn create_grid(m: i32, n: i32) -> Vec<String> {
        let (m, n) = (m as usize, n as usize);
        let rest = "#".repeat(n - 1) + ".";
        let mut grid = vec![rest; m];
        grid[0] = ".".repeat(n);
        grid
    }
}