#lang sicp
(define (square x) (* x x))

; fast-prime? (using Miller-Rabin test)
(define (fast-prime-ori? n times)
  (define (nontrivial-square-root-check a)
    (define s-mod (remainder (square a) n))
    (if (and (not (= a 1))
             (not (= a (- n 1)))
             (= s-mod 1)) 0 s-mod))
  
  (define (Miller-Rabin-test)
    (define (expmod base exp m)
      (cond ((= exp 0) 1)
            ((even? exp)
             (nontrivial-square-root-check
              (expmod base (/ exp 2) m)))
            (else
             (remainder (* base (expmod base (- exp 1) m))
                        m))))
    (define (try-it a)
      (= (expmod a n n) a))
    (try-it (+ 1 (random (- n 1)))))
  
  (cond ((or (= n 0) (= n 1)) false)
        ((= times 0) true)
        ((Miller-Rabin-test) (fast-prime-ori? n (- times 1)))
        (else false)))

; try ? times
(define try-times 100)
(define (fast-prime? n) (fast-prime-ori? n try-times))

(fast-prime? 561)
(fast-prime? 1105)
(fast-prime? 1729)
(fast-prime? 2465)
(fast-prime? 2821)
(fast-prime? 6601)
(fast-prime? 100)
(fast-prime? 29)
(fast-prime? 2)
(fast-prime? 7)
(fast-prime? 0)
(fast-prime? 1)
(fast-prime? 37)
