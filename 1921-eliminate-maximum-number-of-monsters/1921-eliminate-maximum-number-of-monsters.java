class Solution {
    public int eliminateMaximum(int[] dist, int[] speed) {
        int n = dist.length;
        int[] t = new int[n];
        for (int i = 0; i < n; i++) t[i] = (dist[i] + speed[i] - 1) / speed[i];
        Arrays.sort(t);
        for (int i = 0; i < n; i++) if (t[i] <= i) return i;
        return n;
    }
}