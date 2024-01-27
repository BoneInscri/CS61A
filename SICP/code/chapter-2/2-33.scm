#lang sicp


(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(accumulate + 0 (list 1 2 3 4 5))
; 15
(accumulate * 1 (list 1 2 3 4 5))
; 120
(accumulate cons nil (list 1 2 3 4 5))
; (1 2 3 4 5)

; map
(define (map p sequence)
    (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

(define list1 (list 1 2 3 4))
(map (lambda (x) (* x x)) list1)

; append
(define (append seq1 seq2)
    (accumulate cons seq2 seq1))

(define list2 (list 5 6 7 8))
(append list1 list2)

; length
(define (length sequence)
    (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

(length (list 1 2 3 5 6 7))