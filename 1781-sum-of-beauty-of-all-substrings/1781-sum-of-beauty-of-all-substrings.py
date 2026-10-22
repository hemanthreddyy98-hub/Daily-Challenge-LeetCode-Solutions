class Solution(object):
    def beautySum(self, s):
        n = len(s)
        total = 0
        for i in range(n):
            freq = [0] * 26
            mx = 0
            for j in range(i, n):
                k = ord(s[j]) - 97
                freq[k] += 1
                if freq[k] > mx:
                    mx = freq[k]
                mn = min(f for f in freq if f)
                total += mx - mn
        return total