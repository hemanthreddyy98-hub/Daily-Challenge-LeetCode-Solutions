/*
Brute Force

class Solution {
    function shortestPath($n, $edges, $labels, $k) {
        $inf = PHP_INT_MAX;
        $dist = array_fill(0, $n, array_fill(0, $k + 1, $inf));
        $dist[0][1] = 0;
        $changed = true;
        while ($changed) {
            $changed = false;
            foreach ($edges as [$u, $v, $w]) {
                for ($run = 1; $run <= $k; $run++) {
                    if ($dist[$u][$run] == $inf) continue;
                    $next = $labels[$v] == $labels[$u] ? $run + 1 : 1;
                    if ($next <= $k && $dist[$u][$run] + $w < $dist[$v][$next]) {
                        $dist[$v][$next] = $dist[$u][$run] + $w;
                        $changed = true;
                    }
                }
            }
        }
        $ans = min(array_slice($dist[$n - 1], 1));
        return $ans == $inf ? -1 : $ans;
    }
}
*/

/*
Better Approach

class Solution {
    function shortestPath($n, $edges, $labels, $k) {
        $g = array_fill(0, $n, []);
        foreach ($edges as [$u, $v, $w]) $g[$u][] = [$v, $w];
        $pq = new SplMinHeap();
        $dist = array_fill(0, $n, array_fill(0, $k + 1, PHP_INT_MAX));
        $dist[0][1] = 0;
        $pq->insert([0, 0, 1]);
        while (!$pq->isEmpty()) {
            [$d, $u, $run] = $pq->extract();
            if ($u == $n - 1) return $d;
            if ($d > $dist[$u][$run]) continue;
            foreach ($g[$u] as [$v, $w]) {
                $next = $labels[$v] == $labels[$u] ? $run + 1 : 1;
                if ($next <= $k && $d + $w < $dist[$v][$next]) {
                    $dist[$v][$next] = $d + $w;
                    $pq->insert([$d + $w, $v, $next]);
                }
            }
        }
        return -1;
    }
}
*/

class Solution {
    function shortestPath($n, $edges, $labels, $k) {
        $g = array_fill(0, $n, []);
        foreach ($edges as [$u, $v, $w]) $g[$u][] = [$v, $w];
        $pq = new SplMinHeap();
        $best = array_fill(0, $n, $k + 1);
        $pq->insert([0, 0, 1]);
        while (!$pq->isEmpty()) {
            [$d, $u, $run] = $pq->extract();
            if ($run >= $best[$u]) continue;
            if ($u == $n - 1) return $d;
            $best[$u] = $run;
            foreach ($g[$u] as [$v, $w]) {
                $next = $labels[$v] == $labels[$u] ? $run + 1 : 1;
                if ($next <= $k && $next < $best[$v]) $pq->insert([$d + $w, $v, $next]);
            }
        }
        return -1;
    }
}