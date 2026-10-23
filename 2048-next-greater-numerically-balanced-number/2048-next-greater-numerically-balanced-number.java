class Solution {
    public int nextBeautifulNumber(int n) {
        for (int x = n + 1; ; x++) if (bal(x)) return x;
    }
    boolean bal(int x) {
        int[] c = new int[10];
        while (x > 0) {
            c[x % 10]++;
            x /= 10;
        }
        for (int d = 0; d < 10; d++) if (c[d] != 0 && c[d] != d) return false;
        return true;
    }
}