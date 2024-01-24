#lang sicp

(define (cons-frac n1 d1 now) (/ n1 (+ d1 now)))
(define (cont-frac-k-r N D step k)
  (if (= step k)
      (/ (N k) (D k))
      (cons-frac (N step)
                 (D step)
                 (cont-frac-k-r N D (+ step 1) k))
      ))


(define (get-e-r k)
  (define (check? m) (= (remainder (+ m 1) 3) 0))
  (define (map m) (* (/ (+ m 1) 3) 2.0))
  (+ 2
     (cont-frac-k-r (lambda (i) 1.0)
                    (lambda (i)
                      (if (check? i)
                                    (map i)
                                    1.0
                                    ))
                    1 k))
  )

(get-e-r 5)
