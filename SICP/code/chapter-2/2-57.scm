#lang sicp

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
(define (make-sum a1 a2 . an)
  (define (iter-an list result num cnt)
    (if (null? list)
        (if (and (= num 0) (= cnt 0))
            0
            (if (= num 0)
                (if (= cnt 1)
                    (car result)
                    (cons '+ result)
                    )
                (if (= cnt 1)
                    (car (append result (cons num nil)))
                    (append (cons '+ result) (cons num nil)))
                )
            )
        (let ((item (car list)))
          (if (number? item)
              (if (=number? item 0)
                  (iter-an (cdr list) result num cnt)
                  (iter-an (cdr list) result (+ num item) 1)
                  )
              (iter-an (cdr list) (append result (cons item nil)) num (+ cnt 1))
              )
          )
        )
    )
  
  (if (null? a1)
      (iter-an (append (list a2) (car an)) nil 0 0)
      (iter-an (append (list a1 a2) an) nil 0 0)
      )
  )

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))
(define (addend s) (cadr s))
(define (augend s) (make-sum nil (caddr s) (cdddr s)))

; product
(define (make-product m1 m2 . mn)
  (define (iter-mn list result num cnt-num cnt-s)
    (if (= num 0)
        0
        (if (null? list)
            (if (= num 1)
                (if (= (+ cnt-num cnt-s) 1)
                    (car result)
                    (cons '* result)
                    )
                (if (= (+ cnt-num cnt-s) 1)
                    (car (append result (cons num nil)))
                    (append (cons '* result) (cons num nil)))
                )
            (let ((item (car list)))
              (if (number? item)
                  (if (=number? item 0)
                      (iter-mn (cdr list) result 0 0 cnt-s)
                      (if (=number? item 1)
                          (iter-mn (cdr list) result (* num item) cnt-num cnt-s)
                          (iter-mn (cdr list) result (* num item) 1 cnt-s)
                          )
                      )
                  (iter-mn (cdr list) (append result (cons item nil)) num cnt-num (+ cnt-s 1))
                  )
              )
            )
        )
    )
  (if (null? m1)
      (iter-mn (append (list m2) (car mn)) nil 1 0 0)
      (iter-mn (append (list m1 m2) mn) nil 1 0 0)
      )
  )

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))
(define (multiplier p) (cadr p))
(define (multiplicand p)
  (make-product nil (caddr p) (cdddr p)))

; exponent
(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))
(define (base e)
  (cadr e))
(define (exponent e)
  (caddr e))
(define (make-exponentiation b e)
  (cond ((=number? e 0) 1)
        ((=number? e 1) b)
        ((and (number? b) (number? e)) (fast-expt b e))
        (else (list '** b e))
        ))

(define (deriv exp var)
  (cond ((number? exp) 0); 常数,返回0
        ((variable? exp); 变量, 如果exp和var是相同的变量,返回1,否则,返回0
         (if (same-variable? exp var) 1 0))
        ((exponentiation? exp); 如果表达式是求幂表达式?
         (let ((n (exponent exp))
               (u (base exp)))
           (make-product n
                         (make-exponentiation u (- n 1))
                         (deriv u var))                         
           ))
        ((product? exp); 如果表达式是求积表达式?
         (make-sum
          (make-product (multiplier exp); 乘数
                        (deriv (multiplicand exp) var)); 被乘数求导
          (make-product (deriv (multiplier exp) var); 乘法求导
                        (multiplicand exp)))); 被乘数
        ((sum? exp); 如果表达式是求和表达式?
         (make-sum (deriv (addend exp) var); 加数
                   (deriv (augend exp) var))); 被加数
        (else
         (error "unknown expression type -- DERIV" exp))
        ))
(deriv '(* x y (+ x 3)) 'x)
(deriv '(** x 3) 'x)
(deriv '(+ x 3) 'x)
(deriv '(* x x) 'x)
(deriv '(** x 3) 'x)
(deriv '(+ (** x 4) (** x 2)) 'x)
(deriv '(+ (* 4 y) (* 4 x) (** x 4)) 'x)
