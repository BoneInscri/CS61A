#lang sicp
; vector
(define (make-vect xcor ycor)
  (list xcor ycor))
(define (xcor-vec vec)
  (car vec))
(define (ycor-vec vec)
  (car (cdr vec)))

; directed vector
(define (make-segment vect1 vect2)
  (cons vect1 vect2))
(define (start-segment segment)
  (car segment))
(define (end-segment segment)
  (cdr segment))