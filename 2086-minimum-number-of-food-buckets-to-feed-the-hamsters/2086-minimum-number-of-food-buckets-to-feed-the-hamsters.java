class Solution {
    public int minimumBuckets(String hamsters) {
        char[] a = hamsters.toCharArray();
        int n = a.length, res = 0;
        for (int i = 0; i < n; i++) {
            if (a[i] == 'H') {
                if (i > 0 && a[i - 1] == 'B') continue;
                if (i + 1 < n && a[i + 1] == '.') {
                    a[i + 1] = 'B';
                    res++;
                } else if (i > 0 && a[i - 1] == '.') {
                    a[i - 1] = 'B';
                    res++;
                } else return -1;
            }
        }
        return res;
    }
}