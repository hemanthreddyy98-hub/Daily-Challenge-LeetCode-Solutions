/*
Brute Force

function countIslands(grid: number[][], k: number): number {
    const m = grid.length, n = grid[0].length;
    const dr = [1, -1, 0, 0], dc = [0, 0, 1, -1];
    let count = 0;
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 0) continue;
            const seen = new Uint8Array(m * n);
            const stack: number[] = [i * n + j];
            seen[i * n + j] = 1;
            let sum = 0, first = true;
            while (stack.length > 0) {
                const id = stack.pop()!;
                const r = Math.floor(id / n), c = id % n;
                sum += grid[r][c];
                if (id < i * n + j) first = false;
                for (let d = 0; d < 4; d++) {
                    const nr = r + dr[d], nc = c + dc[d];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0 && !seen[nr * n + nc]) {
                        seen[nr * n + nc] = 1;
                        stack.push(nr * n + nc);
                    }
                }
            }
            if (first && sum % k === 0) count++;
        }
    }
    return count;
}
*/

/*
Better Approach

function countIslands(grid: number[][], k: number): number {
    const m = grid.length, n = grid[0].length;
    const visited: boolean[][] = Array.from({ length: m }, () => new Array(n).fill(false));
    const dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
    let count = 0;
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 0 || visited[i][j]) continue;
            const queue: number[][] = [[i, j]];
            visited[i][j] = true;
            let sum = 0;
            for (let h = 0; h < queue.length; h++) {
                const [r0, c0] = queue[h];
                sum += grid[r0][c0];
                for (const [dr, dc] of dirs) {
                    const r = r0 + dr, c = c0 + dc;
                    if (r >= 0 && c >= 0 && r < m && c < n && grid[r][c] > 0 && !visited[r][c]) {
                        visited[r][c] = true;
                        queue.push([r, c]);
                    }
                }
            }
            if (sum % k === 0) count++;
        }
    }
    return count;
}
*/

function countIslands(grid: number[][], k: number): number {
    const m = grid.length, n = grid[0].length;
    const q = new Int32Array(m * n);
    const dr = [1, -1, 0, 0], dc = [0, 0, 1, -1];
    let count = 0;
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (grid[i][j] === 0) continue;
            let head = 0, tail = 0, sum = grid[i][j] % k;
            grid[i][j] = 0;
            q[tail++] = i * n + j;
            while (head < tail) {
                const id = q[head++];
                const r = (id / n) | 0, c = id % n;
                for (let d = 0; d < 4; d++) {
                    const nr = r + dr[d], nc = c + dc[d];
                    if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid[nr][nc] > 0) {
                        sum = (sum + grid[nr][nc]) % k;
                        grid[nr][nc] = 0;
                        q[tail++] = nr * n + nc;
                    }
                }
            }
            if (sum === 0) count++;
        }
    }
    return count;
}