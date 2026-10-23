class Solution {
    public int minimumOperations(int[] nums) {
        int n = nums.length;
        int[] e = new int[100001], o = new int[100001];
        for (int i = 0; i < n; i++) {
            if (i % 2 == 0) e[nums[i]]++;
            else o[nums[i]]++;
        }
        int[] a = top(e), b = top(o);
        if (a[0] != b[0]) return n - a[1] - b[1];
        return n - Math.max(a[1] + b[3], a[3] + b[1]);
    }
    int[] top(int[] cnt) {
        int v1 = 0, f1 = 0, v2 = 0, f2 = 0;
        for (int v = 1; v < cnt.length; v++) {
            if (cnt[v] > f1) {
                v2 = v1;
                f2 = f1;
                v1 = v;
                f1 = cnt[v];
            } else if (cnt[v] > f2) {
                v2 = v;
                f2 = cnt[v];
            }
        }
        return new int[]{v1, f1, v2, f2};
    }
}