#lang sicp

(define (reverse items) 
  (define (iter items result) 
    (if (null? items) 
        result 
        (iter (cdr items) (cons (car items) result))))   
  (iter items nil))

(define x (list (list 1 2) (list 3 4)))
x

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (deep-reverse items)
  (map (lambda (x) (reverse x)) items))


(reverse x)
; ((3 4) (1 2))

(deep-reverse x)
; ((4 3) (2 1))