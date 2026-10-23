class Solution {
    public int[] findOriginalArray(int[] changed) {
        int n = changed.length;
        if (n % 2 == 1) return new int[0];
        Arrays.sort(changed);
        int[] cnt = new int[200001];
        for (int x : changed) cnt[x]++;
        int[] res = new int[n / 2];
        int k = 0;
        for (int x : changed) {
            if (cnt[x] == 0) continue;
            cnt[x]--;
            if (cnt[2 * x] == 0) return new int[0];
            cnt[2 * x]--;
            res[k++] = x;
        }
        return res;
    }
}