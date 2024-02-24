#lang sicp

(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

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

(define records (list->tree
                 (list
                 (list 1 2001 1 1)
                 (list 2 2003 3 15)
                 (list 3 2004 8 1))))
; the first item of record is key
(define (key r)
  (car r))

(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) false)
        ((equal? given-key (key (entry set-of-records)))
         (entry set-of-records)
         )
        ((< given-key (key (entry set-of-records)))
         (lookup given-key (left-branch set-of-records))
         )
        ((> given-key (key (entry set-of-records)))
         (lookup given-key (right-branch set-of-records))
         )
        )
  )

(lookup 2 records)
(lookup 4 records)