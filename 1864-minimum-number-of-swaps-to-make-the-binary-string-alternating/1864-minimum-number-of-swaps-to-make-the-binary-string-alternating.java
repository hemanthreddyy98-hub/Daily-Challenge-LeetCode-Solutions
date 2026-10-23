class Solution {
    public int minSwaps(String s) {
        int n = s.length(), ones = 0;
        for (char c : s.toCharArray()) if (c == '1') ones++;
        int zeros = n - ones;
        if (Math.abs(ones - zeros) > 1) return -1;
        int m0 = 0;
        for (int i = 0; i < n; i++) {
            char e = i % 2 == 0 ? '0' : '1';
            if (s.charAt(i) != e) m0++;
        }
        int m1 = n - m0;
        if (ones > zeros) return m1 / 2;
        if (zeros > ones) return m0 / 2;
        return Math.min(m0, m1) / 2;
    }
}