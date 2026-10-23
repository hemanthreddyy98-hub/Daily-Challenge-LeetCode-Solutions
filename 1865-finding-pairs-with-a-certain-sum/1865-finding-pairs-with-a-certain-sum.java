class FindSumPairs {
    int[] a, b;
    Map<Integer, Integer> m = new HashMap<>();
    public FindSumPairs(int[] nums1, int[] nums2) {
        a = nums1;
        b = nums2;
        for (int x : b) m.merge(x, 1, Integer::sum);
    }
    public void add(int index, int val) {
        m.merge(b[index], -1, Integer::sum);
        b[index] += val;
        m.merge(b[index], 1, Integer::sum);
    }
    public int count(int tot) {
        int c = 0;
        for (int x : a) c += m.getOrDefault(tot - x, 0);
        return c;
    }
}