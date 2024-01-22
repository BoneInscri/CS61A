#lang racket

(define (even? n)
    (= (remainder n 2) 0))
(define (square x) (* x x))
(define (sum-of-squares x y)
  (+ (square x) (square y)))
  
(define (fib n)
  (define (fib-iter a b p q count)
    (cond ((= count 0) b)
          ((even? count)
           (fib-iter a
                     b
                     (sum-of-squares p q)      ; compute p'
                     (+ (square q) (* 2 p q))  ; compute q'
                     (/ count 2)))
          (else (fib-iter (+ (* b q) (* a q) (* a p))
                          (+ (* b p) (* a q))
                          p
                          q
                          (- count 1)))))
  (fib-iter 1 0 0 1 n))


; test
(fib 0) 
(fib 1) 
(fib 2) 
(fib 3) 
(fib 4) 
(fib 5) 
(fib 6) 
(fib 7) 
(fib 8) 
(fib 9) 
(fib 10) 