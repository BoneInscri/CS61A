#lang sicp

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

; 树型结构叶结点的数量
(define (count-leaves x)
  (cond ((null? x) 0)  
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

; 提取树型结构从左到右的叶结点，返回一个list
(define (fringe x)
  (cond ((null? x)
         nil)
        ((not (pair? x))
         (list x))
        (else
         (append (fringe (car x)) (fringe (cdr x)))
         )))

(define x (list (list 1 2) (list 3 4)))

(count-leaves x)
(count-leaves (list x x))


(fringe x)
; (1 2 3 4)

(fringe (list x x))
; (1 2 3 4 1 2 3 4)