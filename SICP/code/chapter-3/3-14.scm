#lang sicp

(define v (list 'a 'b 'c 'd))


(define (mystery x)
  (define (loop x y)
    (display v)
    (newline)
    (if (null? x)
        y
        (let ((temp (cdr x)))
          (set-cdr! x y)
          (loop temp x))))
  (loop x '()))


v
(define w (mystery v))

v
w