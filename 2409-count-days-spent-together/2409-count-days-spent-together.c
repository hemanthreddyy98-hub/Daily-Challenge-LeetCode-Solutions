/*
Brute Force

int countDaysTogether(char* arriveAlice, char* leaveAlice, char* arriveBob, char* leaveBob) {
    int days[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int count = 0;
    char date[16];
    for (int m = 1; m <= 12; m++) {
        for (int d = 1; d <= days[m - 1]; d++) {
            snprintf(date, sizeof(date), "%02d-%02d", m, d);
            if (strcmp(date, arriveAlice) >= 0 && strcmp(date, leaveAlice) <= 0 &&
                strcmp(date, arriveBob) >= 0 && strcmp(date, leaveBob) <= 0)
                count++;
        }
    }
    return count;
}
*/

/*
Better Approach

int toDay(char* date) {
    int days[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    int month = atoi(date);
    int day = atoi(date + 3);
    int total = 0;
    for (int m = 0; m < month - 1; m++) total += days[m];
    return total + day;
}

int countDaysTogether(char* arriveAlice, char* leaveAlice, char* arriveBob, char* leaveBob) {
    int a = toDay(arriveAlice), b = toDay(arriveBob);
    int c = toDay(leaveAlice), d = toDay(leaveBob);
    int start = a > b ? a : b;
    int end = c < d ? c : d;
    return end >= start ? end - start + 1 : 0;
}
*/

int dayOfYear(char* d) {
    static const int prefix[12] = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
    int month = (d[0] - '0') * 10 + (d[1] - '0');
    int day = (d[3] - '0') * 10 + (d[4] - '0');
    return prefix[month - 1] + day;
}

int countDaysTogether(char* arriveAlice, char* leaveAlice, char* arriveBob, char* leaveBob) {
    char* start = strcmp(arriveAlice, arriveBob) > 0 ? arriveAlice : arriveBob;
    char* end = strcmp(leaveAlice, leaveBob) < 0 ? leaveAlice : leaveBob;
    if (strcmp(start, end) > 0) return 0;
    return dayOfYear(end) - dayOfYear(start) + 1;
}