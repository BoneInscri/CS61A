#lang sicp
(define (inc n) (+ n 1))
(define (identity x) x)
(define (square x) (* x x))

; r : recursive
; i : iterative
(define (filtered-accumulate-r cond?
                               combiner null-value term a next b)
  (define filter-term (if (cond? a) (term a) null-value))
  (cond ((and (not (= filter-term null-value)) (<= a b))
         (display a) (display "\n")))
  (if (> a b)
      null-value
      (combiner filter-term
                (filtered-accumulate-r
                 cond? combiner null-value term (next a) next b)))
  )

(define (filtered-accumulate-i cond?
                               combiner null-value term a next b)
  (define (filter-term x) (if (cond? x) (term x) null-value))
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner (filter-term a) result))))
  (iter a null-value)
  )

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

; gcd
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))


(define (sum-square-primes-r a b)
  (filtered-accumulate-r fast-prime?
                         + 0 square a inc b)
  )
  
(define (sum-square-primes-i a b)
  (filtered-accumulate-i fast-prime?
                         + 0 square a inc b)
  )

; test
(sum-square-primes-r 1 100)
(sum-square-primes-i 1 100)
; 2 3 5 7 

(define (product-gcd-1-r n)
  (define (relatively-prime? i)
    (= (gcd i n) 1))
  (filtered-accumulate-r relatively-prime?
                         * 1 identity 1 inc (- n 1))
  )
  
(define (product-gcd-1-i n)
  (define (relatively-prime? i)
    (= (gcd i n) 1))
  (filtered-accumulate-i relatively-prime?
                         * 1 identity 1 inc (- n 1))
  )

; test
(product-gcd-1-r 10)
(product-gcd-1-i 10)
; 3 7