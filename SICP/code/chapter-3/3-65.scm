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

; x^2
(define (square x)
  (* x x))

; scale stream factor
(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor)) stream))

; ref for stream
(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

; 前缀和
(define (partial-sums s) 
    (add-streams s (cons-stream 0 (partial-sums s)))) 


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

; pi (not accelerated)
(define (pi-summands n)
  (cons-stream (/ 1.0 n)
               (stream-map - (pi-summands (+ n 2)))))

; pi-stream (sum stream) (not accelerated)
(define pi-stream
  (scale-stream (partial-sums (pi-summands 1)) 4))

; pi with tolerance
(define (get-pi tolerance)
  (stream-limit pi-stream tolerance))

(display (get-pi 0.001))

; Euler 变换加速求和收敛
(define (euler-transform s)
  (let ((s0 (stream-ref s 0))           ; Sn-1
        (s1 (stream-ref s 1))           ; Sn
        (s2 (stream-ref s 2)))          ; Sn+1
    (cons-stream (- s2 (/ (square (- s2 s1))
                          (+ s0 (* -2 s1) s2)))
                 (euler-transform (stream-cdr s)))))

(define (make-tableau transform s)
  (cons-stream s
               (make-tableau transform
                             (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car
              (make-tableau transform s)))

(define pi-stream-accelerated
  (accelerated-sequence euler-transform pi-stream))

(define (get-pi-accelerated tolerance)
  (stream-limit pi-stream-accelerated tolerance))

(newline)
(display (get-pi-accelerated 0.00000001))


; get-ln2 (not accelerated)
; ln2 (not accelerated)
(define (ln2-summands n)
  (cons-stream (/ 1.0 n)
               (stream-map - (pi-summands (+ n 1)))))

; pi-stream (sum stream) (not accelerated)
(define ln2-stream
  (partial-sums (pi-summands 1)))

; pi with tolerance
(define (get-ln2 tolerance)
  (stream-limit ln2-stream tolerance))

(newline)
(display (get-ln2 0.001))


; get-ln2 (accelerated)
(define ln2-stream-accelerated
  (accelerated-sequence euler-transform ln2-stream))

(define (get-ln2-accelerated tolerance)
  (stream-limit ln2-stream-accelerated tolerance))

(newline)
(display (get-ln2-accelerated 0.000000000000001))
