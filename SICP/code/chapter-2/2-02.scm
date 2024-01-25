#lang sicp

(define (average x y) (/ (+ x y) 2))

; point
(define (make-point x y)
  (cons x y))
(define (x-point x) (car x))
(define (y-point x) (cdr x))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

; segment
(define (make-segment start-point end-point)
  (cons start-point end-point))
(define (start-segment x) (car x))
(define (end-segment x) (cdr x))

(define (midpoint-segment line)
  (make-point (average (x-point (start-segment line))
                       (x-point (end-segment line)))
              (average (y-point (start-segment line))
                       (y-point (end-segment line))))
  )

(define (print-segment p)
  (newline)
  (display "start point : ")
  (print-point (start-segment p))
  (newline)
  (display "end point : ")
  (print-point (end-segment p)))


; test
(define x (make-point 1 1))
(define y (make-point 5 5))
(define l1 (make-segment x y))
(define midpoint (midpoint-segment l1))
(print-segment l1)
(print-point midpoint)