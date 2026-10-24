"""
Brute Force

class Solution:
    def countDaysTogether(self, arriveAlice: str, leaveAlice: str, arriveBob: str, leaveBob: str) -> int:
        days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        count = 0
        for m in range(1, 13):
            for d in range(1, days[m - 1] + 1):
                date = "%02d-%02d" % (m, d)
                if arriveAlice <= date <= leaveAlice and arriveBob <= date <= leaveBob:
                    count += 1
        return count
"""

"""
Better Approach

class Solution:
    def countDaysTogether(self, arriveAlice: str, leaveAlice: str, arriveBob: str, leaveBob: str) -> int:
        days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

        def to_day(date):
            month, day = int(date[:2]), int(date[3:])
            return sum(days[:month - 1]) + day

        start = max(to_day(arriveAlice), to_day(arriveBob))
        end = min(to_day(leaveAlice), to_day(leaveBob))
        return max(0, end - start + 1)
"""

class Solution:
    def countDaysTogether(self, arriveAlice: str, leaveAlice: str, arriveBob: str, leaveBob: str) -> int:
        start = max(arriveAlice, arriveBob)
        end = min(leaveAlice, leaveBob)
        if start > end:
            return 0
        prefix = (0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334)
        s = prefix[int(start[:2]) - 1] + int(start[3:])
        e = prefix[int(end[:2]) - 1] + int(end[3:])
        return e - s + 1