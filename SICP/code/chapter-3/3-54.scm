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

; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

; ones stream
(define ones (cons-stream 1 ones))

; infinite stream starting from 1
(define integers (cons-stream 1 (add-streams ones integers)))

(define factorials (cons-stream 1 (mul-streams (stream-cdr integers) factorials)))

(stream-ref factorials 1)
(stream-ref factorials 2)
(stream-ref factorials 3)