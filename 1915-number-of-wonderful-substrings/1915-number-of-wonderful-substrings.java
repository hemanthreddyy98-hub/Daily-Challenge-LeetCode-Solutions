class Solution {
    public long wonderfulSubstrings(String word) {
        long[] cnt = new long[1024];
        cnt[0] = 1;
        int mask = 0;
        long res = 0;
        for (char c : word.toCharArray()) {
            mask ^= 1 << (c - 'a');
            res += cnt[mask];
            for (int b = 0; b < 10; b++) res += cnt[mask ^ (1 << b)];
            cnt[mask]++;
        }
        return res;
    }
}