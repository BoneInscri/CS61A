#lang sicp

; 不动点
(define tolerance 0.0000001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess step)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next (+ step 1)))))
  (try first-guess 1))

; 求导
(define (deriv g)
    (define dx 0.00001)
    (lambda (x)
            (/ (- (g (+ x dx)) (g x))
               dx)))
; 牛顿法
(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))
(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

(define (cubic a b c)
  (lambda (x) (+ (* x x x) (* a x x) (* b x) c))
  )

(newtons-method (cubic 2 3 4) 2)