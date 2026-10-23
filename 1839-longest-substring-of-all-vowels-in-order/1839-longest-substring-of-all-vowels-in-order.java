class Solution {
    public int longestBeautifulSubstring(String word) {
        int res = 0, len = 1, cnt = 1;
        for (int i = 1; i < word.length(); i++) {
            char c = word.charAt(i), p = word.charAt(i - 1);
            if (c >= p) {
                len++;
                if (c > p) cnt++;
            } else {
                len = 1;
                cnt = 1;
            }
            if (cnt == 5) res = Math.max(res, len);
        }
        return res;
    }
}