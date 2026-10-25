/*
Brute Force

class Solution {
  int pathSum(List<int> nums) {
    int total = 0;
    for (final int x in nums) {
      int d = x ~/ 100, p = x ~/ 10 % 10;
      bool leaf = true;
      for (final int y in nums) {
        final int cd = y ~/ 100, cp = y ~/ 10 % 10;
        if (cd == d + 1 && (cp == 2 * p - 1 || cp == 2 * p)) leaf = false;
      }
      if (!leaf) continue;
      while (d >= 1) {
        for (final int y in nums) {
          if (y ~/ 100 == d && y ~/ 10 % 10 == p) {
            total += y % 10;
            break;
          }
        }
        d--;
        p = (p + 1) ~/ 2;
      }
    }
    return total;
  }
}
*/

/*
Better Approach

class Solution {
  int pathSum(List<int> nums) {
    final Map<int, int> tree = {};
    for (final int x in nums) {
      tree[x ~/ 10] = x % 10;
    }
    return dfs(tree, 1, 1, 0);
  }

  int dfs(Map<int, int> tree, int d, int p, int sum) {
    final int? v = tree[d * 10 + p];
    if (v == null) return 0;
    final int total = sum + v;
    final int left = (d + 1) * 10 + 2 * p - 1;
    if (!tree.containsKey(left) && !tree.containsKey(left + 1)) return total;
    return dfs(tree, d + 1, 2 * p - 1, total) + dfs(tree, d + 1, 2 * p, total);
  }
}
*/

class Solution {
  int pathSum(List<int> nums) {
    final List<int> leaves = List<int>.filled(16, 0);
    int ans = 0;
    for (int i = nums.length - 1; i >= 0; i--) {
      final int d = nums[i] ~/ 100, p = nums[i] ~/ 10 % 10, v = nums[i] % 10;
      final int idx = (1 << (d - 1)) + p - 1;
      if (leaves[idx] == 0) leaves[idx] = 1;
      ans += v * leaves[idx];
      if (idx > 1) leaves[idx ~/ 2] += leaves[idx];
    }
    return ans;
  }
}