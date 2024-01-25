#lang sicp

(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

(define (cdr z)
  (z (lambda (p q) q))
  )

(define p (cons 1 2))
(car p)
(cdr p)
; 是正确的