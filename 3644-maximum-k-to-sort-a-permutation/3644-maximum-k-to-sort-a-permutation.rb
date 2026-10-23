=begin
Brute Force

def sort_permutation(nums)
  n = nums.length
  return 0 if nums.each_with_index.all? { |v, i| v == i }
  parent = []
  find = lambda do |x|
    while parent[x] != x
      parent[x] = parent[parent[x]]
      x = parent[x]
    end
    x
  end
  (n - 1).downto(0) do |k|
    parent = (0...n).to_a
    (0...n).each do |i|
      (i + 1...n).each do |j|
        next unless (nums[i] & nums[j]) == k
        a = find.(nums[i])
        b = find.(nums[j])
        parent[a] = b
      end
    end
    return k if (0...n).all? { |i| find.(nums[i]) == find.(i) }
  end
  0
end
=end

=begin
Better Approach

def sort_permutation(nums)
  n = nums.length
  return 0 if nums.each_with_index.all? { |v, i| v == i }
  (n - 1).downto(0) do |k|
    return k if nums.each_with_index.all? { |v, i| v == i || (v & k) == k }
  end
  0
end
=end

def sort_permutation(nums)
  ans = -1
  nums.each_with_index { |v, i| ans &= v if v != i }
  [ans, 0].max
end