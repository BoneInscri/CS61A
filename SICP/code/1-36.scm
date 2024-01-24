#lang sicp

(define (report-iter-f n step)
  (newline)
  (display n)
  (display ", step : ")
  (display step))

(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess step)
    (let ((next (f guess)))
      (report-iter-f next step)
      (if (close-enough? guess next)
          next
          (try next (+ step 1)))))
  (try first-guess 1))

(define (average x y) (/ (+ x y) 2))
; 得到 x^x = 1000 的解
(fixed-point (lambda (x)  (/ (log 1000) (log x)))
             2.0)
(fixed-point (lambda (x)  (average x (/ (log 1000) (log x))))
             2.0)
