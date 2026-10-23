class Solution {
    Map<Integer, Integer> par = new HashMap<>();
    Map<Integer, Character> dir = new HashMap<>();
    public String getDirections(TreeNode root, int startValue, int destValue) {
        ArrayDeque<TreeNode> q = new ArrayDeque<>();
        q.add(root);
        while (!q.isEmpty()) {
            TreeNode t = q.poll();
            if (t.left != null) {
                par.put(t.left.val, t.val);
                dir.put(t.left.val, 'L');
                q.add(t.left);
            }
            if (t.right != null) {
                par.put(t.right.val, t.val);
                dir.put(t.right.val, 'R');
                q.add(t.right);
            }
        }
        String s = path(startValue), d = path(destValue);
        int i = 0;
        while (i < s.length() && i < d.length() && s.charAt(i) == d.charAt(i)) i++;
        return "U".repeat(s.length() - i) + d.substring(i);
    }
    String path(int v) {
        StringBuilder sb = new StringBuilder();
        while (par.containsKey(v)) {
            sb.append(dir.get(v));
            v = par.get(v);
        }
        return sb.reverse().toString();
    }
}