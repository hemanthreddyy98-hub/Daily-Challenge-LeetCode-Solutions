"""
Brute Force

class Solution:
    def sortPermutation(self, nums: List[int]) -> int:
        n = len(nums)
        if all(nums[i] == i for i in range(n)):
            return 0

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        for k in range(n - 1, -1, -1):
            parent = list(range(n))
            for i in range(n):
                for j in range(i + 1, n):
                    if (nums[i] & nums[j]) == k:
                        a, b = find(nums[i]), find(nums[j])
                        parent[a] = b
            if all(find(nums[i]) == find(i) for i in range(n)):
                return k
        return 0
"""

"""
Better Approach

class Solution:
    def sortPermutation(self, nums: List[int]) -> int:
        n = len(nums)
        if all(nums[i] == i for i in range(n)):
            return 0
        for k in range(n - 1, -1, -1):
            if all(nums[i] == i or (nums[i] & k) == k for i in range(n)):
                return k
        return 0
"""

class Solution:
    def sortPermutation(self, nums: List[int]) -> int:
        ans = -1
        for i, v in enumerate(nums):
            if v != i:
                ans &= v
        return max(ans, 0)