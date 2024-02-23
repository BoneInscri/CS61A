#lang sicp

; helper
(define (set-cadr! x y) (set-car! (cdr x) y))
(define (set-caddr! x y) (set-car! (cddr x) y))

; deque
(define (front-ptr deque) (car deque))
(define (rear-ptr deque) (cdr deque))

(define (set-front-ptr! deque item) (set-car! deque item))
(define (set-rear-ptr! deque item) (set-cdr! deque item))

; interfaces for deque
(define (make-deque) (cons nil nil))
(define (empty-deque? deque) (and (null? (front-ptr deque)) (null? (rear-ptr deque))) )
(define (make-cell item) (list item nil nil))
(define (one-item-deque? deque) (eq? (front-ptr deque) (rear-ptr deque)))
(define (set-empty-deque deque)
  (set-front-ptr! deque nil)
  (set-rear-ptr! deque nil)
  )
; (item next prev)
(define (item-cell cell) (car cell))
(define (next-cell cell) (cadr cell))
(define (prev-cell cell) (caddr cell))
(define (set-next-cell! cell newptr) (set-cadr! cell newptr))
(define (set-prev-cell! cell newptr) (set-caddr! cell newptr))

(define (front-deque deque)
  (if (empty-deque? deque)
      (error "FRONT called with an empty deque" deque)
      (item-cell (front-ptr deque)))
  )

(define (rear-deque deque)
  (if (empty-deque? deque)
      (error "REAR called with an empty deque" deque)
      (item-cell (rear-ptr deque)))
  )

(define (front-insert-deque! deque item)
  (let ((new-cell (make-cell item)))
    (cond ((empty-deque? deque)
           ; empty?
           (set-front-ptr! deque new-cell)
           (set-rear-ptr! deque new-cell)           
           ;deque
           )
          (else
           ; not empty?
           (let ((front (front-ptr deque)))
             (set-next-cell! new-cell (front-ptr deque))
             (set-prev-cell! (front-ptr deque) new-cell)
             (set-front-ptr! deque new-cell)
             )
           ;deque
           ))
    )
  )

(define (rear-insert-deque! deque item)
  (let ((new-cell (make-cell item)))
    (cond ((empty-deque? deque)
           (set-front-ptr! deque new-cell)
           (set-rear-ptr! deque new-cell)
           ;deque
           )
          (else
           (let ((rear (rear-ptr deque)))
             (set-next-cell! (rear-ptr deque) new-cell)
             (set-prev-cell! new-cell (rear-ptr deque))
             (set-rear-ptr! deque new-cell)
             )
           ;deque
           ))
    )
  )

(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "DELETE! called with an empty deque" deque))
        (else
         (let ((front (front-deque deque)))
           (if (one-item-deque? deque)
               (set-empty-deque deque)
               (begin (set-front-ptr! deque (next-cell (front-ptr deque)))
                      (set-prev-cell! (front-ptr deque) nil)
                      )
               )
           front
           ;deque
           )
         ))
  )

(define (rear-delete-deque! deque)
  (cond ((empty-deque? deque)
         (error "DELETE! called with an empty deque" deque))
        (else
         (let ((rear (rear-deque deque)))
           (if (one-item-deque? deque)
               (set-empty-deque deque)
               (begin (set-rear-ptr! deque (prev-cell (rear-ptr deque)))
                      (set-next-cell! (rear-ptr deque) nil)
                      )
               )
           rear
           ;deque
           )
         ))
  )

(define (print-deque deque)
  (define (print-iter cell)
    (if (not (null? cell))
        (begin (display (item-cell cell))
               (display " ")
               (print-iter (next-cell cell)))
        )
    )
  (display "(")
  (print-iter (front-ptr deque))
  (display ")\n")
  )

(define q1 (make-deque))
(front-insert-deque! q1 'a)
(front-insert-deque! q1 'b)
(print-deque q1)
(front-delete-deque! q1)
(rear-insert-deque! q1 'c)
(rear-insert-deque! q1 'd)
(rear-insert-deque! q1 'e)
(print-deque q1)
(rear-delete-deque! q1)
(print-deque q1)
(rear-delete-deque! q1)
(print-deque q1)