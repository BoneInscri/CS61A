#lang sicp

(define (compose f g)
  (lambda (x) (f (g x)))
  )

(define (repeated f n)
  (define (iter g count)
    (if (= count 0)
        g
        (iter (compose f g) (- count 1))
        )
    )
  (iter f (- n 1)))

(define (square x) (* x x))
((repeated square 2) 5)