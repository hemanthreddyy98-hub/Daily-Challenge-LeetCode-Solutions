/*
Brute Force

class Solution {
public:
    int pathSum(vector<int>& nums) {
        int total = 0;
        for (int x : nums) {
            int d = x / 100, p = x / 10 % 10;
            bool leaf = true;
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
};
*/

/*
Better Approach

class Solution {
public:
    int pathSum(vector<int>& nums) {
        unordered_map<int, int> tree;
        for (int x : nums) tree[x / 10] = x % 10;
        return dfs(tree, 1, 1, 0);
    }

    int dfs(unordered_map<int, int>& tree, int d, int p, int sum) {
        auto it = tree.find(d * 10 + p);
        if (it == tree.end()) return 0;
        sum += it->second;
        int left = (d + 1) * 10 + 2 * p - 1;
        if (!tree.count(left) && !tree.count(left + 1)) return sum;
        return dfs(tree, d + 1, 2 * p - 1, sum) + dfs(tree, d + 1, 2 * p, sum);
    }
};
*/

class Solution {
public:
    int pathSum(vector<int>& nums) {
        int leaves[16] = {0};
        int ans = 0;
        for (int i = nums.size() - 1; i >= 0; i--) {
            int d = nums[i] / 100, p = nums[i] / 10 % 10, v = nums[i] % 10;
            int idx = (1 << (d - 1)) + p - 1;
            if (leaves[idx] == 0) leaves[idx] = 1;
            ans += v * leaves[idx];
            if (idx > 1) leaves[idx / 2] += leaves[idx];
        }
        return ans;
    }
};