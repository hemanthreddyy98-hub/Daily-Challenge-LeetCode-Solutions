#|
Brute Force

(define/contract (shortest-path n edges labels k)
  (-> exact-integer? (listof (listof exact-integer?)) string? exact-integer? exact-integer?)
  (define inf (expt 10 18))
  (define dist (for/vector ([i n]) (make-vector (add1 k) inf)))
  (vector-set! (vector-ref dist 0) 1 0)
  (let loop ()
    (define changed
      (for*/fold ([changed #f]) ([e edges] [run (in-range 1 (add1 k))])
        (define-values (u v w) (values (first e) (second e) (third e)))
        (define d (vector-ref (vector-ref dist u) run))
        (define next (if (char=? (string-ref labels v) (string-ref labels u)) (add1 run) 1))
        (cond
          [(and (< d inf) (<= next k) (< (+ d w) (vector-ref (vector-ref dist v) next)))
           (vector-set! (vector-ref dist v) next (+ d w))
           #t]
          [else changed])))
    (when changed (loop)))
  (define ans (for/fold ([m inf]) ([run (in-range 1 (add1 k))]) (min m (vector-ref (vector-ref dist (sub1 n)) run))))
  (if (= ans inf) -1 ans))
|#

#|
Better Approach

(require data/heap)

(define/contract (shortest-path n edges labels k)
  (-> exact-integer? (listof (listof exact-integer?)) string? exact-integer? exact-integer?)
  (define g (make-vector n '()))
  (for ([e edges])
    (vector-set! g (first e) (cons (cons (second e) (third e)) (vector-ref g (first e)))))
  (define pq (make-heap (lambda (a b) (<= (vector-ref a 0) (vector-ref b 0)))))
  (define dist (for/vector ([i n]) (make-vector (add1 k) +inf.0)))
  (vector-set! (vector-ref dist 0) 1 0)
  (heap-add! pq (vector 0 0 1))
  (let loop ()
    (if (zero? (heap-count pq))
        -1
        (let* ([top (heap-min pq)]
               [d (vector-ref top 0)]
               [u (vector-ref top 1)]
               [run (vector-ref top 2)])
          (heap-remove-min! pq)
          (cond
            [(= u (sub1 n)) d]
            [(> d (vector-ref (vector-ref dist u) run)) (loop)]
            [else
             (for ([p (vector-ref g u)])
               (define v (car p))
               (define next (if (char=? (string-ref labels v) (string-ref labels u)) (add1 run) 1))
               (define nd (+ d (cdr p)))
               (when (and (<= next k) (< nd (vector-ref (vector-ref dist v) next)))
                 (vector-set! (vector-ref dist v) next nd)
                 (heap-add! pq (vector nd v next))))
             (loop)])))))
|#

(require data/heap)

(define/contract (shortest-path n edges labels k)
  (-> exact-integer? (listof (listof exact-integer?)) string? exact-integer? exact-integer?)
  (define g (make-vector n '()))
  (for ([e edges])
    (vector-set! g (first e) (cons (cons (second e) (third e)) (vector-ref g (first e)))))
  (define pq (make-heap (lambda (a b) (<= (vector-ref a 0) (vector-ref b 0)))))
  (define best (make-vector n (add1 k)))
  (heap-add! pq (vector 0 0 1))
  (let loop ()
    (if (zero? (heap-count pq))
        -1
        (let* ([top (heap-min pq)]
               [d (vector-ref top 0)]
               [u (vector-ref top 1)]
               [run (vector-ref top 2)])
          (heap-remove-min! pq)
          (cond
            [(>= run (vector-ref best u)) (loop)]
            [(= u (sub1 n)) d]
            [else
             (vector-set! best u run)
             (for ([p (vector-ref g u)])
               (define v (car p))
               (define next (if (char=? (string-ref labels v) (string-ref labels u)) (add1 run) 1))
               (when (and (<= next k) (< next (vector-ref best v)))
                 (heap-add! pq (vector (+ d (cdr p)) v next))))
             (loop)])))))