#lang sicp

(define (make-accumulator sum)
  (lambda (number)
    (begin (set! sum (+ sum number))
           sum)    
    ))

(define A (make-accumulator 5))
(A 10)
(A 10)