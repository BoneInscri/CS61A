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

(define (unique-triples n)
  (accumulate append
              nil
              (accumulate append
                          nil
                          (map (lambda (i)
                                 (map (lambda (j)
                                        (map (lambda (k) (list i j k))
                                             (enumerate-interval 1 (- j 1))
                                             )
                                        )
                                      (enumerate-interval 1 (- i 1))
                                      )
                                 )
                               (enumerate-interval 1 n)
                               )
                          )
              )
  )

(define (prime-sum-triples n s)
  (filter (lambda (x)
            (= s
               (+ (car x)
                  (car (cdr x))
                  (car (cdr (cdr x))))))
          (unique-triples n)))

(prime-sum-triples 100 20)
