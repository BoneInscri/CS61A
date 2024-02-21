#lang sicp

(define random-init 1)
(define (rand-update x) 
  (let ((a 48271) (b 0) (m 2147483647))
    (modulo (+ (* a x) b) m)
    )
  )

(define rand
  (let ((x random-init))
    (define (generate)
      (set! x (rand-update x))
      x)
    (define (reset new-value)
      (set! x new-value)
      )
    (define (dispatch m)
      (cond ((eq? m 'generate) (generate))
            ((eq? m 'reset) reset)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m)))
      )
    dispatch
    )
  )

; test

(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate)
((rand 'reset) 2)
(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate)
((rand 'reset) 1)
(rand 'generate)
(rand 'generate)
(rand 'generate)
(rand 'generate)