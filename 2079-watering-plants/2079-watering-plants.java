class Solution {
    public int wateringPlants(int[] plants, int capacity) {
        int w = capacity, s = 0;
        for (int i = 0; i < plants.length; i++) {
            if (w < plants[i]) {
                s += 2 * i;
                w = capacity;
            }
            s++;
            w -= plants[i];
        }
        return s;
    }
}