/**
 * @param {character[][]} grid
 * @return {number}
 */
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