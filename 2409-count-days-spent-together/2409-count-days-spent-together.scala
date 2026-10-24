/*
Brute Force

object Solution {
  def countDaysTogether(arriveAlice: String, leaveAlice: String, arriveBob: String, leaveBob: String): Int = {
    val days = Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    var count = 0
    for (m <- 1 to 12; d <- 1 to days(m - 1)) {
      val date = f"$m%02d-$d%02d"
      if (date >= arriveAlice && date <= leaveAlice && date >= arriveBob && date <= leaveBob) count += 1
    }
    count
  }
}
*/

/*
Better Approach

object Solution {
  def countDaysTogether(arriveAlice: String, leaveAlice: String, arriveBob: String, leaveBob: String): Int = {
    val start = math.max(toDay(arriveAlice), toDay(arriveBob))
    val end = math.min(toDay(leaveAlice), toDay(leaveBob))
    math.max(0, end - start + 1)
  }

  def toDay(date: String): Int = {
    val days = Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    val month = date.substring(0, 2).toInt
    val day = date.substring(3).toInt
    days.take(month - 1).sum + day
  }
}
*/

object Solution {
  val prefix = Array(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334)

  def countDaysTogether(arriveAlice: String, leaveAlice: String, arriveBob: String, leaveBob: String): Int = {
    val start = if (arriveAlice > arriveBob) arriveAlice else arriveBob
    val end = if (leaveAlice < leaveBob) leaveAlice else leaveBob
    if (start > end) 0 else dayOfYear(end) - dayOfYear(start) + 1
  }

  def dayOfYear(d: String): Int = {
    val month = (d(0) - '0') * 10 + (d(1) - '0')
    val day = (d(3) - '0') * 10 + (d(4) - '0')
    prefix(month - 1) + day
  }
}