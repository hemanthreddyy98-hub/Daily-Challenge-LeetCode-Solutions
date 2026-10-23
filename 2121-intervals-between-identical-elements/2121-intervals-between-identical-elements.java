class Solution {
    public long[] getDistances(int[] arr) {
        Map<Integer, List<Integer>> m = new HashMap<>();
        for (int i = 0; i < arr.length; i++) m.computeIfAbsent(arr[i], z -> new ArrayList<>()).add(i);
        long[] res = new long[arr.length];
        for (List<Integer> list : m.values()) {
            int sz = list.size();
            long total = 0;
            for (int x : list) total += x;
            long pre = 0;
            for (int k = 0; k < sz; k++) {
                long idx = list.get(k);
                res[(int) idx] = idx * k - pre + (total - pre - idx) - idx * (sz - k - 1);
                pre += idx;
            }
        }
        return res;
    }
}