/*
Brute Force

class Solution {
    fun pathSum(nums: IntArray): Int {
        var total = 0
        for (x in nums) {
            val d = x / 100
            val p = x / 10 % 10
            var leaf = true
            for (y in nums) {
                val cd = y / 100
                val cp = y / 10 % 10
                if (cd == d + 1 && (cp == 2 * p - 1 || cp == 2 * p)) leaf = false
            }
            if (!leaf) continue
            var curD = d
            var curP = p
            while (curD >= 1) {
                for (y in nums) {
                    if (y / 100 == curD && y / 10 % 10 == curP) {
                        total += y % 10
                        break
                    }
                }
                curD--
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
    fun pathSum(nums: IntArray): Int {
        val tree = HashMap<Int, Int>()
        for (x in nums) tree[x / 10] = x % 10
        return dfs(tree, 1, 1, 0)
    }

    fun dfs(tree: Map<Int, Int>, d: Int, p: Int, sum: Int): Int {
        val v = tree[d * 10 + p] ?: return 0
        val total = sum + v
        val left = (d + 1) * 10 + 2 * p - 1
        if (left !in tree && left + 1 !in tree) return total
        return dfs(tree, d + 1, 2 * p - 1, total) + dfs(tree, d + 1, 2 * p, total)
    }
}
*/

class Solution {
    fun pathSum(nums: IntArray): Int {
        val leaves = IntArray(16)
        var ans = 0
        for (i in nums.indices.reversed()) {
            val d = nums[i] / 100
            val p = nums[i] / 10 % 10
            val v = nums[i] % 10
            val idx = (1 shl (d - 1)) + p - 1
            if (leaves[idx] == 0) leaves[idx] = 1
            ans += v * leaves[idx]
            if (idx > 1) leaves[idx / 2] += leaves[idx]
        }
        return ans
    }
}