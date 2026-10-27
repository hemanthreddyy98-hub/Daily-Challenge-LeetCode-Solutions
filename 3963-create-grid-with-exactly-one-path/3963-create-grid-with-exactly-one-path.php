/*
Brute Force

class Solution {
    function createGrid($m, $n) {
        $g = array_fill(0, $m, str_repeat('.', $n));
        for ($i = 0; $i < $m; $i++)
            for ($j = 0; $j < $n; $j++) {
                if (($i == 0 && $j == 0) || ($i == $m - 1 && $j == $n - 1)) continue;
                $g[$i][$j] = '#';
                if (!$this->reach($g, $m, $n, 0, 0)) $g[$i][$j] = '.';
            }
        return $g;
    }

    function reach($g, $m, $n, $r, $c) {
        if ($r >= $m || $c >= $n || $g[$r][$c] == '#') return false;
        if ($r == $m - 1 && $c == $n - 1) return true;
        return $this->reach($g, $m, $n, $r + 1, $c) || $this->reach($g, $m, $n, $r, $c + 1);
    }
}
*/

/*
Better Approach

class Solution {
    function createGrid($m, $n) {
        $g = array_fill(0, $m, str_repeat('.', $n));
        for ($i = 0; $i < $m; $i++)
            for ($j = 0; $j < $n; $j++) {
                if (($i == 0 && $j == 0) || ($i == $m - 1 && $j == $n - 1)) continue;
                $g[$i][$j] = '#';
                if (!$this->reach($g, $m, $n)) $g[$i][$j] = '.';
            }
        return $g;
    }

    function reach($g, $m, $n) {
        $ok = array_fill(0, $m, array_fill(0, $n, false));
        for ($i = 0; $i < $m; $i++)
            for ($j = 0; $j < $n; $j++) {
                if ($g[$i][$j] == '#') continue;
                $ok[$i][$j] = ($i == 0 && $j == 0) || ($i > 0 && $ok[$i - 1][$j]) || ($j > 0 && $ok[$i][$j - 1]);
            }
        return $ok[$m - 1][$n - 1];
    }
}
*/

class Solution {
    function createGrid($m, $n) {
        $rest = str_repeat('#', $n - 1) . '.';
        $grid = array_fill(0, $m, $rest);
        $grid[0] = str_repeat('.', $n);
        return $grid;
    }
}