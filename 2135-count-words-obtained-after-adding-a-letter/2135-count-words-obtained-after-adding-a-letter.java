class Solution {
    public int wordCount(String[] startWords, String[] targetWords) {
        Set<Integer> set = new HashSet<>();
        for (String s : startWords) set.add(mask(s));
        int res = 0;
        for (String t : targetWords) {
            int m = mask(t);
            for (char c : t.toCharArray()) {
                if (set.contains(m ^ (1 << (c - 'a')))) {
                    res++;
                    break;
                }
            }
        }
        return res;
    }
    int mask(String s) {
        int m = 0;
        for (char c : s.toCharArray()) m |= 1 << (c - 'a');
        return m;
    }
}