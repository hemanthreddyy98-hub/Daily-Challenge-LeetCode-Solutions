"""
Brute Force

import sys

class Solution(object):
    def minCost(self, grid):
        sys.setrecursionlimit(10000)
        m, n = len(grid), len(grid[0])

        def dfs(i, j, x):
            if i == m - 1 and j == n - 1:
                return x
            best = float('inf')
            if i + 1 < m:
                best = min(best, dfs(i + 1, j, x ^ grid[i + 1][j]))
            if j + 1 < n:
                best = min(best, dfs(i, j + 1, x ^ grid[i][j + 1]))
            return best

        return dfs(0, 0, grid[0][0])
"""

"""
Better Approach

import sys

class Solution(object):
    def minCost(self, grid):
        sys.setrecursionlimit(10000)
        m, n = len(grid), len(grid[0])
        memo = [[[-1] * 1024 for _ in range(n)] for _ in range(m)]

        def dfs(i, j, x):
            if i == m - 1 and j == n - 1:
                return x
            if memo[i][j][x] != -1:
                return memo[i][j][x]
            best = float('inf')
            if i + 1 < m:
                best = min(best, dfs(i + 1, j, x ^ grid[i + 1][j]))
            if j + 1 < n:
                best = min(best, dfs(i, j + 1, x ^ grid[i][j + 1]))
            memo[i][j][x] = best
            return best

        return dfs(0, 0, grid[0][0])
"""

class Solution(object):
    def minCost(self, grid):
        m, n = len(grid), len(grid[0])
        dp = [set() for _ in range(n)]
        for i in range(m):
            for j in range(n):
                prev = {0} if i == 0 and j == 0 else dp[j] | (dp[j - 1] if j > 0 else set())
                dp[j] = {x ^ grid[i][j] for x in prev}
        return min(dp[n - 1])