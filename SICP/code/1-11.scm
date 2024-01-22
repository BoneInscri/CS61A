#lang racket
(define (f-recursion n)
  (cond ((< n 3) n)
        (else (+ (f-recursion (- n 1))
                 (* 2 (f-recursion (- n 2)))
                 (* 3 (f-recursion (- n 3)))
                 )
              )))

(define (f-iterative n) 
  (define (f-i a b c count) 
    (cond ((< n 3) n) 
          ((<= count 0) a) 
          (else (f-i (+ a (* 2 b) (* 3 c)) a b (- count 1))))) 
  (f-i 2 1 0 (- n 2))) 

; test
(f-recursion -1)
(f-recursion -2)
(f-recursion 0)
(f-recursion 1)
(f-recursion 2)
(f-recursion 3)
(f-recursion 4)
(f-recursion 5)
(f-recursion 6)
(f-recursion 7)


(f-iterative -1)
(f-iterative -2)
(f-iterative 0)
(f-iterative 1)
(f-iterative 2)
(f-iterative 3)
(f-iterative 4)
(f-iterative 5)
(f-iterative 6)
(f-iterative 7)



