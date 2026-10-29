/*
Brute Force

object Solution {
  def palindromePath(n: Int, edges: Array[Array[Int]], s: String, queries: Array[String]): List[Boolean] = {
    val g = Array.fill(n)(scala.collection.mutable.ArrayBuffer[Int]())
    for (e <- edges) {
      g(e(0)) += e(1)
      g(e(1)) += e(0)
    }
    val ch = s.map(_ - 'a').toArray
    val ans = scala.collection.mutable.ListBuffer[Boolean]()
    for (q <- queries) {
      val p = q.split(" ")
      val u = p(1).toInt
      if (p(0) == "update") ch(u) = p(2)(0) - 'a'
      else {
        val v = p(2).toInt
        val par = Array.fill(n)(-1)
        par(u) = u
        val bfs = scala.collection.mutable.Queue(u)
        while (bfs.nonEmpty) {
          val x = bfs.dequeue()
          for (y <- g(x) if par(y) == -1) {
            par(y) = x
            bfs.enqueue(y)
          }
        }
        var mask = 1 << ch(u)
        var cur = v
        while (cur != u) {
          mask ^= 1 << ch(cur)
          cur = par(cur)
        }
        ans += ((mask & (mask - 1)) == 0)
      }
    }
    ans.toList
  }
}
*/

/*
Better Approach

object Solution {
  def palindromePath(n: Int, edges: Array[Array[Int]], s: String, queries: Array[String]): List[Boolean] = {
    val g = Array.fill(n)(scala.collection.mutable.ArrayBuffer[Int]())
    for (e <- edges) {
      g(e(0)) += e(1)
      g(e(1)) += e(0)
    }
    val ch = s.map(_ - 'a').toArray
    val par = Array.fill(n)(-1)
    val depth = new Array[Int](n)
    par(0) = 0
    val bfs = scala.collection.mutable.Queue(0)
    while (bfs.nonEmpty) {
      val x = bfs.dequeue()
      for (y <- g(x) if par(y) == -1) {
        par(y) = x
        depth(y) = depth(x) + 1
        bfs.enqueue(y)
      }
    }
    val ans = scala.collection.mutable.ListBuffer[Boolean]()
    for (q <- queries) {
      val p = q.split(" ")
      var u = p(1).toInt
      if (p(0) == "update") ch(u) = p(2)(0) - 'a'
      else {
        var v = p(2).toInt
        var mask = 0
        while (u != v) {
          if (depth(u) < depth(v)) {
            val t = u
            u = v
            v = t
          }
          mask ^= 1 << ch(u)
          u = par(u)
        }
        mask ^= 1 << ch(u)
        ans += ((mask & (mask - 1)) == 0)
      }
    }
    ans.toList
  }
}
*/

object Solution {
  def palindromePath(n: Int, edges: Array[Array[Int]], s: String, queries: Array[String]): List[Boolean] = {
    val g = Array.fill(n)(scala.collection.mutable.ArrayBuffer[Int]())
    for (e <- edges) {
      g(e(0)) += e(1)
      g(e(1)) += e(0)
    }
    val ch = s.map(_ - 'a').toArray
    val log = 17
    val up = Array.ofDim[Int](log, n)
    val depth = new Array[Int](n)
    val tin = new Array[Int](n)
    val sz = Array.fill(n)(1)
    val seen = new Array[Boolean](n)
    val order = new Array[Int](n)
    val stack = new Array[Int](n)
    var top = 1
    var timer = 0
    seen(0) = true
    while (top > 0) {
      top -= 1
      val x = stack(top)
      tin(x) = timer
      order(timer) = x
      timer += 1
      for (y <- g(x) if !seen(y)) {
        seen(y) = true
        up(0)(y) = x
        depth(y) = depth(x) + 1
        stack(top) = y
        top += 1
      }
    }
    for (i <- n - 1 until 0 by -1) sz(up(0)(order(i))) += sz(order(i))
    for (k <- 1 until log; x <- 0 until n) up(k)(x) = up(k - 1)(up(k - 1)(x))
    val bit = new Array[Int](n + 1)
    def add(start: Int, d: Int): Unit = {
      var i = start
      while (i <= n) {
        bit(i) ^= d
        i += i & -i
      }
    }
    def rangeXor(x: Int, d: Int): Unit = {
      add(tin(x) + 1, d)
      add(tin(x) + sz(x) + 1, d)
    }
    def prefix(x: Int): Int = {
      var r = 0
      var i = tin(x) + 1
      while (i > 0) {
        r ^= bit(i)
        i -= i & -i
      }
      r
    }
    def lca(a0: Int, b0: Int): Int = {
      var a = if (depth(a0) >= depth(b0)) a0 else b0
      var b = if (depth(a0) >= depth(b0)) b0 else a0
      for (k <- log - 1 to 0 by -1) if (depth(a) - (1 << k) >= depth(b)) a = up(k)(a)
      if (a == b) a
      else {
        for (k <- log - 1 to 0 by -1)
          if (up(k)(a) != up(k)(b)) {
            a = up(k)(a)
            b = up(k)(b)
          }
        up(0)(a)
      }
    }
    for (x <- 0 until n) rangeXor(x, 1 << ch(x))
    val ans = scala.collection.mutable.ListBuffer[Boolean]()
    for (q <- queries) {
      val p = q.split(" ")
      val u = p(1).toInt
      if (p(0) == "update") {
        val c = p(2)(0) - 'a'
        rangeXor(u, (1 << ch(u)) ^ (1 << c))
        ch(u) = c
      } else {
        val v = p(2).toInt
        val mask = prefix(u) ^ prefix(v) ^ (1 << ch(lca(u, v)))
        ans += ((mask & (mask - 1)) == 0)
      }
    }
    ans.toList
  }
}