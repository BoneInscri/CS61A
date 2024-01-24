#lang sicp
(define (inc n) (+ n 1))
(define (identity x) x)

; r : recursive
; i : iterative
(define (accumulate-r combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
         (accumulate-r combiner null-value term (next a) next b)))
  )

(define (accumulate-i combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner (term a) result))))
  (iter a null-value)
  )

(define (sum-r a b)
  (accumulate-r + 0 identity a inc b)
  )

(define (sum-i a b)
  (accumulate-i + 0 identity a inc b)
  )

(define (product-r a b)
  (accumulate-r * 1 identity a inc b)
  )

(define (product-i a b)
  (accumulate-i * 1 identity a inc b)
  )

(sum-r 1 5)
(sum-i 1 5)

(product-r 1 5)
(product-i 1 5)