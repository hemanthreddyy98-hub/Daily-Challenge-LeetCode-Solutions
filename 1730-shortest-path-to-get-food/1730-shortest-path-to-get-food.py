"""
Brute Force

class Solution:
    def getFood(self, grid: List[List[str]]) -> int:
        m, n = len(grid), len(grid[0])
        self.best = float('inf')

        def dfs(r, c, steps):
            if r < 0 or c < 0 or r >= m or c >= n:
                return
            ch = grid[r][c]
            if ch == 'X' or ch == 'V':
                return
            if ch == '#':
                self.best = min(self.best, steps)
                return
            grid[r][c] = 'V'
            dfs(r + 1, c, steps + 1)
            dfs(r - 1, c, steps + 1)
            dfs(r, c + 1, steps + 1)
            dfs(r, c - 1, steps + 1)
            grid[r][c] = ch

        for i in range(m):
            for j in range(n):
                if grid[i][j] == '*':
                    dfs(i, j, 0)
        return -1 if self.best == float('inf') else self.best
"""

"""
Basic Approach

from collections import deque

class Solution:
    def getFood(self, grid: List[List[str]]) -> int:
        m, n = len(grid), len(grid[0])
        queue = deque()
        visited = [[False] * n for _ in range(m)]

        for i in range(m):
            for j in range(n):
                if grid[i][j] == '*':
                    queue.append((i, j))
                    visited[i][j] = True

        dirs = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        steps = 0

        while queue:
            size = len(queue)
            for _ in range(size):
                r0, c0 = queue.popleft()
                if grid[r0][c0] == '#':
                    return steps
                for dr, dc in dirs:
                    r, c = r0 + dr, c0 + dc
                    if 0 <= r < m and 0 <= c < n and not visited[r][c] and grid[r][c] != 'X':
                        visited[r][c] = True
                        queue.append((r, c))
            steps += 1

        return -1
"""

class Solution:
    def getFood(self, grid: List[List[str]]) -> int:
        m, n = len(grid), len(grid[0])

        start = -1
        for i, row in enumerate(grid):
            if '*' in row:
                start = i * n + row.index('*')
                break
        if start < 0:
            return -1

        q = [0] * (m * n)
        q[0] = start
        head, tail = 0, 1
        steps = 0

        while head < tail:
            steps += 1
            level_end = tail
            while head < level_end:
                r, c = divmod(q[head], n)
                head += 1
                for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                    if 0 <= nr < m and 0 <= nc < n:
                        ch = grid[nr][nc]
                        if ch == '#':
                            return steps
                        if ch == 'O':
                            grid[nr][nc] = 'X'
                            q[tail] = nr * n + nc
                            tail += 1
        return -1