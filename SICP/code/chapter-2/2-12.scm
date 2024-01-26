#lang sicp

(define (average x y)
  (/ (+ x y) 2))

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

; Percent is between 0 and 1 
(define (make-interval-percent center tolerance)
  (define width (* center tolerance))
  (make-interval (- center width) (+ center width)))

(define (center-interval i) (average (lower-bound i) (upper-bound i)))

(define (percent i)
  (define lower (lower-bound i))
  (define upper (upper-bound i))
  (let ((center (average lower upper))
        (width (/ (- upper lower) 2)))
    (/ width center)))

(define I1 (make-interval-percent 3.0 0.1))
(percent I1)
(center-interval I1)

(print-interval I1)