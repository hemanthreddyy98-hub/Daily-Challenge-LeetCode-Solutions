class Solution {
    public List<Integer> findLonely(int[] nums) {
        int[] cnt = new int[1000002];
        for (int x : nums) cnt[x]++;
        List<Integer> res = new ArrayList<>();
        for (int x : nums) {
            if (cnt[x] == 1 && (x == 0 || cnt[x - 1] == 0) && cnt[x + 1] == 0) res.add(x);
        }
        return res;
    }
}