#lang sicp

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (cons x set))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)        
         (cons (car set1)
               (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        ((not (element-of-set? (car set1) set2))
         (cons (car set1)
               (union-set (cdr set1) set2))
         )
        (else (union-set (cdr set1) set2))
        ))

(define s1 (list 1 2 3 4))
(define s2 (list 2 4 5 8))
(adjoin-set 2 s1)
(adjoin-set 2 s1)
(adjoin-set 2 s1)

(intersection-set s1 s2)
(union-set s1 s2)
