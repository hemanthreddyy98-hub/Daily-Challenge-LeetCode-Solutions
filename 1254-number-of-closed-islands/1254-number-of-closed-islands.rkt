#|
Brute Force

(define/contract (closed-island grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define (land? r c)
    (and (>= r 0) (>= c 0) (< r m) (< c n) (= (vector-ref (vector-ref g r) c) 0)))
  (for*/sum ([i (in-range m)]
             [j (in-range n)]
             #:when (land? i j))
    (define seen (make-vector (* m n) #f))
    (vector-set! seen (+ (* i n) j) #t)
    (let loop ([stack (list (cons i j))] [closed #t] [first? #t])
      (if (null? stack)
          (if (and closed first?) 1 0)
          (let* ([r (caar stack)]
                 [c (cdar stack)]
                 [next (for/list ([d '((1 . 0) (-1 . 0) (0 . 1) (0 . -1))]
                                  #:when (land? (+ r (car d)) (+ c (cdr d)))
                                  #:unless (vector-ref seen (+ (* (+ r (car d)) n) (+ c (cdr d)))))
                         (define nr (+ r (car d)))
                         (define nc (+ c (cdr d)))
                         (vector-set! seen (+ (* nr n) nc) #t)
                         (cons nr nc))])
            (loop (append next (cdr stack))
                  (and closed (> r 0) (> c 0) (< r (sub1 m)) (< c (sub1 n)))
                  (and first? (>= (+ (* r n) c) (+ (* i n) j)))))))))
|#

#|
Better Approach

(define/contract (closed-island grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define (sink r c)
    (when (and (>= r 0) (>= c 0) (< r m) (< c n) (= (vector-ref (vector-ref g r) c) 0))
      (vector-set! (vector-ref g r) c 1)
      (sink (add1 r) c)
      (sink (sub1 r) c)
      (sink r (add1 c))
      (sink r (sub1 c))))
  (for ([i (in-range m)])
    (sink i 0)
    (sink i (sub1 n)))
  (for ([j (in-range n)])
    (sink 0 j)
    (sink (sub1 m) j))
  (for*/sum ([i (in-range m)]
             [j (in-range n)]
             #:when (= (vector-ref (vector-ref g i) j) 0))
    (sink i j)
    1))
|#

(define/contract (closed-island grid)
  (-> (listof (listof exact-integer?)) exact-integer?)
  (define m (length grid))
  (define n (length (car grid)))
  (define cells (list->vector (apply append grid)))
  (define q (make-vector (* m n) 0))
  (for/sum ([id (in-range (* m n))]
            #:when (= (vector-ref cells id) 0))
    (vector-set! cells id 1)
    (vector-set! q 0 id)
    (let loop ([head 0] [tail 1] [closed #t])
      (if (= head tail)
          (if closed 1 0)
          (let* ([cur (vector-ref q head)]
                 [r (quotient cur n)]
                 [c (remainder cur n)]
                 [new-tail
                  (for/fold ([t tail]) ([d (in-list '((1 . 0) (-1 . 0) (0 . 1) (0 . -1)))])
                    (define nr (+ r (car d)))
                    (define nc (+ c (cdr d)))
                    (cond
                      [(and (>= nr 0) (>= nc 0) (< nr m) (< nc n)
                            (= (vector-ref cells (+ (* nr n) nc)) 0))
                       (vector-set! cells (+ (* nr n) nc) 1)
                       (vector-set! q t (+ (* nr n) nc))
                       (add1 t)]
                      [else t]))])
            (loop (add1 head) new-tail
                  (and closed (> r 0) (> c 0) (< r (sub1 m)) (< c (sub1 n)))))))))