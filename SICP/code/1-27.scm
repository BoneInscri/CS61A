#lang sicp
(define (square x) (* x x))

; fast-prime? (using Fermat test)
(define (fast-prime-ori? n times)
  (define (fermat-test)
    (define (expmod base exp m)
      (cond ((= exp 0) 1)
            ((even? exp)
             (remainder (square (expmod base (/ exp 2) m))
                        m))
            (else
             (remainder (* base (expmod base (- exp 1) m))
                        m))))
    (define (try-it a)
      (= (expmod a n n) a))
    (try-it (+ 1 (random (- n 1)))))
  
  (cond ((= times 0) true)
        ((fermat-test) (fast-prime-ori? n (- times 1)))
        (else false)))

; try ? times
(define try-times 100000)
(define (fast-prime? n) (fast-prime-ori? n try-times))

(fast-prime? 561)
(fast-prime? 1105)
(fast-prime? 1729)
(fast-prime? 2465)
(fast-prime? 2821)
(fast-prime? 6601)
