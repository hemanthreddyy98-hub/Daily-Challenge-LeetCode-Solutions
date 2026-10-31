/*
Brute Force

var uniquePaths = function(grid) {
    const MOD = 1_000_000_007;
    const m = grid.length, n = grid[0].length;
    const dfs = (i, j, d) => {
        if (i >= m || j >= n) return 0;
        if (i === m - 1 && j === n - 1) return 1;
        if (grid[i][j] === 1) return d === 0 ? dfs(i + 1, j, 1) : dfs(i, j + 1, 0);
        return (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % MOD;
    };
    return dfs(0, 0, 0);
};
*/

/*
Better Approach

var uniquePaths = function(grid) {
    const MOD = 1_000_000_007;
    const m = grid.length, n = grid[0].length;
    const memo = new Int32Array(m * n * 2).fill(-1);
    const dfs = (i, j, d) => {
        if (i >= m || j >= n) return 0;
        if (i === m - 1 && j === n - 1) return 1;
        const key = (i * n + j) * 2 + d;
        if (memo[key] !== -1) return memo[key];
        if (grid[i][j] === 1) return memo[key] = d === 0 ? dfs(i + 1, j, 1) : dfs(i, j + 1, 0);
        return memo[key] = (dfs(i, j + 1, 0) + dfs(i + 1, j, 1)) % MOD;
    };
    return dfs(0, 0, 0);
};
*/

var uniquePaths = function(grid) {
    const MOD = 1_000_000_007;
    const m = grid.length, n = grid[0].length;
    const r = new Array(n).fill(0), d = new Array(n).fill(0);
    for (let i = 0; i < m; i++) {
        for (let j = 0; j < n; j++) {
            if (i === 0 && j === 0) {
                r[0] = 1;
                continue;
            }
            const nd = i === 0 ? 0 : grid[i - 1][j] === 0 ? (r[j] + d[j]) % MOD : r[j];
            const nr = j === 0 ? 0 : grid[i][j - 1] === 0 ? (r[j - 1] + d[j - 1]) % MOD : d[j - 1];
            r[j] = nr;
            d[j] = nd;
        }
    }
    return (r[n - 1] + d[n - 1]) % MOD;
};