class Bitset {
    boolean[] b;
    boolean f;
    int cnt, n;
    public Bitset(int size) {
        n = size;
        b = new boolean[size];
    }
    public void fix(int idx) {
        if (b[idx] == f) {
            b[idx] = !f;
            cnt++;
        }
    }
    public void unfix(int idx) {
        if (b[idx] != f) {
            b[idx] = f;
            cnt--;
        }
    }
    public void flip() {
        f = !f;
        cnt = n - cnt;
    }
    public boolean all() {
        return cnt == n;
    }
    public boolean one() {
        return cnt > 0;
    }
    public int count() {
        return cnt;
    }
    public String toString() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) sb.append(b[i] != f ? '1' : '0');
        return sb.toString();
    }
}