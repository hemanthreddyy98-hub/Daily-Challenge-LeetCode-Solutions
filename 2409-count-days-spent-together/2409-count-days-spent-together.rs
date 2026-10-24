/*
Brute Force

impl Solution {
    pub fn count_days_together(arrive_alice: String, leave_alice: String, arrive_bob: String, leave_bob: String) -> i32 {
        let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        let mut count = 0;
        for m in 1..=12 {
            for d in 1..=days[m - 1] {
                let date = format!("{:02}-{:02}", m, d);
                if date >= arrive_alice && date <= leave_alice && date >= arrive_bob && date <= leave_bob {
                    count += 1;
                }
            }
        }
        count
    }
}
*/

/*
Better Approach

impl Solution {
    pub fn count_days_together(arrive_alice: String, leave_alice: String, arrive_bob: String, leave_bob: String) -> i32 {
        fn to_day(date: &str) -> i32 {
            let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
            let month: usize = date[0..2].parse().unwrap();
            let day: i32 = date[3..5].parse().unwrap();
            days[..month - 1].iter().sum::<i32>() + day
        }
        let start = to_day(&arrive_alice).max(to_day(&arrive_bob));
        let end = to_day(&leave_alice).min(to_day(&leave_bob));
        (end - start + 1).max(0)
    }
}
*/

impl Solution {
    pub fn count_days_together(arrive_alice: String, leave_alice: String, arrive_bob: String, leave_bob: String) -> i32 {
        const PREFIX: [i32; 12] = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
        let start = arrive_alice.max(arrive_bob);
        let end = leave_alice.min(leave_bob);
        if start > end {
            return 0;
        }
        let day_of_year = |d: &str| {
            let b = d.as_bytes();
            let month = ((b[0] - b'0') * 10 + (b[1] - b'0')) as usize;
            let day = ((b[3] - b'0') * 10 + (b[4] - b'0')) as i32;
            PREFIX[month - 1] + day
        };
        day_of_year(&end) - day_of_year(&start) + 1
    }
}