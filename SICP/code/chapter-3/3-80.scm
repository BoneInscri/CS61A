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

; ones stream
(define ones (cons-stream 1 ones))

; zero stream
(define zeros (cons-stream 0 zeros))

; infinite stream starting from 1
(define integers (cons-stream 1 (add-streams ones integers)))

(define (RLC R L C dt)
  (lambda (vC0 iL0)
    (define vC (integral (delay dVc) vC0 dt) )  
    (define iL (integral (delay diL) iL0 dt)) 
    (define dVc (scale-stream iL0 (- (/ 1 C))) )
    (define diL (add-streams (scale-stream iL (- (/ R L))) (scale-stream vC (/ 1 L)) ) )
    (cons vC iL)
  )
)

(define (RLC-vC rlc) (car rlc))
(define (RLC-iL rlc) (cadr rlc))

; test
(define R 1)
(define C 0.2)
(define L 1)  (lambda (vC0 iL0)
(define vC (integral (delay dVc) vC0 dt) )  
(define iL (integral (delay diL) iL0 dt)) 
(define dVc (scale-stream iL0 (- (/ 1 C))) )
(define diL (add-streams (scale-stream iL (- (/ R L))) (scale-stream vC (/ 1 L)) ) )
(cons vC iL)
(define dt 0.1)
(define iL0 zeros)
(define vC0 ones)
; (define vC0 10)
; (define iL0 0)

(define RLC1 (RLC R L C dt))
(define test (RLC1 vC0 iL0))