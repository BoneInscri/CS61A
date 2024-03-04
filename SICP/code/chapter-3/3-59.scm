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

; multiple two streams
(define (mul-streams s1 s2)
  (stream-map * s1 s2))

; divide two streams
(define (div-streams s1 s2)
  (stream-map / s1 s2)
  )
; scale stream
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

; infinite stream starting from 1
(define integers (cons-stream 1 (add-streams ones integers)))

; ones stream
(define ones (cons-stream 1 ones))

; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

; integrate
(define (integrate-series a)
  (mul-streams a (div-streams ones integers))
  )

; exp
(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

; sine
(define sine-series
  (cons-stream 0 (integrate-series cosine-series))
  )

; cosine
(define cosine-series
  (cons-stream 1 (integrate-series (scale-stream sine-series -1)))
  )

(stream-ref exp-series 0)
(stream-ref exp-series 1)
(stream-ref exp-series 2)
(stream-ref exp-series 3)

(newline)

(stream-ref sine-series 0)
(stream-ref sine-series 1)
(stream-ref sine-series 2)
(stream-ref sine-series 3)

(newline)

(stream-ref cosine-series 0)
(stream-ref cosine-series 1)
(stream-ref cosine-series 2)
(stream-ref cosine-series 3)
