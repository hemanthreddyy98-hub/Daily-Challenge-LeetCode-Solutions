class Solution {
    public int[][] findFarmland(int[][] land) {
        int m = land.length, n = land[0].length;
        List<int[]> res = new ArrayList<>();
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                if (land[i][j] == 1 && (i == 0 || land[i - 1][j] == 0) && (j == 0 || land[i][j - 1] == 0)) {
                    int r = i, c = j;
                    while (r + 1 < m && land[r + 1][j] == 1) r++;
                    while (c + 1 < n && land[i][c + 1] == 1) c++;
                    res.add(new int[]{i, j, r, c});
                }
            }
        }
        return res.toArray(new int[0][]);
    }
}