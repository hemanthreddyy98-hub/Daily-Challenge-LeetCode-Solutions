class Solution {
    public int maximumRemovals(String s, String p, int[] removable) {
        int lo = 0, hi = removable.length;
        while (lo < hi) {
            int mid = (lo + hi + 1) / 2;
            if (check(s, p, removable, mid)) lo = mid;
            else hi = mid - 1;
        }
        return lo;
    }
    boolean check(String s, String p, int[] removable, int k) {
        boolean[] rem = new boolean[s.length()];
        for (int i = 0; i < k; i++) rem[removable[i]] = true;
        int j = 0;
        for (int i = 0; i < s.length() && j < p.length(); i++) {
            if (!rem[i] && s.charAt(i) == p.charAt(j)) j++;
        }
        return j == p.length();
    }
}