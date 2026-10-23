class Solution {
    public List<List<Integer>> highestRankedKItems(int[][] grid, int[] pricing, int[] start, int k) {
        int m = grid.length, n = grid[0].length;
        boolean[][] vis = new boolean[m][n];
        int[][] d = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        ArrayDeque<int[]> q = new ArrayDeque<>();
        q.add(new int[]{start[0], start[1], 0});
        vis[start[0]][start[1]] = true;
        List<int[]> items = new ArrayList<>();
        while (!q.isEmpty()) {
            int[] c = q.poll();
            int v = grid[c[0]][c[1]];
            if (v > 1 && v >= pricing[0] && v <= pricing[1]) items.add(new int[]{c[2], v, c[0], c[1]});
            for (int[] x : d) {
                int r = c[0] + x[0], cc = c[1] + x[1];
                if (r >= 0 && r < m && cc >= 0 && cc < n && !vis[r][cc] && grid[r][cc] != 0) {
                    vis[r][cc] = true;
                    q.add(new int[]{r, cc, c[2] + 1});
                }
            }
        }
        items.sort((a, b) -> {
            for (int i = 0; i < 4; i++) if (a[i] != b[i]) return Integer.compare(a[i], b[i]);
            return 0;
        });
        List<List<Integer>> res = new ArrayList<>();
        for (int i = 0; i < Math.min(k, items.size()); i++) res.add(Arrays.asList(items.get(i)[2], items.get(i)[3]));
        return res;
    }
}