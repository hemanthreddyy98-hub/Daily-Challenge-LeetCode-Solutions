/*
Brute Force

class Solution {
    function pathSum($nums) {
        $total = 0;
        foreach ($nums as $x) {
            $d = intdiv($x, 100);
            $p = intdiv($x, 10) % 10;
            $leaf = true;
            foreach ($nums as $y) {
                $cd = intdiv($y, 100);
                $cp = intdiv($y, 10) % 10;
                if ($cd == $d + 1 && ($cp == 2 * $p - 1 || $cp == 2 * $p)) $leaf = false;
            }
            if (!$leaf) continue;
            while ($d >= 1) {
                foreach ($nums as $y) {
                    if (intdiv($y, 100) == $d && intdiv($y, 10) % 10 == $p) {
                        $total += $y % 10;
                        break;
                    }
                }
                $d--;
                $p = intdiv($p + 1, 2);
            }
        }
        return $total;
    }
}
*/

/*
Better Approach

class Solution {
    function pathSum($nums) {
        $tree = [];
        foreach ($nums as $x) $tree[intdiv($x, 10)] = $x % 10;
        return $this->dfs($tree, 1, 1, 0);
    }

    function dfs($tree, $d, $p, $sum) {
        $key = $d * 10 + $p;
        if (!isset($tree[$key])) return 0;
        $sum += $tree[$key];
        $left = ($d + 1) * 10 + 2 * $p - 1;
        if (!isset($tree[$left]) && !isset($tree[$left + 1])) return $sum;
        return $this->dfs($tree, $d + 1, 2 * $p - 1, $sum) + $this->dfs($tree, $d + 1, 2 * $p, $sum);
    }
}
*/

class Solution {
    function pathSum($nums) {
        $leaves = array_fill(0, 16, 0);
        $ans = 0;
        for ($i = count($nums) - 1; $i >= 0; $i--) {
            $d = intdiv($nums[$i], 100);
            $p = intdiv($nums[$i], 10) % 10;
            $idx = (1 << ($d - 1)) + $p - 1;
            if ($leaves[$idx] == 0) $leaves[$idx] = 1;
            $ans += ($nums[$i] % 10) * $leaves[$idx];
            if ($idx > 1) $leaves[$idx >> 1] += $leaves[$idx];
        }
        return $ans;
    }
}