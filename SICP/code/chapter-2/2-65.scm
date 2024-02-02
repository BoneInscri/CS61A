#lang sicp

(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (entry set)) true)
        ((< x (entry set))
         (element-of-set? x (left-branch set)))
        ((> x (entry set))
         (element-of-set? x (right-branch set)))))


(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
        ((= x (entry set)) set)
        ((< x (entry set))
         (make-tree (entry set) 
                    (adjoin-set x (left-branch set))
                    (right-branch set)))
        ((> x (entry set))
         (make-tree (entry set)
                    (left-branch set)
                    (adjoin-set x (right-branch set))))))

(define (list->tree elements)
  (define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts) right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree) remaining-elts)
                )
              )
            )
          )
        )
      )
  )
  (car (partial-tree elements (length elements))))

(define (tree->list tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))


(define (union-set set1 set2)
  (define (do-union-set set1 set2)
    (cond ((null? set1) set2)
          ((null? set2) set1)
          (else
           (let ((x1 (car set1)) (x2 (car set2)))
             (cond ((= x1 x2)
                    (cons x1
                          (do-union-set (cdr set1)
                                        (cdr set2))))
                   ((< x1 x2)
                    (cons x1
                          (do-union-set (cdr set1)
                                        set2)
                          ))
                   ((< x2 x1)
                    (cons x2
                          (do-union-set set1
                                        (cdr set2))
                          ))))
           )))
  (list->tree (do-union-set (tree->list set1)
                            (tree->list set2))))

(define (intersection-set set1 set2)
  (define (do-intersection-set set1 set2)
    (if (or (null? set1) (null? set2))
        '()    
        (let ((x1 (car set1)) (x2 (car set2)))
          (cond ((= x1 x2)
                 (cons x1
                       (do-intersection-set (cdr set1)
                                         (cdr set2))))
                ((< x1 x2)
                 (do-intersection-set (cdr set1) set2))
                ((< x2 x1)
                 (do-intersection-set set1 (cdr set2)))))
        ))
  (list->tree (do-intersection-set (tree->list set1)
                                (tree->list set2)))
  )


(define s1 (list->tree (list 1 4 8 10)))
(define s2 (list->tree (list 2 4 5 8 12)))

(tree->list (union-set s1 s2))
(tree->list (intersection-set s1 s2))