/*
Brute Force

func pathSum(nums []int) int {
	total := 0
	for _, x := range nums {
		d, p := x/100, x/10%10
		leaf := true
		for _, y := range nums {
			cd, cp := y/100, y/10%10
			if cd == d+1 && (cp == 2*p-1 || cp == 2*p) {
				leaf = false
			}
		}
		if !leaf {
			continue
		}
		for curD, curP := d, p; curD >= 1; curD, curP = curD-1, (curP+1)/2 {
			for _, y := range nums {
				if y/100 == curD && y/10%10 == curP {
					total += y % 10
					break
				}
			}
		}
	}
	return total
}
*/

/*
Better Approach

func pathSum(nums []int) int {
	tree := map[int]int{}
	for _, x := range nums {
		tree[x/10] = x % 10
	}
	var dfs func(d, p, sum int) int
	dfs = func(d, p, sum int) int {
		v, ok := tree[d*10+p]
		if !ok {
			return 0
		}
		sum += v
		left := (d+1)*10 + 2*p - 1
		_, hasL := tree[left]
		_, hasR := tree[left+1]
		if !hasL && !hasR {
			return sum
		}
		return dfs(d+1, 2*p-1, sum) + dfs(d+1, 2*p, sum)
	}
	return dfs(1, 1, 0)
}
*/

func pathSum(nums []int) int {
	var leaves [16]int
	ans := 0
	for i := len(nums) - 1; i >= 0; i-- {
		d, p, v := nums[i]/100, nums[i]/10%10, nums[i]%10
		idx := 1<<(d-1) + p - 1
		if leaves[idx] == 0 {
			leaves[idx] = 1
		}
		ans += v * leaves[idx]
		if idx > 1 {
			leaves[idx/2] += leaves[idx]
		}
	}
	return ans
}