#lang sicp
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()    
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))
      ))

(define (adjoin-set x set)
  (define (check-pos x set)
    (or (null? (cdr set))
        (and (> x (car set))
             (< x (cadr set)))
        ))
  (cond ((null? set)
         nil)
        ((= x (car set))
         set)
        ((check-pos x set)
         (cons (car set) (cons x (cdr set))))
        (else
         (cons (car set) (adjoin-set x (cdr set))))
        )
  )

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else
         (let ((x1 (car set1)) (x2 (car set2)))
           (cond ((= x1 x2)
                  (cons x1
                        (union-set (cdr set1)
                                   (cdr set2))))
                 ((< x1 x2)
                  (cons x1
                        (union-set (cdr set1)
                                   set2)
                        ))
                 ((< x2 x1)
                  (cons x2
                        (union-set set1
                                   (cdr set2))
                        ))))
         )))

(define s1 (list 1 4 8 10))
(define s2 (list 2 4 5 8))
(union-set s1 s2)