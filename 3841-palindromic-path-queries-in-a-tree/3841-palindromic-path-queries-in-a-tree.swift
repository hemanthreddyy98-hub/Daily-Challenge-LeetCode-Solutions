/*
Brute Force

class Solution {
    func palindromePath(_ n: Int, _ edges: [[Int]], _ s: String, _ queries: [String]) -> [Bool] {
        var g = [[Int]](repeating: [], count: n)
        for e in edges {
            g[e[0]].append(e[1])
            g[e[1]].append(e[0])
        }
        var ch = s.utf8.map { Int($0) - 97 }
        var ans = [Bool]()
        for q in queries {
            let p = q.split(separator: " ")
            let u = Int(p[1])!
            if p[0] == "update" {
                ch[u] = Int(p[2].utf8.first!) - 97
                continue
            }
            let v = Int(p[2])!
            var par = [Int](repeating: -1, count: n)
            par[u] = u
            var bfs = [u]
            var head = 0
            while head < bfs.count {
                let x = bfs[head]
                head += 1
                for y in g[x] where par[y] == -1 {
                    par[y] = x
                    bfs.append(y)
                }
            }
            var mask = 1 << ch[u]
            var cur = v
            while cur != u {
                mask ^= 1 << ch[cur]
                cur = par[cur]
            }
            ans.append(mask & (mask - 1) == 0)
        }
        return ans
    }
}
*/

/*
Better Approach

class Solution {
    func palindromePath(_ n: Int, _ edges: [[Int]], _ s: String, _ queries: [String]) -> [Bool] {
        var g = [[Int]](repeating: [], count: n)
        for e in edges {
            g[e[0]].append(e[1])
            g[e[1]].append(e[0])
        }
        var ch = s.utf8.map { Int($0) - 97 }
        var par = [Int](repeating: -1, count: n)
        var depth = [Int](repeating: 0, count: n)
        par[0] = 0
        var bfs = [0]
        var head = 0
        while head < bfs.count {
            let x = bfs[head]
            head += 1
            for y in g[x] where par[y] == -1 {
                par[y] = x
                depth[y] = depth[x] + 1
                bfs.append(y)
            }
        }
        var ans = [Bool]()
        for q in queries {
            let p = q.split(separator: " ")
            var u = Int(p[1])!
            if p[0] == "update" {
                ch[u] = Int(p[2].utf8.first!) - 97
                continue
            }
            var v = Int(p[2])!
            var mask = 0
            while u != v {
                if depth[u] < depth[v] { swap(&u, &v) }
                mask ^= 1 << ch[u]
                u = par[u]
            }
            mask ^= 1 << ch[u]
            ans.append(mask & (mask - 1) == 0)
        }
        return ans
    }
}
*/

class Solution {
    func palindromePath(_ n: Int, _ edges: [[Int]], _ s: String, _ queries: [String]) -> [Bool] {
        var g = [[Int]](repeating: [], count: n)
        for e in edges {
            g[e[0]].append(e[1])
            g[e[1]].append(e[0])
        }
        var ch = s.utf8.map { Int($0) - 97 }
        let lg = 17
        var up = [[Int]](repeating: [Int](repeating: 0, count: n), count: lg)
        var depth = [Int](repeating: 0, count: n)
        var tin = [Int](repeating: 0, count: n)
        var sz = [Int](repeating: 1, count: n)
        var seen = [Bool](repeating: false, count: n)
        var order = [Int]()
        var st = [0]
        seen[0] = true
        while let x = st.popLast() {
            tin[x] = order.count
            order.append(x)
            for y in g[x] where !seen[y] {
                seen[y] = true
                up[0][y] = x
                depth[y] = depth[x] + 1
                st.append(y)
            }
        }
        for i in stride(from: n - 1, to: 0, by: -1) {
            sz[up[0][order[i]]] += sz[order[i]]
        }
        for k in 1..<lg {
            for x in 0..<n {
                up[k][x] = up[k - 1][up[k - 1][x]]
            }
        }
        var bit = [Int](repeating: 0, count: n + 1)
        func add(_ start: Int, _ d: Int) {
            var i = start
            while i <= n {
                bit[i] ^= d
                i += i & -i
            }
        }
        func rangeXor(_ x: Int, _ d: Int) {
            add(tin[x] + 1, d)
            add(tin[x] + sz[x] + 1, d)
        }
        func prefix(_ x: Int) -> Int {
            var r = 0
            var i = tin[x] + 1
            while i > 0 {
                r ^= bit[i]
                i -= i & -i
            }
            return r
        }
        func lca(_ a0: Int, _ b0: Int) -> Int {
            var a = depth[a0] >= depth[b0] ? a0 : b0
            var b = depth[a0] >= depth[b0] ? b0 : a0
            for k in stride(from: lg - 1, through: 0, by: -1) {
                if depth[a] - (1 << k) >= depth[b] { a = up[k][a] }
            }
            if a == b { return a }
            for k in stride(from: lg - 1, through: 0, by: -1) {
                if up[k][a] != up[k][b] {
                    a = up[k][a]
                    b = up[k][b]
                }
            }
            return up[0][a]
        }
        for x in 0..<n {
            rangeXor(x, 1 << ch[x])
        }
        var ans = [Bool]()
        for q in queries {
            let p = q.split(separator: " ")
            let u = Int(p[1])!
            if p[0] == "update" {
                let c = Int(p[2].utf8.first!) - 97
                rangeXor(u, (1 << ch[u]) ^ (1 << c))
                ch[u] = c
            } else {
                let v = Int(p[2])!
                let mask = prefix(u) ^ prefix(v) ^ (1 << ch[lca(u, v)])
                ans.append(mask & (mask - 1) == 0)
            }
        }
        return ans
    }
}