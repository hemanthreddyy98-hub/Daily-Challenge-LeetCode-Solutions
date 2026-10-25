/*
Brute Force

function pathSum(nums: number[]): number {
    let total = 0;
    for (const x of nums) {
        const d = Math.floor(x / 100), p = Math.floor(x / 10) % 10;
        let leaf = true;
        for (const y of nums) {
            const cd = Math.floor(y / 100), cp = Math.floor(y / 10) % 10;
            if (cd === d + 1 && (cp === 2 * p - 1 || cp === 2 * p)) leaf = false;
        }
        if (!leaf) continue;
        let curD = d, curP = p;
        while (curD >= 1) {
            for (const y of nums) {
                if (Math.floor(y / 100) === curD && Math.floor(y / 10) % 10 === curP) {
                    total += y % 10;
                    break;
                }
            }
            curD--;
            curP = Math.floor((curP + 1) / 2);
        }
    }
    return total;
}
*/

/*
Better Approach

function pathSum(nums: number[]): number {
    const tree = new Map<number, number>();
    for (const x of nums) tree.set(Math.floor(x / 10), x % 10);
    const dfs = (d: number, p: number, sum: number): number => {
        const key = d * 10 + p;
        if (!tree.has(key)) return 0;
        sum += tree.get(key)!;
        const left = (d + 1) * 10 + 2 * p - 1;
        if (!tree.has(left) && !tree.has(left + 1)) return sum;
        return dfs(d + 1, 2 * p - 1, sum) + dfs(d + 1, 2 * p, sum);
    };
    return dfs(1, 1, 0);
}
*/

function pathSum(nums: number[]): number {
    const leaves = new Int32Array(16);
    let ans = 0;
    for (let i = nums.length - 1; i >= 0; i--) {
        const x = nums[i];
        const d = (x / 100) | 0, p = ((x / 10) | 0) % 10, v = x % 10;
        const idx = (1 << (d - 1)) + p - 1;
        if (leaves[idx] === 0) leaves[idx] = 1;
        ans += v * leaves[idx];
        if (idx > 1) leaves[idx >> 1] += leaves[idx];
    }
    return ans;
}