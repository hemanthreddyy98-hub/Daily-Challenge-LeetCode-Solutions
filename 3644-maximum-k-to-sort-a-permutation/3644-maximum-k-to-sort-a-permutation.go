/*
Brute Force

func sortPermutation(nums []int) int {
	n := len(nums)
	sorted := true
	for i, v := range nums {
		if v != i {
			sorted = false
		}
	}
	if sorted {
		return 0
	}
	parent := make([]int, n)
	find := func(x int) int {
		for parent[x] != x {
			parent[x] = parent[parent[x]]
			x = parent[x]
		}
		return x
	}
	for k := n - 1; k >= 0; k-- {
		for v := range parent {
			parent[v] = v
		}
		for i := 0; i < n; i++ {
			for j := i + 1; j < n; j++ {
				if nums[i]&nums[j] == k {
					a, b := find(nums[i]), find(nums[j])
					parent[a] = b
				}
			}
		}
		ok := true
		for i := 0; i < n && ok; i++ {
			if find(nums[i]) != find(i) {
				ok = false
			}
		}
		if ok {
			return k
		}
	}
	return 0
}
*/

/*
Better Approach

func sortPermutation(nums []int) int {
	n := len(nums)
	sorted := true
	for i, v := range nums {
		if v != i {
			sorted = false
		}
	}
	if sorted {
		return 0
	}
	for k := n - 1; k >= 0; k-- {
		ok := true
		for i := 0; i < n && ok; i++ {
			if nums[i] != i && nums[i]&k != k {
				ok = false
			}
		}
		if ok {
			return k
		}
	}
	return 0
}
*/

func sortPermutation(nums []int) int {
	ans := -1
	for i, v := range nums {
		if v != i {
			ans &= v
		}
	}
	if ans < 0 {
		return 0
	}
	return ans
}