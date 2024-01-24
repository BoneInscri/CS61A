#lang sicp
; 倒数
(define (reciprocal x) (/ 1 x))
(define tolerance 0.0001)
(define (close-enough? v1 v2)
  (< (abs (- v1 v2)) tolerance))

(define (report-iter-f n step)
  (newline)
  (display n)
  (display ", step : ")
  (display step))

; r : recursive
; i : iterative
(define (cons-frac n1 d1 now) (/ n1 (+ d1 now)))
(define (cont-frac-k-i N D k)
  (define (try guess step)
    (let ((next (cons-frac (N (- k 1)) (D (- k 1))
                           guess)
                ))
      ;(report-iter-f next step)
      (if (< step 2)
          next
          (try next (- step 1)))))
  (try (/ (N k) (D k)) k))

(define (cont-frac-k-r N D step k)
  (if (= step k)
      (/ (N k) (D k))
      (cons-frac (N step)
                 (D step)
                 (cont-frac-k-r N D (+ step 1) k))
                 ))

(define (cont-frac-i k)
  (cont-frac-k-i (lambda (i) 1.0) (lambda (i) 1.0) k))

(define (cont-frac-r k)
  (cont-frac-k-r (lambda (i) 1.0) (lambda (i) 1.0) 1 k))

; search the lowest k to get an approximation
; that is accurate to 4 decimal places
(define (cont-frac-find-best-k-i k)
  (if (close-enough? (reciprocal(cont-frac-i k)) 1.6180)
      k
      (cont-frac-find-best-k-i (+ k 1))))

(define (cont-frac-find-best-k-r k)
  (if (close-enough? (reciprocal(cont-frac-r k)) 1.6180)
      k
      (cont-frac-find-best-k-r (+ k 1))))

(define best-k-i (cont-frac-find-best-k-i 1))
(define best-k-r (cont-frac-find-best-k-r 1))
(display "best-k of i : ")
(display best-k-i)
(newline)
(display "best-k of r : ")
(display best-k-r)
(newline)

(cont-frac-i best-k-i)
(cont-frac-r best-k-r)

