#lang sicp
(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

; 得到 cosx 的不动点
(fixed-point cos 1.0)
; 得到 y = sin y + cos y的解
(fixed-point (lambda (y) (+ (sin y) (cos y)))
             1.0)
; 得到 phi^2 = phi + 1 的解
(fixed-point (lambda (x) (+ 1 (/ 1 x)))
             1.0)