#lang racket
(define (square x)
  (* x x))

(define (average x y)
  (/ (+ x y) 2))

(define (abs x)
    (cond ((< x 0) (- x))
        (else x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (new-if predicate then-clause else-clause) 
    (cond (predicate then-clause)    
        (else else-clause)))

(new-if (= 2 3) 0 5)
(new-if (= 1 1) 0 5)


(define (sqrt-iter guess x)
  (if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

(define (sqrt x)
  (sqrt-iter 1.0 x))



(sqrt 9)
(sqrt (+ 100 37))
(sqrt (+ (sqrt 2) (sqrt 3)))
(square (sqrt 1000))