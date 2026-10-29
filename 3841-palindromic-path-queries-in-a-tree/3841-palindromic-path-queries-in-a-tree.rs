/*
Brute Force

impl Solution {
    pub fn palindrome_path(n: i32, edges: Vec<Vec<i32>>, s: String, queries: Vec<String>) -> Vec<bool> {
        let n = n as usize;
        let mut g = vec![vec![]; n];
        for e in &edges {
            let (a, b) = (e[0] as usize, e[1] as usize);
            g[a].push(b);
            g[b].push(a);
        }
        let mut ch: Vec<i32> = s.bytes().map(|c| (c - b'a') as i32).collect();
        let mut ans = vec![];
        for q in &queries {
            let p: Vec<&str> = q.split(' ').collect();
            let u: usize = p[1].parse().unwrap();
            if p[0] == "update" {
                ch[u] = (p[2].as_bytes()[0] - b'a') as i32;
                continue;
            }
            let v: usize = p[2].parse().unwrap();
            let mut par = vec![usize::MAX; n];
            par[u] = u;
            let mut bfs = std::collections::VecDeque::new();
            bfs.push_back(u);
            while let Some(x) = bfs.pop_front() {
                for &y in &g[x] {
                    if par[y] == usize::MAX {
                        par[y] = x;
                        bfs.push_back(y);
                    }
                }
            }
            let mut mask = 1 << ch[u];
            let mut cur = v;
            while cur != u {
                mask ^= 1 << ch[cur];
                cur = par[cur];
            }
            ans.push((mask & (mask - 1)) == 0);
        }
        ans
    }
}
*/

/*
Better Approach

impl Solution {
    pub fn palindrome_path(n: i32, edges: Vec<Vec<i32>>, s: String, queries: Vec<String>) -> Vec<bool> {
        let n = n as usize;
        let mut g = vec![vec![]; n];
        for e in &edges {
            let (a, b) = (e[0] as usize, e[1] as usize);
            g[a].push(b);
            g[b].push(a);
        }
        let mut ch: Vec<i32> = s.bytes().map(|c| (c - b'a') as i32).collect();
        let mut par = vec![usize::MAX; n];
        let mut depth = vec![0usize; n];
        par[0] = 0;
        let mut bfs = std::collections::VecDeque::new();
        bfs.push_back(0);
        while let Some(x) = bfs.pop_front() {
            for &y in &g[x] {
                if par[y] == usize::MAX {
                    par[y] = x;
                    depth[y] = depth[x] + 1;
                    bfs.push_back(y);
                }
            }
        }
        let mut ans = vec![];
        for q in &queries {
            let p: Vec<&str> = q.split(' ').collect();
            let mut u: usize = p[1].parse().unwrap();
            if p[0] == "update" {
                ch[u] = (p[2].as_bytes()[0] - b'a') as i32;
                continue;
            }
            let mut v: usize = p[2].parse().unwrap();
            let mut mask = 0;
            while u != v {
                if depth[u] < depth[v] {
                    std::mem::swap(&mut u, &mut v);
                }
                mask ^= 1 << ch[u];
                u = par[u];
            }
            mask ^= 1 << ch[u];
            ans.push((mask & (mask - 1)) == 0);
        }
        ans
    }
}
*/

impl Solution {
    pub fn palindrome_path(n: i32, edges: Vec<Vec<i32>>, s: String, queries: Vec<String>) -> Vec<bool> {
        fn add(bit: &mut Vec<i32>, mut i: usize, d: i32) {
            while i < bit.len() {
                bit[i] ^= d;
                i += i & i.wrapping_neg();
            }
        }

        fn prefix(bit: &Vec<i32>, mut i: usize) -> i32 {
            let mut r = 0;
            while i > 0 {
                r ^= bit[i];
                i -= i & i.wrapping_neg();
            }
            r
        }

        let n = n as usize;
        let mut g = vec![vec![]; n];
        for e in &edges {
            let (a, b) = (e[0] as usize, e[1] as usize);
            g[a].push(b);
            g[b].push(a);
        }
        let mut ch: Vec<i32> = s.bytes().map(|c| (c - b'a') as i32).collect();
        const LOG: usize = 17;
        let mut up = vec![vec![0usize; n]; LOG];
        let mut depth = vec![0usize; n];
        let mut tin = vec![0usize; n];
        let mut sz = vec![1usize; n];
        let mut seen = vec![false; n];
        let mut order = Vec::with_capacity(n);
        let mut st = vec![0usize];
        seen[0] = true;
        while let Some(x) = st.pop() {
            tin[x] = order.len();
            order.push(x);
            for &y in &g[x] {
                if !seen[y] {
                    seen[y] = true;
                    up[0][y] = x;
                    depth[y] = depth[x] + 1;
                    st.push(y);
                }
            }
        }
        for i in (1..n).rev() {
            let x = order[i];
            sz[up[0][x]] += sz[x];
        }
        for k in 1..LOG {
            for x in 0..n {
                up[k][x] = up[k - 1][up[k - 1][x]];
            }
        }
        let lca = |mut a: usize, mut b: usize| -> usize {
            if depth[a] < depth[b] {
                std::mem::swap(&mut a, &mut b);
            }
            for k in (0..LOG).rev() {
                if depth[a] >= depth[b] + (1 << k) {
                    a = up[k][a];
                }
            }
            if a == b {
                return a;
            }
            for k in (0..LOG).rev() {
                if up[k][a] != up[k][b] {
                    a = up[k][a];
                    b = up[k][b];
                }
            }
            up[0][a]
        };
        let mut bit = vec![0i32; n + 1];
        for x in 0..n {
            add(&mut bit, tin[x] + 1, 1 << ch[x]);
            add(&mut bit, tin[x] + sz[x] + 1, 1 << ch[x]);
        }
        let mut ans = vec![];
        for q in &queries {
            let p: Vec<&str> = q.split(' ').collect();
            let u: usize = p[1].parse().unwrap();
            if p[0] == "update" {
                let c = (p[2].as_bytes()[0] - b'a') as i32;
                let d = (1 << ch[u]) ^ (1 << c);
                add(&mut bit, tin[u] + 1, d);
                add(&mut bit, tin[u] + sz[u] + 1, d);
                ch[u] = c;
            } else {
                let v: usize = p[2].parse().unwrap();
                let mask = prefix(&bit, tin[u] + 1) ^ prefix(&bit, tin[v] + 1) ^ (1 << ch[lca(u, v)]);
                ans.push((mask & (mask - 1)) == 0);
            }
        }
        ans
    }
}