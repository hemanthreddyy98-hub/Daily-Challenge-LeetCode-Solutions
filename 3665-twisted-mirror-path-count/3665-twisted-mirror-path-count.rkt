#|
Brute Force

(define/contract (unique-paths grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define (dfs i j d)
    (cond
      [(or (>= i m) (>= j n)) 0]
      [(and (= i (sub1 m)) (= j (sub1 n))) 1]
      [(= (vector-ref (vector-ref g i) j) 0) (modulo (+ (dfs i (add1 j) 0) (dfs (add1 i) j 1)) 1000000007)]
      [(= d 0) (dfs (add1 i) j 1)]
      [else (dfs i (add1 j) 0)]))
  (dfs 0 0 0))
|#

#|
Better Approach

(define/contract (unique-paths grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define memo (make-vector (* m n 2) -1))
  (define (dfs i j d)
    (cond
      [(or (>= i m) (>= j n)) 0]
      [(and (= i (sub1 m)) (= j (sub1 n))) 1]
      [else
       (define key (+ (* (+ (* i n) j) 2) d))
       (when (= (vector-ref memo key) -1)
         (vector-set! memo key
                      (cond
                        [(= (vector-ref (vector-ref g i) j) 0)
                         (modulo (+ (dfs i (add1 j) 0) (dfs (add1 i) j 1)) 1000000007)]
                        [(= d 0) (dfs (add1 i) j 1)]
                        [else (dfs i (add1 j) 0)])))
       (vector-ref memo key)]))
  (dfs 0 0 0))
|#

(define/contract (unique-paths grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define r (make-vector n 0))
  (define d (make-vector n 0))
  (for* ([i (in-range m)] [j (in-range n)])
    (cond
      [(and (= i 0) (= j 0)) (vector-set! r 0 1)]
      [else
       (define nd
         (cond
           [(= i 0) 0]
           [(= (vector-ref (vector-ref g (sub1 i)) j) 0) (modulo (+ (vector-ref r j) (vector-ref d j)) 1000000007)]
           [else (vector-ref r j)]))
       (define nr
         (cond
           [(= j 0) 0]
           [(= (vector-ref (vector-ref g i) (sub1 j)) 0)
            (modulo (+ (vector-ref r (sub1 j)) (vector-ref d (sub1 j))) 1000000007)]
           [else (vector-ref d (sub1 j))]))
       (vector-set! r j nr)
       (vector-set! d j nd)]))
  (modulo (+ (vector-ref r (sub1 n)) (vector-ref d (sub1 n))) 1000000007))