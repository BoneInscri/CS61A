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

; given Huffman tree
(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                   (make-leaf 'B 2)
                   (make-code-tree (make-leaf 'D 1)
                                   (make-leaf 'C 1))))
  )

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))
(define sample-char (decode sample-message sample-tree))
sample-tree
sample-message
sample-char
(encode sample-char sample-tree)


