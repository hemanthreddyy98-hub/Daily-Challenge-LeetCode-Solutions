class Solution {
    public int[] platesBetweenCandles(String s, int[][] queries) {
        int n = s.length();
        int[] pre = new int[n], L = new int[n], R = new int[n];
        int c = 0, last = -1;
        for (int i = 0; i < n; i++) {
            if (s.charAt(i) == '*') c++;
            else last = i;
            pre[i] = c;
            L[i] = last;
        }
        last = -1;
        for (int i = n - 1; i >= 0; i--) {
            if (s.charAt(i) == '|') last = i;
            R[i] = last;
        }
        int[] ans = new int[queries.length];
        for (int q = 0; q < queries.length; q++) {
            int x = R[queries[q][0]], y = L[queries[q][1]];
            ans[q] = (x != -1 && y != -1 && x < y) ? pre[y] - pre[x] : 0;
        }
        return ans;
    }
}