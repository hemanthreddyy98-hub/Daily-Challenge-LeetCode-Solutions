class SeatManager {
    PriorityQueue<Integer> pq = new PriorityQueue<>();
    public SeatManager(int n) {
        for (int i = 1; i <= n; i++) pq.add(i);
    }
    public int reserve() {
        return pq.poll();
    }
    public void unreserve(int seatNumber) {
        pq.add(seatNumber);
    }
}