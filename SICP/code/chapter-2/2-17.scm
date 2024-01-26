#lang sicp

; "下标访问"
(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

; list的元素个数
(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

; list1 + list2
(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

(define (last-pair list)
  (if (null? (cdr list))
      list
      (last-pair (cdr list)))
  )

(last-pair (list 23 72 149 34))