/*
Brute Force

object Solution {
  def shortestPath(n: Int, edges: Array[Array[Int]], labels: String, k: Int): Int = {
    val inf = Long.MaxValue
    val dist = Array.fill(n, k + 1)(inf)
    dist(0)(1) = 0
    var changed = true
    while (changed) {
      changed = false
      for (e <- edges; run <- 1 to k if dist(e(0))(run) != inf) {
        val (u, v, w) = (e(0), e(1), e(2))
        val next = if (labels(v) == labels(u)) run + 1 else 1
        if (next <= k && dist(u)(run) + w < dist(v)(next)) {
          dist(v)(next) = dist(u)(run) + w
          changed = true
        }
      }
    }
    val ans = (1 to k).map(dist(n - 1)(_)).min
    if (ans == inf) -1 else ans.toInt
  }
}
*/

/*
Better Approach

object Solution {
  def shortestPath(n: Int, edges: Array[Array[Int]], labels: String, k: Int): Int = {
    val g = Array.fill(n)(scala.collection.mutable.ArrayBuffer[(Int, Int)]())
    for (e <- edges) g(e(0)) += ((e(1), e(2)))
    val pq = scala.collection.mutable.PriorityQueue.empty[(Long, Int, Int)](Ordering.by[(Long, Int, Int), Long](_._1).reverse)
    val dist = Array.fill(n, k + 1)(Long.MaxValue)
    dist(0)(1) = 0
    pq.enqueue((0L, 0, 1))
    var ans = -1L
    while (pq.nonEmpty && ans < 0) {
      val (d, u, run) = pq.dequeue()
      if (u == n - 1) ans = d
      else if (d <= dist(u)(run)) {
        for ((v, w) <- g(u)) {
          val next = if (labels(v) == labels(u)) run + 1 else 1
          if (next <= k && d + w < dist(v)(next)) {
            dist(v)(next) = d + w
            pq.enqueue((d + w, v, next))
          }
        }
      }
    }
    ans.toInt
  }
}
*/

object Solution {
  def shortestPath(n: Int, edges: Array[Array[Int]], labels: String, k: Int): Int = {
    val g = Array.fill(n)(scala.collection.mutable.ArrayBuffer[(Int, Int)]())
    for (e <- edges) g(e(0)) += ((e(1), e(2)))
    val pq = scala.collection.mutable.PriorityQueue.empty[(Long, Int, Int)](Ordering.by[(Long, Int, Int), Long](_._1).reverse)
    val best = Array.fill(n)(k + 1)
    pq.enqueue((0L, 0, 1))
    var ans = -1L
    while (pq.nonEmpty && ans < 0) {
      val (d, u, run) = pq.dequeue()
      if (run < best(u)) {
        if (u == n - 1) ans = d
        else {
          best(u) = run
          for ((v, w) <- g(u)) {
            val next = if (labels(v) == labels(u)) run + 1 else 1
            if (next <= k && next < best(v)) pq.enqueue((d + w, v, next))
          }
        }
      }
    }
    ans.toInt
  }
}