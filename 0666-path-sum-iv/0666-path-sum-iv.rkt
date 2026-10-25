#|
Brute Force

(define/contract (path-sum nums)
  (-> (listof exact-integer?) exact-integer?)
  (define (depth x) (quotient x 100))
  (define (pos x) (remainder (quotient x 10) 10))
  (define (leaf? x)
    (not (for/or ([y (in-list nums)])
           (and (= (depth y) (add1 (depth x)))
                (or (= (pos y) (sub1 (* 2 (pos x))))
                    (= (pos y) (* 2 (pos x))))))))
  (define (climb d p)
    (if (zero? d)
        0
        (+ (remainder (for/first ([y (in-list nums)]
                                   #:when (and (= (depth y) d) (= (pos y) p)))
                        y)
                      10)
           (climb (sub1 d) (quotient (add1 p) 2)))))
  (for/sum ([x (in-list nums)] #:when (leaf? x))
    (climb (depth x) (pos x))))
|#

#|
Better Approach

(define/contract (path-sum nums)
  (-> (listof exact-integer?) exact-integer?)
  (define tree (for/hash ([x (in-list nums)]) (values (quotient x 10) (remainder x 10))))
  (define (dfs d p sum)
    (define key (+ (* d 10) p))
    (cond
      [(not (hash-has-key? tree key)) 0]
      [else
       (define total (+ sum (hash-ref tree key)))
       (define left (+ (* (add1 d) 10) (* 2 p) -1))
       (if (or (hash-has-key? tree left) (hash-has-key? tree (add1 left)))
           (+ (dfs (add1 d) (sub1 (* 2 p)) total) (dfs (add1 d) (* 2 p) total))
           total)]))
  (dfs 1 1 0))
|#

(define/contract (path-sum nums)
  (-> (listof exact-integer?) exact-integer?)
  (define leaves (make-vector 16 0))
  (for/sum ([x (in-list (reverse nums))])
    (define idx (+ (arithmetic-shift 1 (sub1 (quotient x 100)))
                   (remainder (quotient x 10) 10)
                   -1))
    (when (zero? (vector-ref leaves idx))
      (vector-set! leaves idx 1))
    (when (> idx 1)
      (vector-set! leaves (quotient idx 2)
                   (+ (vector-ref leaves (quotient idx 2)) (vector-ref leaves idx))))
    (* (remainder x 10) (vector-ref leaves idx))))