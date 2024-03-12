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

; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

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

; rand
(define random-init 1) 
(define (rand-update x) 
    (let ((a 48271) (b 0) (m 2147483647))
         (modulo (+ (* a x) b) m)
         )
  )

; random-number (stream version)
(define random-numbers
  (cons-stream random-init
               (stream-map rand-update random-numbers)))

(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

; random-in-range for stream
(define (rand-range-stream low high) 
  (cons-stream 
   (random-in-range low high) 
   (rand-range-stream low high))) 

(define (map-successive-pairs f s)
  (cons-stream
   (f (stream-car s) (stream-car (stream-cdr s)))
   (map-successive-pairs f (stream-cdr (stream-cdr s)))))


(define cesaro-stream
  (map-successive-pairs (lambda (r1 r2) (= (gcd r1 r2) 1))
                        random-numbers))

; 蒙特卡罗随机算法
(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (/ passed (+ passed failed))
     (monte-carlo
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))
(define pi
  (stream-map (lambda (p) (sqrt (/ 6 p)))
              (monte-carlo cesaro-stream 0 0)))

; judge condition
(define (square x) (* x x))
(define (square-sum x y) (+ (square x) (square y)))    
(define (in-circle x0 y0 r)
  (lambda (x y)
    (< (square-sum (- x x0) (- y y0)) (square r))
    )
  )

; estimate the integral
(define (estimate-integral P x1 x2 y1 y2)
  (define P-test-stream      
    (stream-map (lambda (x y) (P x y))
                (rand-range-stream x1 x2) (rand-range-stream y1 y2)
                )
    )
  (stream-map (lambda (factor) (* factor 4))
              (monte-carlo P-test-stream 0 0))
  )

(define (estimate-pi-pickpoints r)
  (estimate-integral (in-circle 0 0 r) (- r) r (- r) r)
  )

(stream-ref (estimate-pi-pickpoints 10000) 100000) 