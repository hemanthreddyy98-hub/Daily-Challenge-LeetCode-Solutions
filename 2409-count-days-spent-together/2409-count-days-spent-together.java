class Solution {
    int[] days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

    public int countDaysTogether(String arriveAlice, String leaveAlice, String arriveBob, String leaveBob) {
        int start = Math.max(toDay(arriveAlice), toDay(arriveBob));
        int end = Math.min(toDay(leaveAlice), toDay(leaveBob));
        return Math.max(0, end - start + 1);
    }
    int toDay(String d) {
        int month = Integer.parseInt(d.substring(0, 2)), day = Integer.parseInt(d.substring(3));
        int total = day;
        for (int i = 0; i < month - 1; i++) total += days[i];
        return total;
    }
}