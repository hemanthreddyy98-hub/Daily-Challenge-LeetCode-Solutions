/*
Brute Force

object Solution {
  def pathSum(nums: Array[Int]): Int = {
    var total = 0
    for (x <- nums) {
      val d = x / 100
      val p = x / 10 % 10
      val hasChild = nums.exists(y => y / 100 == d + 1 && (y / 10 % 10 == 2 * p - 1 || y / 10 % 10 == 2 * p))
      if (!hasChild) {
        var curD = d
        var curP = p
        while (curD >= 1) {
          total += nums.find(y => y / 100 == curD && y / 10 % 10 == curP).get % 10
          curD -= 1
          curP = (curP + 1) / 2
        }
      }
    }
    total
  }
}
*/

/*
Better Approach

object Solution {
  def pathSum(nums: Array[Int]): Int = {
    val tree = nums.map(x => (x / 10, x % 10)).toMap
    dfs(tree, 1, 1, 0)
  }

  def dfs(tree: Map[Int, Int], d: Int, p: Int, sum: Int): Int = {
    tree.get(d * 10 + p) match {
      case None => 0
      case Some(v) =>
        val total = sum + v
        val left = (d + 1) * 10 + 2 * p - 1
        if (!tree.contains(left) && !tree.contains(left + 1)) total
        else dfs(tree, d + 1, 2 * p - 1, total) + dfs(tree, d + 1, 2 * p, total)
    }
  }
}
*/

object Solution {
  def pathSum(nums: Array[Int]): Int = {
    val leaves = new Array[Int](16)
    var ans = 0
    var i = nums.length - 1
    while (i >= 0) {
      val d = nums(i) / 100
      val p = nums(i) / 10 % 10
      val idx = (1 << (d - 1)) + p - 1
      if (leaves(idx) == 0) leaves(idx) = 1
      ans += (nums(i) % 10) * leaves(idx)
      if (idx > 1) leaves(idx / 2) += leaves(idx)
      i -= 1
    }
    ans
  }
}