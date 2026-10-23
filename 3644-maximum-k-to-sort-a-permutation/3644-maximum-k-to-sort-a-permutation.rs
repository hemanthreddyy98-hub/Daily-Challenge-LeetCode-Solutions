/*
Brute Force

impl Solution {
    pub fn sort_permutation(nums: Vec<i32>) -> i32 {
        fn find(parent: &mut Vec<usize>, mut x: usize) -> usize {
            while parent[x] != x {
                parent[x] = parent[parent[x]];
                x = parent[x];
            }
            x
        }

        let n = nums.len();
        if nums.iter().enumerate().all(|(i, &v)| v as usize == i) {
            return 0;
        }
        for k in (0..n as i32).rev() {
            let mut parent: Vec<usize> = (0..n).collect();
            for i in 0..n {
                for j in i + 1..n {
                    if nums[i] & nums[j] == k {
                        let a = find(&mut parent, nums[i] as usize);
                        let b = find(&mut parent, nums[j] as usize);
                        parent[a] = b;
                    }
                }
            }
            if (0..n).all(|i| find(&mut parent, nums[i] as usize) == find(&mut parent, i)) {
                return k;
            }
        }
        0
    }
}
*/

/*
Better Approach

impl Solution {
    pub fn sort_permutation(nums: Vec<i32>) -> i32 {
        let n = nums.len() as i32;
        if nums.iter().enumerate().all(|(i, &v)| v == i as i32) {
            return 0;
        }
        for k in (0..n).rev() {
            if nums.iter().enumerate().all(|(i, &v)| v == i as i32 || v & k == k) {
                return k;
            }
        }
        0
    }
}
*/

impl Solution {
    pub fn sort_permutation(nums: Vec<i32>) -> i32 {
        let mut ans: i32 = -1;
        for (i, &v) in nums.iter().enumerate() {
            if v != i as i32 {
                ans &= v;
            }
        }
        ans.max(0)
    }
}