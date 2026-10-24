/*
Brute Force

class Solution {
    public int countDaysTogether(String arriveAlice, String leaveAlice, String arriveBob, String leaveBob) {
        int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int count = 0;
        for (int m = 1; m <= 12; m++) {
            for (int d = 1; d <= days[m - 1]; d++) {
                String date = String.format("%02d-%02d", m, d);
                if (date.compareTo(arriveAlice) >= 0 && date.compareTo(leaveAlice) <= 0
                        && date.compareTo(arriveBob) >= 0 && date.compareTo(leaveBob) <= 0)
                    count++;
            }
        }
        return count;
    }
}
*/

/*
Better Approach

class Solution {
    public int countDaysTogether(String arriveAlice, String leaveAlice, String arriveBob, String leaveBob) {
        int start = Math.max(toDay(arriveAlice), toDay(arriveBob));
        int end = Math.min(toDay(leaveAlice), toDay(leaveBob));
        return Math.max(0, end - start + 1);
    }

    int toDay(String date) {
        int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int month = Integer.parseInt(date.substring(0, 2));
        int day = Integer.parseInt(date.substring(3));
        int total = 0;
        for (int m = 0; m < month - 1; m++) total += days[m];
        return total + day;
    }
}
*/

class Solution {
    static final int[] PREFIX = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};

    public int countDaysTogether(String arriveAlice, String leaveAlice, String arriveBob, String leaveBob) {
        String start = arriveAlice.compareTo(arriveBob) > 0 ? arriveAlice : arriveBob;
        String end = leaveAlice.compareTo(leaveBob) < 0 ? leaveAlice : leaveBob;
        if (start.compareTo(end) > 0) return 0;
        return dayOfYear(end) - dayOfYear(start) + 1;
    }

    int dayOfYear(String d) {
        int month = (d.charAt(0) - '0') * 10 + (d.charAt(1) - '0');
        int day = (d.charAt(3) - '0') * 10 + (d.charAt(4) - '0');
        return PREFIX[month - 1] + day;
    }
}