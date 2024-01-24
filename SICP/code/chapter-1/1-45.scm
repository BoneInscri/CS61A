#lang sicp

; 迭代法求快速幂
(define (fast-expt b n)
  (define (expt-iter b counter product)
    (cond ((= counter 0) product)
          ((even? counter) (expt-iter
                            (* b b) (/ counter 2) product) )
          (else (expt-iter b (- counter 1) (* product b)))
          )) 
  (expt-iter b n 1))

(define (time-out x)
  (> x 100000))
  
; 迭代法求不动点
; 使用runtime记时，发现超过了1000还没有收敛，那就返回
(define (fixed-point f first-guess time-start)
  (define tolerance 0.00001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      ;(display (- (runtime) time-start))
      ;(newline)
      (if (time-out (- (runtime) time-start))
          0
          ; signaling fixed-point fails for these m of average-damp
          (if (close-enough? guess next)
              next
              (try next))
          )))
  (try first-guess))

; 更加通用的不动点求解过程
(define (fixed-point-of-transform g transform guess)
  (fixed-point (transform g) guess (runtime)))

; 平均阻尼加速不动点收敛
(define (average-damp f)
  (define (average a b) (/ (+ a b) 2))
  (lambda (x) (average x (f x))))

; 过程复合
(define (compose f g)
  (lambda (x) (f (g x)))
  )

; n 次调用自身过程
(define (repeated f n)
  (define (iter g count)
    (if (= count 0)
        g
        (iter (compose f g) (- count 1))
        )
    )
  (iter f (- n 1)))


; n 次方根,使用平均阻尼进行加速收敛
; m 是平均阻尼的次数
(define (root-n x n iter-m)
  (define (try-fixed-point m)
    (fixed-point-of-transform (lambda (y) (/ x (fast-expt
                                              y (- n 1))))
                            (repeated average-damp m)
                            1.0))
  (let ((res (try-fixed-point iter-m)))
      (cond ((and (= 0 res) (not (= 0 x)))
             (root-n x n (+ iter-m 1))
         )
        (else
         (display "for n : ")
         (display n)
         (display ", m = ")
         (display iter-m)
         (display " is ok\n")
         res))
    )
  )

; 迭代 n ，即 平方根，立方根，四次方根 ... n 次方根，找到可以收敛的最小 平均阻尼次数
(define (root-n-iter-range x a b)
  (cond ((<= a b)
         (display (root-n x a 1))
         (newline)
         (root-n-iter-range x (+ a 1) b)
         ))
      )

; test, find answer
(root-n-iter-range 2 2 40)