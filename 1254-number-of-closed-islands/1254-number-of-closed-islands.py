"""
Brute Force

class Solution(object):
    def closedIsland(self, grid):
        m, n = len(grid), len(grid[0])
        count = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] != 0:
                    continue
                seen = [[False] * n for _ in range(m)]
                seen[i][j] = True
                stack = [(i, j)]
                closed = first = True
                while stack:
                    r, c = stack.pop()
                    if r == 0 or c == 0 or r == m - 1 or c == n - 1:
                        closed = False
                    if r * n + c < i * n + j:
                        first = False
                    for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                        if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] == 0 and not seen[nr][nc]:
                            seen[nr][nc] = True
                            stack.append((nr, nc))
                if closed and first:
                    count += 1
        return count
"""

"""
Better Approach

import sys

class Solution(object):
    def closedIsland(self, grid):
        sys.setrecursionlimit(20000)
        m, n = len(grid), len(grid[0])

        def sink(r, c):
            if r < 0 or c < 0 or r >= m or c >= n or grid[r][c] != 0:
                return
            grid[r][c] = 1
            sink(r + 1, c)
            sink(r - 1, c)
            sink(r, c + 1)
            sink(r, c - 1)

        for i in range(m):
            sink(i, 0)
            sink(i, n - 1)
        for j in range(n):
            sink(0, j)
            sink(m - 1, j)
        count = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0:
                    sink(i, j)
                    count += 1
        return count
"""

class Solution(object):
    def closedIsland(self, grid):
        m, n = len(grid), len(grid[0])
        q = [0] * (m * n)
        count = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] != 0:
                    continue
                grid[i][j] = 1
                q[0] = i * n + j
                head, tail = 0, 1
                closed = True
                while head < tail:
                    r, c = divmod(q[head], n)
                    head += 1
                    if r == 0 or c == 0 or r == m - 1 or c == n - 1:
                        closed = False
                    for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                        if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] == 0:
                            grid[nr][nc] = 1
                            q[tail] = nr * n + nc
                            tail += 1
                if closed:
                    count += 1
        return count