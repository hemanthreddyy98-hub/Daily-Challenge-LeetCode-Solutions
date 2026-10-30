/*
Brute Force

class Solution {
    func shortestPath(_ n: Int, _ edges: [[Int]], _ labels: String, _ k: Int) -> Int {
        let lab = Array(labels.utf8)
        let inf = Int.max
        var dist = [[Int]](repeating: [Int](repeating: inf, count: k + 1), count: n)
        dist[0][1] = 0
        var changed = true
        while changed {
            changed = false
            for e in edges {
                let u = e[0], v = e[1], w = e[2]
                for run in 1...k where dist[u][run] != inf {
                    let next = lab[v] == lab[u] ? run + 1 : 1
                    if next <= k && dist[u][run] + w < dist[v][next] {
                        dist[v][next] = dist[u][run] + w
                        changed = true
                    }
                }
            }
        }
        let ans = dist[n - 1][1...k].min()!
        return ans == inf ? -1 : ans
    }
}
*/

/*
Better Approach

class Solution {
    func shortestPath(_ n: Int, _ edges: [[Int]], _ labels: String, _ k: Int) -> Int {
        let lab = Array(labels.utf8)
        var g = [[(Int, Int)]](repeating: [], count: n)
        for e in edges {
            g[e[0]].append((e[1], e[2]))
        }
        var dist = [[Int]](repeating: [Int](repeating: Int.max, count: k + 1), count: n)
        var heap: [(Int, Int, Int)] = []
        func push(_ item: (Int, Int, Int)) {
            heap.append(item)
            var i = heap.count - 1
            while i > 0 {
                let p = (i - 1) / 2
                if heap[p].0 <= item.0 { break }
                heap[i] = heap[p]
                i = p
            }
            heap[i] = item
        }
        func pop() -> (Int, Int, Int) {
            let top = heap[0]
            let last = heap.removeLast()
            if !heap.isEmpty {
                var i = 0
                while 2 * i + 1 < heap.count {
                    var c = 2 * i + 1
                    if c + 1 < heap.count && heap[c + 1].0 < heap[c].0 { c += 1 }
                    if heap[c].0 >= last.0 { break }
                    heap[i] = heap[c]
                    i = c
                }
                heap[i] = last
            }
            return top
        }
        dist[0][1] = 0
        push((0, 0, 1))
        while !heap.isEmpty {
            let (d, u, run) = pop()
            if u == n - 1 { return d }
            if d > dist[u][run] { continue }
            for (v, w) in g[u] {
                let next = lab[v] == lab[u] ? run + 1 : 1
                if next <= k && d + w < dist[v][next] {
                    dist[v][next] = d + w
                    push((d + w, v, next))
                }
            }
        }
        return -1
    }
}
*/

class Solution {
    func shortestPath(_ n: Int, _ edges: [[Int]], _ labels: String, _ k: Int) -> Int {
        let lab = Array(labels.utf8)
        var g = [[(Int, Int)]](repeating: [], count: n)
        for e in edges {
            g[e[0]].append((e[1], e[2]))
        }
        var best = [Int](repeating: k + 1, count: n)
        var heap: [(Int, Int, Int)] = []
        func push(_ item: (Int, Int, Int)) {
            heap.append(item)
            var i = heap.count - 1
            while i > 0 {
                let p = (i - 1) / 2
                if heap[p].0 <= item.0 { break }
                heap[i] = heap[p]
                i = p
            }
            heap[i] = item
        }
        func pop() -> (Int, Int, Int) {
            let top = heap[0]
            let last = heap.removeLast()
            if !heap.isEmpty {
                var i = 0
                while 2 * i + 1 < heap.count {
                    var c = 2 * i + 1
                    if c + 1 < heap.count && heap[c + 1].0 < heap[c].0 { c += 1 }
                    if heap[c].0 >= last.0 { break }
                    heap[i] = heap[c]
                    i = c
                }
                heap[i] = last
            }
            return top
        }
        push((0, 0, 1))
        while !heap.isEmpty {
            let (d, u, run) = pop()
            if run >= best[u] { continue }
            if u == n - 1 { return d }
            best[u] = run
            for (v, w) in g[u] {
                let next = lab[v] == lab[u] ? run + 1 : 1
                if next <= k && next < best[v] { push((d + w, v, next)) }
            }
        }
        return -1
    }
}