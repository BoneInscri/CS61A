#lang sicp

(define (make-monitored f)
  (define count 0)
  
  (define (inc-count)
    (set! count (+ count 1))
    )

  (define (reset-count)
    (set! count 0)
    )

  (define (how-many-calls?)
    count
    )
  
  (define (mf m)
    (cond ((eq? m 'how-many-calls?) (how-many-calls?))
          ((eq? m 'reset-count) (reset-count))
          (else
           (inc-count)
           (f m)
           )))
  
  mf)

(define s (make-monitored sqrt))
(s 100)
(s 10)
(s 4)
(s 8)
(s 'how-many-calls?)
(s 'reset-count)
(s 'how-many-calls?)