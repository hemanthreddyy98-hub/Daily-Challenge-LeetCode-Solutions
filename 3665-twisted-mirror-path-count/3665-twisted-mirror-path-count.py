"""
Brute Force

class Solution(object):
    def uniquePaths(self, grid):
        MOD = 10**9 + 7
        m, n = len(grid), len(grid[0])

        def dfs(i, j, d):
            if i >= m or j >= n:
                return 0
            if i == m - 1 and j == n - 1:
                return 1
            if grid[i][j] == 1:
                return dfs(i + 1, j, 1) if d == 0 else dfs(i, j + 1, 0)
            return (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % MOD

        return dfs(0, 0, 0)
"""

"""
Better Approach

import sys

class Solution(object):
    def uniquePaths(self, grid):
        sys.setrecursionlimit(10000)
        MOD = 10**9 + 7
        m, n = len(grid), len(grid[0])
        memo = [[[-1, -1] for _ in range(n)] for _ in range(m)]

        def dfs(i, j, d):
            if i >= m or j >= n:
                return 0
            if i == m - 1 and j == n - 1:
                return 1
            if memo[i][j][d] == -1:
                if grid[i][j] == 1:
                    memo[i][j][d] = dfs(i + 1, j, 1) if d == 0 else dfs(i, j + 1, 0)
                else:
                    memo[i][j][d] = (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % MOD
            return memo[i][j][d]

        return dfs(0, 0, 0)
"""

class Solution(object):
    def uniquePaths(self, grid):
        MOD = 10**9 + 7
        m, n = len(grid), len(grid[0])
        r, d = [0] * n, [0] * n
        for i in range(m):
            for j in range(n):
                if i == 0 and j == 0:
                    r[0] = 1
                    continue
                nd = 0 if i == 0 else (r[j] + d[j]) % MOD if grid[i - 1][j] == 0 else r[j]
                nr = 0 if j == 0 else (r[j - 1] + d[j - 1]) % MOD if grid[i][j - 1] == 0 else d[j - 1]
                r[j], d[j] = nr, nd
        return (r[n - 1] + d[n - 1]) % MOD