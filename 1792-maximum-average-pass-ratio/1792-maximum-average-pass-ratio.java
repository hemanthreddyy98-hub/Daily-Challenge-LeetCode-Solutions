class Solution {
    public double maxAverageRatio(int[][] classes, int extraStudents) {
        PriorityQueue<double[]> pq = new PriorityQueue<>((a, b) -> Double.compare(b[0], a[0]));
        for (int[] c : classes) pq.add(new double[]{gain(c[0], c[1]), c[0], c[1]});
        while (extraStudents-- > 0) {
            double[] t = pq.poll();
            int p = (int) t[1] + 1, q = (int) t[2] + 1;
            pq.add(new double[]{gain(p, q), p, q});
        }
        double s = 0;
        for (double[] t : pq) s += t[1] / t[2];
        return s / classes.length;
    }
    double gain(int p, int q) {
        return (double) (p + 1) / (q + 1) - (double) p / q;
    }
}