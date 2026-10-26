"""
Brute Force

class Solution:
    def countIslands(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        count = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0:
                    continue
                seen = [[False] * n for _ in range(m)]
                seen[i][j] = True
                stack = [(i, j)]
                total, first = 0, True
                while stack:
                    r, c = stack.pop()
                    total += grid[r][c]
                    if r * n + c < i * n + j:
                        first = False
                    for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                        if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > 0 and not seen[nr][nc]:
                            seen[nr][nc] = True
                            stack.append((nr, nc))
                if first and total % k == 0:
                    count += 1
        return count
"""

"""
Better Approach

from collections import deque

class Solution:
    def countIslands(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        visited = [[False] * n for _ in range(m)]
        count = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0 or visited[i][j]:
                    continue
                visited[i][j] = True
                queue = deque([(i, j)])
                total = 0
                while queue:
                    r, c = queue.popleft()
                    total += grid[r][c]
                    for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                        if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > 0 and not visited[nr][nc]:
                            visited[nr][nc] = True
                            queue.append((nr, nc))
                if total % k == 0:
                    count += 1
        return count
"""

class Solution:
    def countIslands(self, grid: List[List[int]], k: int) -> int:
        m, n = len(grid), len(grid[0])
        q = [0] * (m * n)
        count = 0
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 0:
                    continue
                total = grid[i][j] % k
                grid[i][j] = 0
                q[0] = i * n + j
                head, tail = 0, 1
                while head < tail:
                    r, c = divmod(q[head], n)
                    head += 1
                    for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                        if 0 <= nr < m and 0 <= nc < n and grid[nr][nc] > 0:
                            total = (total + grid[nr][nc]) % k
                            grid[nr][nc] = 0
                            q[tail] = nr * n + nc
                            tail += 1
                if total == 0:
                    count += 1
        return count