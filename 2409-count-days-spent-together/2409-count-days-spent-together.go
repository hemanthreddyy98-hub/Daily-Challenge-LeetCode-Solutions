/*
Brute Force

func countDaysTogether(arriveAlice string, leaveAlice string, arriveBob string, leaveBob string) int {
	days := []int{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
	count := 0
	for m := 1; m <= 12; m++ {
		for d := 1; d <= days[m-1]; d++ {
			date := string([]byte{byte('0' + m/10), byte('0' + m%10), '-', byte('0' + d/10), byte('0' + d%10)})
			if date >= arriveAlice && date <= leaveAlice && date >= arriveBob && date <= leaveBob {
				count++
			}
		}
	}
	return count
}
*/

/*
Better Approach

func countDaysTogether(arriveAlice string, leaveAlice string, arriveBob string, leaveBob string) int {
	days := []int{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
	toDay := func(date string) int {
		month := int(date[0]-'0')*10 + int(date[1]-'0')
		day := int(date[3]-'0')*10 + int(date[4]-'0')
		total := 0
		for m := 0; m < month-1; m++ {
			total += days[m]
		}
		return total + day
	}
	start, end := toDay(arriveAlice), toDay(leaveAlice)
	if b := toDay(arriveBob); b > start {
		start = b
	}
	if b := toDay(leaveBob); b < end {
		end = b
	}
	if end < start {
		return 0
	}
	return end - start + 1
}
*/

func countDaysTogether(arriveAlice string, leaveAlice string, arriveBob string, leaveBob string) int {
	start, end := arriveAlice, leaveAlice
	if arriveBob > start {
		start = arriveBob
	}
	if leaveBob < end {
		end = leaveBob
	}
	if start > end {
		return 0
	}
	prefix := [12]int{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334}
	dayOfYear := func(d string) int {
		month := int(d[0]-'0')*10 + int(d[1]-'0')
		day := int(d[3]-'0')*10 + int(d[4]-'0')
		return prefix[month-1] + day
	}
	return dayOfYear(end) - dayOfYear(start) + 1
}