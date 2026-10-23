class Solution {
    public boolean checkMove(char[][] board, int rMove, int cMove, char color) {
        int[][] d = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}};
        for (int[] x : d) {
            int r = rMove + x[0], c = cMove + x[1], step = 1;
            while (r >= 0 && r < 8 && c >= 0 && c < 8) {
                if (board[r][c] == '.') break;
                if (board[r][c] == color) {
                    if (step >= 2) return true;
                    break;
                }
                r += x[0];
                c += x[1];
                step++;
            }
        }
        return false;
    }
}