/*
Brute Force

class Solution {
    function closedIsland($grid) {
        $m = count($grid);
        $n = count($grid[0]);
        $dr = [1, -1, 0, 0];
        $dc = [0, 0, 1, -1];
        $count = 0;
        for ($i = 0; $i < $m; $i++) {
            for ($j = 0; $j < $n; $j++) {
                if ($grid[$i][$j] != 0) continue;
                $seen = array_fill(0, $m * $n, false);
                $seen[$i * $n + $j] = true;
                $stack = [[$i, $j]];
                $closed = true;
                $first = true;
                while ($stack) {
                    [$r, $c] = array_pop($stack);
                    if ($r == 0 || $c == 0 || $r == $m - 1 || $c == $n - 1) $closed = false;
                    if ($r * $n + $c < $i * $n + $j) $first = false;
                    for ($k = 0; $k < 4; $k++) {
                        $nr = $r + $dr[$k];
                        $nc = $c + $dc[$k];
                        if ($nr < 0 || $nc < 0 || $nr >= $m || $nc >= $n) continue;
                        if ($grid[$nr][$nc] == 0 && !$seen[$nr * $n + $nc]) {
                            $seen[$nr * $n + $nc] = true;
                            $stack[] = [$nr, $nc];
                        }
                    }
                }
                if ($closed && $first) $count++;
            }
        }
        return $count;
    }
}
*/

/*
Better Approach

class Solution {
    function closedIsland($grid) {
        $m = count($grid);
        $n = count($grid[0]);
        for ($i = 0; $i < $m; $i++) {
            $this->sink($grid, $i, 0);
            $this->sink($grid, $i, $n - 1);
        }
        for ($j = 0; $j < $n; $j++) {
            $this->sink($grid, 0, $j);
            $this->sink($grid, $m - 1, $j);
        }
        $count = 0;
        for ($i = 0; $i < $m; $i++)
            for ($j = 0; $j < $n; $j++)
                if ($grid[$i][$j] == 0) {
                    $this->sink($grid, $i, $j);
                    $count++;
                }
        return $count;
    }

    function sink(&$grid, $r, $c) {
        if ($r < 0 || $c < 0 || $r >= count($grid) || $c >= count($grid[0]) || $grid[$r][$c] != 0) return;
        $grid[$r][$c] = 1;
        $this->sink($grid, $r + 1, $c);
        $this->sink($grid, $r - 1, $c);
        $this->sink($grid, $r, $c + 1);
        $this->sink($grid, $r, $c - 1);
    }
}
*/

class Solution {
    function closedIsland($grid) {
        $m = count($grid);
        $n = count($grid[0]);
        $q = array_fill(0, $m * $n, 0);
        $dr = [1, -1, 0, 0];
        $dc = [0, 0, 1, -1];
        $count = 0;
        for ($i = 0; $i < $m; $i++) {
            for ($j = 0; $j < $n; $j++) {
                if ($grid[$i][$j] != 0) continue;
                $head = 0;
                $tail = 0;
                $closed = true;
                $grid[$i][$j] = 1;
                $q[$tail++] = $i * $n + $j;
                while ($head < $tail) {
                    $id = $q[$head++];
                    $r = intdiv($id, $n);
                    $c = $id % $n;
                    if ($r == 0 || $c == 0 || $r == $m - 1 || $c == $n - 1) $closed = false;
                    for ($k = 0; $k < 4; $k++) {
                        $nr = $r + $dr[$k];
                        $nc = $c + $dc[$k];
                        if ($nr >= 0 && $nc >= 0 && $nr < $m && $nc < $n && $grid[$nr][$nc] == 0) {
                            $grid[$nr][$nc] = 1;
                            $q[$tail++] = $nr * $n + $nc;
                        }
                    }
                }
                if ($closed) $count++;
            }
        }
        return $count;
    }
}