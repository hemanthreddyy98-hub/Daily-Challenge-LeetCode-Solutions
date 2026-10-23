class Solution {
    public long smallestNumber(long num) {
        if (num == 0) return 0;
        boolean neg = num < 0;
        char[] d = String.valueOf(Math.abs(num)).toCharArray();
        Arrays.sort(d);
        if (neg) {
            for (int l = 0, r = d.length - 1; l < r; l++, r--) {
                char t = d[l];
                d[l] = d[r];
                d[r] = t;
            }
            return -Long.parseLong(new String(d));
        }
        int i = 0;
        while (d[i] == '0') i++;
        char t = d[0];
        d[0] = d[i];
        d[i] = t;
        return Long.parseLong(new String(d));
    }
}