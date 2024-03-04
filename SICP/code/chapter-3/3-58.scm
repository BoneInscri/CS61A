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

; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (expand num den radix)
    (cons-stream
     (quotient (* num radix) den)
     (expand (remainder (* num radix) den) den radix))
  )

; test
(define t1 (expand 1 7 10))
(stream-ref t1 0)
(stream-ref t1 1)
(stream-ref t1 2)
(stream-ref t1 3)
(stream-ref t1 4)
(stream-ref t1 5)
(stream-ref t1 6)
(newline)

(define t2 (expand 3 8 10))
(stream-ref t2 0)
(stream-ref t2 1)
(stream-ref t2 2)
(stream-ref t2 3)
(stream-ref t2 4)
(stream-ref t2 5)
(stream-ref t2 6)