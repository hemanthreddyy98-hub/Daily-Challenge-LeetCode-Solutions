#|
Brute Force

(define/contract (palindrome-path n edges s queries)
  (-> exact-integer? (listof (listof exact-integer?)) string? (listof string?) (listof boolean?))
  (define g (make-vector n '()))
  (for ([e edges])
    (vector-set! g (first e) (cons (second e) (vector-ref g (first e))))
    (vector-set! g (second e) (cons (first e) (vector-ref g (second e)))))
  (define ch (for/vector ([c s]) (- (char->integer c) 97)))
  (define (bit x) (arithmetic-shift 1 (vector-ref ch x)))
  (reverse
   (for/fold ([ans '()]) ([q queries])
     (define p (string-split q))
     (define u (string->number (second p)))
     (cond
       [(string=? (first p) "update")
        (vector-set! ch u (- (char->integer (string-ref (third p) 0)) 97))
        ans]
       [else
        (define v (string->number (third p)))
        (define par (make-vector n -1))
        (vector-set! par u u)
        (let loop ([stack (list u)])
          (unless (null? stack)
            (define x (car stack))
            (define new (filter (lambda (y) (= (vector-ref par y) -1)) (vector-ref g x)))
            (for ([y new]) (vector-set! par y x))
            (loop (append new (cdr stack)))))
        (define mask
          (let walk ([x v] [m 0])
            (if (= x u)
                (bitwise-xor m (bit u))
                (walk (vector-ref par x) (bitwise-xor m (bit x))))))
        (cons (zero? (bitwise-and mask (sub1 mask))) ans)]))))
|#

#|
Better Approach

(define/contract (palindrome-path n edges s queries)
  (-> exact-integer? (listof (listof exact-integer?)) string? (listof string?) (listof boolean?))
  (define g (make-vector n '()))
  (for ([e edges])
    (vector-set! g (first e) (cons (second e) (vector-ref g (first e))))
    (vector-set! g (second e) (cons (first e) (vector-ref g (second e)))))
  (define ch (for/vector ([c s]) (- (char->integer c) 97)))
  (define (bit x) (arithmetic-shift 1 (vector-ref ch x)))
  (define par (make-vector n -1))
  (define depth (make-vector n 0))
  (vector-set! par 0 0)
  (let loop ([stack '(0)])
    (unless (null? stack)
      (define x (car stack))
      (define new (filter (lambda (y) (= (vector-ref par y) -1)) (vector-ref g x)))
      (for ([y new])
        (vector-set! par y x)
        (vector-set! depth y (add1 (vector-ref depth x))))
      (loop (append new (cdr stack)))))
  (reverse
   (for/fold ([ans '()]) ([q queries])
     (define p (string-split q))
     (define u (string->number (second p)))
     (cond
       [(string=? (first p) "update")
        (vector-set! ch u (- (char->integer (string-ref (third p) 0)) 97))
        ans]
       [else
        (define mask
          (let climb ([a u] [b (string->number (third p))] [m 0])
            (cond
              [(= a b) (bitwise-xor m (bit a))]
              [(< (vector-ref depth a) (vector-ref depth b)) (climb b a m)]
              [else (climb (vector-ref par a) b (bitwise-xor m (bit a)))])))
        (cons (zero? (bitwise-and mask (sub1 mask))) ans)]))))
|#

(define/contract (palindrome-path n edges s queries)
  (-> exact-integer? (listof (listof exact-integer?)) string? (listof string?) (listof boolean?))
  (define g (make-vector n '()))
  (for ([e edges])
    (vector-set! g (first e) (cons (second e) (vector-ref g (first e))))
    (vector-set! g (second e) (cons (first e) (vector-ref g (second e)))))
  (define ch (for/vector ([c s]) (- (char->integer c) 97)))
  (define (bit x) (arithmetic-shift 1 (vector-ref ch x)))
  (define lg 17)
  (define up (for/vector ([k lg]) (make-vector n 0)))
  (define depth (make-vector n 0))
  (define tin (make-vector n 0))
  (define size (make-vector n 1))
  (define seen (make-vector n #f))
  (vector-set! seen 0 #t)
  (define rev
    (let loop ([stack '(0)] [acc '()])
      (if (null? stack)
          acc
          (let* ([x (car stack)]
                 [new (filter (lambda (y) (not (vector-ref seen y))) (vector-ref g x))])
            (for ([y new])
              (vector-set! seen y #t)
              (vector-set! (vector-ref up 0) y x)
              (vector-set! depth y (add1 (vector-ref depth x))))
            (loop (append new (cdr stack)) (cons x acc))))))
  (for ([x (reverse rev)] [i (in-naturals)])
    (vector-set! tin x i))
  (for ([x rev] #:unless (= x 0))
    (define p (vector-ref (vector-ref up 0) x))
    (vector-set! size p (+ (vector-ref size p) (vector-ref size x))))
  (for* ([k (in-range 1 lg)] [x (in-range n)])
    (define prev (vector-ref up (sub1 k)))
    (vector-set! (vector-ref up k) x (vector-ref prev (vector-ref prev x))))
  (define tree (make-vector (add1 n) 0))
  (define (add! i d)
    (when (<= i n)
      (vector-set! tree i (bitwise-xor (vector-ref tree i) d))
      (add! (+ i (bitwise-and i (- i))) d)))
  (define (range-xor! x d)
    (add! (add1 (vector-ref tin x)) d)
    (add! (+ (vector-ref tin x) (vector-ref size x) 1) d))
  (define (prefix i)
    (if (= i 0)
        0
        (bitwise-xor (vector-ref tree i) (prefix (- i (bitwise-and i (- i)))))))
  (define (lca a b)
    (cond
      [(< (vector-ref depth a) (vector-ref depth b)) (lca b a)]
      [else
       (define a1
         (for/fold ([a a]) ([k (in-range (sub1 lg) -1 -1)])
           (if (>= (- (vector-ref depth a) (arithmetic-shift 1 k)) (vector-ref depth b))
               (vector-ref (vector-ref up k) a)
               a)))
       (if (= a1 b)
           a1
           (let-values ([(x y) (for/fold ([x a1] [y b]) ([k (in-range (sub1 lg) -1 -1)])
                                 (define row (vector-ref up k))
                                 (if (= (vector-ref row x) (vector-ref row y))
                                     (values x y)
                                     (values (vector-ref row x) (vector-ref row y))))])
             (vector-ref (vector-ref up 0) x)))]))
  (for ([x (in-range n)])
    (range-xor! x (bit x)))
  (reverse
   (for/fold ([ans '()]) ([q queries])
     (define p (string-split q))
     (define u (string->number (second p)))
     (cond
       [(string=? (first p) "update")
        (define c (- (char->integer (string-ref (third p) 0)) 97))
        (range-xor! u (bitwise-xor (bit u) (arithmetic-shift 1 c)))
        (vector-set! ch u c)
        ans]
       [else
        (define v (string->number (third p)))
        (define mask
          (bitwise-xor (prefix (add1 (vector-ref tin u)))
                       (prefix (add1 (vector-ref tin v)))
                       (bit (lca u v))))
        (cons (zero? (bitwise-and mask (sub1 mask))) ans)]))))