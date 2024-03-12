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

; scale a stream factor
(define (scale-stream stream factor)
(stream-map (lambda (x) (* x factor)) stream))

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


; test random-numbers
(define random-init 1)
(define (rand-update x) 
  (let ((a 48271) (b 0) (m 2147483647))
    (modulo (+ (* a x) b) m)
    )
  )
;(define random-numbers
;  (cons-stream random-init
;               (stream-map rand-update random-numbers)))

(define (request-message r) (car r))
(define (request-reset-value r) (cadr r))

(define (random-numbers request)
  (define (dispatch m-stream random-number)
    (let ((request (stream-car m-stream))
          (next (stream-cdr m-stream))
          )
      (cond ((eq? (request-message request) 'generate)
             (cons-stream random-number
                          (dispatch next
                                    (rand-update random-number))
                          )
             )
            ((eq? (request-message request) 'reset)
             (cons-stream (request-reset-value request)
                          (dispatch next
                                    (rand-update (request-reset-value request)))
                          )
             )
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         request)))
      )
    )
  (dispatch request random-init)
  )

; test
(define requests 
   (cons-stream '(generate)
   (cons-stream '(generate)
   (cons-stream '(generate)
   (cons-stream '(reset 3) 
   (cons-stream '(generate)
   (cons-stream '(generate)
                 the-empty-stream))))))) 

(define test (random-numbers requests))

(display-stream-cnt test 5)

;(display-stream-cnt (random-numbers 'generate) 1)
;(display-stream-cnt ((random-numbers 'reset) 2) 10)
;(display-stream-cnt (random-numbers 'generate) 10)

;(define (map-successive-pairs f s)
;  (cons-stream
 ;  (f (stream-car s) (stream-car (stream-cdr s)))
 ;  (map-successive-pairs f (stream-cdr (stream-cdr s)))))

;(define cesaro-stream
;  (map-successive-pairs (lambda (r1 r2) (= (gcd r1 r2) 1))
;                        random-numbers))

;(display-stream-cnt cesaro-stream 10)