#lang sicp

(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

(define one (lambda (f) (lambda (x) (f x))))
(define two (lambda (f) (lambda (x) (f (f x)))))
; 调用了几次 f 就是 数字 几

(define (+ a b)
  (lambda (f)
    (lambda (x)
      ((a f) ((b f) x))))
  )