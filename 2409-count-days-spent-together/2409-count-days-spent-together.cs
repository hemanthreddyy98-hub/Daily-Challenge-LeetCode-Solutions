/*
Brute Force

public class Solution {
    public int CountDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob) {
        int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int count = 0;
        for (int m = 1; m <= 12; m++) {
            for (int d = 1; d <= days[m - 1]; d++) {
                string date = m.ToString("D2") + "-" + d.ToString("D2");
                if (string.CompareOrdinal(date, arriveAlice) >= 0 && string.CompareOrdinal(date, leaveAlice) <= 0
                    && string.CompareOrdinal(date, arriveBob) >= 0 && string.CompareOrdinal(date, leaveBob) <= 0)
                    count++;
            }
        }
        return count;
    }
}
*/

/*
Better Approach

public class Solution {
    public int CountDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob) {
        int start = Math.Max(ToDay(arriveAlice), ToDay(arriveBob));
        int end = Math.Min(ToDay(leaveAlice), ToDay(leaveBob));
        return Math.Max(0, end - start + 1);
    }

    int ToDay(string date) {
        int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int month = int.Parse(date.Substring(0, 2));
        int day = int.Parse(date.Substring(3));
        int total = 0;
        for (int m = 0; m < month - 1; m++) total += days[m];
        return total + day;
    }
}
*/

public class Solution {
    static readonly int[] Prefix = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};

    public int CountDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob) {
        string start = string.CompareOrdinal(arriveAlice, arriveBob) > 0 ? arriveAlice : arriveBob;
        string end = string.CompareOrdinal(leaveAlice, leaveBob) < 0 ? leaveAlice : leaveBob;
        if (string.CompareOrdinal(start, end) > 0) return 0;
        return DayOfYear(end) - DayOfYear(start) + 1;
    }

    int DayOfYear(string d) {
        int month = (d[0] - '0') * 10 + (d[1] - '0');
        int day = (d[3] - '0') * 10 + (d[4] - '0');
        return Prefix[month - 1] + day;
    }
}