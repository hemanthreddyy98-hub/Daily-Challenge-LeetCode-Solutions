/*
Brute Force

var getFood = function(grid) {
    const m = grid.length, n = grid[0].length;
    let best = Infinity;

    const dfs = (r, c, steps) => {
        if (r < 0 || c < 0 || r >= m || c >= n) return;
        const ch = grid[r][c];
        if (ch === 'X' || ch === 'V') return;
        if (ch === '#') {
            best = Math.min(best, steps);
            return;
        }
        grid[r][c] = 'V';
        dfs(r + 1, c, steps + 1);
        dfs(r - 1, c, steps + 1);
        dfs(r, c + 1, steps + 1);
        dfs(r, c - 1, steps + 1);
        grid[r][c] = ch;
    };

    for (let i = 0; i < m; i++)
        for (let j = 0; j < n; j++)
            if (grid[i][j] === '*') dfs(i, j, 0);
    return best === Infinity ? -1 : best;
};
*/

/*
Basic Approach

var getFood = function(grid) {
    const m = grid.length, n = grid[0].length;
    let queue = [];
    const visited = Array.from({ length: m }, () => new Array(n).fill(false));

    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === '*') {
                queue.push([i, j]);
                visited[i][j] = true;
            }
        }
    }

    const dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
    let steps = 0;

    while (queue.length > 0) {
        const next = [];
        for (const [r0, c0] of queue) {
            if (grid[r0][c0] === '#') return steps;
            for (const [dr, dc] of dirs) {
                const r = r0 + dr, c = c0 + dc;
                if (r >= 0 && c >= 0 && r < m && c < n && !visited[r][c] && grid[r][c] !== 'X') {
                    visited[r][c] = true;
                    next.push([r, c]);
                }
            }
        }
        queue = next;
        steps++;
    }

    return -1;
};
*/

var getFood = function(grid) {
    const m = grid.length, n = grid[0].length;

    let start = -1;
    for (let i = 0; i < m && start < 0; i++) {
        const j = grid[i].indexOf('*');
        if (j !== -1) start = i * n + j;
    }
    if (start < 0) return -1;

    const q = new Int32Array(m * n);
    let head = 0, tail = 0;
    q[tail++] = start;
    const dr = [1, -1, 0, 0], dc = [0, 0, 1, -1];
    let steps = 0;

    while (head < tail) {
        steps++;
        const levelEnd = tail;
        while (head < levelEnd) {
            const id = q[head++];
            const r = (id / n) | 0, c = id % n;
            for (let k = 0; k < 4; k++) {
                const nr = r + dr[k], nc = c + dc[k];
                if (nr < 0 || nc < 0 || nr >= m || nc >= n) continue;
                const ch = grid[nr][nc];
                if (ch === '#') return steps;
                if (ch === 'O') {
                    grid[nr][nc] = 'X';
                    q[tail++] = nr * n + nc;
                }
            }
        }
    }
    return -1;
};