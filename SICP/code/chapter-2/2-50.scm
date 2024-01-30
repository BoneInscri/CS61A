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


(define (flip-vert painter)
  (transform-painter painter
                     (make-vect 0.0 1.0)   ; new origin
                     (make-vect 1.0 1.0)   ; new end of edge1
                     (make-vect 0.0 0.0))) ; new end of edge2
(paint einstein)
(paint (flip-vert einstein))


(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)
                     (make-vect 0.0 0.0)
                     (make-vect 1.0 1.0)))

(paint (flip-horiz einstein))

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
(paint (roate90 einstein))
(paint (roate180 einstein))
(paint (roate270 einstein))

(define (shrink-to-upper-right painter)
  (transform-painter painter
                     (make-vect 0.5 0.5)
                     (make-vect 1.0 0.5)
                     (make-vect 0.5 1.0)))

(paint (shrink-to-upper-right einstein))

(define (squash-inwards painter)
  (transform-painter painter
                     (make-vect 0.0 0.0)
                     (make-vect 0.65 0.35)
                     (make-vect 0.35 0.65)))

(paint (squash-inwards einstein))

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