class Solution {
    public String maximumNumber(String num, int[] change) {
        char[] a = num.toCharArray();
        int n = a.length, i = 0;
        while (i < n && change[a[i] - '0'] <= a[i] - '0') i++;
        while (i < n && change[a[i] - '0'] >= a[i] - '0') {
            a[i] = (char) ('0' + change[a[i] - '0']);
            i++;
        }
        return new String(a);
    }
}