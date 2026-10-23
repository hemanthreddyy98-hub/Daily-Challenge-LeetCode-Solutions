/*
Brute Force

class Solution {
  List<int> parent = [];

  int sortPermutation(List<int> nums) {
    final int n = nums.length;
    bool sorted = true;
    for (int i = 0; i < n; i++) {
      if (nums[i] != i) sorted = false;
    }
    if (sorted) return 0;
    for (int k = n - 1; k >= 0; k--) {
      parent = List<int>.generate(n, (i) => i);
      for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
          if ((nums[i] & nums[j]) == k) {
            final int a = find(nums[i]), b = find(nums[j]);
            parent[a] = b;
          }
        }
      }
      bool ok = true;
      for (int i = 0; i < n && ok; i++) {
        if (find(nums[i]) != find(i)) ok = false;
      }
      if (ok) return k;
    }
    return 0;
  }

  int find(int x) {
    while (parent[x] != x) {
      parent[x] = parent[parent[x]];
      x = parent[x];
    }
    return x;
  }
}
*/

/*
Better Approach

class Solution {
  int sortPermutation(List<int> nums) {
    final int n = nums.length;
    bool sorted = true;
    for (int i = 0; i < n; i++) {
      if (nums[i] != i) sorted = false;
    }
    if (sorted) return 0;
    for (int k = n - 1; k >= 0; k--) {
      bool ok = true;
      for (int i = 0; i < n && ok; i++) {
        if (nums[i] != i && (nums[i] & k) != k) ok = false;
      }
      if (ok) return k;
    }
    return 0;
  }
}
*/

class Solution {
  int sortPermutation(List<int> nums) {
    int ans = -1;
    for (int i = 0; i < nums.length; i++) {
      if (nums[i] != i) ans &= nums[i];
    }
    return ans < 0 ? 0 : ans;
  }
}