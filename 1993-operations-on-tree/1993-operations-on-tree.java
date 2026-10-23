class LockingTree {
    int[] par, lk;
    List<List<Integer>> ch = new ArrayList<>();
    public LockingTree(int[] parent) {
        int n = parent.length;
        par = parent;
        lk = new int[n];
        for (int i = 0; i < n; i++) ch.add(new ArrayList<>());
        for (int i = 1; i < n; i++) ch.get(parent[i]).add(i);
    }
    public boolean lock(int num, int user) {
        if (lk[num] != 0) return false;
        lk[num] = user;
        return true;
    }
    public boolean unlock(int num, int user) {
        if (lk[num] != user) return false;
        lk[num] = 0;
        return true;
    }
    public boolean upgrade(int num, int user) {
        if (lk[num] != 0) return false;
        for (int p = par[num]; p != -1; p = par[p]) if (lk[p] != 0) return false;
        boolean any = false;
        ArrayDeque<Integer> st = new ArrayDeque<>(ch.get(num));
        while (!st.isEmpty()) {
            int x = st.pop();
            if (lk[x] != 0) {
                any = true;
                lk[x] = 0;
            }
            for (int y : ch.get(x)) st.push(y);
        }
        if (!any) return false;
        lk[num] = user;
        return true;
    }
}