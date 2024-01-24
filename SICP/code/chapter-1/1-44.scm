#lang sicp

; 过程复合
(define (compose f g)
  (lambda (x) (f (g x)))
  )

; n 次调用自身
(define (repeated f n)
  (define (iter g count)
    (if (= count 0)
        g
        (iter (compose f g) (- count 1))
        )
    )
  (iter f (- n 1)))

; 平滑
(define (smooth f)
  (define dx 0.00001)
  (define (average_3 a b c)
    (/ (+ a b c) 3))
  (lambda (x)
    (average_3 (f (- x dx))
               (f x)
               (f (+ x dx)))))

; n 次平滑
(define (n-fold-smooth f n)
  ((repeated smooth n) f))

(define (square x) (* x x))

((smooth square) 4)

; 10 次平滑 最后代入 4
((n-fold-smooth square 10) 4)