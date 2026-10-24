/*
Brute Force

class Solution {
  int countDaysTogether(String arriveAlice, String leaveAlice, String arriveBob, String leaveBob) {
    const List<int> days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    int count = 0;
    for (int m = 1; m <= 12; m++) {
      for (int d = 1; d <= days[m - 1]; d++) {
        final String date = m.toString().padLeft(2, '0') + '-' + d.toString().padLeft(2, '0');
        if (date.compareTo(arriveAlice) >= 0 && date.compareTo(leaveAlice) <= 0 &&
            date.compareTo(arriveBob) >= 0 && date.compareTo(leaveBob) <= 0) {
          count++;
        }
      }
    }
    return count;
  }
}
*/

/*
Better Approach

class Solution {
  int countDaysTogether(String arriveAlice, String leaveAlice, String arriveBob, String leaveBob) {
    final int a = toDay(arriveAlice), b = toDay(arriveBob);
    final int c = toDay(leaveAlice), d = toDay(leaveBob);
    final int start = a > b ? a : b;
    final int end = c < d ? c : d;
    return end >= start ? end - start + 1 : 0;
  }

  int toDay(String date) {
    const List<int> days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    final int month = int.parse(date.substring(0, 2));
    final int day = int.parse(date.substring(3));
    int total = 0;
    for (int m = 0; m < month - 1; m++) {
      total += days[m];
    }
    return total + day;
  }
}
*/

class Solution {
  static const List<int> prefix = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];

  int countDaysTogether(String arriveAlice, String leaveAlice, String arriveBob, String leaveBob) {
    final String start = arriveAlice.compareTo(arriveBob) > 0 ? arriveAlice : arriveBob;
    final String end = leaveAlice.compareTo(leaveBob) < 0 ? leaveAlice : leaveBob;
    if (start.compareTo(end) > 0) return 0;
    return dayOfYear(end) - dayOfYear(start) + 1;
  }

  int dayOfYear(String d) {
    final int month = (d.codeUnitAt(0) - 48) * 10 + (d.codeUnitAt(1) - 48);
    final int day = (d.codeUnitAt(3) - 48) * 10 + (d.codeUnitAt(4) - 48);
    return prefix[month - 1] + day;
  }
}