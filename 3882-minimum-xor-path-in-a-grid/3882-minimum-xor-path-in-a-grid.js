/*
Brute Force

var minCost = function(grid) {
    const m = grid.length, n = grid[0].length;
    const dfs = (i, j, x) => {
        if (i === m - 1 && j === n - 1) return x;
        let best = Infinity;
        if (i + 1 < m) best = Math.min(best, dfs(i + 1, j, x ^ grid[i + 1][j]));
        if (j + 1 < n) best = Math.min(best, dfs(i, j + 1, x ^ grid[i][j + 1]));
        return best;
    };
    return dfs(0, 0, grid[0][0]);
};
*/

/*
Better Approach

var minCost = function(grid) {
    const m = grid.length, n = grid[0].length;
    const memo = new Int32Array(m * n * 1024).fill(-1);
    const dfs = (i, j, x) => {
        if (i === m - 1 && j === n - 1) return x;
        const key = (i * n + j) * 1024 + x;
        if (memo[key] !== -1) return memo[key];
        let best = Infinity;
        if (i + 1 < m) best = Math.min(best, dfs(i + 1, j, x ^ grid[i + 1][j]));
        if (j + 1 < n) best = Math.min(best, dfs(i, j + 1, x ^ grid[i][j + 1]));
        return memo[key] = best;
    };
    return dfs(0, 0, grid[0][0]);
};
*/

var minCost = function(grid) {
    const m = grid.length, n = grid[0].length;
    const dp = Array.from({ length: n }, () => new Uint8Array(1024));
    const tmp = new Uint8Array(1024);
    for (let i = 0; i < m; i++)
        for (let j = 0; j < n; j++) {
            for (let x = 0; x < 1024; x++)
                tmp[x] = (i === 0 && j === 0 && x === 0) || (i > 0 && dp[j][x]) || (j > 0 && dp[j - 1][x]) ? 1 : 0;
            for (let x = 0; x < 1024; x++) dp[j][x ^ grid[i][j]] = tmp[x];
        }
    let x = 0;
    while (!dp[n - 1][x]) x++;
    return x;
};