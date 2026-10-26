/*
Brute Force

object Solution {
  def countIslands(grid: Array[Array[Int]], k: Int): Int = {
    val m = grid.length
    val n = grid(0).length
    val dr = Array(1, -1, 0, 0)
    val dc = Array(0, 0, 1, -1)
    var count = 0
    for (i <- 0 until m; j <- 0 until n if grid(i)(j) > 0) {
      val seen = Array.ofDim[Boolean](m, n)
      var stack = List((i, j))
      seen(i)(j) = true
      var sum = 0L
      var first = true
      while (stack.nonEmpty) {
        val (r, c) = stack.head
        stack = stack.tail
        sum += grid(r)(c)
        if (r * n + c < i * n + j) first = false
        for (d <- 0 until 4) {
          val nr = r + dr(d)
          val nc = c + dc(d)
          if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid(nr)(nc) > 0 && !seen(nr)(nc)) {
            seen(nr)(nc) = true
            stack = (nr, nc) :: stack
          }
        }
      }
      if (first && sum % k == 0) count += 1
    }
    count
  }
}
*/

/*
Better Approach

import scala.collection.mutable

object Solution {
  def countIslands(grid: Array[Array[Int]], k: Int): Int = {
    val m = grid.length
    val n = grid(0).length
    val visited = Array.ofDim[Boolean](m, n)
    val dirs = Array((1, 0), (-1, 0), (0, 1), (0, -1))
    var count = 0
    for (i <- 0 until m; j <- 0 until n if grid(i)(j) > 0 && !visited(i)(j)) {
      val queue = mutable.Queue((i, j))
      visited(i)(j) = true
      var sum = 0L
      while (queue.nonEmpty) {
        val (r0, c0) = queue.dequeue()
        sum += grid(r0)(c0)
        for ((dr, dc) <- dirs) {
          val r = r0 + dr
          val c = c0 + dc
          if (r >= 0 && c >= 0 && r < m && c < n && grid(r)(c) > 0 && !visited(r)(c)) {
            visited(r)(c) = true
            queue.enqueue((r, c))
          }
        }
      }
      if (sum % k == 0) count += 1
    }
    count
  }
}
*/

object Solution {
  def countIslands(grid: Array[Array[Int]], k: Int): Int = {
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
        if (grid(i)(j) > 0) {
          var head = 0
          var tail = 0
          var sum = grid(i)(j) % k
          grid(i)(j) = 0
          q(tail) = i * n + j
          tail += 1
          while (head < tail) {
            val id = q(head)
            head += 1
            val r = id / n
            val c = id % n
            var d = 0
            while (d < 4) {
              val nr = r + dr(d)
              val nc = c + dc(d)
              if (nr >= 0 && nc >= 0 && nr < m && nc < n && grid(nr)(nc) > 0) {
                sum = (sum + grid(nr)(nc)) % k
                grid(nr)(nc) = 0
                q(tail) = nr * n + nc
                tail += 1
              }
              d += 1
            }
          }
          if (sum == 0) count += 1
        }
        j += 1
      }
      i += 1
    }
    count
  }
}