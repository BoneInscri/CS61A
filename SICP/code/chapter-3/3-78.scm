
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
(define (solve-2nd a b dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (add-streams (scale-stream dy a) (scale-stream y b)))
  y)


(stream-ref (solve-2nd 1 0 0.0001 1 1) 10000)  ; e                                                         
(stream-ref (solve-2nd 0 -1 0.0001 1 0) 10472)  ; cos pi/3 = 0.5                                           
(stream-ref (solve-2nd 0 -1 0.0001 0 1) 5236)  ; sin pi/6 = 0.5 
