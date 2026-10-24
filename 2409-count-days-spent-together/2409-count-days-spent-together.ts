/*
Brute Force

function countDaysTogether(arriveAlice: string, leaveAlice: string, arriveBob: string, leaveBob: string): number {
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    let count = 0;
    for (let m = 1; m <= 12; m++) {
        for (let d = 1; d <= days[m - 1]; d++) {
            const date = String(m).padStart(2, '0') + '-' + String(d).padStart(2, '0');
            if (date >= arriveAlice && date <= leaveAlice && date >= arriveBob && date <= leaveBob) count++;
        }
    }
    return count;
}
*/

/*
Better Approach

function countDaysTogether(arriveAlice: string, leaveAlice: string, arriveBob: string, leaveBob: string): number {
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    const toDay = (date: string): number => {
        const month = parseInt(date.slice(0, 2), 10);
        const day = parseInt(date.slice(3), 10);
        let total = 0;
        for (let m = 0; m < month - 1; m++) total += days[m];
        return total + day;
    };
    const start = Math.max(toDay(arriveAlice), toDay(arriveBob));
    const end = Math.min(toDay(leaveAlice), toDay(leaveBob));
    return Math.max(0, end - start + 1);
}
*/

function countDaysTogether(arriveAlice: string, leaveAlice: string, arriveBob: string, leaveBob: string): number {
    const start = arriveAlice > arriveBob ? arriveAlice : arriveBob;
    const end = leaveAlice < leaveBob ? leaveAlice : leaveBob;
    if (start > end) return 0;
    const prefix = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    const dayOfYear = (d: string): number => {
        const month = (d.charCodeAt(0) - 48) * 10 + (d.charCodeAt(1) - 48);
        const day = (d.charCodeAt(3) - 48) * 10 + (d.charCodeAt(4) - 48);
        return prefix[month - 1] + day;
    };
    return dayOfYear(end) - dayOfYear(start) + 1;
}