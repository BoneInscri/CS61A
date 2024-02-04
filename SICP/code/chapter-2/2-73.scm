#lang sicp
; 2d table 
; a global table
(define (make-table) (list '*table*))
(define *table* (make-table))
; put and get 
(define (put op type item)
  (define (insert2! key-1 key-2 value table) 
    (let ((subtable (assoc key-1 (cdr table)))) 
      (if subtable 
          ; subtable exist 
          (let ((record (assoc key-2 (cdr subtable)))) 
            (if record 
                (set-cdr! record value) ; modify record 
                (set-cdr! subtable 
                          (cons (cons key-2 value) (cdr subtable))) ; add record 
                ) 
            ) 
          ; subtable doesn't exist, insert a subtable 
          (set-cdr! table 
                    (cons (list key-1 (cons key-2 value)) ; inner subtable 
                          (cdr table)) 
                    ) 
          ) 
      ) 
    ) 
  (insert2! op type item *table*)) 
(define (get op type)
  (define (lookup2 key-1 key-2 table) 
    (let ((subtable (assoc key-1 (cdr table)))) 
      (if subtable 
          (let ((record (assoc key-2 (cdr subtable)))) 
            (if record 
                (cdr record) 
                #f 
                ) 
            ) 
          #f 
          ) 
      ) 
    ) 
  (lookup2 op type *table*)) 

(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))
(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (attach-tag type-tag contents)
  (cons type-tag contents))
(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum -- TYPE-TAG" datum)))
(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum -- CONTENTS" datum)))

(define (make-sum a1 a2 . an) 
  ;(apply (get 'make-sum '+) (append (list a1 a2) an))
  (apply (get '+ 'make-sum) (append (list a1 a2) an))
  ) 
(define (make-product a1 a2 . an) 
  ;(apply (get 'make-product '*) (append (list a1 a2) an))
  (apply (get '* 'make-product) (append (list a1 a2) an))
  ) 


; 对于 sum 表达式 的过程
(define (install-sum-package)
  ;; internal procedures
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
  (define (addend operands) (car operands))
  (define (augend operands) (make-sum nil
                                      (cadr operands)
                                      (cddr operands)))
  (define (deriv-sum operands var)
    (make-sum (deriv (addend operands) var)
              (deriv (augend operands) var))  
  )
  ;; interface to the rest of the system
  ;(put 'deriv '+ deriv-sum)
  ;(put 'make-sum '+ make-sum)
  (put '+ 'deriv deriv-sum)
  (put '+ 'make-sum make-sum))

; 对于 product 表达式 的过程
(define (install-product-package)
  ;; internal procedures
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
  (define (multiplier operands) (car operands))
  (define (multiplicand operands)
    (make-product nil (cadr operands) (cddr operands)))
  
  (define (deriv-product operands var)
      (make-sum
       (make-product (multiplier operands); 乘数
                     (deriv (multiplicand operands) var)); 被乘数求导
       (make-product (deriv (multiplier operands) var); 乘法求导
                     (multiplicand operands)))  
    )
  ;; interface to the rest of the system
;  (put 'deriv '* deriv-product)
;  (put 'make-product '* make-product)

  (put '* 'deriv deriv-product)
  (put '* 'make-product make-product))

; 对于 exponentiation 表达式 的过程
(define (install-exponentiation-package)
  ;; internal procedures
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
  
  (define (base operands)
    (car operands))
  (define (exponent operands)
    (cadr operands))
  (define (make-exponentiation b e)
    (cond ((=number? e 0) 1)
          ((=number? e 1) b)
          ((and (number? b) (number? e)) (fast-expt b e))
          (else (list '** b e))
          ))
  (define (deriv-exponentiation operands var)
      (let ((n (exponent operands))
            (u (base operands)))
        (make-product n
                      (make-exponentiation u (- n 1))
                      (deriv u var))                         
        ))
  ;; interface to the rest of the system
;  (put 'deriv '** deriv-exponentiation)
  (put '** 'deriv deriv-exponentiation))

(install-sum-package)
(install-product-package)
(install-exponentiation-package)


(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) (if (same-variable? exp var) 1 0))
        (else
         ;((get 'deriv (operator exp)) (operands exp) var)
         ((get (operator exp) 'deriv) (operands exp) var)
         )))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(deriv '(* x y (+ x 3)) 'x)
(deriv '(** x 3) 'x)
(deriv '(+ x 3) 'x)
(deriv '(* x x) 'x)
(deriv '(** x 3) 'x)
(deriv '(+ (** x 4) (** x 2)) 'x)
(deriv '(+ (* 4 y) (* 4 x) (** x 4)) 'x)
