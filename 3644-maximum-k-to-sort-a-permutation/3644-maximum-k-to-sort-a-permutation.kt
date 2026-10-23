/*
Brute Force

class Solution {
    var parent = IntArray(0)

    fun sortPermutation(nums: IntArray): Int {
        val n = nums.size
        if (nums.indices.all { nums[it] == it }) return 0
        for (k in n - 1 downTo 0) {
            parent = IntArray(n) { it }
            for (i in 0 until n)
                for (j in i + 1 until n)
                    if ((nums[i] and nums[j]) == k) {
                        val a = find(nums[i])
                        val b = find(nums[j])
                        parent[a] = b
                    }
            if (nums.indices.all { find(nums[it]) == find(it) }) return k
        }
        return 0
    }

    fun find(start: Int): Int {
        var x = start
        while (parent[x] != x) {
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
    fun sortPermutation(nums: IntArray): Int {
        val n = nums.size
        if (nums.indices.all { nums[it] == it }) return 0
        for (k in n - 1 downTo 0)
            if (nums.indices.all { nums[it] == it || (nums[it] and k) == k }) return k
        return 0
    }
}
*/

class Solution {
    fun sortPermutation(nums: IntArray): Int {
        var ans = -1
        for (i in nums.indices)
            if (nums[i] != i) ans = ans and nums[i]
        return maxOf(ans, 0)
    }
}