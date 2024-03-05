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

; multiple two streams
(define (mul-streams s1 s2)
  (stream-map * s1 s2))

; scale stream
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

; add two streams
(define (add-streams s1 s2)
  (stream-map + s1 s2))

; multiple two series
(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1)
                  (stream-car s2))
               (add-streams (scale-stream (stream-cdr s2) (stream-car s1))
                            (mul-series (stream-cdr s1) s2))
               )
  )

; infinite stream starting from 1
(define integers (cons-stream 1 (add-streams ones integers)))

; ones stream
(define ones (cons-stream 1 ones))

; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

; divide two streams
(define (div-streams s1 s2)
  (stream-map / s1 s2)
  )

; integrate
(define (integrate-series a)
  (mul-streams a (div-streams ones integers))
  )

; sine
(define sine-series
  (cons-stream 0 (integrate-series cosine-series))
  )

; cosine
(define cosine-series
  (cons-stream 1 (integrate-series (scale-stream sine-series -1)))
  )

; invert-unit (求导数)
(define (invert-unit-series s)
  (cons-stream 1
    (scale-stream (mul-series (stream-cdr s) (invert-unit-series s)) -1)
  ))

; divide two series
(define (div-series s1 s2)
  (if (= (stream-car s2) 0)
      (error "not valid")
      (mul-series s1 (invert-unit-series s2))
      )
  )

;tangent
(define tangent-series
  (div-series sine-series cosine-series)
  )

(stream-ref tangent-series 0)
(stream-ref tangent-series 1)
(stream-ref tangent-series 2)
(stream-ref tangent-series 3)
(stream-ref tangent-series 4)

