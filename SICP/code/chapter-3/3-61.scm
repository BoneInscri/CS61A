#lang sicp

; stream
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

; map for stream
(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))
; add two streams
(define (add-streams s1 s2)
  (stream-map + s1 s2))

; sub two streams
(define (sub-streams s1 s2)
  (stream-map - s1 s2))

; scale stream
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

; infinite stream starting from 1
(define integers (cons-stream 1 (add-streams ones integers)))

; ones stream
(define ones (cons-stream 1 ones))

; multiple two series
(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1)
                  (stream-car s2))
               (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
                            (mul-series (stream-cdr s1) s2))
               )
  )

; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (invert-unit-series s)
  (cons-stream 1
    (scale-stream (mul-series (stream-cdr s) (invert-unit-series s)) -1)
  ))

(define invert-integers (invert-unit-series integers))
(stream-ref integers 0)
(stream-ref integers 1)
(stream-ref integers 2)
(stream-ref integers 3)
(newline)
(stream-ref invert-integers 0)
(stream-ref invert-integers 1)
(stream-ref invert-integers 2)
(stream-ref invert-integers 3)
(stream-ref invert-integers 4)
(stream-ref invert-integers 5)
