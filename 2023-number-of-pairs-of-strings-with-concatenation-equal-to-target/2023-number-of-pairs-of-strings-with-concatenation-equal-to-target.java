class Solution {
    public int numOfPairs(String[] nums, String target) {
        Map<String, Integer> m = new HashMap<>();
        for (String s : nums) m.merge(s, 1, Integer::sum);
        int res = 0;
        for (String s : m.keySet()) {
            if (target.startsWith(s)) {
                String rest = target.substring(s.length());
                int c = m.get(s);
                if (rest.equals(s)) res += c * (c - 1);
                else res += c * m.getOrDefault(rest, 0);
            }
        }
        return res;
    }
}