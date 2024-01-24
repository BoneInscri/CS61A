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

;递归，log(n)
(define (fast-prod-r a b)
  (cond ((= b 0) 0)
        ((even? b) (double (fast-prod-r a (half b))))
        (else (+ a (fast-prod-r a (- b 1)))))
  )


; test
(* 3 4)
(fast-prod-r 3 4)
(fast-prod-r 100 1000)
