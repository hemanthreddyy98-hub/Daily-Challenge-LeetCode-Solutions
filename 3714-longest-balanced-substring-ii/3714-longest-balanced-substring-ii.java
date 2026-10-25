class Solution {
    public int longestBalanced(String s) {
        int n = s.length(), ans = 0, run = 0;
        char[] ch = s.toCharArray();
        for (int i = 0; i < n; i++) {
            run = (i > 0 && ch[i] == ch[i - 1]) ? run + 1 : 1;
            ans = Math.max(ans, run);
        }
        char[][] pairs = {{'a', 'b', 'c'}, {'a', 'c', 'b'}, {'b', 'c', 'a'}};
        int[] first = new int[2 * n + 1];
        int[] seg = new int[2 * n + 1];
        int segId = 0;
        for (char[] p : pairs) {
            segId++;
            int diff = 0;
            first[n] = -1;
            seg[n] = segId;
            for (int i = 0; i < n; i++) {
                char c = ch[i];
                if (c == p[2]) {
                    segId++;
                    diff = 0;
                    first[n] = i;
                    seg[n] = segId;
                    continue;
                }
                diff += c == p[0] ? 1 : -1;
                int k = diff + n;
                if (seg[k] != segId) {
                    seg[k] = segId;
                    first[k] = i;
                } else {
                    ans = Math.max(ans, i - first[k]);
                }
            }
        }
        Map<Long, Integer> firstTriple = new HashMap<>();
        int a = 0, b = 0, c = 0;
        firstTriple.put(key(0, 0), -1);
        for (int i = 0; i < n; i++) {
            if (ch[i] == 'a') a++;
            else if (ch[i] == 'b') b++;
            else c++;
            long k = key(a - b, a - c);
            Integer f = firstTriple.get(k);
            if (f == null) firstTriple.put(k, i);
            else ans = Math.max(ans, i - f);
        }
        return ans;
    }
    long key(int x, int y) {
        return (long) (x + 200000) * 1_000_000L + (y + 200000);
    }
}