/*
Brute Force

class Solution {
    function countDaysTogether($arriveAlice, $leaveAlice, $arriveBob, $leaveBob) {
        $days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        $count = 0;
        for ($m = 1; $m <= 12; $m++) {
            for ($d = 1; $d <= $days[$m - 1]; $d++) {
                $date = sprintf("%02d-%02d", $m, $d);
                if (strcmp($date, $arriveAlice) >= 0 && strcmp($date, $leaveAlice) <= 0
                    && strcmp($date, $arriveBob) >= 0 && strcmp($date, $leaveBob) <= 0) {
                    $count++;
                }
            }
        }
        return $count;
    }
}
*/

/*
Better Approach

class Solution {
    function countDaysTogether($arriveAlice, $leaveAlice, $arriveBob, $leaveBob) {
        $start = max($this->toDay($arriveAlice), $this->toDay($arriveBob));
        $end = min($this->toDay($leaveAlice), $this->toDay($leaveBob));
        return max(0, $end - $start + 1);
    }

    function toDay($date) {
        $days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
        $month = intval(substr($date, 0, 2));
        $day = intval(substr($date, 3, 2));
        return array_sum(array_slice($days, 0, $month - 1)) + $day;
    }
}
*/

class Solution {
    function countDaysTogether($arriveAlice, $leaveAlice, $arriveBob, $leaveBob) {
        $start = strcmp($arriveAlice, $arriveBob) > 0 ? $arriveAlice : $arriveBob;
        $end = strcmp($leaveAlice, $leaveBob) < 0 ? $leaveAlice : $leaveBob;
        if (strcmp($start, $end) > 0) return 0;
        return $this->dayOfYear($end) - $this->dayOfYear($start) + 1;
    }

    function dayOfYear($d) {
        $prefix = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
        return $prefix[intval(substr($d, 0, 2)) - 1] + intval(substr($d, 3, 2));
    }
}