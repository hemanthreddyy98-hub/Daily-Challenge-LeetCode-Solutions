/*
Brute Force

impl Solution {
    pub fn path_sum(nums: Vec<i32>) -> i32 {
        let mut total = 0;
        for &x in nums.iter() {
            let (d, p) = (x / 100, x / 10 % 10);
            let has_child = nums.iter().any(|&y| y / 100 == d + 1 && (y / 10 % 10 == 2 * p - 1 || y / 10 % 10 == 2 * p));
            if has_child {
                continue;
            }
            let (mut cur_d, mut cur_p) = (d, p);
            while cur_d >= 1 {
                if let Some(&y) = nums.iter().find(|&&y| y / 100 == cur_d && y / 10 % 10 == cur_p) {
                    total += y % 10;
                }
                cur_d -= 1;
                cur_p = (cur_p + 1) / 2;
            }
        }
        total
    }
}
*/

/*
Better Approach

use std::collections::HashMap;

impl Solution {
    pub fn path_sum(nums: Vec<i32>) -> i32 {
        fn dfs(tree: &HashMap<i32, i32>, d: i32, p: i32, sum: i32) -> i32 {
            let v = match tree.get(&(d * 10 + p)) {
                Some(&v) => v,
                None => return 0,
            };
            let total = sum + v;
            let left = (d + 1) * 10 + 2 * p - 1;
            if !tree.contains_key(&left) && !tree.contains_key(&(left + 1)) {
                return total;
            }
            dfs(tree, d + 1, 2 * p - 1, total) + dfs(tree, d + 1, 2 * p, total)
        }

        let tree: HashMap<i32, i32> = nums.iter().map(|&x| (x / 10, x % 10)).collect();
        dfs(&tree, 1, 1, 0)
    }
}
*/

impl Solution {
    pub fn path_sum(nums: Vec<i32>) -> i32 {
        let mut leaves = [0i32; 16];
        let mut ans = 0;
        for &x in nums.iter().rev() {
            let (d, p, v) = ((x / 100) as usize, (x / 10 % 10) as usize, x % 10);
            let idx = (1 << (d - 1)) + p - 1;
            if leaves[idx] == 0 {
                leaves[idx] = 1;
            }
            ans += v * leaves[idx];
            if idx > 1 {
                leaves[idx / 2] += leaves[idx];
            }
        }
        ans
    }
}