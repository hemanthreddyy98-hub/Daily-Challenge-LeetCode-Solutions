class Solution {
    public List<Long> maximumEvenSplit(long finalSum) {
        List<Long> res = new ArrayList<>();
        if (finalSum % 2 == 1) return res;
        long cur = 2;
        while (finalSum >= cur) {
            res.add(cur);
            finalSum -= cur;
            cur += 2;
        }
        int last = res.size() - 1;
        res.set(last, res.get(last) + finalSum);
        return res;
    }
}