/*
Brute Force

class Solution {
    fun palindromePath(n: Int, edges: Array<IntArray>, s: String, queries: Array<String>): List<Boolean> {
        val g = Array(n) { mutableListOf<Int>() }
        for (e in edges) {
            g[e[0]].add(e[1])
            g[e[1]].add(e[0])
        }
        val ch = IntArray(n) { s[it] - 'a' }
        val ans = mutableListOf<Boolean>()
        for (q in queries) {
            val p = q.split(" ")
            val u = p[1].toInt()
            if (p[0] == "update") {
                ch[u] = p[2][0] - 'a'
                continue
            }
            val v = p[2].toInt()
            val par = IntArray(n) { -1 }
            par[u] = u
            val bfs = ArrayDeque<Int>()
            bfs.addLast(u)
            while (bfs.isNotEmpty()) {
                val x = bfs.removeFirst()
                for (y in g[x])
                    if (par[y] == -1) {
                        par[y] = x
                        bfs.addLast(y)
                    }
            }
            var mask = 1 shl ch[u]
            var cur = v
            while (cur != u) {
                mask = mask xor (1 shl ch[cur])
                cur = par[cur]
            }
            ans.add((mask and (mask - 1)) == 0)
        }
        return ans
    }
}
*/

/*
Better Approach

class Solution {
    fun palindromePath(n: Int, edges: Array<IntArray>, s: String, queries: Array<String>): List<Boolean> {
        val g = Array(n) { mutableListOf<Int>() }
        for (e in edges) {
            g[e[0]].add(e[1])
            g[e[1]].add(e[0])
        }
        val ch = IntArray(n) { s[it] - 'a' }
        val par = IntArray(n) { -1 }
        val depth = IntArray(n)
        par[0] = 0
        val bfs = ArrayDeque<Int>()
        bfs.addLast(0)
        while (bfs.isNotEmpty()) {
            val x = bfs.removeFirst()
            for (y in g[x])
                if (par[y] == -1) {
                    par[y] = x
                    depth[y] = depth[x] + 1
                    bfs.addLast(y)
                }
        }
        val ans = mutableListOf<Boolean>()
        for (q in queries) {
            val p = q.split(" ")
            var u = p[1].toInt()
            if (p[0] == "update") {
                ch[u] = p[2][0] - 'a'
                continue
            }
            var v = p[2].toInt()
            var mask = 0
            while (u != v) {
                if (depth[u] < depth[v]) {
                    val t = u
                    u = v
                    v = t
                }
                mask = mask xor (1 shl ch[u])
                u = par[u]
            }
            mask = mask xor (1 shl ch[u])
            ans.add((mask and (mask - 1)) == 0)
        }
        return ans
    }
}
*/

class Solution {
    fun palindromePath(n: Int, edges: Array<IntArray>, s: String, queries: Array<String>): List<Boolean> {
        val g = Array(n) { mutableListOf<Int>() }
        for (e in edges) {
            g[e[0]].add(e[1])
            g[e[1]].add(e[0])
        }
        val ch = IntArray(n) { s[it] - 'a' }
        val log = 17
        val up = Array(log) { IntArray(n) }
        val depth = IntArray(n)
        val tin = IntArray(n)
        val sz = IntArray(n) { 1 }
        val order = IntArray(n)
        val seen = BooleanArray(n)
        val st = ArrayDeque<Int>()
        var timer = 0
        st.addLast(0)
        seen[0] = true
        while (st.isNotEmpty()) {
            val x = st.removeLast()
            tin[x] = timer
            order[timer++] = x
            for (y in g[x])
                if (!seen[y]) {
                    seen[y] = true
                    up[0][y] = x
                    depth[y] = depth[x] + 1
                    st.addLast(y)
                }
        }
        for (i in n - 1 downTo 1) sz[up[0][order[i]]] += sz[order[i]]
        for (k in 1 until log)
            for (x in 0 until n) up[k][x] = up[k - 1][up[k - 1][x]]
        val bit = IntArray(n + 1)
        fun add(start: Int, d: Int) {
            var i = start
            while (i <= n) {
                bit[i] = bit[i] xor d
                i += i and -i
            }
        }
        fun rangeXor(x: Int, d: Int) {
            add(tin[x] + 1, d)
            add(tin[x] + sz[x] + 1, d)
        }
        fun prefix(x: Int): Int {
            var r = 0
            var i = tin[x] + 1
            while (i > 0) {
                r = r xor bit[i]
                i -= i and -i
            }
            return r
        }
        fun lca(a0: Int, b0: Int): Int {
            var a = if (depth[a0] >= depth[b0]) a0 else b0
            var b = if (depth[a0] >= depth[b0]) b0 else a0
            for (k in log - 1 downTo 0)
                if (depth[a] - (1 shl k) >= depth[b]) a = up[k][a]
            if (a == b) return a
            for (k in log - 1 downTo 0)
                if (up[k][a] != up[k][b]) {
                    a = up[k][a]
                    b = up[k][b]
                }
            return up[0][a]
        }
        for (x in 0 until n) rangeXor(x, 1 shl ch[x])
        val ans = mutableListOf<Boolean>()
        for (q in queries) {
            val p = q.split(" ")
            val u = p[1].toInt()
            if (p[0] == "update") {
                val c = p[2][0] - 'a'
                rangeXor(u, (1 shl ch[u]) xor (1 shl c))
                ch[u] = c
            } else {
                val v = p[2].toInt()
                val mask = prefix(u) xor prefix(v) xor (1 shl ch[lca(u, v)])
                ans.add((mask and (mask - 1)) == 0)
            }
        }
        return ans
    }
}