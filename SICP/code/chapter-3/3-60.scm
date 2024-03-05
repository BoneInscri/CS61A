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

; multiple two series
(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1)
                  (stream-car s2))
               (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
                            (mul-series (stream-cdr s1) s2))
               )
  )

; test
(define test (add-streams (mul-series sine-series sine-series)
                          (mul-series cosine-series cosine-series)
                          ))


(stream-ref test 0)
(stream-ref test 1)
(stream-ref test 2)
(stream-ref test 3)
(stream-ref test 4)