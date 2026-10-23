class Solution {
    public long minimumPerimeter(long neededApples) {
        long k = 1;
        while (2 * k * (k + 1) * (2 * k + 1) < neededApples) k++;
        return 8 * k;
    }
}