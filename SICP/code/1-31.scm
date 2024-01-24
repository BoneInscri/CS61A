#lang sicp
(define (square x) (* x x))
(define (inc-2 n) (+ n 2))
(define (inc-1 n) (+ n 1))
(define (identity x) x)

(define (product-r term a next b)
  (if (> a b)
      1
      (* (term a)
         (product-r term (next a) next b))))

(define (product-i term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (factorial-r n)
  (product-r identity 1 inc-1 n))

(define (factorial-i n)
  (product-i identity 1 inc-1 n))

; p : precision. the larger, the better.
(define (pi prod-f p)
  (define prod-even
    (prod-f identity 4 inc-2 (+ 4 (* 2 p))))
  (define prod-odd
    (prod-f identity 3 inc-2 (+ 3 (* 2 p))))
  (/
   (* 8
     (/ (square prod-even)
        (square prod-odd)))
   (+ 4 (* 2 p))
   )
  )

(define (pi-r p)
  (pi product-r p))

(define (pi-i p)
  (pi product-i p))

(factorial-r 3)
(factorial-i 3)

(pi-r 1000)
(pi-i 1000)