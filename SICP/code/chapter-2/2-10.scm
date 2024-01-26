#lang sicp

(define (assert p m)
  (if (not p)
      (error m)))

(define (assert_eq x y)
  (assert (= x y)))

(define (make-interval a b) (cons a b))
(define (lower-bound i)
  (car i))
(define (upper-bound i)
  (cdr i))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (span-interval i)
  (- (upper-bound i) (lower-bound i)))

(define (div-interval x y)
  (assert (> (span-interval y) 0)
          "divide by an interval that spans zero")
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

(define x (make-interval 2 3))
(define y (make-interval 3 3))

(div-interval x y)