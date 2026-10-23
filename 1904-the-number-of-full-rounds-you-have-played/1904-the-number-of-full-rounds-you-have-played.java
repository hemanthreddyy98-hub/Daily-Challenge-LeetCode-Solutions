class Solution {
    public int numberOfRounds(String loginTime, String logoutTime) {
        int a = parse(loginTime), b = parse(logoutTime);
        if (b < a) b += 1440;
        return Math.max(0, b / 15 - (a + 14) / 15);
    }
    int parse(String s) {
        return Integer.parseInt(s.substring(0, 2)) * 60 + Integer.parseInt(s.substring(3));
    }
}