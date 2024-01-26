#lang sicp

; mobile
; (define (make-mobile left right)
;   (list left right))
; (define (left-branch mobile)
;   (car mobile))
; (define (right-branch mobile)
;   (car (cdr mobile)))

; branch
; (define (make-branch length structure)
;   (list length structure))
; (define (branch-length branch)
;   (car branch))
; (define (branch-structure branch)
;   (car (cdr branch)))

; 第二种表示，很好解释了什么叫作数据抽象形成了数据屏障
(define (make-mobile left right)
  (cons left right))
(define (left-branch mobile)
  (car mobile))
(define (right-branch mobile)
  (cdr mobile))
(define (make-branch length structure)
  (cons length structure))
(define (branch-length branch)
  (car branch))
(define (branch-structure branch)
  (cdr branch))


; total-weight
(define (total-weight m)
  (cond ((null? m) 0)
        ((not (pair? m)) m)
        (else (+
               (total-weight (branch-structure (left-branch m)))
               (total-weight (branch-structure (right-branch m)))
                 )
              )
        )
  )

; check-balanced
(define (check-balanced m)
  ; check sub-mobile
  (define (check-balanced-sub m)
    (define lb (left-branch m))
    (define rb (right-branch m))
    (let ((left-weight (total-weight (branch-structure lb)))
          (right-weight (total-weight (branch-structure rb))))
      (= (* (branch-length lb) left-weight)
         (* (branch-length rb) right-weight))
    )
  )
  ; check all sub-mobiles
  (define (mobile-iter m)
    (if (check-balanced-sub m)
        (let ((lb-stru (branch-structure (left-branch m)))
              (rb-stru (branch-structure (right-branch m))))
          (if (pair? lb-stru); left-branch
              (mobile-iter lb-stru)
              (if (pair? rb-stru); right-branch
                  (mobile-iter rb-stru)
                  #t
              ))
            )
        #f
        )
    )
  (mobile-iter m))

(define m1 (make-mobile 
            (make-branch 4
                         (make-mobile
                          (make-branch 3 8)
                          (make-branch 2 4)
                          )
                         ) 
            (make-branch 4
                         (make-mobile 
                          (make-branch 4 2) 
                          (make-branch 2 4)))))
(check-balanced m1)