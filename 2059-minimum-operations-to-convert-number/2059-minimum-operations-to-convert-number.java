class Solution {
    public int minimumOperations(int[] nums, int start, int goal) {
        boolean[] vis = new boolean[1001];
        ArrayDeque<Integer> q = new ArrayDeque<>();
        q.add(start);
        vis[start] = true;
        int steps = 0;
        while (!q.isEmpty()) {
            int sz = q.size();
            steps++;
            while (sz-- > 0) {
                int x = q.poll();
                for (int num : nums) {
                    int[] ys = {x + num, x - num, x ^ num};
                    for (int y : ys) {
                        if (y == goal) return steps;
                        if (y >= 0 && y <= 1000 && !vis[y]) {
                            vis[y] = true;
                            q.add(y);
                        }
                    }
                }
            }
        }
        return -1;
    }
}