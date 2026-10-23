/*
Brute Force

static int find(int* parent, int x) {
    while (parent[x] != x) {
        parent[x] = parent[parent[x]];
        x = parent[x];
    }
    return x;
}

int sortPermutation(int* nums, int numsSize) {
    int n = numsSize;
    bool sorted = true;
    for (int i = 0; i < n; i++)
        if (nums[i] != i) sorted = false;
    if (sorted) return 0;
    int* parent = (int*)malloc(sizeof(int) * n);
    for (int k = n - 1; k >= 0; k--) {
        for (int v = 0; v < n; v++) parent[v] = v;
        for (int i = 0; i < n; i++)
            for (int j = i + 1; j < n; j++)
                if ((nums[i] & nums[j]) == k) {
                    int a = find(parent, nums[i]), b = find(parent, nums[j]);
                    parent[a] = b;
                }
        bool ok = true;
        for (int i = 0; i < n && ok; i++)
            if (find(parent, nums[i]) != find(parent, i)) ok = false;
        if (ok) {
            free(parent);
            return k;
        }
    }
    free(parent);
    return 0;
}
*/

/*
Better Approach

int sortPermutation(int* nums, int numsSize) {
    int n = numsSize;
    bool sorted = true;
    for (int i = 0; i < n; i++)
        if (nums[i] != i) sorted = false;
    if (sorted) return 0;
    for (int k = n - 1; k >= 0; k--) {
        bool ok = true;
        for (int i = 0; i < n && ok; i++)
            if (nums[i] != i && (nums[i] & k) != k) ok = false;
        if (ok) return k;
    }
    return 0;
}
*/

int sortPermutation(int* nums, int numsSize) {
    int ans = -1;
    for (int i = 0; i < numsSize; i++)
        if (nums[i] != i) ans &= nums[i];
    return ans < 0 ? 0 : ans;
}