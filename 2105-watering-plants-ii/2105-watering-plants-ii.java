class Solution {
    public int minimumRefill(int[] plants, int capacityA, int capacityB) {
        int i = 0, j = plants.length - 1, a = capacityA, b = capacityB, res = 0;
        while (i < j) {
            if (a < plants[i]) {
                res++;
                a = capacityA;
            }
            a -= plants[i++];
            if (b < plants[j]) {
                res++;
                b = capacityB;
            }
            b -= plants[j--];
        }
        if (i == j && Math.max(a, b) < plants[i]) res++;
        return res;
    }
}