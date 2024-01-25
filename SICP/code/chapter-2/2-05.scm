#lang sicp

; 快速幂
(define (fast-expt b n)
    (define (expt-iter b counter product)
      (cond ((= counter 0) product)
            ((even? counter) (expt-iter (* b b) (/ counter 2) product))
            (else (expt-iter b (- counter 1) (* product b)))
      )) 
    (expt-iter b n 1))

; x = 2^a*3^b
; (power-of-factor x 2) -> a
; (power-of-factor x 3) -> b
(define (power-of-factor x factor)
  (if (= 0 (remainder x factor))
      (+ 1 (power-of-factor (/ x factor) factor))
      0)
  )

(define (cons a b)
  (* (fast-expt 2 a) (fast-expt 3 b)))
(define (car p)
  (power-of-factor p 2))
(define (cdr p)
  (power-of-factor p 3))

(define p (cons 3 4))
(car p)
(cdr p)