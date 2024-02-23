#lang sicp

(define (make-queue)
  (let ((front-ptr nil)
        (rear-ptr nil))
    (define (set-front-ptr! item) (set! front-ptr item))
    (define (set-rear-ptr! item) (set! rear-ptr item))
    (define (empty-queue?)
      (null? front-ptr)
      )
    (define (front-queue)
      (if (empty-queue?)
          (error "FRONT called with an empty queue")
          (car front-ptr)
          )
      )
    (define (insert-queue! item)
        (let ((new-pair (cons item nil)))
          (cond ((empty-queue?)
                 (set-front-ptr! new-pair)
                 (set-rear-ptr! new-pair)
                 ;queue
                 )
                (else
                 (set-cdr! rear-ptr new-pair)
                 (set-rear-ptr! new-pair)
                 ;queue
                 ))
        )
      )
    (define (delete-queue!)
      (cond ((empty-queue?)
             (error "DELETE! called with an empty queue"))
            (else
             (let ((front (front-queue)))
               (set-front-ptr! (cdr front-ptr))
               front
               ;queue
               )
             ))
      )
    (define (print-queue)
      (display front-ptr)
      (newline)
      )
    (define (dispatch m)
      (cond ((eq? m 'empty-queue?) (empty-queue?))
            ((eq? m 'front-queue) (front-queue))
            ((eq? m 'insert-queue!) insert-queue!)
            ((eq? m 'delete-queue!) (delete-queue!))
            ((eq? m 'print-queue) (print-queue))
            (else (error "Unknown request -- MAKE-QUEUE"
                         m)))
      )
    dispatch))

(define q1 (make-queue))
(q1 'empty-queue?)
((q1 'insert-queue!) 'a)
((q1 'insert-queue!) 'b)
(q1 'print-queue)
(q1 'empty-queue?)
((q1 'insert-queue!) 'c)
(q1 'print-queue)
(q1 'delete-queue!)
(q1 'print-queue)
(q1 'delete-queue!)
(q1 'print-queue)