#lang sicp

(define (square x)
  (* x x))

(define (average x y)
  (/ (+ x y) 2))

(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))

;(define (good-enough? guess x)
;  (define tolerance 0.001)
;  (< (abs (- (square guess) x)) tolerance))

;(define (good-enough? guess x) 
;  (= (improve guess x) guess))

;(define (sqrt x)
;  (define tolerance 0.0001)
;  (define (good-enough? guess) 
;    (< (abs (- x (square guess)))
;       (* tolerance x)))   
;  (define (improve guess)
;    (average guess (/ x guess)))
;  (define (sqrt-iter guess)
;    (if (good-enough? guess x)
;        guess
;        (sqrt-iter (improve guess x))))
;  (sqrt-iter 1.0))

;(define (fixed-point f first-guess)
;  (define (close-enough? v1 v2)
;    (define tolerance 0.00001)
;    (< (abs (- v1 v2)) tolerance))
;  (define (try guess)
;    (let ((next (f guess)))
;      (if (close-enough? guess next)
;          next
;          (try next))))
;  (try first-guess))

; 迭代改进的抽象过程
(define (iterative-improve good-enough? improve)
  (define (iter guess)
    (if (good-enough? guess)
        guess
        (iter (improve guess)))
    )
  (lambda (guess)
    (iter guess)))

; 使用抽象过程重写sqrt
(define (sqrt x)
  (define (good-enough? guess)    
    (define tolerance 0.0001)
    (< (abs (- x (square guess)))
       (* tolerance x)))
  (define (improve guess)
    (average guess (/ x guess)))
  ((iterative-improve good-enough? improve) x))

; 使用抽象过程重写fixed-point
(define (fixed-point f guess)
  (define (good-enough? guess)
    (define tolerance 0.00001)
    (< (abs (- guess (f guess))) tolerance))
  (define (improve guess)
    (f guess))
  ((iterative-improve good-enough? improve) guess))


(sqrt 2)

(define (fixed-point-sqrt x)
  (fixed-point (lambda (y) (average y (/ x y)))
               1.0))

(fixed-point-sqrt 2)