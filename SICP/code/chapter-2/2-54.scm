#lang sicp

(define (equal? x y)
  (cond ((and (null? x) (null? y))
         #t)
        ((and (pair? (car x)) (pair? (car y)))
         (and (equal? (car x) (car y)) (equal? (cdr x) (cdr y)))
         )
        ((and (not (pair? (car x))) (not (pair? (car y))))
         (if (eq? (car x) (car y))
             (equal? (cdr x) (cdr y))
             #f
             )
         )
        (else #f)
  ))

(equal? '(this is a list) '(this is a list))
(equal? '(this (is b) list) '(this (is a) list))