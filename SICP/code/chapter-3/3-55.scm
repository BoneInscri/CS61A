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

; ones stream
(define ones (cons-stream 1 ones))
; infinite stream starting from 1
(define integers (cons-stream 1 (add-streams ones integers)))


; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

; partial-sum streams
(define (partial-sums s) 
    (add-streams s (cons-stream 0 (partial-sums s)))) 
  
(define test (partial-sums integers))

(stream-ref test 1)
(stream-ref test 2)
(stream-ref test 3)