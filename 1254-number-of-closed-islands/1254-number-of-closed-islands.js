/*
Brute Force

var closedIsland = function(grid) {
    const m = grid.length, n = grid[0].length;
    const dr = [1, -1, 0, 0], dc = [0, 0, 1, -1];
    let count = 0;
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] !== 0) continue;
            const seen = new Uint8Array(m * n);
            const stack = [i * n + j];
            seen[i * n + j] = 1;
            let closed = true, first = true;
            while (stack.length > 0) {
                const id = stack.pop();
                const r = Math.floor(id / n), c = id % n;
                if (r === 0 || c === 0 || r === m - 1 || c === n - 1) closed = false;
                if (id < i * n + j) first = false;
                for (let k = 0; k < 4; k++) {
                    const nr = r + dr[k], nc = c + dc[k];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] === 0 && !seen[nr * n + nc]) {
                        seen[nr * n + nc] = 1;
                        stack.push(nr * n + nc);
                    }
                }
            }
            if (closed && first) count++;
        }
    }
    return count;
};
*/

/*
Better Approach

var closedIsland = function(grid) {
    const m = grid.length, n = grid[0].length;
    const sink = (r, c) => {
        if (r < 0 || c < 0 || r >= m || c >= n || grid[r][c] !== 0) return;
        grid[r][c] = 1;
        sink(r + 1, c);
        sink(r - 1, c);
        sink(r, c + 1);
        sink(r, c - 1);
    };
    for (let i = 0; i < m; i++) {
        sink(i, 0);
        sink(i, n - 1);
    }
    for (let j = 0; j < n; j++) {
        sink(0, j);
        sink(m - 1, j);
    }
    let count = 0;
    for (let i = 0; i < m; i++)
        for (let j = 0; j < n; j++)
            if (grid[i][j] === 0) {
                sink(i, j);
                count++;
            }
    return count;
};
*/

var closedIsland = function(grid) {
    const m = grid.length, n = grid[0].length;
    const q = new Int32Array(m * n);
    const dr = [1, -1, 0, 0], dc = [0, 0, 1, -1];
    let count = 0;
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] !== 0) continue;
            let head = 0, tail = 0, closed = true;
            grid[i][j] = 1;
            q[tail++] = i * n + j;
            while (head < tail) {
                const id = q[head++];
                const r = (id / n) | 0, c = id % n;
                if (r === 0 || c === 0 || r === m - 1 || c === n - 1) closed = false;
                for (let k = 0; k < 4; k++) {
                    const nr = r + dr[k], nc = c + dc[k];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] === 0) {
                        grid[nr][nc] = 1;
                        q[tail++] = nr * n + nc;
                    }
                }
            }
            if (closed) count++;
        }
    }
    return count;
};