/*
Brute Force

public class Solution {
    public int PathSum(int[] nums) {
        int total = 0;
        foreach (int x in nums) {
            int d = x / 100, p = x / 10 % 10;
            bool leaf = true;
            foreach (int y in nums) {
                int cd = y / 100, cp = y / 10 % 10;
                if (cd == d + 1 && (cp == 2 * p - 1 || cp == 2 * p)) leaf = false;
            }
            if (!leaf) continue;
            int curD = d, curP = p;
            while (curD >= 1) {
                foreach (int y in nums) {
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

public class Solution {
    public int PathSum(int[] nums) {
        var tree = new Dictionary<int, int>();
        foreach (int x in nums) tree[x / 10] = x % 10;
        return Dfs(tree, 1, 1, 0);
    }

    int Dfs(Dictionary<int, int> tree, int d, int p, int sum) {
        if (!tree.TryGetValue(d * 10 + p, out int v)) return 0;
        sum += v;
        int left = (d + 1) * 10 + 2 * p - 1;
        if (!tree.ContainsKey(left) && !tree.ContainsKey(left + 1)) return sum;
        return Dfs(tree, d + 1, 2 * p - 1, sum) + Dfs(tree, d + 1, 2 * p, sum);
    }
}
*/

public class Solution {
    public int PathSum(int[] nums) {
        int[] leaves = new int[16];
        int ans = 0;
        for (int i = nums.Length - 1; i >= 0; i--) {
            int d = nums[i] / 100, p = nums[i] / 10 % 10, v = nums[i] % 10;
            int idx = (1 << (d - 1)) + p - 1;
            if (leaves[idx] == 0) leaves[idx] = 1;
            ans += v * leaves[idx];
            if (idx > 1) leaves[idx / 2] += leaves[idx];
        }
        return ans;
    }
}