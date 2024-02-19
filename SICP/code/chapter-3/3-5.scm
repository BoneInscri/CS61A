#lang sicp


(define random-init 1) 
(define (rand-update x) 
    (let ((a 48271) (b 0) (m 2147483647))
         (modulo (+ (* a x) b) m)
         )
  )
(define rand
  (let ((x random-init))
    (lambda ()
      (set! x (rand-update x))
      x)))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))


(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials cesaro-test))))
(define (cesaro-test)
  (= (gcd (rand) (rand)) 1)
  )
(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(estimate-pi 1000000)

(define (estimate-integral trials P x1 x2 y1 y2)
  (define (P-test)
    (let ((random-x (random-in-range x1 x2))
          (random-y (random-in-range y1 y2)))      
      (P random-x random-y)
      )
    )
  (let ((factor (monte-carlo trials P-test)))
    (* factor 4)
    )
  )

(define (square x) (* x x))
(define (square-sum x y) (+ (square x) (square y)))    
(define (in-circle x0 y0 r)
  (lambda (x y)
    (< (square-sum (- x x0) (- y y0)) (square r))
    )
  )

(define (estimate-pi-pickpoints trials r)
  (estimate-integral trials (in-circle 0 0 r) (- r) r (- r) r)
  )

(estimate-pi-pickpoints 10000000 10000)
