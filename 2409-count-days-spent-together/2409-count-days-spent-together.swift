/*
Brute Force

class Solution {
    func countDaysTogether(_ arriveAlice: String, _ leaveAlice: String, _ arriveBob: String, _ leaveBob: String) -> Int {
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        var count = 0
        for m in 1...12 {
            for d in 1...days[m - 1] {
                let mm = m < 10 ? "0\(m)" : "\(m)"
                let dd = d < 10 ? "0\(d)" : "\(d)"
                let date = mm + "-" + dd
                if date >= arriveAlice && date <= leaveAlice && date >= arriveBob && date <= leaveBob {
                    count += 1
                }
            }
        }
        return count
    }
}
*/

/*
Better Approach

class Solution {
    func countDaysTogether(_ arriveAlice: String, _ leaveAlice: String, _ arriveBob: String, _ leaveBob: String) -> Int {
        let start = max(toDay(arriveAlice), toDay(arriveBob))
        let end = min(toDay(leaveAlice), toDay(leaveBob))
        return max(0, end - start + 1)
    }

    func toDay(_ date: String) -> Int {
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        let parts = date.split(separator: "-")
        let month = Int(parts[0])!
        let day = Int(parts[1])!
        var total = 0
        for m in 0..<(month - 1) {
            total += days[m]
        }
        return total + day
    }
}
*/

class Solution {
    let prefix = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]

    func countDaysTogether(_ arriveAlice: String, _ leaveAlice: String, _ arriveBob: String, _ leaveBob: String) -> Int {
        let start = max(arriveAlice, arriveBob)
        let end = min(leaveAlice, leaveBob)
        if start > end { return 0 }
        return dayOfYear(end) - dayOfYear(start) + 1
    }

    func dayOfYear(_ d: String) -> Int {
        let c = d.utf8.map { Int($0) - 48 }
        return prefix[c[0] * 10 + c[1] - 1] + c[3] * 10 + c[4]
    }
}