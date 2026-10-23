/*
Brute Force

public class Solution {
    int[] parent;

    public int SortPermutation(int[] nums) {
        int n = nums.Length;
        bool sorted = true;
        for (int i = 0; i < n; i++)
            if (nums[i] != i) sorted = false;
        if (sorted) return 0;
        for (int k = n - 1; k >= 0; k--) {
            parent = new int[n];
            for (int v = 0; v < n; v++) parent[v] = v;
            for (int i = 0; i < n; i++)
                for (int j = i + 1; j < n; j++)
                    if ((nums[i] & nums[j]) == k) {
                        int a = Find(nums[i]), b = Find(nums[j]);
                        parent[a] = b;
                    }
            bool ok = true;
            for (int i = 0; i < n && ok; i++)
                if (Find(nums[i]) != Find(i)) ok = false;
            if (ok) return k;
        }
        return 0;
    }

    int Find(int x) {
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

public class Solution {
    public int SortPermutation(int[] nums) {
        int n = nums.Length;
        bool sorted = true;
        for (int i = 0; i < n; i++)
            if (nums[i] != i) sorted = false;
        if (sorted) return 0;
        for (int k = n - 1; k >= 0; k--) {
            bool ok = true;
            for (int i = 0; i < n && ok; i++)
                if (nums[i] != i && (nums[i] & k) != k) ok = false;
            if (ok) return k;
        }
        return 0;
    }
}
*/

public class Solution {
    public int SortPermutation(int[] nums) {
        int ans = -1;
        for (int i = 0; i < nums.Length; i++)
            if (nums[i] != i) ans &= nums[i];
        return Math.Max(ans, 0);
    }
}