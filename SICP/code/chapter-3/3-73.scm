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

; scale a stream factor
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

; add two streams
(define (add-streams s1 s2)
  (stream-map + s1 s2))

; integral for stream
(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
                 (add-streams (scale-stream integrand dt)
                              int)))
  int)


(define (RC R C dt)
  (lambda (i v0)
    (define rc
      (add-streams (scale-stream i R)
                   (integral (scale-stream i (/ 1 C)) v0 dt)
                   )
      )
    rc
    )
  )

(define RC1 (RC 5 1 0.5))

; ones stream
(define ones (cons-stream 1 ones))

; infinite stream starting from 1
(define integers (cons-stream 1 (add-streams ones integers)))

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

(define test (RC1 integers 1))

(display-stream-cnt test 10)
