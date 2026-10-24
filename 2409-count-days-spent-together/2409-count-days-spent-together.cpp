/*
Brute Force

class Solution {
public:
    int countDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob) {
        int days[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int count = 0;
        char buf[16];
        for (int m = 1; m <= 12; m++) {
            for (int d = 1; d <= days[m - 1]; d++) {
                snprintf(buf, sizeof(buf), "%02d-%02d", m, d);
                string date(buf);
                if (date >= arriveAlice && date <= leaveAlice && date >= arriveBob && date <= leaveBob)
                    count++;
            }
        }
        return count;
    }
};
*/

/*
Better Approach

class Solution {
public:
    int countDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob) {
        int start = max(toDay(arriveAlice), toDay(arriveBob));
        int end = min(toDay(leaveAlice), toDay(leaveBob));
        return max(0, end - start + 1);
    }

    int toDay(const string& date) {
        int days[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        int month = stoi(date.substr(0, 2));
        int day = stoi(date.substr(3));
        int total = 0;
        for (int m = 0; m < month - 1; m++) total += days[m];
        return total + day;
    }
};
*/

class Solution {
public:
    int countDaysTogether(string arriveAlice, string leaveAlice, string arriveBob, string leaveBob) {
        const string& start = max(arriveAlice, arriveBob);
        const string& end = min(leaveAlice, leaveBob);
        if (start > end) return 0;
        return dayOfYear(end) - dayOfYear(start) + 1;
    }

    int dayOfYear(const string& d) {
        static const int prefix[12] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
        int month = (d[0] - '0') * 10 + (d[1] - '0');
        int day = (d[3] - '0') * 10 + (d[4] - '0');
        return prefix[month - 1] + day;
    }
};