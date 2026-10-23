class Solution {
    public int maxConsecutiveAnswers(String answerKey, int k) {
        return Math.max(f(answerKey, k, 'T'), f(answerKey, k, 'F'));
    }
    int f(String s, int k, char c) {
        int l = 0, cnt = 0, res = 0;
        for (int r = 0; r < s.length(); r++) {
            if (s.charAt(r) != c) cnt++;
            while (cnt > k) {
                if (s.charAt(l) != c) cnt--;
                l++;
            }
            res = Math.max(res, r - l + 1);
        }
        return res;
    }
}