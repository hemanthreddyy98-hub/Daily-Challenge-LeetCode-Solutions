/*
Brute Force

class Solution {
    fun shortestPath(n: Int, edges: Array<IntArray>, labels: String, k: Int): Int {
        val inf = Long.MAX_VALUE
        val dist = Array(n) { LongArray(k + 1) { inf } }
        dist[0][1] = 0
        var changed = true
        while (changed) {
            changed = false
            for (e in edges) {
                val u = e[0]
                val v = e[1]
                val w = e[2]
                for (run in 1..k) {
                    if (dist[u][run] == inf) continue
                    val next = if (labels[v] == labels[u]) run + 1 else 1
                    if (next <= k && dist[u][run] + w < dist[v][next]) {
                        dist[v][next] = dist[u][run] + w
                        changed = true
                    }
                }
            }
        }
        val ans = (1..k).minOf { dist[n - 1][it] }
        return if (ans == inf) -1 else ans.toInt()
    }
}
*/

/*
Better Approach

class Solution {
    fun shortestPath(n: Int, edges: Array<IntArray>, labels: String, k: Int): Int {
        val g = Array(n) { mutableListOf<IntArray>() }
        for (e in edges) g[e[0]].add(intArrayOf(e[1], e[2]))
        val dist = Array(n) { LongArray(k + 1) { Long.MAX_VALUE } }
        val pq = PriorityQueue<LongArray>(compareBy { it[0] })
        dist[0][1] = 0
        pq.add(longArrayOf(0, 0, 1))
        while (pq.isNotEmpty()) {
            val top = pq.poll()
            val d = top[0]
            val u = top[1].toInt()
            val run = top[2].toInt()
            if (u == n - 1) return d.toInt()
            if (d > dist[u][run]) continue
            for (e in g[u]) {
                val v = e[0]
                val next = if (labels[v] == labels[u]) run + 1 else 1
                if (next <= k && d + e[1] < dist[v][next]) {
                    dist[v][next] = d + e[1]
                    pq.add(longArrayOf(d + e[1], v.toLong(), next.toLong()))
                }
            }
        }
        return -1
    }
}
*/

class Solution {
    fun shortestPath(n: Int, edges: Array<IntArray>, labels: String, k: Int): Int {
        val g = Array(n) { mutableListOf<IntArray>() }
        for (e in edges) g[e[0]].add(intArrayOf(e[1], e[2]))
        val best = IntArray(n) { k + 1 }
        val pq = PriorityQueue<LongArray>(compareBy { it[0] })
        pq.add(longArrayOf(0, 0, 1))
        while (pq.isNotEmpty()) {
            val top = pq.poll()
            val d = top[0]
            val u = top[1].toInt()
            val run = top[2].toInt()
            if (run >= best[u]) continue
            if (u == n - 1) return d.toInt()
            best[u] = run
            for (e in g[u]) {
                val v = e[0]
                val next = if (labels[v] == labels[u]) run + 1 else 1
                if (next <= k && next < best[v]) pq.add(longArrayOf(d + e[1], v.toLong(), next.toLong()))
            }
        }
        return -1
    }
}