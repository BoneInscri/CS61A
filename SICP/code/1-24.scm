#lang sicp
(define (square x) (* x x))

(define (divides? a b)
  (= (remainder b a) 0))

(define (next-plusone value) (+ 1 value))
(define (next-plustwo value) (if (= value 2) 3 (+ 2 value)))

; prime? (using searching factors)
(define (prime_search_factors? next-test-method n)
  (define (smallest-divisor)
    (define (find-divisor test-divisor)
      (cond 
        ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor
               (next-test-method test-divisor)))))
    (find-divisor 2))
  (= n (smallest-divisor)))

(define (slow-prime?-1 n)
  (prime_search_factors? next-plusone n))
(define (slow-prime?-2 n)
  (prime_search_factors? next-plustwo n))

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
(define (fast-prime? n) (fast-prime-ori? n 3))

; [lower, upper] {count} smallest primes
(define (search-for-primes prime? lower upper count)
  (define (timed-prime-test n)
    (define (report-prime elapsed-time)
      (newline)
      (display n)
      (display " *** ")
      (display elapsed-time)
      #t)
    (define (start-prime-test start-time)
      (if (prime? n)
          (report-prime (- (runtime) start-time))
          #f))
    (start-prime-test (runtime)))
  (define (iter n count)
    (cond ((and (<= n upper) (> count 0))
           (if (timed-prime-test n)
               (iter (+ n 2) (- count 1))
               (iter (+ n 2) count))
           )
          (else (display "\nOver\n"))
          )) 
  (iter (if (odd? lower) lower (+ lower 1)) count))

; test
(fast-prime? 29)
(fast-prime? 33)


(display "test for old start")
(search-for-primes slow-prime?-1
                   1000 1100 3)
(search-for-primes slow-prime?-1
                   10000 11000 3)
(search-for-primes slow-prime?-1
                   100000 110000 3)
(search-for-primes slow-prime?-1
                   1000000 1100000 3)
(search-for-primes slow-prime?-1
                   10000000 11000000 3)
(search-for-primes slow-prime?-1
                   100000000 110000000 3)
(search-for-primes slow-prime?-1
                   1000000000 1100000000 3)
(display "test for old end\n")

(display "\ntest for fast start")
(search-for-primes fast-prime?
                   1000 1100 3)
(search-for-primes fast-prime?
                   10000 11000 3)
(search-for-primes fast-prime?
                   100000 110000 3)
(search-for-primes fast-prime?
                   1000000 1100000 3)
(search-for-primes fast-prime?
                   10000000 11000000 3)
(search-for-primes fast-prime?
                   100000000 110000000 3)
(search-for-primes fast-prime?
                   1000000000 1100000000 3)
(display "test for fast end\n")