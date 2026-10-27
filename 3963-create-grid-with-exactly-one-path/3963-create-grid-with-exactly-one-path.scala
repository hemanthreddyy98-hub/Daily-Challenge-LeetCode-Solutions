/*
Brute Force

object Solution {
  def createGrid(m: Int, n: Int): Array[String] = {
    val g = Array.fill(m, n)('.')
    for (i <- 0 until m; j <- 0 until n if !(i == 0 && j == 0) && !(i == m - 1 && j == n - 1)) {
      g(i)(j) = '#'
      if (!reach(g, 0, 0)) g(i)(j) = '.'
    }
    g.map(_.mkString)
  }

  def reach(g: Array[Array[Char]], r: Int, c: Int): Boolean = {
    if (r >= g.length || c >= g(0).length || g(r)(c) == '#') false
    else if (r == g.length - 1 && c == g(0).length - 1) true
    else reach(g, r + 1, c) || reach(g, r, c + 1)
  }
}
*/

/*
Better Approach

object Solution {
  def createGrid(m: Int, n: Int): Array[String] = {
    val g = Array.fill(m, n)('.')
    for (i <- 0 until m; j <- 0 until n if !(i == 0 && j == 0) && !(i == m - 1 && j == n - 1)) {
      g(i)(j) = '#'
      if (!reach(g)) g(i)(j) = '.'
    }
    g.map(_.mkString)
  }

  def reach(g: Array[Array[Char]]): Boolean = {
    val m = g.length
    val n = g(0).length
    val ok = Array.ofDim[Boolean](m, n)
    for (i <- 0 until m; j <- 0 until n if g(i)(j) != '#')
      ok(i)(j) = (i == 0 && j == 0) || (i > 0 && ok(i - 1)(j)) || (j > 0 && ok(i)(j - 1))
    ok(m - 1)(n - 1)
  }
}
*/

object Solution {
  def createGrid(m: Int, n: Int): Array[String] = {
    val rest = "#" * (n - 1) + "."
    Array.tabulate(m)(i => if (i == 0) "." * n else rest)
  }
}