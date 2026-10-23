class Solution {
    public String removeOccurrences(String s, String part) {
        StringBuilder sb = new StringBuilder();
        int k = part.length();
        for (char c : s.toCharArray()) {
            sb.append(c);
            if (sb.length() >= k && sb.substring(sb.length() - k).equals(part)) sb.setLength(sb.length() - k);
        }
        return sb.toString();
    }
}