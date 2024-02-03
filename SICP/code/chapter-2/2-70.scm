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

; decode bits given Huffman tree
(define (decode bits tree)
  (define (choose-branch bit branch)
    (cond ((= bit 0) (left-branch branch))
          ((= bit 1) (right-branch branch))
          (else (error "bad bit -- CHOOSE-BRANCH" bit))))
  (define (decode-1 bits current-branch)
    (if (null? bits)
        '()
        (let ((next-branch
               (choose-branch (car bits) current-branch)))
          (if (leaf? next-branch)
              (cons (symbol-leaf next-branch)
                    (decode-1 (cdr bits) tree))
              (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

; encode message given Huffman tree
(define (encode message tree)
  (define (encode-symbol char tree)
    (cond ((leaf? tree) nil) 
          ((memq char (symbols (left-branch tree))) 
           (cons 0 (encode-symbol char (left-branch tree)))) 
          ((memq char (symbols (right-branch tree))) 
           (cons 1 (encode-symbol char (right-branch tree)))) 
          (else (error "symbol not in tree" char)))) 
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree)))
  )

; 构造Huffman given symbol-frequency
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

(define freq-pairs (list (list 'A 2)
                         (list 'NA 16)
                         (list 'BOOM 1)
                         (list 'SHA 3)
                         (list 'GET 2)
                         (list 'YIP 9)
                         (list 'JOB 2)
                         (list 'WAH 1)))
(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define huffman-tree (generate-huffman-tree freq-pairs))
(define message '(GET A JOB
                      SHA NA NA NA NA NA NA NA NA
                      GET A JOB
                      SHA NA NA NA NA NA NA NA NA
                      WAH YIP YIP YIP YIP YIP YIP YIP YIP YIP
                      SHA BOOM))
(define huffman-code (encode message huffman-tree))
(length huffman-code)

