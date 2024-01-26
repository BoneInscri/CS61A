#lang sicp

(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define (no-more? coin-values)
  (null? coin-values))

(define (first-denomination coin-values)
  (car coin-values))

(define (except-first-denomination coin-values)
  (cdr coin-values))

(define (count-change amount coin-values)
  (cc amount coin-values))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

(count-change 100 us-coins)
; 292
(count-change 100 uk-coins)
; 104561
(count-change 100 (list 25 10 50 1 5))
; 292
(count-change 100 (list 50 100 20 5 10 1 2 0.5))
; 104561