#lang sicp

(define (make-interval a b) (cons a b))
(define (lower-bound i)
  (car i))
(define (upper-bound i)
  (cdr i))

(define (print-interval p)
  (display "[")
  (display (lower-bound p))
  (display ",")
  (display (upper-bound p))
  (display "]")
  )

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))

(define I1 (make-interval 1 3))
(define I2 (make-interval 2 4))
(define R (sub-interval I1 I2))
(print-interval R)