#lang racket
(define (square x)
  (* x x))

(define (cube x)
  (* x x x))

(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))

(define (cube-guess-op x y)
  (/ (+ (/ x (square y)) (* 2 y)) 3))

(define (improve guess x)
  (cube-guess-op x guess))

;(define (good-enough? guess x)
;  (define tolerance 0.001)
;  (< (abs (- (square guess) x)) tolerance))

;(define (good-enough? guess x) 
;  (< (abs (- x (cube guess)))
;     (* 0.0001 x)))   

(define (good-enough? guess x) 
  (= (improve guess x) guess))


(define (cube-root-iter guess x)
  (if (good-enough? guess x)
      guess
      (cube-root-iter (improve guess x)
                 x)))

(define (cube-root x)
  (if (< x 0)
      (* -1 (cube-root-iter 1.0 (abs x)))
      (cube-root-iter 1.0 x)
  ))

; test
(cube-root 27)
(cube-root -27)
(cube-root 8)
(cube-root -8)
(cube-root 5)
(cube-root -5)
(cube-root 1)
(cube-root -1000) 
(cube-root 1e-30) 
(cube-root 1e60) 
(cube-root 0)