#lang sicp
(define (average x y)
  (/ (+ x y) 2))
(define (make-interval a b) (cons a b))
(define (lower-bound i)
  (car i))
(define (upper-bound i)
  (cdr i))
(define (print-interval p)
  (display "[")
  (display (lower-bound p))
  (display ",")
  (display (upper-bound p))
  (display "]")
  )

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

; 第一种并联方式
(define (par2 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))
; 第二种并联方式
(define (par1 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))

; Percent is between 0 and 1 
(define (make-interval-percent center tolerance)
  (define width (* center tolerance))
  (make-interval (- center width) (+ center width)))

(define (center-interval i) (average (lower-bound i) (upper-bound i)))

(define (percent i)
  (define lower (lower-bound i))
  (define upper (upper-bound i))
  (let ((center (average lower upper))
        (width (/ (- upper lower) 2)))
    (/ width center)))

(define R1 (make-interval-percent 6.8 0.1))
(define R2 (make-interval-percent 4.7 0.05))

(par1 R1 R2)
(par2 R1 R2)