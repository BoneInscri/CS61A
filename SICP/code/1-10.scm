#lang racket
(define (A x y)
    (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))

; test
(A 1 10)
(A 2 4)
(A 3 3)

(define (f n) (A 0 n))
(define (g n) (A 1 n))
(define (h n) (A 2 n))
(define (k n) (* 5 n n))

(f 10)
(f 20)
(f 40)

(g 2)
(g 4)
(g 8)

(h 0)
(h 1)
(h 2)
(h 3)
(h 4)