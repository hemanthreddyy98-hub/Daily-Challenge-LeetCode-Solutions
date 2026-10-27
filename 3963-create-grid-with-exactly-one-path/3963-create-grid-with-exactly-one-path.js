/*
Brute Force

var createGrid = function(m, n) {
    const g = Array.from({ length: m }, () => new Array(n).fill('.'));
    const reach = (r, c) => {
        if (r >= m || c >= n || g[r][c] === '#') return false;
        if (r === m - 1 && c === n - 1) return true;
        return reach(r + 1, c) || reach(r, c + 1);
    };
    for (let i = 0; i < m; i++)
        for (let j = 0; j < n; j++) {
            if ((i === 0 && j === 0) || (i === m - 1 && j === n - 1)) continue;
            g[i][j] = '#';
            if (!reach(0, 0)) g[i][j] = '.';
        }
    return g.map(row => row.join(''));
};
*/

/*
Better Approach

var createGrid = function(m, n) {
    const g = Array.from({ length: m }, () => new Array(n).fill('.'));
    const reach = () => {
        const ok = Array.from({ length: m }, () => new Array(n).fill(false));
        for (let i = 0; i < m; i++)
            for (let j = 0; j < n; j++) {
                if (g[i][j] === '#') continue;
                ok[i][j] = (i === 0 && j === 0) || (i > 0 && ok[i - 1][j]) || (j > 0 && ok[i][j - 1]);
            }
        return ok[m - 1][n - 1];
    };
    for (let i = 0; i < m; i++)
        for (let j = 0; j < n; j++) {
            if ((i === 0 && j === 0) || (i === m - 1 && j === n - 1)) continue;
            g[i][j] = '#';
            if (!reach()) g[i][j] = '.';
        }
    return g.map(row => row.join(''));
};
*/

var createGrid = function(m, n) {
    const rest = '#'.repeat(n - 1) + '.';
    const grid = ['.'.repeat(n)];
    for (let i = 1; i < m; i++) grid.push(rest);
    return grid;
};