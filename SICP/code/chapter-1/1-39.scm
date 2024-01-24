#lang sicp

(define (cons-frac n1 d1 now) (/ n1 (+ d1 now)))

(define (cont-frac-k-r N D step k)
  (define N-i (N step))
  (define D-i (D step))
  (if (= step k)
      (/ N-i D-i)
      (cons-frac N-i
                 D-i
                 (cont-frac-k-r N D (+ step 1) k))
      ))


(define (tanx-cf-r x k)
  (cont-frac-k-r (lambda (i)
                   (if (= i 1) x (- (* x x))))
                 (lambda (i) (- (* 2 i) 1))
                 1 k)
  )
(tanx-cf-r 0.5 2)