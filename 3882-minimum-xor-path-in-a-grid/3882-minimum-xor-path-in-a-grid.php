/*
Brute Force

class Solution {
    function minCost($grid) {
        return $this->dfs($grid, 0, 0, $grid[0][0]);
    }

    function dfs($grid, $i, $j, $x) {
        $m = count($grid);
        $n = count($grid[0]);
        if ($i == $m - 1 && $j == $n - 1) return $x;
        $best = PHP_INT_MAX;
        if ($i + 1 < $m) $best = min($best, $this->dfs($grid, $i + 1, $j, $x ^ $grid[$i + 1][$j]));
        if ($j + 1 < $n) $best = min($best, $this->dfs($grid, $i, $j + 1, $x ^ $grid[$i][$j + 1]));
        return $best;
    }
}
*/

/*
Better Approach

class Solution {
    function minCost($grid) {
        $memo = [];
        return $this->dfs($grid, $memo, 0, 0, $grid[0][0]);
    }

    function dfs($grid, &$memo, $i, $j, $x) {
        $m = count($grid);
        $n = count($grid[0]);
        if ($i == $m - 1 && $j == $n - 1) return $x;
        $key = ($i * $n + $j) * 1024 + $x;
        if (isset($memo[$key])) return $memo[$key];
        $best = PHP_INT_MAX;
        if ($i + 1 < $m) $best = min($best, $this->dfs($grid, $memo, $i + 1, $j, $x ^ $grid[$i + 1][$j]));
        if ($j + 1 < $n) $best = min($best, $this->dfs($grid, $memo, $i, $j + 1, $x ^ $grid[$i][$j + 1]));
        return $memo[$key] = $best;
    }
}
*/

class Solution {
    function minCost($grid) {
        $m = count($grid);
        $n = count($grid[0]);
        $dp = array_fill(0, $n, []);
        for ($i = 0; $i < $m; $i++)
            for ($j = 0; $j < $n; $j++) {
                $from = ($i == 0 && $j == 0) ? [0 => true] : $dp[$j] + ($j > 0 ? $dp[$j - 1] : []);
                $cur = [];
                foreach ($from as $x => $_) $cur[$x ^ $grid[$i][$j]] = true;
                $dp[$j] = $cur;
            }
        return min(array_keys($dp[$n - 1]));
    }
}