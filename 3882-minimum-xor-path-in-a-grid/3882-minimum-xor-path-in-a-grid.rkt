#|
Brute Force

(define/contract (min-cost grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define (cell i j) (vector-ref (vector-ref g i) j))
  (define (dfs i j x)
    (cond
      [(and (= i (sub1 m)) (= j (sub1 n))) x]
      [(= i (sub1 m)) (dfs i (add1 j) (bitwise-xor x (cell i (add1 j))))]
      [(= j (sub1 n)) (dfs (add1 i) j (bitwise-xor x (cell (add1 i) j)))]
      [else (min (dfs (add1 i) j (bitwise-xor x (cell (add1 i) j)))
                 (dfs i (add1 j) (bitwise-xor x (cell i (add1 j)))))]))
  (dfs 0 0 (cell 0 0)))
|#

#|
Better Approach

(define/contract (min-cost grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define (cell i j) (vector-ref (vector-ref g i) j))
  (define memo (make-vector (* m n 1024) #f))
  (define (dfs i j x)
    (define key (+ (* (+ (* i n) j) 1024) x))
    (cond
      [(and (= i (sub1 m)) (= j (sub1 n))) x]
      [(vector-ref memo key) => values]
      [else
       (define best
         (cond
           [(= i (sub1 m)) (dfs i (add1 j) (bitwise-xor x (cell i (add1 j))))]
           [(= j (sub1 n)) (dfs (add1 i) j (bitwise-xor x (cell (add1 i) j)))]
           [else (min (dfs (add1 i) j (bitwise-xor x (cell (add1 i) j)))
                      (dfs i (add1 j) (bitwise-xor x (cell i (add1 j)))))]))
       (vector-set! memo key best)
       best]))
  (dfs 0 0 (cell 0 0)))
|#

(define/contract (min-cost grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define n (length (first grid)))
  (define dp (for/vector ([j (in-range n)]) (make-vector 1024 #f)))
  (define tmp (make-vector 1024 #f))
  (for ([row grid] [i (in-naturals)])
    (for ([v row] [j (in-naturals)])
      (for ([x (in-range 1024)])
        (vector-set! tmp x (or (and (= i 0) (= j 0) (= x 0))
                               (and (> i 0) (vector-ref (vector-ref dp j) x))
                               (and (> j 0) (vector-ref (vector-ref dp (sub1 j)) x)))))
      (for ([x (in-range 1024)])
        (vector-set! (vector-ref dp j) (bitwise-xor x v) (vector-ref tmp x)))))
  (for/first ([x (in-range 1024)] #:when (vector-ref (vector-ref dp (sub1 n)) x)) x))