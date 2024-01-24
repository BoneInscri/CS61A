#lang sicp
(define (cube x) (* x x x))
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (integral-raw f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) dx))

(define (integral-Simpson f a b n)
  (define h (/ (- b a) n))
  (define (y_k k) (f (+ a (* k h))))
  (define (next_idx idx) (+ 2 idx))
  
  (* (/ h 3)
     (+ (y_k 0)
        (y_k n)
        (* 4 (sum y_k 1 next_idx (- n 1)))
        (* 2 (sum y_k 2 next_idx (- n 2))))
     )
)

(integral-Simpson cube 0 1 100)
(integral-Simpson cube 0 1 1000)

(integral-raw cube 0 1 0.01)
(integral-raw cube 0 1 0.001)
