class Solution {
    public ListNode reverseEvenLengthGroups(ListNode head) {
        ListNode prev = head;
        for (int g = 2; prev.next != null; g++) {
            ListNode node = prev.next;
            int cnt = 0;
            while (node != null && cnt < g) {
                node = node.next;
                cnt++;
            }
            if (cnt % 2 == 0) {
                ListNode first = prev.next, cur = first, p = node;
                for (int i = 0; i < cnt; i++) {
                    ListNode nx = cur.next;
                    cur.next = p;
                    p = cur;
                    cur = nx;
                }
                prev.next = p;
                prev = first;
            } else {
                for (int i = 0; i < cnt; i++) prev = prev.next;
            }
        }
        return head;
    }
}