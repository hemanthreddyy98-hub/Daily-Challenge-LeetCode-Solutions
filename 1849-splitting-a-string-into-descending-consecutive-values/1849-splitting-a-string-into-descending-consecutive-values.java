class Solution {
    public boolean splitString(String s) {
        long v = 0;
        for (int i = 0; i < s.length() - 1; i++) {
            v = v * 10 + (s.charAt(i) - '0');
            if (v > 10000000000L) break;
            if (dfs(s, i + 1, v)) return true;
        }
        return false;
    }
    boolean dfs(String s, int idx, long prev) {
        if (idx == s.length()) return true;
        long v = 0;
        for (int i = idx; i < s.length(); i++) {
            v = v * 10 + (s.charAt(i) - '0');
            if (v > prev) break;
            if (v == prev - 1 && dfs(s, i + 1, v)) return true;
        }
        return false;
    }
}