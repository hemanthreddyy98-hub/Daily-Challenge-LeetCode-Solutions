class Solution {
    public int countPalindromicSubsequence(String s) {
        int[] first = new int[26], last = new int[26];
        Arrays.fill(first, -1);
        for (int i = 0; i < s.length(); i++) {
            int c = s.charAt(i) - 'a';
            if (first[c] == -1) first[c] = i;
            last[c] = i;
        }
        int res = 0;
        for (int c = 0; c < 26; c++) {
            if (first[c] != -1 && first[c] < last[c]) {
                boolean[] seen = new boolean[26];
                int cnt = 0;
                for (int i = first[c] + 1; i < last[c]; i++) {
                    int x = s.charAt(i) - 'a';
                    if (!seen[x]) {
                        seen[x] = true;
                        cnt++;
                    }
                }
                res += cnt;
            }
        }
        return res;
    }
}