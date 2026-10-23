class Solution {
    public int longestPalindrome(String[] words) {
        int[][] cnt = new int[26][26];
        int res = 0;
        for (String w : words) {
            int a = w.charAt(0) - 'a', b = w.charAt(1) - 'a';
            if (cnt[b][a] > 0) {
                res += 4;
                cnt[b][a]--;
            } else cnt[a][b]++;
        }
        for (int i = 0; i < 26; i++) {
            if (cnt[i][i] > 0) {
                res += 2;
                break;
            }
        }
        return res;
    }
}