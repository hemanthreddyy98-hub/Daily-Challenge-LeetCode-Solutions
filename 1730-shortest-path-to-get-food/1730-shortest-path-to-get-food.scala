/*
Brute Force

object Solution {
  private var best = Int.MaxValue

  def getFood(grid: Array[Array[Char]]): Int = {
    best = Int.MaxValue
    for (i <- grid.indices; j <- grid(0).indices)
      if (grid(i)(j) == '*') dfs(grid, i, j, 0)
    if (best == Int.MaxValue) -1 else best
  }

  private def dfs(grid: Array[Array[Char]], r: Int, c: Int, steps: Int): Unit = {
    if (r < 0 || c < 0 || r >= grid.length || c >= grid(0).length) return
    val ch = grid(r)(c)
    if (ch == 'X' || ch == 'V') return
    if (ch == '#') {
      best = math.min(best, steps)
      return
    }
    grid(r)(c) = 'V'
    dfs(grid, r + 1, c, steps + 1)
    dfs(grid, r - 1, c, steps + 1)
    dfs(grid, r, c + 1, steps + 1)
    dfs(grid, r, c - 1, steps + 1)
    grid(r)(c) = ch
  }
}
*/

/*
Basic Approach

import scala.collection.mutable

object Solution {
  def getFood(grid: Array[Array[Char]]): Int = {
    val m = grid.length
    val n = grid(0).length
    val queue = mutable.Queue[(Int, Int)]()
    val visited = Array.ofDim[Boolean](m, n)
    for (i <- 0 until m; j <- 0 until n if grid(i)(j) == '*') {
      queue.enqueue((i, j))
      visited(i)(j) = true
    }
    val dirs = Array((1, 0), (-1, 0), (0, 1), (0, -1))
    var steps = 0
    while (queue.nonEmpty) {
      val size = queue.size
      var k = 0
      while (k < size) {
        val (r0, c0) = queue.dequeue()
        if (grid(r0)(c0) == '#') return steps
        for ((dr, dc) <- dirs) {
          val r = r0 + dr
          val c = c0 + dc
          if (r >= 0 && c >= 0 && r < m && c < n && !visited(r)(c) && grid(r)(c) != 'X') {
            visited(r)(c) = true
            queue.enqueue((r, c))
          }
        }
        k += 1
      }
      steps += 1
    }
    -1
  }
}
*/

object Solution {
  def getFood(grid: Array[Array[Char]]): Int = {
    val m = grid.length
    val n = grid(0).length

    var start = -1
    var i = 0
    while (i < m && start < 0) {
      val j = grid(i).indexOf('*')
      if (j != -1) start = i * n + j
      i += 1
    }
    if (start < 0) return -1

    val q = new Array[Int](m * n)
    var head = 0
    var tail = 0
    q(tail) = start
    tail += 1
    val dr = Array(1, -1, 0, 0)
    val dc = Array(0, 0, 1, -1)
    var steps = 0

    while (head < tail) {
      steps += 1
      val levelEnd = tail
      while (head < levelEnd) {
        val id = q(head)
        head += 1
        val r = id / n
        val c = id % n
        var k = 0
        while (k < 4) {
          val nr = r + dr(k)
          val nc = c + dc(k)
          k += 1
          if (nr >= 0 && nc >= 0 && nr < m && nc < n) {
            val ch = grid(nr)(nc)
            if (ch == '#') return steps
            if (ch == 'O') {
              grid(nr)(nc) = 'X'
              q(tail) = nr * n + nc
              tail += 1
            }
          }
        }
      }
    }
    -1
  }
}