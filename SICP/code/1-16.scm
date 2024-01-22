#lang racket
(define (expt b n)
    (define (expt-iter b counter product)
        (if (= counter 0)
            product
            (expt-iter b
                       (- counter 1)
                       (* b product)))) 
    (expt-iter b n 1))


(define (fast-expt b n)
    (define (expt-iter b counter product)
      (cond ((= counter 0) product)
            ((even? counter) (expt-iter (* b b) (/ counter 2) product) )
            (else (expt-iter b (- counter 1) (* product b)))
      )) 
    (expt-iter b n 1))


; test
(expt 2 5)
(expt 2 10)
(fast-expt 2 5)
(fast-expt 2 6)