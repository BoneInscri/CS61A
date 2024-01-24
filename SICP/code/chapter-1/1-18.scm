#lang racket
;递归，n
(define (* a b)
  (if (= b 0)
      0
      (+ a (* a (- b 1)))))


(define (double x) (* 2 x))
(define (half x) (/ x 2))
(define (even? n)
    (= (remainder n 2) 0))

;迭代， log(n)
(define (fast-prod-i a b)
    (define (prod-iter a b sum)
      (cond ((= b 0) sum)
            ((even? b) (prod-iter (double a) (half b) sum))
            (else (prod-iter a (- b 1) (+ sum a)))
      )) 
    (prod-iter a b 0))


; test
(* 3 4)
(fast-prod-i 3 4)
(fast-prod-i 100 1000)
