#lang sicp

; accumulate
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

; enumerate
(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

; filter
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (unique-pairs n)
  (accumulate append
            nil
            (map (lambda (i)
                         (map (lambda (j) (list i j))
                              (enumerate-interval 1 (- i 1))))
                 (enumerate-interval 1 n))))


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

(define (prime-sum? pair)
  (fast-prime? (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map (lambda (x)
         (list (car x) (car (cdr x)) (+ (car x) (car (cdr x)))))
       
       (filter prime-sum?
          (unique-pairs n))))

; (prime-sum-pairs 6)
(unique-pairs 6)