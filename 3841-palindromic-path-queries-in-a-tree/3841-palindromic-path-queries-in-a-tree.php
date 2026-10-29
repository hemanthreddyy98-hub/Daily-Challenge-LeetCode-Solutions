/*
Brute Force

class Solution {
    function palindromePath($n, $edges, $s, $queries) {
        $g = array_fill(0, $n, []);
        foreach ($edges as [$a, $b]) {
            $g[$a][] = $b;
            $g[$b][] = $a;
        }
        $ch = [];
        for ($i = 0; $i < $n; $i++) $ch[] = ord($s[$i]) - 97;
        $ans = [];
        foreach ($queries as $q) {
            $p = explode(" ", $q);
            $u = intval($p[1]);
            if ($p[0] == "update") {
                $ch[$u] = ord($p[2]) - 97;
                continue;
            }
            $v = intval($p[2]);
            $par = array_fill(0, $n, -1);
            $par[$u] = $u;
            $bfs = [$u];
            for ($i = 0; $i < count($bfs); $i++)
                foreach ($g[$bfs[$i]] as $y)
                    if ($par[$y] == -1) {
                        $par[$y] = $bfs[$i];
                        $bfs[] = $y;
                    }
            $mask = 1 << $ch[$u];
            for ($cur = $v; $cur != $u; $cur = $par[$cur]) $mask ^= 1 << $ch[$cur];
            $ans[] = ($mask & ($mask - 1)) == 0;
        }
        return $ans;
    }
}
*/

/*
Better Approach

class Solution {
    function palindromePath($n, $edges, $s, $queries) {
        $g = array_fill(0, $n, []);
        foreach ($edges as [$a, $b]) {
            $g[$a][] = $b;
            $g[$b][] = $a;
        }
        $ch = [];
        for ($i = 0; $i < $n; $i++) $ch[] = ord($s[$i]) - 97;
        $par = array_fill(0, $n, -1);
        $depth = array_fill(0, $n, 0);
        $par[0] = 0;
        $bfs = [0];
        for ($i = 0; $i < count($bfs); $i++) {
            $x = $bfs[$i];
            foreach ($g[$x] as $y)
                if ($par[$y] == -1) {
                    $par[$y] = $x;
                    $depth[$y] = $depth[$x] + 1;
                    $bfs[] = $y;
                }
        }
        $ans = [];
        foreach ($queries as $q) {
            $p = explode(" ", $q);
            $u = intval($p[1]);
            if ($p[0] == "update") {
                $ch[$u] = ord($p[2]) - 97;
                continue;
            }
            $v = intval($p[2]);
            $mask = 0;
            while ($u != $v) {
                if ($depth[$u] < $depth[$v]) [$u, $v] = [$v, $u];
                $mask ^= 1 << $ch[$u];
                $u = $par[$u];
            }
            $mask ^= 1 << $ch[$u];
            $ans[] = ($mask & ($mask - 1)) == 0;
        }
        return $ans;
    }
}
*/

class Solution {
    function palindromePath($n, $edges, $s, $queries) {
        $g = array_fill(0, $n, []);
        foreach ($edges as [$a, $b]) {
            $g[$a][] = $b;
            $g[$b][] = $a;
        }
        $ch = [];
        for ($i = 0; $i < $n; $i++) $ch[] = ord($s[$i]) - 97;
        $log = 17;
        $up = array_fill(0, $log, array_fill(0, $n, 0));
        $depth = array_fill(0, $n, 0);
        $tin = array_fill(0, $n, 0);
        $sz = array_fill(0, $n, 1);
        $seen = array_fill(0, $n, false);
        $order = [];
        $st = [0];
        $seen[0] = true;
        while ($st) {
            $x = array_pop($st);
            $tin[$x] = count($order);
            $order[] = $x;
            foreach ($g[$x] as $y)
                if (!$seen[$y]) {
                    $seen[$y] = true;
                    $up[0][$y] = $x;
                    $depth[$y] = $depth[$x] + 1;
                    $st[] = $y;
                }
        }
        for ($i = $n - 1; $i > 0; $i--) $sz[$up[0][$order[$i]]] += $sz[$order[$i]];
        for ($k = 1; $k < $log; $k++)
            for ($x = 0; $x < $n; $x++) $up[$k][$x] = $up[$k - 1][$up[$k - 1][$x]];
        $bit = array_fill(0, $n + 1, 0);
        $add = function ($i, $d) use (&$bit, $n) {
            for (; $i <= $n; $i += $i & -$i) $bit[$i] ^= $d;
        };
        $rangeXor = function ($x, $d) use ($add, $tin, $sz) {
            $add($tin[$x] + 1, $d);
            $add($tin[$x] + $sz[$x] + 1, $d);
        };
        $prefix = function ($x) use (&$bit, $tin) {
            $r = 0;
            for ($i = $tin[$x] + 1; $i > 0; $i -= $i & -$i) $r ^= $bit[$i];
            return $r;
        };
        $lca = function ($a, $b) use ($up, $depth, $log) {
            if ($depth[$a] < $depth[$b]) [$a, $b] = [$b, $a];
            for ($k = $log - 1; $k >= 0; $k--)
                if ($depth[$a] - (1 << $k) >= $depth[$b]) $a = $up[$k][$a];
            if ($a == $b) return $a;
            for ($k = $log - 1; $k >= 0; $k--)
                if ($up[$k][$a] != $up[$k][$b]) {
                    $a = $up[$k][$a];
                    $b = $up[$k][$b];
                }
            return $up[0][$a];
        };
        for ($x = 0; $x < $n; $x++) $rangeXor($x, 1 << $ch[$x]);
        $ans = [];
        foreach ($queries as $q) {
            $p = explode(" ", $q);
            $u = intval($p[1]);
            if ($p[0] == "update") {
                $c = ord($p[2]) - 97;
                $rangeXor($u, (1 << $ch[$u]) ^ (1 << $c));
                $ch[$u] = $c;
            } else {
                $v = intval($p[2]);
                $mask = $prefix($u) ^ $prefix($v) ^ (1 << $ch[$lca($u, $v)]);
                $ans[] = ($mask & ($mask - 1)) == 0;
            }
        }
        return $ans;
    }
}