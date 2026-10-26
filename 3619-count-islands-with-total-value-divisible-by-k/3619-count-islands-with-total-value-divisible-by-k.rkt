#|
Brute Force

(define/contract (count-islands grid k)
  (-> (listof (listof exact-integer?)) exact-integer? exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define (val r c) (vector-ref (vector-ref g r) c))
  (define (land? r c) (and (>= r 0) (>= c 0) (< r m) (< c n) (> (val r c) 0)))
  (for*/sum ([i (in-range m)]
             [j (in-range n)]
             #:when (land? i j))
    (define seen (make-vector (* m n) #f))
    (vector-set! seen (+ (* i n) j) #t)
    (let loop ([stack (list (cons i j))] [sum 0] [first? #t])
      (if (null? stack)
          (if (and first? (zero? (remainder sum k))) 1 0)
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
                  (+ sum (val r c))
                  (and first? (>= (+ (* r n) c) (+ (* i n) j)))))))))
|#

#|
Better Approach

(define/contract (count-islands grid k)
  (-> (listof (listof exact-integer?)) exact-integer? exact-integer?)
  (define g (for/vector ([row grid]) (list->vector row)))
  (define m (vector-length g))
  (define n (vector-length (vector-ref g 0)))
  (define visited (for/vector ([i (in-range m)]) (make-vector n #f)))
  (define (val r c) (vector-ref (vector-ref g r) c))
  (define (open? r c)
    (and (>= r 0) (>= c 0) (< r m) (< c n) (> (val r c) 0)
         (not (vector-ref (vector-ref visited r) c))))
  (define (mark! r c) (vector-set! (vector-ref visited r) c #t))
  (for*/sum ([i (in-range m)]
             [j (in-range n)]
             #:when (open? i j))
    (mark! i j)
    (let bfs ([queue (list (cons i j))] [sum 0])
      (if (null? queue)
          (if (zero? (remainder sum k)) 1 0)
          (bfs (for*/list ([cell (in-list queue)]
                           [d (in-list '((1 . 0) (-1 . 0) (0 . 1) (0 . -1)))]
                           [r (in-value (+ (car cell) (car d)))]
                           [c (in-value (+ (cdr cell) (cdr d)))]
                           #:when (open? r c))
                 (mark! r c)
                 (cons r c))
               (+ sum (for/sum ([cell (in-list queue)]) (val (car cell) (cdr cell)))))))))
|#

(define/contract (count-islands grid k)
  (-> (listof (listof exact-integer?)) exact-integer? exact-integer?)
  (define m (length grid))
  (define n (length (car grid)))
  (define cells (list->vector (apply append grid)))
  (define q (make-vector (* m n) 0))
  (for/sum ([id (in-range (* m n))]
            #:when (> (vector-ref cells id) 0))
    (define start (remainder (vector-ref cells id) k))
    (vector-set! cells id 0)
    (vector-set! q 0 id)
    (let loop ([head 0] [tail 1] [sum start])
      (if (= head tail)
          (if (zero? sum) 1 0)
          (let*-values ([(cur) (vector-ref q head)]
                        [(r) (quotient cur n)]
                        [(c) (remainder cur n)]
                        [(new-tail new-sum)
                         (for/fold ([t tail] [s sum])
                                   ([d (in-list '((1 . 0) (-1 . 0) (0 . 1) (0 . -1)))])
                           (define nr (+ r (car d)))
                           (define nc (+ c (cdr d)))
                           (define nid (+ (* nr n) nc))
                           (if (and (>= nr 0) (>= nc 0) (< nr m) (< nc n) (> (vector-ref cells nid) 0))
                               (let ([v (vector-ref cells nid)])
                                 (vector-set! cells nid 0)
                                 (vector-set! q t nid)
                                 (values (add1 t) (remainder (+ s v) k)))
                               (values t s)))])
            (loop (add1 head) new-tail new-sum))))))