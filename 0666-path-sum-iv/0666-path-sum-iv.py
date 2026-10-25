"""
Brute Force

class Solution:
    def pathSum(self, nums: List[int]) -> int:
        total = 0
        for x in nums:
            d, p = x // 100, x // 10 % 10
            if any(y // 100 == d + 1 and y // 10 % 10 in (2 * p - 1, 2 * p) for y in nums):
                continue
            while d >= 1:
                for y in nums:
                    if y // 100 == d and y // 10 % 10 == p:
                        total += y % 10
                        break
                d -= 1
                p = (p + 1) // 2
        return total
"""

"""
Better Approach

class Solution:
    def pathSum(self, nums: List[int]) -> int:
        tree = {x // 10: x % 10 for x in nums}

        def dfs(d, p, s):
            key = d * 10 + p
            if key not in tree:
                return 0
            s += tree[key]
            left = (d + 1) * 10 + 2 * p - 1
            if left not in tree and left + 1 not in tree:
                return s
            return dfs(d + 1, 2 * p - 1, s) + dfs(d + 1, 2 * p, s)

        return dfs(1, 1, 0)
"""

class Solution:
    def pathSum(self, nums: List[int]) -> int:
        leaves = [0] * 16
        ans = 0
        for x in reversed(nums):
            d, p, v = x // 100, x // 10 % 10, x % 10
            idx = (1 << (d - 1)) + p - 1
            if leaves[idx] == 0:
                leaves[idx] = 1
            ans += v * leaves[idx]
            if idx > 1:
                leaves[idx // 2] += leaves[idx]
        return ans