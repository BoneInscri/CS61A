#lang sicp

(define (make-interval a b) (cons a b))
(define (lower-bound i)
  (car i))
(define (upper-bound i)
  (cdr i))

(define (sign x)
  (> x 0))

; patt |  min  |  max

; 最大乘以最大,就是最大。
; 最小乘以最小,就是最小。
; ++++ | al bl | ah bh ok
; ---- | ah bh | al bl ok

; 负区间的最小乘以正区间的最大,就是最小(负的越多)
; 负区间的最大乘以正区间的最小,就是最大(负得越少)
; ++-- | ah bl | al bh ok
; --++ | al bh | ah bl ok

; 最小就是最小的负数乘以最大的正数,
; 最大就是最大的负数乘以最小的负数。(负数乘以负数)
; ---+ | al bh | al bl 
; -+-- | ah bl | al bl 
; 最大就是最大的正数乘以最大的正数。(正数乘以正数)
; -+++ | al bh | ah bh 
; ++-+ | ah bl | ah bh

; -+-+ | trouble case

(define (mul-interval x y)
  (let ((s1 (sign (lower-bound x)))
        (s2 (sign (upper-bound x)))
        (s3 (sign (lower-bound y)))
        (s4 (sign (upper-bound y)))
        (al (lower-bound x))
        (ah (upper-bound x))
        (bl (lower-bound y))
        (bh (upper-bound y))
        )
    (cond ((and s1 s2 s3 s4)
           (make-interval (* al bl) (* ah bh))) ; ++++
          ((and (not s1) (not s2) (not s3) (not s4))
           (make-interval (* ah bh) (* al bl))) ; ----
          ((and s1 s2 (not s3) (not s4))
           (make-interval (* ah bl) (* al bh))) ; ++--
          ((and (not s1) (not s2) s3 s4)
           (make-interval (* al bh) (* ah bl))) ; --++
          ((and (not s1) (not s2) (not s3) (s4))
           (make-interval (* al bh) (* al bl))) ; ---+
          ((and (not s1) s2 (not s3) (not s4))
           (make-interval (* ah bl) (* al bl))) ; -+--
          ((and (not s1) s2 s3 s4)
           (make-interval (* al bh) (* ah bh))) ; -+++
          ((and s1 s2 (not s3) s4)
           (make-interval (* ah bl) (* ah bh))) ; ++-+
          (else ; -+-+
           (let ((p1 (* (lower-bound x) (lower-bound y)))
                 (p2 (* (lower-bound x) (upper-bound y)))
                 (p3 (* (upper-bound x) (lower-bound y)))
                 (p4 (* (upper-bound x) (upper-bound y))))
             (make-interval (min p1 p2 p3 p4)
                            (max p1 p2 p3 p4)))
           )
          )
    )
  )

(define a (make-interval -3 -4))
(define b (make-interval 4 5))
(mul-interval a b)
