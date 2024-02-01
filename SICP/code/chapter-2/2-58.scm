#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence))))
  )

(define (priority op) 
  (cond
    [(eq? op '+) 0] 
    [(eq? op '*) 1] 
    [(eq? op '**) 2]
    [(eq? op 'maxop) 3]
    [else (error "unknown op")]
    )) 
(define (operator? op)
  (or (eq? op '+) (eq? op '*) (eq? op '**) (eq? op 'maxop)))

(define (min-op a b)
  (if (< (priority a) (priority b))
      a
      b))

(define (smallest-op exp)
  (accumulate (lambda (a b)
                (if (operator? a)
                    (min-op a b)
                    b)
                )
              'maxop
              exp))

(define (remove-bracket exp)
  (if (pair? exp)
      (if (null? (cdr exp))
          (car exp)
          exp
      )
      (error "remove-bracket ???")
      )
  )

; 前缀
(define (prefix exp op)
  (define (do-prefix exp op)
    (if (eq? (car exp) op)
        nil
        (cons (car exp) (do-prefix (cdr exp) op)))    
    )
  (remove-bracket (do-prefix exp op))
)

; 后缀
(define (suffix exp op)
  (define (do-suffix exp)
    (if (null? exp)
        nil
        (cons (car exp) (do-suffix (cdr exp)))
        )
    )
  (define (find-start exp op)
    (if (eq? (car exp) op)
        (cdr exp)
        (find-start (cdr exp) op)
        )
    )
  (remove-bracket (do-suffix (find-start exp op)))
  )

; 快速幂
(define (fast-expt b n)
  (define (expt-iter b counter product)
    (cond ((= counter 0) product)
          ((even? counter)
           (expt-iter (* b b) (/ counter 2) product) )
          (else
           (expt-iter b (- counter 1) (* product b)))
          )) 
  (expt-iter b n 1))


(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))
(define (=number? exp num)
  (and (number? exp) (= exp num)))

; sum
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))
(define (sum? expr) 
  (eq? '+ (smallest-op expr)))   
(define (addend s) (prefix s '+))
(define (augend s) (suffix s '+))

; product
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))
(define (product? expr) 
  (eq? '* (smallest-op expr)))

(define (multiplier p) (prefix p '*))
(define (multiplicand p) (suffix p '*))

; exponent
(define (make-exponentiation b e)
  (cond ((=number? e 0) 1)
        ((=number? e 1) b)
        ((and (number? b) (number? e)) (fast-expt b e))
        (else (list b '** e))
        ))
(define (exponentiation? x)
  (eq? '** (smallest-op x)))
(define (base e)
  (prefix e '**))
(define (exponent e)
  (suffix e '**))

(define (deriv exp var)
  (cond ((number? exp) 0); 常数,返回0
        ((variable? exp); 变量, 如果exp和var是相同的变量,返回1,否则,返回0
         (if (same-variable? exp var) 1 0))
        ((sum? exp); 如果表达式是求和表达式?
         (make-sum (deriv (addend exp) var); 加数
                   (deriv (augend exp) var))); 被加数
        ((product? exp); 如果表达式是求积表达式?
         (make-sum
          (make-product (multiplier exp); 乘数
                        (deriv (multiplicand exp) var)); 被乘数求导
          (make-product (deriv (multiplier exp) var); 乘法求导
                        (multiplicand exp)))); 被乘数
        ((exponentiation? exp); 如果表达式是求幂表达式?
         (let ((n (exponent exp))
               (u (base exp)))
           (make-product (make-product n (make-exponentiation u (- n 1)))
                         (deriv u var))                         
           ))
        (else
         (error "unknown expression type -- DERIV" exp))))

(deriv '(x + 3 * (x + y + 2)) 'x)
(deriv '(x + (3 * (x + (y + 2)))) 'x)
(deriv '(y + 3 * y + x ** 5) 'x)
