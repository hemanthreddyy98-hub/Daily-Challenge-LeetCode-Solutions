class Solution {
    public int getMinSwaps(String num, int k) {
        char[] a = num.toCharArray(), b = a.clone();
        while (k-- > 0) next(b);
        int res = 0, n = a.length;
        for (int i = 0; i < n; i++) {
            if (a[i] != b[i]) {
                int j = i;
                while (a[j] != b[i]) j++;
                while (j > i) {
                    char t = a[j];
                    a[j] = a[j - 1];
                    a[j - 1] = t;
                    j--;
                    res++;
                }
            }
        }
        return res;
    }
    void next(char[] a) {
        int n = a.length, i = n - 2;
        while (i >= 0 && a[i] >= a[i + 1]) i--;
        int j = n - 1;
        while (a[j] <= a[i]) j--;
        char t = a[i];
        a[i] = a[j];
        a[j] = t;
        for (int l = i + 1, r = n - 1; l < r; l++, r--) {
            t = a[l];
            a[l] = a[r];
            a[r] = t;
        }
    }
}