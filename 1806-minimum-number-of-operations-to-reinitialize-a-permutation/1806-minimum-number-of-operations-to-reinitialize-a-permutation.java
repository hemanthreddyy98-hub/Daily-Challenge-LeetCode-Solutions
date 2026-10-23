class Solution {
    public int reinitializePermutation(int n) {
        int[] perm = new int[n];
        for (int i = 0; i < n; i++) perm[i] = i;
        int cnt = 0;
        while (true) {
            int[] arr = new int[n];
            for (int i = 0; i < n; i++) arr[i] = i % 2 == 0 ? perm[i / 2] : perm[n / 2 + (i - 1) / 2];
            perm = arr;
            cnt++;
            boolean ok = true;
            for (int i = 0; i < n; i++) {
                if (perm[i] != i) {
                    ok = false;
                    break;
                }
            }
            if (ok) return cnt;
        }
    }
}