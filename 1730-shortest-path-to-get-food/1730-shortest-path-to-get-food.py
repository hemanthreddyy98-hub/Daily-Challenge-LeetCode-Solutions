from collections import deque
from typing import List

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