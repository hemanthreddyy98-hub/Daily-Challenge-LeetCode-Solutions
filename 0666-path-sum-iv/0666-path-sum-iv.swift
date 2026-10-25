/*
Brute Force

class Solution {
    func pathSum(_ nums: [Int]) -> Int {
        var total = 0
        for x in nums {
            let d = x / 100, p = x / 10 % 10
            var leaf = true
            for y in nums {
                let cd = y / 100, cp = y / 10 % 10
                if cd == d + 1 && (cp == 2 * p - 1 || cp == 2 * p) { leaf = false }
            }
            if !leaf { continue }
            var curD = d, curP = p
            while curD >= 1 {
                for y in nums where y / 100 == curD && y / 10 % 10 == curP {
                    total += y % 10
                    break
                }
                curD -= 1
                curP = (curP + 1) / 2
            }
        }
        return total
    }
}
*/

/*
Better Approach

class Solution {
    func pathSum(_ nums: [Int]) -> Int {
        var tree = [Int: Int]()
        for x in nums { tree[x / 10] = x % 10 }
        func dfs(_ d: Int, _ p: Int, _ sum: Int) -> Int {
            guard let v = tree[d * 10 + p] else { return 0 }
            let total = sum + v
            let left = (d + 1) * 10 + 2 * p - 1
            if tree[left] == nil && tree[left + 1] == nil { return total }
            return dfs(d + 1, 2 * p - 1, total) + dfs(d + 1, 2 * p, total)
        }
        return dfs(1, 1, 0)
    }
}
*/

class Solution {
    func pathSum(_ nums: [Int]) -> Int {
        var leaves = [Int](repeating: 0, count: 16)
        var ans = 0
        for x in nums.reversed() {
            let d = x / 100, p = x / 10 % 10, v = x % 10
            let idx = (1 << (d - 1)) + p - 1
            if leaves[idx] == 0 { leaves[idx] = 1 }
            ans += v * leaves[idx]
            if idx > 1 { leaves[idx / 2] += leaves[idx] }
        }
        return ans
    }
}