/*
Brute Force

class Solution {
    private int[] parent;

    public int sortPermutation(int[] nums) {
        int n = nums.length;
        boolean sorted = true;
        for (int i = 0; i < n; i++)
            if (nums[i] != i) sorted = false;
        if (sorted) return 0;
        for (int k = n - 1; k >= 0; k--) {
            parent = new int[n];
            for (int v = 0; v < n; v++) parent[v] = v;
            for (int i = 0; i < n; i++)
                for (int j = i + 1; j < n; j++)
                    if ((nums[i] & nums[j]) == k) {
                        int a = find(nums[i]), b = find(nums[j]);
                        parent[a] = b;
                    }
            boolean ok = true;
            for (int i = 0; i < n && ok; i++)
                if (find(nums[i]) != find(i)) ok = false;
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
    public int sortPermutation(int[] nums) {
        int n = nums.length;
        boolean sorted = true;
        for (int i = 0; i < n; i++)
            if (nums[i] != i) sorted = false;
        if (sorted) return 0;
        for (int k = n - 1; k >= 0; k--) {
            boolean ok = true;
            for (int i = 0; i < n && ok; i++)
                if (nums[i] != i && (nums[i] & k) != k) ok = false;
            if (ok) return k;
        }
        return 0;
    }
}
*/

class Solution {
    public int sortPermutation(int[] nums) {
        int ans = -1;
        for (int i = 0; i < nums.length; i++)
            if (nums[i] != i) ans &= nums[i];
        return Math.max(ans, 0);
    }
}