 #lang sicp
(define (square x) (* x x))

(define (divides? a b)
    (= (remainder b a) 0))

(define (smallest-divisor n)
    (define (find-divisor test-divisor)
        (cond 
            ((> (square test-divisor) n) n)
            ((divides? test-divisor n) test-divisor)
            (else (find-divisor (+ test-divisor 1)))))
    (find-divisor 2))

(define (prime? n)
    (= n (smallest-divisor n)))

(define (report-prime n elapsed-time)
  (newline)
  (display n)
  (display " *** ")
  (display elapsed-time)
  #t)

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime n (- (runtime) start-time))
      #f))

(define (timed-prime-test n)
  (start-prime-test n (runtime)))

(define (search-for-primes lower upper count) 
  (define (iter n count)
    (cond ((and (<= n upper) (> count 0))
           (if (timed-prime-test n)
               (iter (+ n 2) (- count 1))
               (iter (+ n 2) count))
           )
          (else (display "\nOver"))
          )) 
  (iter (if (odd? lower) lower (+ lower 1)) count))

; test
(search-for-primes 1000 1100 3)
(search-for-primes 10000 11000 3)
(search-for-primes 100000 110000 3)
(search-for-primes 1000000 1100000 3)
