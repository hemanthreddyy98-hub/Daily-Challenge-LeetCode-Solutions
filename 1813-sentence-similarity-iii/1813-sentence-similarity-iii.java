class Solution {
    public boolean areSentencesSimilar(String sentence1, String sentence2) {
        String[] a = sentence1.split(" "), b = sentence2.split(" ");
        if (a.length < b.length) {
            String[] t = a;
            a = b;
            b = t;
        }
        int n = a.length, m = b.length, i = 0, j = 0;
        while (i < m && a[i].equals(b[i])) i++;
        while (j < m - i && a[n - 1 - j].equals(b[m - 1 - j])) j++;
        return i + j == m;
    }
}