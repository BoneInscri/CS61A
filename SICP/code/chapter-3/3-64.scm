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

; the average of x and y
(define (average x y)
  (/ (+ x y) 2))

; sqrt-improve
(define (sqrt-improve guess x)
  (average guess (/ x guess)))

; sqrt-stream (guess stream)
(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

; for-each for steam
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

; display stream specially for infinite stream
(define (display-stream-cnt s cnt)
  (stream-for-each-cnt show s cnt)
  )

(display-stream-cnt (sqrt-stream 2) 10)

; limit stream s with tolerance
(define (stream-limit s tolerance)
  (if (stream-null? s)
      (error "not tested")
      (let ((a (stream-car s))
            (b (stream-car (stream-cdr s)))
            )
        (if (< (abs (- a b)) tolerance)
            b
            (stream-limit (stream-cdr s) tolerance)
            )
        )
      )
  )

; sqrt x with tolerance
(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(sqrt 9 0.00001)