class Solution {
    public int[] findingUsersActiveMinutes(int[][] logs, int k) {
        Map<Integer, Set<Integer>> m = new HashMap<>();
        for (int[] l : logs) m.computeIfAbsent(l[0], z -> new HashSet<>()).add(l[1]);
        int[] ans = new int[k];
        for (Set<Integer> s : m.values()) ans[s.size() - 1]++;
        return ans;
    }
}