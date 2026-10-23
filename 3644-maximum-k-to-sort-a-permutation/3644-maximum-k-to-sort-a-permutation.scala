/*
Brute Force

object Solution {
  var parent: Array[Int] = Array.empty[Int]

  def sortPermutation(nums: Array[Int]): Int = {
    val n = nums.length
    if (nums.indices.forall(i => nums(i) == i)) return 0
    var k = n - 1
    while (k >= 0) {
      parent = Array.tabulate(n)(identity)
      for (i <- 0 until n; j <- i + 1 until n)
        if ((nums(i) & nums(j)) == k) {
          val a = find(nums(i))
          val b = find(nums(j))
          parent(a) = b
        }
      if (nums.indices.forall(i => find(nums(i)) == find(i))) return k
      k -= 1
    }
    0
  }

  def find(start: Int): Int = {
    var x = start
    while (parent(x) != x) {
      parent(x) = parent(parent(x))
      x = parent(x)
    }
    x
  }
}
*/

/*
Better Approach

object Solution {
  def sortPermutation(nums: Array[Int]): Int = {
    val n = nums.length
    if (nums.indices.forall(i => nums(i) == i)) return 0
    var k = n - 1
    while (k >= 0) {
      if (nums.indices.forall(i => nums(i) == i || (nums(i) & k) == k)) return k
      k -= 1
    }
    0
  }
}
*/

object Solution {
  def sortPermutation(nums: Array[Int]): Int = {
    var ans = -1
    for (i <- nums.indices)
      if (nums(i) != i) ans &= nums(i)
    math.max(ans, 0)
  }
}