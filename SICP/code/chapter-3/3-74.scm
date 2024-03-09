#lang sicp

; stream
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

; map for stream (multiple arguments)
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

(define (make-zero-crossings input-stream last-value)
  (cons-stream
   (sign-change-detector (stream-car input-stream) last-value)
   (make-zero-crossings (stream-cdr input-stream)
                        (stream-car input-stream))))

; test
(define (random-in-range low high)  
  (let ((range (- high low)))  
    (+ low (* (random 2) range))))  
(define (random-stream low high) 
  (cons-stream (random-in-range low high) 
               (random-stream low high))) 
(define sense-data (random-stream -10 10))
(display-stream-cnt sense-data 10)
;(define zero-crossings (make-zero-crossings sense-data 0))
;(display-stream-cnt zero-crossings 10)

(define zero-crossings
  (stream-map sign-change-detector sense-data (cons-stream 0 sense-data)))

(display-stream-cnt zero-crossings 10)


