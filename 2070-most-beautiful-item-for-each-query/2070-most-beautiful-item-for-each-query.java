class Solution {
    public int[] maximumBeauty(int[][] items, int[] queries) {
        Arrays.sort(items, (a, b) -> Integer.compare(a[0], b[0]));
        int n = items.length;
        for (int i = 1; i < n; i++) items[i][1] = Math.max(items[i][1], items[i - 1][1]);
        int[] ans = new int[queries.length];
        for (int k = 0; k < queries.length; k++) {
            int lo = 0, hi = n - 1, idx = -1;
            while (lo <= hi) {
                int mid = (lo + hi) / 2;
                if (items[mid][0] <= queries[k]) {
                    idx = mid;
                    lo = mid + 1;
                } else hi = mid - 1;
            }
            ans[k] = idx == -1 ? 0 : items[idx][1];
        }
        return ans;
    }
}