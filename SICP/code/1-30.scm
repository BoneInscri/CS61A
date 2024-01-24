#lang sicp
(define (inc n) (+ n 1))
(define (identity x) x)

(define (sum-r term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum-r term (next a) next b))))

(define (sum-i term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ (term a) result))))
  (iter a 0))

(define (sum-integers-r a b)
    (sum-r identity a inc b))

(define (sum-integers-i a b)
    (sum-i identity a inc b))

  
(sum-integers-r 1 10)
(sum-integers-i 1 10)
  
; 55
