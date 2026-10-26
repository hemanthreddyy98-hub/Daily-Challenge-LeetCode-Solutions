/*
Brute Force

class Solution {
    function countIslands($grid, $k) {
        $m = count($grid);
        $n = count($grid[0]);
        $dr = [1, -1, 0, 0];
        $dc = [0, 0, 1, -1];
        $count = 0;
        for ($i = 0; $i < $m; $i++) {
            for ($j = 0; $j < $n; $j++) {
                if ($grid[$i][$j] == 0) continue;
                $seen = array_fill(0, $m * $n, false);
                $seen[$i * $n + $j] = true;
                $stack = [[$i, $j]];
                $sum = 0;
                $first = true;
                while ($stack) {
                    [$r, $c] = array_pop($stack);
                    $sum += $grid[$r][$c];
                    if ($r * $n + $c < $i * $n + $j) $first = false;
                    for ($d = 0; $d < 4; $d++) {
                        $nr = $r + $dr[$d];
                        $nc = $c + $dc[$d];
                        if ($nr < 0 || $nc < 0 || $nr >= $m || $nc >= $n) continue;
                        if ($grid[$nr][$nc] > 0 && !$seen[$nr * $n + $nc]) {
                            $seen[$nr * $n + $nc] = true;
                            $stack[] = [$nr, $nc];
                        }
                    }
                }
                if ($first && $sum % $k == 0) $count++;
            }
        }
        return $count;
    }
}
*/

/*
Better Approach

class Solution {
    function countIslands($grid, $k) {
        $m = count($grid);
        $n = count($grid[0]);
        $visited = array_fill(0, $m, array_fill(0, $n, false));
        $dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
        $count = 0;
        for ($i = 0; $i < $m; $i++) {
            for ($j = 0; $j < $n; $j++) {
                if ($grid[$i][$j] == 0 || $visited[$i][$j]) continue;
                $queue = new SplQueue();
                $queue->enqueue([$i, $j]);
                $visited[$i][$j] = true;
                $sum = 0;
                while (!$queue->isEmpty()) {
                    [$r0, $c0] = $queue->dequeue();
                    $sum += $grid[$r0][$c0];
                    foreach ($dirs as [$dr, $dc]) {
                        $r = $r0 + $dr;
                        $c = $c0 + $dc;
                        if ($r >= 0 && $c >= 0 && $r < $m && $c < $n && $grid[$r][$c] > 0 && !$visited[$r][$c]) {
                            $visited[$r][$c] = true;
                            $queue->enqueue([$r, $c]);
                        }
                    }
                }
                if ($sum % $k == 0) $count++;
            }
        }
        return $count;
    }
}
*/

class Solution {
    function countIslands($grid, $k) {
        $m = count($grid);
        $n = count($grid[0]);
        $q = array_fill(0, $m * $n, 0);
        $dr = [1, -1, 0, 0];
        $dc = [0, 0, 1, -1];
        $count = 0;
        for ($i = 0; $i < $m; $i++) {
            for ($j = 0; $j < $n; $j++) {
                if ($grid[$i][$j] == 0) continue;
                $head = 0;
                $tail = 0;
                $sum = $grid[$i][$j] % $k;
                $grid[$i][$j] = 0;
                $q[$tail++] = $i * $n + $j;
                while ($head < $tail) {
                    $id = $q[$head++];
                    $r = intdiv($id, $n);
                    $c = $id % $n;
                    for ($d = 0; $d < 4; $d++) {
                        $nr = $r + $dr[$d];
                        $nc = $c + $dc[$d];
                        if ($nr >= 0 && $nc >= 0 && $nr < $m && $nc < $n && $grid[$nr][$nc] > 0) {
                            $sum = ($sum + $grid[$nr][$nc]) % $k;
                            $grid[$nr][$nc] = 0;
                            $q[$tail++] = $nr * $n + $nc;
                        }
                    }
                }
                if ($sum == 0) $count++;
            }
        }
        return $count;
    }
}