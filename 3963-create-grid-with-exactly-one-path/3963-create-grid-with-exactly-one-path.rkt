#|
Brute Force

(define/contract (create-grid m n)
  (-> exact-integer? exact-integer? (listof string?))
  (define g (for/vector ([i (in-range m)]) (make-string n #\.)))
  (define (reach? r c)
    (cond
      [(or (>= r m) (>= c n)) #f]
      [(char=? (string-ref (vector-ref g r) c) #\#) #f]
      [(and (= r (sub1 m)) (= c (sub1 n))) #t]
      [else (or (reach? (add1 r) c) (reach? r (add1 c)))]))
  (for* ([i (in-range m)]
         [j (in-range n)]
         #:unless (or (and (= i 0) (= j 0)) (and (= i (sub1 m)) (= j (sub1 n)))))
    (string-set! (vector-ref g i) j #\#)
    (unless (reach? 0 0)
      (string-set! (vector-ref g i) j #\.)))
  (map string->immutable-string (vector->list g)))
|#

#|
Better Approach

(define/contract (create-grid m n)
  (-> exact-integer? exact-integer? (listof string?))
  (define g (for/vector ([i (in-range m)]) (make-string n #\.)))
  (define (reach?)
    (define ok (make-vector (* m n) #f))
    (for* ([i (in-range m)]
           [j (in-range n)]
           #:unless (char=? (string-ref (vector-ref g i) j) #\#))
      (vector-set! ok (+ (* i n) j)
                   (or (and (= i 0) (= j 0))
                       (and (> i 0) (vector-ref ok (+ (* (sub1 i) n) j)))
                       (and (> j 0) (vector-ref ok (+ (* i n) (sub1 j)))))))
    (vector-ref ok (sub1 (* m n))))
  (for* ([i (in-range m)]
         [j (in-range n)]
         #:unless (or (and (= i 0) (= j 0)) (and (= i (sub1 m)) (= j (sub1 n)))))
    (string-set! (vector-ref g i) j #\#)
    (unless (reach?)
      (string-set! (vector-ref g i) j #\.)))
  (map string->immutable-string (vector->list g)))
|#

(define/contract (create-grid m n)
  (-> exact-integer? exact-integer? (listof string?))
  (cons (make-string n #\.)
        (for/list ([i (in-range (sub1 m))])
          (string-append (make-string (sub1 n) #\#) "."))))