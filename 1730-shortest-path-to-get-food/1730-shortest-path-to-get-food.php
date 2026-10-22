/*
Brute Force

class Solution {
    private $grid;
    private $m;
    private $n;
    private $best;

    function getFood($grid) {
        $this->grid = $grid;
        $this->m = count($grid);
        $this->n = count($grid[0]);
        $this->best = PHP_INT_MAX;
        for ($i = 0; $i < $this->m; $i++)
            for ($j = 0; $j < $this->n; $j++)
                if ($grid[$i][$j] === '*') $this->dfs($i, $j, 0);
        return $this->best === PHP_INT_MAX ? -1 : $this->best;
    }

    private function dfs($r, $c, $steps) {
        if ($r < 0 || $c < 0 || $r >= $this->m || $c >= $this->n) return;
        $ch = $this->grid[$r][$c];
        if ($ch === 'X' || $ch === 'V') return;
        if ($ch === '#') {
            $this->best = min($this->best, $steps);
            return;
        }
        $this->grid[$r][$c] = 'V';
        $this->dfs($r + 1, $c, $steps + 1);
        $this->dfs($r - 1, $c, $steps + 1);
        $this->dfs($r, $c + 1, $steps + 1);
        $this->dfs($r, $c - 1, $steps + 1);
        $this->grid[$r][$c] = $ch;
    }
}
*/

/*
Basic Approach

class Solution {
    function getFood($grid) {
        $m = count($grid);
        $n = count($grid[0]);
        $queue = new SplQueue();
        $visited = array_fill(0, $m, array_fill(0, $n, false));
        for ($i = 0; $i < $m; $i++) {
            for ($j = 0; $j < $n; $j++) {
                if ($grid[$i][$j] === '*') {
                    $queue->enqueue([$i, $j]);
                    $visited[$i][$j] = true;
                }
            }
        }
        $dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]];
        $steps = 0;
        while (!$queue->isEmpty()) {
            $size = $queue->count();
            for ($k = 0; $k < $size; $k++) {
                [$r0, $c0] = $queue->dequeue();
                if ($grid[$r0][$c0] === '#') return $steps;
                foreach ($dirs as [$dr, $dc]) {
                    $r = $r0 + $dr;
                    $c = $c0 + $dc;
                    if ($r >= 0 && $c >= 0 && $r < $m && $c < $n && !$visited[$r][$c] && $grid[$r][$c] !== 'X') {
                        $visited[$r][$c] = true;
                        $queue->enqueue([$r, $c]);
                    }
                }
            }
            $steps++;
        }
        return -1;
    }
}
*/

class Solution {
    function getFood($grid) {
        $m = count($grid);
        $n = count($grid[0]);

        $start = -1;
        for ($i = 0; $i < $m; $i++) {
            $j = array_search('*', $grid[$i], true);
            if ($j !== false) { $start = $i * $n + $j; break; }
        }
        if ($start < 0) return -1;

        $q = array_fill(0, $m * $n, 0);
        $head = 0;
        $tail = 0;
        $q[$tail++] = $start;
        $dr = [1, -1, 0, 0];
        $dc = [0, 0, 1, -1];
        $steps = 0;

        while ($head < $tail) {
            $steps++;
            $levelEnd = $tail;
            while ($head < $levelEnd) {
                $id = $q[$head++];
                $r = intdiv($id, $n);
                $c = $id % $n;
                for ($k = 0; $k < 4; $k++) {
                    $nr = $r + $dr[$k];
                    $nc = $c + $dc[$k];
                    if ($nr < 0 || $nc < 0 || $nr >= $m || $nc >= $n) continue;
                    $ch = $grid[$nr][$nc];
                    if ($ch === '#') return $steps;
                    if ($ch === 'O') {
                        $grid[$nr][$nc] = 'X';
                        $q[$tail++] = $nr * $n + $nc;
                    }
                }
            }
        }
        return -1;
    }
}