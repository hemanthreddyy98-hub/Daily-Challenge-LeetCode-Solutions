class Solution {
    public List<Integer> goodDaysToRobBank(int[] security, int time) {
        int n = security.length;
        int[] l = new int[n], r = new int[n];
        for (int i = 1; i < n; i++) l[i] = security[i] <= security[i - 1] ? l[i - 1] + 1 : 0;
        for (int i = n - 2; i >= 0; i--) r[i] = security[i] <= security[i + 1] ? r[i + 1] + 1 : 0;
        List<Integer> res = new ArrayList<>();
        for (int i = 0; i < n; i++) if (l[i] >= time && r[i] >= time) res.add(i);
        return res;
    }
}