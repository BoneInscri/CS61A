#lang sicp

; prime?
(define (prime? n)
  (define (square x) (* x x))
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (smallest-divisor n)
    (define (find-divisor test-divisor)
      (cond 
        ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor (+ test-divisor 1)))))
    (find-divisor 2))
  (= n (smallest-divisor n)))

; stream
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

; map for stream
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

; filter for stream
(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

; interleaving s1 and s2
(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

; add two streams
(define (add-streams s1 s2)
  (stream-map + s1 s2))

; ones stream
(define ones (cons-stream 1 ones))

; infinite stream starting from 1
(define integers (cons-stream 1 (add-streams ones integers)))

; display stream specially for infinite stream
(define (display-stream-cnt s cnt)
  (define (stream-for-each-cnt proc s cnt)
    (if (or (stream-null? s) (= cnt 0))
        'done
        (begin (proc (stream-car s))
               (stream-for-each-cnt proc (stream-cdr s) (- cnt 1)))
        )
    )
  (define (show x)
    (display x)
    (newline)
    x)
  (stream-for-each-cnt show s cnt)
  )

; pairs
(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

(display-stream-cnt (pairs integers integers) 30)

(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
        ((stream-null? s2) s1)
        (else
         (let ((s1car (stream-car s1))
               (s2car (stream-car s2)))
           (cond ((< (weight s1car) (weight s2car))
                  (cons-stream s1car (merge-weighted (stream-cdr s1) s2 weight)))
                 ((> (weight s1car) (weight s2car))
                  (cons-stream s2car (merge-weighted s1 (stream-cdr s2) weight)))
                 (else
                  (cons-stream s1car
                               (cons-stream s2car
                                            (merge-weighted (stream-cdr s1) (stream-cdr s2) weight))
                               )
                  )
                 )
           )
         )
        )  
  )

; weighted-pairs
(define (weighted-pairs s t weight)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
    (stream-map (lambda (x) (list (stream-car s) x))
                (stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
    weight
    )
   )
  )
(define (cube x) (* x x x))
(define (cube-sum x y) (+ (cube x) (cube y)))
(define test-tmp (weighted-pairs integers integers (lambda (x) (cube-sum (car x) (cadr x)))))
(define test (stream-map (lambda (x) (cube-sum (car x) (cadr x))) test-tmp) )

(define (iter s)
  (if (stream-null? s)
      (error "not tested")
      (let ((i (stream-car s))
            (j (stream-car (stream-cdr s)))
            )
        (if (= i j)
            (cons-stream i
                         (iter (stream-cdr s))
                         )
            (iter (stream-cdr s))
            )
        )
      )
)

(define Ramanujan
  (iter test)
  )

(display-stream-cnt Ramanujan 10)