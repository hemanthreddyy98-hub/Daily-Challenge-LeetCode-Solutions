/*
Brute Force

int pathSum(int* nums, int numsSize) {
    int total = 0;
    for (int i = 0; i < numsSize; i++) {
        int d = nums[i] / 100, p = nums[i] / 10 % 10;
        bool leaf = true;
        for (int j = 0; j < numsSize; j++) {
            int cd = nums[j] / 100, cp = nums[j] / 10 % 10;
            if (cd == d + 1 && (cp == 2 * p - 1 || cp == 2 * p)) leaf = false;
        }
        if (!leaf) continue;
        int curD = d, curP = p;
        while (curD >= 1) {
            for (int j = 0; j < numsSize; j++) {
                if (nums[j] / 100 == curD && nums[j] / 10 % 10 == curP) {
                    total += nums[j] % 10;
                    break;
                }
            }
            curD--;
            curP = (curP + 1) / 2;
        }
    }
    return total;
}
*/

/*
Better Approach

int dfs(int* tree, int d, int p, int sum) {
    int key = d * 10 + p;
    if (tree[key] < 0) return 0;
    sum += tree[key];
    int left = (d + 1) * 10 + 2 * p - 1;
    if (tree[left] < 0 && tree[left + 1] < 0) return sum;
    return dfs(tree, d + 1, 2 * p - 1, sum) + dfs(tree, d + 1, 2 * p, sum);
}

int pathSum(int* nums, int numsSize) {
    int tree[70];
    for (int i = 0; i < 70; i++) tree[i] = -1;
    for (int i = 0; i < numsSize; i++) tree[nums[i] / 10] = nums[i] % 10;
    return dfs(tree, 1, 1, 0);
}
*/

int pathSum(int* nums, int numsSize) {
    int leaves[16] = {0};
    int ans = 0;
    for (int i = numsSize - 1; i >= 0; i--) {
        int d = nums[i] / 100, p = nums[i] / 10 % 10, v = nums[i] % 10;
        int idx = (1 << (d - 1)) + p - 1;
        if (leaves[idx] == 0) leaves[idx] = 1;
        ans += v * leaves[idx];
        if (idx > 1) leaves[idx / 2] += leaves[idx];
    }
    return ans;
}