/*
Brute Force

impl Solution {
    pub fn shortest_path(n: i32, edges: Vec<Vec<i32>>, labels: String, k: i32) -> i32 {
        let (n, k) = (n as usize, k as usize);
        let lab = labels.as_bytes();
        let inf = i64::MAX;
        let mut dist = vec![vec![inf; k + 1]; n];
        dist[0][1] = 0;
        let mut changed = true;
        while changed {
            changed = false;
            for e in &edges {
                let (u, v, w) = (e[0] as usize, e[1] as usize, e[2] as i64);
                for run in 1..=k {
                    if dist[u][run] == inf {
                        continue;
                    }
                    let next = if lab[v] == lab[u] { run + 1 } else { 1 };
                    if next <= k && dist[u][run] + w < dist[v][next] {
                        dist[v][next] = dist[u][run] + w;
                        changed = true;
                    }
                }
            }
        }
        let ans = *dist[n - 1][1..].iter().min().unwrap();
        if ans == inf { -1 } else { ans as i32 }
    }
}
*/

/*
Better Approach

impl Solution {
    pub fn shortest_path(n: i32, edges: Vec<Vec<i32>>, labels: String, k: i32) -> i32 {
        let (n, k) = (n as usize, k as usize);
        let lab = labels.as_bytes();
        let mut g = vec![vec![]; n];
        for e in &edges {
            g[e[0] as usize].push((e[1] as usize, e[2] as i64));
        }
        let mut dist = vec![vec![i64::MAX; k + 1]; n];
        let mut pq = std::collections::BinaryHeap::new();
        dist[0][1] = 0;
        pq.push(std::cmp::Reverse((0i64, 0usize, 1usize)));
        while let Some(std::cmp::Reverse((d, u, run))) = pq.pop() {
            if u == n - 1 {
                return d as i32;
            }
            if d > dist[u][run] {
                continue;
            }
            for &(v, w) in &g[u] {
                let next = if lab[v] == lab[u] { run + 1 } else { 1 };
                if next <= k && d + w < dist[v][next] {
                    dist[v][next] = d + w;
                    pq.push(std::cmp::Reverse((d + w, v, next)));
                }
            }
        }
        -1
    }
}
*/

impl Solution {
    pub fn shortest_path(n: i32, edges: Vec<Vec<i32>>, labels: String, k: i32) -> i32 {
        let (n, k) = (n as usize, k as usize);
        let lab = labels.as_bytes();
        let mut g = vec![vec![]; n];
        for e in &edges {
            g[e[0] as usize].push((e[1] as usize, e[2] as i64));
        }
        let mut best = vec![k + 1; n];
        let mut pq = std::collections::BinaryHeap::new();
        pq.push(std::cmp::Reverse((0i64, 0usize, 1usize)));
        while let Some(std::cmp::Reverse((d, u, run))) = pq.pop() {
            if run >= best[u] {
                continue;
            }
            if u == n - 1 {
                return d as i32;
            }
            best[u] = run;
            for &(v, w) in &g[u] {
                let next = if lab[v] == lab[u] { run + 1 } else { 1 };
                if next <= k && next < best[v] {
                    pq.push(std::cmp::Reverse((d + w, v, next)));
                }
            }
        }
        -1
    }
}