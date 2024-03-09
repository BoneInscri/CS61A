#lang sicp

; stream
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

(define (sign-change-detector new old)
  (cond ((and (< old 0) (> new 0)) 1)
        ((and (> old 0) (< new 0)) -1)
        (else 0)
        )
  )

; display stream specially for infinite stream
(define (display-stream-cnt s cnt)
  (define (stream-for-each-cnt proc s cnt)
    (if (or (stream-null? s) (= cnt 0))
        'done
        (begin (proc (stream-car s))
               (stream-for-each-cnt proc (stream-cdr s) (- cnt 1)))
        )
    )
  (define (show x)
    (display x)
    (newline)
    x)
  (stream-for-each-cnt show s cnt)
  )
;(define (make-zero-crossings input-stream last-value)
;  (cons-stream
;   (sign-change-detector (stream-car input-stream) last-value)
;   (make-zero-crossings (stream-cdr input-stream)
;                        (stream-car input-stream))))

(define (make-zero-crossings input-stream last-value last-avpt)
  (let ((avpt (/ (+ (stream-car input-stream) last-value) 2)))
    (cons-stream (sign-change-detector avpt last-avpt)
                 (make-zero-crossings (stream-cdr input-stream)
                                      (stream-car input-stream)
                                      avpt))))

; test
(define random-init 1) 
(define (rand-update x) 
    (let ((a 48271) (b 0) (m 2147483647))
         (modulo (+ (* a x) b) m)
         )
  )
(define rand
  (let ((x random-init))
    (lambda ()
      (set! x (rand-update x))
      x)))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (random-stream low high) 
  (cons-stream (random-in-range low high) 
               (random-stream low high))) 
(define sense-data (random-stream -30 30))
(display-stream-cnt sense-data 30)

(define zero-crossings (make-zero-crossings sense-data 0 0))
(display-stream-cnt zero-crossings 30)