#|
Brute Force

(define/contract (count-days-together arriveAlice leaveAlice arriveBob leaveBob)
  (-> string? string? string? string? exact-integer?)
  (define days #(31 28 31 30 31 30 31 31 30 31 30 31))
  (define (pad n) (~r n #:min-width 2 #:pad-string "0"))
  (for*/sum ([m (in-range 12)]
             [d (in-range 1 (add1 (vector-ref days m)))])
    (define date (string-append (pad (add1 m)) "-" (pad d)))
    (if (and (string<=? arriveAlice date leaveAlice)
             (string<=? arriveBob date leaveBob))
        1
        0)))
|#

#|
Better Approach

(define/contract (count-days-together arriveAlice leaveAlice arriveBob leaveBob)
  (-> string? string? string? string? exact-integer?)
  (define days #(31 28 31 30 31 30 31 31 30 31 30 31))
  (define (to-day date)
    (define month (string->number (substring date 0 2)))
    (define day (string->number (substring date 3 5)))
    (+ day (for/sum ([m (in-range (sub1 month))]) (vector-ref days m))))
  (max 0 (+ 1 (- (min (to-day leaveAlice) (to-day leaveBob))
                 (max (to-day arriveAlice) (to-day arriveBob))))))
|#

(define/contract (count-days-together arriveAlice leaveAlice arriveBob leaveBob)
  (-> string? string? string? string? exact-integer?)
  (define start (if (string>? arriveAlice arriveBob) arriveAlice arriveBob))
  (define end (if (string<? leaveAlice leaveBob) leaveAlice leaveBob))
  (define prefix #(0 31 59 90 120 151 181 212 243 273 304 334))
  (define (digit s i) (- (char->integer (string-ref s i)) 48))
  (define (day-of-year s)
    (+ (vector-ref prefix (sub1 (+ (* 10 (digit s 0)) (digit s 1))))
       (* 10 (digit s 3))
       (digit s 4)))
  (if (string>? start end)
      0
      (+ 1 (- (day-of-year end) (day-of-year start)))))