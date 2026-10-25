/*
Brute Force

class Solution {
    public int pathSum(int[] nums) {
        int total = 0;
        for (int x : nums) {
            int d = x / 100, p = x / 10 % 10;
            boolean leaf = true;
            for (int y : nums) {
                int cd = y / 100, cp = y / 10 % 10;
                if (cd == d + 1 && (cp == 2 * p - 1 || cp == 2 * p)) leaf = false;
            }
            if (!leaf) continue;
            int curD = d, curP = p;
            while (curD >= 1) {
                for (int y : nums) {
                    if (y / 100 == curD && y / 10 % 10 == curP) {
                        total += y % 10;
                        break;
                    }
                }
                curD--;
                curP = (curP + 1) / 2;
            }
        }
        return total;
    }
}
*/

/*
Better Approach

class Solution {
    public int pathSum(int[] nums) {
        Map<Integer, Integer> tree = new HashMap<>();
        for (int x : nums) tree.put(x / 10, x % 10);
        return dfs(tree, 1, 1, 0);
    }

    int dfs(Map<Integer, Integer> tree, int d, int p, int sum) {
        Integer v = tree.get(d * 10 + p);
        if (v == null) return 0;
        sum += v;
        int left = (d + 1) * 10 + 2 * p - 1;
        if (!tree.containsKey(left) && !tree.containsKey(left + 1)) return sum;
        return dfs(tree, d + 1, 2 * p - 1, sum) + dfs(tree, d + 1, 2 * p, sum);
    }
}
*/

class Solution {
    public int pathSum(int[] nums) {
        int[] leaves = new int[16];
        int ans = 0;
        for (int i = nums.length - 1; i >= 0; i--) {
            int d = nums[i] / 100, p = nums[i] / 10 % 10, v = nums[i] % 10;
            int idx = (1 << (d - 1)) + p - 1;
            if (leaves[idx] == 0) leaves[idx] = 1;
            ans += v * leaves[idx];
            if (idx > 1) leaves[idx / 2] += leaves[idx];
        }
        return ans;
    }
}