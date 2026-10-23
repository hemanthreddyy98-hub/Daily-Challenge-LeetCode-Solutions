/*
Brute Force

class Solution {
    var parent = [Int]()

    func sortPermutation(_ nums: [Int]) -> Int {
        let n = nums.count
        if nums.indices.allSatisfy({ nums[$0] == $0 }) { return 0 }
        for k in stride(from: n - 1, through: 0, by: -1) {
            parent = Array(0..<n)
            for i in 0..<n {
                for j in (i + 1)..<n where nums[i] & nums[j] == k {
                    let a = find(nums[i]), b = find(nums[j])
                    parent[a] = b
                }
            }
            if nums.indices.allSatisfy({ find(nums[$0]) == find($0) }) { return k }
        }
        return 0
    }

    func find(_ start: Int) -> Int {
        var x = start
        while parent[x] != x {
            parent[x] = parent[parent[x]]
            x = parent[x]
        }
        return x
    }
}
*/

/*
Better Approach

class Solution {
    func sortPermutation(_ nums: [Int]) -> Int {
        let n = nums.count
        if nums.indices.allSatisfy({ nums[$0] == $0 }) { return 0 }
        for k in stride(from: n - 1, through: 0, by: -1) {
            if nums.indices.allSatisfy({ nums[$0] == $0 || nums[$0] & k == k }) { return k }
        }
        return 0
    }
}
*/

class Solution {
    func sortPermutation(_ nums: [Int]) -> Int {
        var ans = -1
        for (i, v) in nums.enumerated() where v != i {
            ans &= v
        }
        return max(ans, 0)
    }
}