/*
Brute Force

class Solution {
    fun countDaysTogether(arriveAlice: String, leaveAlice: String, arriveBob: String, leaveBob: String): Int {
        val days = intArrayOf(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
        var count = 0
        for (m in 1..12) {
            for (d in 1..days[m - 1]) {
                val date = "%02d-%02d".format(m, d)
                if (date >= arriveAlice && date <= leaveAlice && date >= arriveBob && date <= leaveBob) count++
            }
        }
        return count
    }
}
*/

/*
Better Approach

class Solution {
    fun countDaysTogether(arriveAlice: String, leaveAlice: String, arriveBob: String, leaveBob: String): Int {
        val start = maxOf(toDay(arriveAlice), toDay(arriveBob))
        val end = minOf(toDay(leaveAlice), toDay(leaveBob))
        return maxOf(0, end - start + 1)
    }

    fun toDay(date: String): Int {
        val days = intArrayOf(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
        val month = date.substring(0, 2).toInt()
        val day = date.substring(3).toInt()
        var total = 0
        for (m in 0 until month - 1) total += days[m]
        return total + day
    }
}
*/

class Solution {
    val prefix = intArrayOf(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334)

    fun countDaysTogether(arriveAlice: String, leaveAlice: String, arriveBob: String, leaveBob: String): Int {
        val start = maxOf(arriveAlice, arriveBob)
        val end = minOf(leaveAlice, leaveBob)
        if (start > end) return 0
        return dayOfYear(end) - dayOfYear(start) + 1
    }

    fun dayOfYear(d: String): Int {
        val month = (d[0] - '0') * 10 + (d[1] - '0')
        val day = (d[3] - '0') * 10 + (d[4] - '0')
        return prefix[month - 1] + day
    }
}