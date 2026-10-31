/*
Brute Force

class Solution {
    function uniquePaths($grid) {
        return $this->dfs($grid, count($grid), count($grid[0]), 0, 0, 0);
    }

    function dfs($grid, $m, $n, $i, $j, $d) {
        if ($i >= $m || $j >= $n) return 0;
        if ($i == $m - 1 && $j == $n - 1) return 1;
        if ($grid[$i][$j] == 1) {
            return $d == 0 ? $this->dfs($grid, $m, $n, $i + 1, $j, 1) : $this->dfs($grid, $m, $n, $i, $j + 1, 0);
        }
        return ($this->dfs($grid, $m, $n, $i, $j + 1, 0) + $this->dfs($grid, $m, $n, $i + 1, $j, 1)) % 1000000007;
    }
}
*/

/*
Better Approach

class Solution {
    function uniquePaths($grid) {
        $m = count($grid);
        $n = count($grid[0]);
        $memo = array_fill(0, $m * $n * 2, -1);
        return $this->dfs($grid, $m, $n, $memo, 0, 0, 0);
    }

    function dfs($grid, $m, $n, &$memo, $i, $j, $d) {
        if ($i >= $m || $j >= $n) return 0;
        if ($i == $m - 1 && $j == $n - 1) return 1;
        $key = ($i * $n + $j) * 2 + $d;
        if ($memo[$key] != -1) return $memo[$key];
        if ($grid[$i][$j] == 0) {
            $res = ($this->dfs($grid, $m, $n, $memo, $i, $j + 1, 0) + $this->dfs($grid, $m, $n, $memo, $i + 1, $j, 1)) % 1000000007;
        } elseif ($d == 0) {
            $res = $this->dfs($grid, $m, $n, $memo, $i + 1, $j, 1);
        } else {
            $res = $this->dfs($grid, $m, $n, $memo, $i, $j + 1, 0);
        }
        return $memo[$key] = $res;
    }
}
*/

class Solution {
    function uniquePaths($grid) {
        $mod = 1000000007;
        $m = count($grid);
        $n = count($grid[0]);
        $r = array_fill(0, $n, 0);
        $d = array_fill(0, $n, 0);
        for ($i = 0; $i < $m; $i++) {
            for ($j = 0; $j < $n; $j++) {
                if ($i == 0 && $j == 0) {
                    $r[0] = 1;
                    continue;
                }
                $nd = $i == 0 ? 0 : ($grid[$i - 1][$j] == 0 ? ($r[$j] + $d[$j]) % $mod : $r[$j]);
                $nr = $j == 0 ? 0 : ($grid[$i][$j - 1] == 0 ? ($r[$j - 1] + $d[$j - 1]) % $mod : $d[$j - 1]);
                $r[$j] = $nr;
                $d[$j] = $nd;
            }
        }
        return ($r[$n - 1] + $d[$n - 1]) % $mod;
    }
}