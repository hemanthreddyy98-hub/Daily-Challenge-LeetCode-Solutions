#|
Brute Force

(define/contract (get-food grid)
  (-> (listof (listof char?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define best #f)
  (define (dfs r c steps)
    (when (and (>= r 0) (>= c 0) (< r m) (< c n))
      (define ch (vector-ref (vector-ref g r) c))
      (cond
        [(or (char=? ch #\X) (char=? ch #\V)) (void)]
        [(char=? ch #\#) (set! best (if best (min best steps) steps))]
        [else
         (vector-set! (vector-ref g r) c #\V)
         (dfs (add1 r) c (add1 steps))
         (dfs (sub1 r) c (add1 steps))
         (dfs r (add1 c) (add1 steps))
         (dfs r (sub1 c) (add1 steps))
         (vector-set! (vector-ref g r) c ch)])))
  (for* ([i (in-range m)]
         [j (in-range n)]
         #:when (char=? (vector-ref (vector-ref g i) j) #\*))
    (dfs i j 0))
  (or best -1))
|#

#|
Basic Approach

(define/contract (get-food grid)
  (-> (listof (listof char?)) exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define visited (for/vector ([i (in-range m)]) (make-vector n #f)))
  (define start
    (for*/list ([i (in-range m)]
                [j (in-range n)]
                #:when (char=? (vector-ref (vector-ref g i) j) #\*))
      (vector-set! (vector-ref visited i) j #t)
      (cons i j)))
  (let loop ([queue start] [steps 0])
    (cond
      [(null? queue) -1]
      [(for/or ([cell queue])
         (char=? (vector-ref (vector-ref g (car cell)) (cdr cell)) #\#))
       steps]
      [else
       (loop
        (for*/list ([cell queue]
                    [d '((1 . 0) (-1 . 0) (0 . 1) (0 . -1))]
                    [r (in-value (+ (car cell) (car d)))]
                    [c (in-value (+ (cdr cell) (cdr d)))]
                    #:when (and (>= r 0) (>= c 0) (< r m) (< c n)
                                (not (vector-ref (vector-ref visited r) c))
                                (not (char=? (vector-ref (vector-ref g r) c) #\X))))
          (vector-set! (vector-ref visited r) c #t)
          (cons r c))
        (add1 steps))])))
|#

(define/contract (get-food grid)
  (-> (listof (listof char?)) exact-integer?)
  (let* ([m (length grid)]
         [n (length (car grid))]
         [cells (list->vector (apply append grid))]
         [start (for/first ([ch (in-vector cells)]
                            [i (in-naturals)]
                            #:when (char=? ch #\*))
                  i)])
    (if (not start)
        -1
        (let ([q (make-vector (* m n) 0)])
          (vector-set! q 0 start)
          (let/ec return
            (let level ([head 0] [tail 1] [steps 1])
              (when (< head tail)
                (define new-tail
                  (for/fold ([t tail]) ([pos (in-range head tail)])
                    (define id (vector-ref q pos))
                    (define r (quotient id n))
                    (define c (remainder id n))
                    (for/fold ([t t])
                              ([d (in-list '((1 . 0) (-1 . 0) (0 . 1) (0 . -1)))])
                      (define nr (+ r (car d)))
                      (define nc (+ c (cdr d)))
                      (if (and (>= nr 0) (>= nc 0) (< nr m) (< nc n))
                          (let* ([nid (+ (* nr n) nc)]
                                 [ch (vector-ref cells nid)])
                            (cond
                              [(char=? ch #\#) (return steps)]
                              [(char=? ch #\O)
                               (vector-set! cells nid #\X)
                               (vector-set! q t nid)
                               (add1 t)]
                              [else t]))
                          t))))
                (level tail new-tail (add1 steps))))
            -1)))))