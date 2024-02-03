#lang sicp

; leaf node
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))
(define (leaf? object)
  (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

; tree node
(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))


(define sample-pairs (list (list 'A 4)
                           (list 'B 2)
                           (list 'C 1)
                           (list 'D 1)
                           ))
; (make-leaf-set sample-pairs)

(define (generate-huffman-tree pairs)
  ; 添加结点
  (define (adjoin-set x set)
    (cond ((null? set) (list x))
          ((< (weight x) (weight (car set)))
           (cons x set))
          (else (cons (car set)
                      (adjoin-set x (cdr set)))))
    )
  ; 根据weight进行排序,从小到大
  (define (make-leaf-set pairs)
    (if (null? pairs)
        '()
        (let ((pair (car pairs)))
          (adjoin-set (make-leaf (car pair)    ; symbol
                                 (cadr pair))  ; frequency
                      (make-leaf-set (cdr pairs))))
        )
    )
  ; 连续合并
  (define (successive-merge pairs-list)
    (cond ((null? pairs-list) nil)
          ((null? (cdr pairs-list))
           (car pairs-list)) ; !!!
          (else
           (let ((one (car pairs-list))
                 (two (cadr pairs-list)))
             (successive-merge (adjoin-set (make-code-tree one two)
                                           (cddr pairs-list)))
             ))
           )
    )
  (successive-merge (make-leaf-set pairs))
  )
  
(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                   (make-leaf 'B 2)
                   (make-code-tree (make-leaf 'D 1)
                                   (make-leaf 'C 1))))
  )

(generate-huffman-tree sample-pairs)
sample-tree