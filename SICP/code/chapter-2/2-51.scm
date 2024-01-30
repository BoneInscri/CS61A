#lang sicp
(#%require sicp-pict)
(define (compose f g)
  (lambda (x) (f (g x)))
  )
(define (repeated f n)
  (define (iter g count)
    (if (= count 0)
        g
        (iter (compose f g) (- count 1))
        )
    )
  (iter f (- n 1)))
(define (roate90 painter)
    (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 1.0 1.0)
                     (make-vect 0.0 0.0)
                     ))
(define (roate180 painter)
  ((repeated roate90 2) painter))
(define (roate270 painter)
  ((repeated roate90 3) painter))

(define (beside painter1 painter2)
  (let ((split-point (make-vect 0.5 0.0)))
    (let ((paint-left
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              split-point
                              (make-vect 0.0 1.0)))
          (paint-right
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.0)
                              (make-vect 0.5 1.0))))
      (lambda (frame)
        (paint-left frame)
        (paint-right frame)))))

(paint (beside einstein einstein))

(define (below-1 painter1 painter2)
  (let ((split-point (make-vect 0.0 0.5)))
    (let ((paint-up
           (transform-painter painter1
                              (make-vect 0.0 0.0)
                              (make-vect 1.0 0.0)
                              split-point
                              ))
          (paint-down
           (transform-painter painter2
                              split-point
                              (make-vect 1.0 0.5)
                              (make-vect 0.0 1.0))))
      (lambda (frame)
        (paint-up frame)
        (paint-down frame)))))
(paint (below-1 einstein einstein))

(define (below-2 painter1 painter2)
  (rotate270 (beside (rotate90 painter1) (rotate90 painter2))))

(paint (below-2 einstein einstein))