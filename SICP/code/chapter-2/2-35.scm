#lang sicp


(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

;(define (count-leaves x)
;  (cond ((null? x) 0)  
;        ((not (pair? x)) 1)
;        (else (+ (count-leaves (car x))
;                 (count-leaves (cdr x))))))

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

(define (length sequence)
    (accumulate (lambda (x y) (+ 1 y)) 0 sequence))


(define (count-leaves t)
  (accumulate (lambda (x y) (+ (length x) y)) 0
              (map (lambda (x) (enumerate-tree x)) t)))

(define tree (list 1 (list 2 (list 3 4)) 5))

(count-leaves tree)