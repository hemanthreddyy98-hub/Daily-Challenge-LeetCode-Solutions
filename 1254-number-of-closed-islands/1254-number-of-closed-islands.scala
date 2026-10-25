/*
Brute Force

object Solution {
  def closedIsland(grid: Array[Array[Int]]): Int = {
    val m = grid.length
    val n = grid(0).length
    val dr = Array(1, -1, 0, 0)
    val dc = Array(0, 0, 1, -1)
    var count = 0
    for (i <- 0 until m; j <- 0 until n if grid(i)(j) == 0) {
      val seen = Array.ofDim[Boolean](m, n)
      var stack = List((i, j))
      seen(i)(j) = true
      var closed = true
      var first = true
      while (stack.nonEmpty) {
        val (r, c) = stack.head
        stack = stack.tail
        if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false
        if (r * n + c < i * n + j) first = false
        for (k <- 0 until 4) {
          val nr = r + dr(k)
          val nc = c + dc(k)
          if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid(nr)(nc) == 0 && !seen(nr)(nc)) {
            seen(nr)(nc) = true
            stack = (nr, nc) :: stack
          }
        }
      }
      if (closed && first) count += 1
    }
    count
  }
}
*/

/*
Better Approach

object Solution {
  def closedIsland(grid: Array[Array[Int]]): Int = {
    val m = grid.length
    val n = grid(0).length
    for (i <- 0 until m) {
      sink(grid, i, 0)
      sink(grid, i, n - 1)
    }
    for (j <- 0 until n) {
      sink(grid, 0, j)
      sink(grid, m - 1, j)
    }
    var count = 0
    for (i <- 0 until m; j <- 0 until n if grid(i)(j) == 0) {
      sink(grid, i, j)
      count += 1
    }
    count
  }

  def sink(grid: Array[Array[Int]], r: Int, c: Int): Unit = {
    if (r < 0 || c < 0 || r >= grid.length || c >= grid(0).length || grid(r)(c) != 0) return
    grid(r)(c) = 1
    sink(grid, r + 1, c)
    sink(grid, r - 1, c)
    sink(grid, r, c + 1)
    sink(grid, r, c - 1)
  }
}
*/

object Solution {
  def closedIsland(grid: Array[Array[Int]]): Int = {
    val m = grid.length
    val n = grid(0).length
    val q = new Array[Int](m * n)
    val dr = Array(1, -1, 0, 0)
    val dc = Array(0, 0, 1, -1)
    var count = 0
    var i = 0
    while (i < m) {
      var j = 0
      while (j < n) {
        if (grid(i)(j) == 0) {
          var head = 0
          var tail = 0
          var closed = true
          grid(i)(j) = 1
          q(tail) = i * n + j
          tail += 1
          while (head < tail) {
            val id = q(head)
            head += 1
            val r = id / n
            val c = id % n
            if (r == 0 || c == 0 || r == m - 1 || c == n - 1) closed = false
            var k = 0
            while (k < 4) {
              val nr = r + dr(k)
              val nc = c + dc(k)
              if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid(nr)(nc) == 0) {
                grid(nr)(nc) = 1
                q(tail) = nr * n + nc
                tail += 1
              }
              k += 1
            }
          }
          if (closed) count += 1
        }
        j += 1
      }
      i += 1
    }
    count
  }
}