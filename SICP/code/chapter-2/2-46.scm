#lang sicp

(define (make-vect xcor ycor)
  (list xcor ycor))
(define (xcor-vec vec)
  (car vec))
(define (ycor-vec vec)
  (car (cdr vec)))
(define (add-vect vec1 vec2)
  (make-vect (+ (xcor-vec vec1) (xcor-vec vec2))
             (+ (ycor-vec vec1) (ycor-vec vec2))))
(define (sub-vect vec1 vec2)
  (make-vect (- (xcor-vec vec1) (xcor-vec vec2))
             (- (ycor-vec vec1) (ycor-vec vec2))))
(define (scale-vect vec s)
  (make-vect (* s (xcor-vec vec))
             (* s (ycor-vec vec))))


(define vec1 (make-vect 1 2))
(define vec2 (make-vect 4 5))
(add-vect vec1 vec2)
(sub-vect vec1 vec2)
(scale-vect vec1 8)