#lang sicp

(define (average x y)
  (/ (+ x y) 2 ))

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

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))

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

(define (width-interval i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define I1 (make-interval 1 3))
(define I2 (make-interval -2 8))

(define (assert p)
  (if (not p)
      (error "panic")))

(define (assert_eq x y)
  (assert (= x y)))

(assert_eq (+ (width-interval I1) (width-interval I2))
        (width-interval (add-interval I1 I2))) 

(assert_eq (+ (width-interval I1) (width-interval I2))
        (width-interval (sub-interval I1 I2)) )


