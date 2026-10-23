#|
Brute Force

(define/contract (sort-permutation nums)
  (-> (listof exact-integer?) exact-integer?)
  (define n (length nums))
  (define vs (list->vector nums))
  (define (find parent x)
    (if (= (vector-ref parent x) x)
        x
        (let ([root (find parent (vector-ref parent x))])
          (vector-set! parent x root)
          root)))
  (if (for/and ([i (in-range n)]) (= (vector-ref vs i) i))
      0
      (for/first ([k (in-range (sub1 n) -1 -1)]
                  #:when
                  (let ([parent (build-vector n values)])
                    (for* ([i (in-range n)]
                           [j (in-range (add1 i) n)]
                           #:when (= (bitwise-and (vector-ref vs i) (vector-ref vs j)) k))
                      (define a (find parent (vector-ref vs i)))
                      (define b (find parent (vector-ref vs j)))
                      (vector-set! parent a b))
                    (for/and ([i (in-range n)])
                      (= (find parent (vector-ref vs i)) (find parent i)))))
        k)))
|#

#|
Better Approach

(define/contract (sort-permutation nums)
  (-> (listof exact-integer?) exact-integer?)
  (define n (length nums))
  (define misplaced
    (for/list ([v (in-list nums)] [i (in-naturals)] #:unless (= v i)) v))
  (if (null? misplaced)
      0
      (for/first ([k (in-range (sub1 n) -1 -1)]
                  #:when (for/and ([v (in-list misplaced)]) (= (bitwise-and v k) k)))
        k)))
|#

(define/contract (sort-permutation nums)
  (-> (listof exact-integer?) exact-integer?)
  (max 0
       (for/fold ([ans -1]) ([v (in-list nums)] [i (in-naturals)])
         (if (= v i) ans (bitwise-and ans v)))))