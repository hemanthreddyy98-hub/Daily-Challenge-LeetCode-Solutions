"""
Brute Force

class Solution(object):
    def createGrid(self, m, n):
        g = [['.'] * n for _ in range(m)]

        def reach(r, c):
            if r >= m or c >= n or g[r][c] == '#':
                return False
            if r == m - 1 and c == n - 1:
                return True
            return reach(r + 1, c) or reach(r, c + 1)

        for i in range(m):
            for j in range(n):
                if (i, j) in ((0, 0), (m - 1, n - 1)):
                    continue
                g[i][j] = '#'
                if not reach(0, 0):
                    g[i][j] = '.'
        return [''.join(row) for row in g]
"""

"""
Better Approach

class Solution(object):
    def createGrid(self, m, n):
        g = [['.'] * n for _ in range(m)]

        def reach():
            ok = [[False] * n for _ in range(m)]
            for i in range(m):
                for j in range(n):
                    if g[i][j] == '#':
                        continue
                    ok[i][j] = (i == 0 and j == 0) or (i > 0 and ok[i - 1][j]) or (j > 0 and ok[i][j - 1])
            return ok[m - 1][n - 1]

        for i in range(m):
            for j in range(n):
                if (i, j) in ((0, 0), (m - 1, n - 1)):
                    continue
                g[i][j] = '#'
                if not reach():
                    g[i][j] = '.'
        return [''.join(row) for row in g]
"""

class Solution(object):
    def createGrid(self, m, n):
        return ['.' * n] + ['#' * (n - 1) + '.'] * (m - 1)