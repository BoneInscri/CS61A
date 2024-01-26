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

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))
; 倒数
(define (reciprocal i)
  (div-interval (make-interval 1 1) i))

(define R1 (make-interval 6.12 7.48))
(define R2 (make-interval 4.465 4.935))

(define Rp (reciprocal
            (add-interval (reciprocal R1) (reciprocal R2))))

(print-interval Rp)