/*
Brute Force

var sortPermutation = function(nums) {
    const n = nums.length;
    if (nums.every((v, i) => v === i)) return 0;
    let parent = [];
    const find = (x) => {
        while (parent[x] !== x) {
            parent[x] = parent[parent[x]];
            x = parent[x];
        }
        return x;
    };
    for (let k = n - 1; k >= 0; k--) {
        parent = Array.from({ length: n }, (_, i) => i);
        for (let i = 0; i < n; i++)
            for (let j = i + 1; j < n; j++)
                if ((nums[i] & nums[j]) === k) {
                    const a = find(nums[i]), b = find(nums[j]);
                    parent[a] = b;
                }
        let ok = true;
        for (let i = 0; i < n && ok; i++)
            if (find(nums[i]) !== find(i)) ok = false;
        if (ok) return k;
    }
    return 0;
};
*/

/*
Better Approach

var sortPermutation = function(nums) {
    const n = nums.length;
    if (nums.every((v, i) => v === i)) return 0;
    for (let k = n - 1; k >= 0; k--) {
        let ok = true;
        for (let i = 0; i < n && ok; i++)
            if (nums[i] !== i && (nums[i] & k) !== k) ok = false;
        if (ok) return k;
    }
    return 0;
};
*/

var sortPermutation = function(nums) {
    let ans = -1;
    for (let i = 0; i < nums.length; i++)
        if (nums[i] !== i) ans &= nums[i];
    return Math.max(ans, 0);
};