
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

; add two streams
(define (add-streams s1 s2)
(stream-map + s1 s2))

; scale a stream factor
(define (scale-stream stream factor)
(stream-map (lambda (x) (* x factor)) stream))

; integral for stream with delayed parameter
(define (integral delayed-integrand initial-value dt) 
        (cons-stream initial-value 
                (let ((integrand (force delayed-integrand))) 
                        (if (stream-null? integrand) 
                                the-empty-stream 
                                (integral (delay (stream-cdr integrand)) 
                                          (+ (* dt (stream-car integrand)) 
                                                    initial-value) 
                                              dt)))))
; map for stream (multiple arguments)
(define (stream-map proc . argstreams)
(if (stream-null? (car argstreams))
    the-empty-stream
    (cons-stream
     (apply proc (map stream-car argstreams))
     (apply stream-map
            (cons proc (map stream-cdr argstreams))))))

(define (solve-2nd-expand f dt y0 dy0) 
  (define y (integral (delay dy) y0 dt)) 
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f dy y)) 
y) 

(define (f1 a b) (lambda (x y) (+ (* a x) (* b y)) ) )

(stream-ref (solve-2nd-expand (f1 1 0) 0.0001 1 1) 10000)  ; e                                                         
(stream-ref (solve-2nd-expand (f1 0 -1) 0.0001 1 0) 10472)  ; cos pi/3 = 0.5                                           
(stream-ref (solve-2nd-expand (f1 0 -1) 0.0001 0 1) 5236)  ; sin pi/6 = 0.5 
