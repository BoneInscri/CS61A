; stream
(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

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

; scale a stream factor
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

;(define (integral delayed-integrand initial-value dt)
;  (define int
;    (cons-stream initial-value
;                 (let ((integrand (force delayed-integrand)))
;                   (add-streams (scale-stream integrand dt)
;                                int))))
;  int)

 (define (integral delayed-integrand initial-value dt) 
         (cons-stream initial-value 
                 (let ((integrand (force delayed-integrand))) 
                         (if (stream-null? integrand) 
                                 the-empty-stream 
                                 (integral (delay (stream-cdr integrand)) 
                                           (+ (* dt (stream-car integrand)) 
                                                      initial-value) 
                                                dt))))) 

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(stream-ref (solve (lambda (y) y) 1 0.001) 1000)

