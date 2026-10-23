class Solution {
    public boolean placeWordInCrossword(char[][] board, String word) {
        int m = board.length, n = board[0].length;
        for (int i = 0; i < m; i++) if (check(board[i], word)) return true;
        for (int j = 0; j < n; j++) {
            char[] col = new char[m];
            for (int i = 0; i < m; i++) col[i] = board[i][j];
            if (check(col, word)) return true;
        }
        return false;
    }
    boolean check(char[] line, String w) {
        int n = line.length, i = 0;
        while (i < n) {
            if (line[i] == '#') {
                i++;
                continue;
            }
            int j = i;
            while (j < n && line[j] != '#') j++;
            if (j - i == w.length() && (match(line, i, w, false) || match(line, i, w, true))) return true;
            i = j;
        }
        return false;
    }
    boolean match(char[] line, int i, String w, boolean rev) {
        int len = w.length();
        for (int t = 0; t < len; t++) {
            char c = rev ? w.charAt(len - 1 - t) : w.charAt(t);
            if (line[i + t] != ' ' && line[i + t] != c) return false;
        }
        return true;
    }
}