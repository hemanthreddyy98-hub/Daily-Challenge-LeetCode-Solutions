/*
Brute Force

class Solution {
    $parent;

    function sortPermutation($nums) {
        $n = count($nums);
        $sorted = true;
        for ($i = 0; $i < $n; $i++)
            if ($nums[$i] !== $i) $sorted = false;
        if ($sorted) return 0;
        for ($k = $n - 1; $k >= 0; $k--) {
            $this->parent = range(0, $n - 1);
            for ($i = 0; $i < $n; $i++)
                for ($j = $i + 1; $j < $n; $j++)
                    if (($nums[$i] & $nums[$j]) === $k) {
                        $a = $this->find($nums[$i]);
                        $b = $this->find($nums[$j]);
                        $this->parent[$a] = $b;
                    }
            $ok = true;
            for ($i = 0; $i < $n && $ok; $i++)
                if ($this->find($nums[$i]) !== $this->find($i)) $ok = false;
            if ($ok) return $k;
        }
        return 0;
    }

    function find($x) {
        while ($this->parent[$x] !== $x) {
            $this->parent[$x] = $this->parent[$this->parent[$x]];
            $x = $this->parent[$x];
        }
        return $x;
    }
}
*/

/*
Better Approach

class Solution {
    function sortPermutation($nums) {
        $n = count($nums);
        $sorted = true;
        for ($i = 0; $i < $n; $i++)
            if ($nums[$i] !== $i) $sorted = false;
        if ($sorted) return 0;
        for ($k = $n - 1; $k >= 0; $k--) {
            $ok = true;
            for ($i = 0; $i < $n && $ok; $i++)
                if ($nums[$i] !== $i && ($nums[$i] & $k) !== $k) $ok = false;
            if ($ok) return $k;
        }
        return 0;
    }
}
*/

class Solution {
    function sortPermutation($nums) {
        $ans = -1;
        foreach ($nums as $i => $v)
            if ($v !== $i) $ans &= $v;
        return max($ans, 0);
    }
}