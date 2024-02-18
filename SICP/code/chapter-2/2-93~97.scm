#lang sicp

; 2d-table
(define *table-op* (list '*table-op*))
(define *table-coercion* (list '*table-coercion*))

(define (insert2! key-1 key-2 value table) 
  (let ((subtable (assoc key-1 (cdr table)))) 
    (if subtable 
        ; subtable exist 
        (let ((record (assoc key-2 (cdr subtable)))) 
          (if record 
              (set-cdr! record value)
              ; modify record 
              (set-cdr! subtable 
                        (cons (cons key-2 value) (cdr subtable)))
              ; add record 
              ) 
          ) 
        ; subtable doesn't exist, insert a subtable 
        (set-cdr! table 
                  (cons (list key-1 (cons key-2 value))
                        ; inner subtable 
                        (cdr table)) 
                  ) 
        ) 
    ) 
  )

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

; put and get 
(define (put op type item)
  (insert2! op type item *table-op*))
  
(define (get op type) 
  (lookup2 op type *table-op*))

(define (put-coercion op type item)
  (insert2! op type item *table-coercion*))
  
(define (get-coercion op type) 
  (lookup2 op type *table-coercion*))


; add tag for procedure
(define (attach-tag type-tag contents)
  (cons type-tag contents))
(define (type-tag datum)
  (cond ((pair? datum) (car datum))
        ((number? datum) 'scheme-number)
        (else
         (error "Bad tagged datum -- TYPE-TAG" datum))
        ))
(define (contents datum)
  (cond ((pair? datum) (cdr datum))
        ((number? datum) datum)
        (else
         (error "Bad tagged datum -- CONTENTS" datum))
        )
  )

; turn x to scheme-real
(define (raise-to-scheme-real x)
  (contents (try-raise x 'real))
  )

(define (level type) 
  (cond
    [(eq? type 'mintype) -1]     
    [(eq? type 'scheme-number) 0] 
    [(eq? type 'rational) 1]
    [(eq? type 'real) 2]
    [(eq? type 'complex) 3]
    [(eq? type 'polynomial) 4]
    [(eq? type 'maxtype) 5]
    [else (error "unknown type" type)]
    ))

(define (highest-type args)
  (define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence))))
    )
  (define (higher-type a b)
    (if (> (level a) (level b))
        a
        b))
  (accumulate (lambda (a b)
                (higher-type a b))
              'mintype
              args))

; try raise x to target-type
(define (try-raise x target-type)
  (if (eq? (type-tag x) target-type)
      x
      (try-raise (raise x) target-type))
  )

(define (apply-generic op . args)
  ; get type-tags of args
  (define (get-type-tags args)
    (map type-tag args)
    )

  ; try drop x to simplest type
  (define (try-drop x)
    (if (or (eq? x #t) (eq? x #f))
        x
        (let ((project-func (get 'project (type-tag x)))); don't use get-type-tags
          (if project-func
              (let ((project-x (project-func (contents x))))
                (if (eq? project-x #f)
                    x
                    (try-drop project-x)
                    )
                )
              x
              )
          )
        )
    )

  ; apply try-raise for args
  (define (raise-args args type-tags)
    (let ((highest-type (highest-type type-tags)))
      (let ((coerced-args (map (lambda (x) (try-raise x highest-type)) args)))
        (let ((proc (get op (get-type-tags coerced-args))))
          (if proc
              (try-drop (apply proc (map contents coerced-args)))
              (error "No method for these types" (list op type-tags))
              )
          )
        )
      )
    )

  
  (let ((type-tags (get-type-tags args)))
    (let ((proc (get op type-tags)))
      (if proc
          (let ((res (apply proc (map contents args))))
            (if (or (eq? op 'raise) (eq? op 'project) (eq? op 'print))
                res ; don't drop when op is raise or project
                (try-drop res)
                )
            )
          (raise-args args type-tags)
          )
      )
    )
  )

; generic ops
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (equ? x y) (apply-generic 'equ? x y))
(define (=zero? x) (apply-generic '=zero? x))
(define (exp x y) (apply-generic 'exp x y))
(define (add-three x y z) (apply-generic 'add-three x y z))
(define (raise x) (apply-generic 'raise x))
(define (project x) (apply-generic 'project x))
(define (neg x) (apply-generic 'neg x))
(define (print x) (apply-generic 'print x))
(define (my-gcd x y) (apply-generic 'my-gcd x y))
(define (reduce x y) (apply-generic 'reduce x y))

; scheme-number
(define (install-scheme-number-package)
  (define (my-gcd a b)
    (if (= b 0)
        a
        (my-gcd b (remainder a b))))
  
  (define (reduce-integers n d)
    (let ((g (my-gcd n d)))
      (list (/ n g) (/ d g))))
  
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (+ x y))
       )
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (- x y))
       )
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (* x y))
       )
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (/ x y))
       )
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y))
       )
  (put '=zero? '(scheme-number)
       (lambda (x) (= x 0))
       )
  (put 'exp '(scheme-number scheme-number)
       (lambda (x y) (expt x y)))

  (put 'add-three '(scheme-number scheme-number scheme-number)
       (lambda (x y z) (+ x y z))
       )
  (put 'raise '(scheme-number)
       (lambda (x)
         (make-rational x 1))
       )
  (put 'neg '(scheme-number)
       (lambda (x)
         (- x)
         )
       )
  (put 'print '(scheme-number)
       (lambda (x)
         (display x)
         )
       )
  (put 'my-gcd '(scheme-number scheme-number)
       (lambda (x y)
         (my-gcd x y)
         )
       )
  (put 'reduce '(scheme-number scheme-number)
       (lambda (x y)
         (reduce-integers x y)
         )
       )
  (put 'make 'scheme-number
       (lambda (x) x)
       )
  )
(install-scheme-number-package)
(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

; rational number
(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (if (=zero? d)
        (error "denom can't be 0"))
    ;(define s (if (or (and (> 0 n) (> 0 d)) (and (< 0 n) (< 0 d))) 1 -1))
    (let ((res (reduce n d)))
      (cons (car res) (cadr res))
      )
    ;(let ((g (my-gcd n d)))
    ; ?.0 -> ?
    ;  (cons (inexact->exact (* s (abs (/ n g))))
    ;        (inexact->exact (abs (/ d g)))
    ;        )
      ;(display "g : ")
      ;(display g)
      ;(newline)
      ;(cons (div n g) (div d g))
      ;)
    )
  (define (add-rat x y)
    (make-rat (add (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                   (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))
  (define (equ?-rat x y)
    (and (equ? (numer x) (numer y))
         (equ? (denom x) (denom y))))
  (define (=zero?-rat x)
    (=zero? (numer x))
    )

  (define (round-to-two-decimal num)
    (/ (round (* num 100)) 100))
  ;; interface to rest of the system
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'equ? '(rational rational)
       (lambda (x y) (equ?-rat x y)))
  (put '=zero? '(rational)
       (lambda (x) (=zero?-rat x)))
  (put 'raise '(rational)
       (lambda (x) (make-real (round-to-two-decimal (* 1.0 (/ (numer x) (denom x))) ))))
  (put 'project 'rational
       (lambda (x)
         (if (equ? (denom x) 1)
             (make-scheme-number (numer x))
             #f
             ))
       )
  
  (put 'add-three '(rational rational rational)
       (lambda (x y z) (tag (add-rat (add-rat x y) z)))
       )
  (put 'neg '(rational)
       (lambda (x)
         (make-rational (neg (numer x)) (denom x))
         )
       )
  (put 'print '(rational)
       (lambda (x)
         (print (numer x))
         (display " / ")
         (print (denom x))
         )
       )
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d)))))
(install-rational-package)
(define (make-rational n d)
  ((get 'make 'rational) n d))

(define (install-real-package)
  (define (tag x) (attach-tag 'real x))
  (put 'add '(real real)
       (lambda (x y) (tag (+ x y)))
       )
  (put 'sub '(real real)
       (lambda (x y) (tag (- x y)))
       )
  (put 'mul '(real real)
       (lambda (x y) (tag (* x y)))
       )
  (put 'div '(real real)
       (lambda (x y) (tag (/ x y)))
       )
  (put 'equ? '(real real)
       (lambda (x y) (= x y))
       )
  (put '=zero? '(real)
       (lambda (x) (= x 0))
       )
  (put 'exp '(real real)
       (lambda (x y) (tag (expt x y))))

  (put 'add-three '(real real real)
       (lambda (x y z) (tag (+ x y z)))
       )
  (put 'raise '(real)
       (lambda (x)
         (make-complex-from-real-imag x 0)
         )
       )
  (put 'project 'real
       (lambda (x)
         (define (get-denom-mul10 x)
           (if (= (round x) x)
               1
               (* 10 (get-denom-mul10 (* 10 x)))
               )           
           )
         (let ((new-denom (get-denom-mul10 x)))
           (make-rational (* x new-denom) new-denom)
           )
         )
       )
  (put 'neg '(real)
       (lambda (x)
         (- x)
         )
       )
  (put 'print '(real)
       (lambda (x)
         (display x)
         )
       )
  (put 'make 'real
       (lambda (x) (tag x)))
  )
  

(install-real-package)
(define (make-real n)
  ((get 'make 'real) n))

; complex number
(define (install-complex-package)
  (define (square x) (mul x x))
  ; 直角坐标表示的complex
  (define (install-rectangular-package)
    ;; internal procedures
    (define (real-part z) (raise-to-scheme-real (car z)))
    (define (imag-part z) (raise-to-scheme-real (cdr z)))
    
    (define (make-from-real-imag x y) (cons x y))
    (define (magnitude z)
      (sqrt (add (square (real-part z))
                 (square (imag-part z)))))
    (define (angle z)
      (atan (imag-part z) (real-part z)))
    (define (make-from-mag-ang r a) 
      (cons (mul r (cos a)) (mul r (sin a))))
    ;; interface to the rest of the system
    (define (tag x) (attach-tag 'rectangular x))
    (put 'real-part '(rectangular) real-part)
    (put 'imag-part '(rectangular) imag-part)
    (put 'magnitude '(rectangular) magnitude)
    (put 'angle '(rectangular) angle)
    (put 'make-from-real-imag 'rectangular 
         (lambda (x y) (tag (make-from-real-imag x y))))
    (put 'make-from-mag-ang 'rectangular 
         (lambda (r a) (tag (make-from-mag-ang r a)))))
  ; 极坐标表示的complex
  (define (install-polar-package)
    ;; internal procedures
    (define (magnitude z) (raise-to-scheme-real (car z)))
    (define (angle z) (raise-to-scheme-real (cdr z)))

    (define (make-from-mag-ang r a) (cons r a))
    (define (real-part z)
      (mul (magnitude z) (cos (angle z))))
    (define (imag-part z)
      (mul (magnitude z) (sin (angle z))))
    (define (make-from-real-imag x y) 
      (cons (sqrt (add (square x) (square y)))
            (atan y x)))
    ;; interface to the rest of the system
    (define (tag x) (attach-tag 'polar x))
    (put 'real-part '(polar) real-part)
    (put 'imag-part '(polar) imag-part)
    (put 'magnitude '(polar) magnitude)
    (put 'angle '(polar) angle)
    (put 'make-from-real-imag 'polar
         (lambda (x y) (tag (make-from-real-imag x y))))
    (put 'make-from-mag-ang 'polar 
         (lambda (r a) (tag (make-from-mag-ang r a)))))
  
  ;; imported procedures from rectangular and polar packages
  (install-rectangular-package)
  (install-polar-package)
  (define (real-part z) (apply-generic 'real-part z))
  (define (imag-part z) (apply-generic 'imag-part z))
  (define (magnitude z) (apply-generic 'magnitude z))
  (define (angle z) (apply-generic 'angle z))
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))
  
  ;; internal procedures
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))
                         (add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2))
                         (sub (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2))
                       (add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2))
                       (sub (angle z1) (angle z2))))
  (define (equ?-complex z1 z2)
    (and (equ? (real-part z1) (real-part z2))
         (equ? (imag-part z1) (imag-part z2))))
  (define (=zero?-complex z1)
    (and (equ? (real-part z1) 0)
         (equ? (imag-part z1) 0)))
  (define (add-three-complex z1 z2 z3)
    (make-from-real-imag (add-three (real-part z1) (real-part z2) (real-part z3))
                         (add-three (imag-part z1) (imag-part z2) (imag-part z3))))
  ;; interface to rest of the system
  (define (tag z) (attach-tag 'complex z))
  (put 'real-part '(complex) real-part)
  (put 'imag-part '(complex) imag-part)
  (put 'magnitude '(complex) magnitude)
  (put 'angle '(complex) angle)
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'equ? '(complex complex)
       (lambda (z1 z2) (equ?-complex z1 z2)))
  (put '=zero? '(complex)
       (lambda (z1) (=zero?-complex z1)))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  (put 'add-three '(complex complex complex)
       (lambda (z1 z2 z3) (tag (add-three-complex z1 z2 z3))))
  (put 'project 'complex
       (lambda (z1)
         (if (=zero? (imag-part z1))
             (real-part z1)
             #f
             )
         )
       )
  (put 'raise '(complex)
       (lambda (z1)
         (make-polynomial-sparse 'x (list (list 0 (tag z1))))
         )
       )
  
  (put 'neg '(complex)
       (lambda (x)
         (make-complex-from-real-imag (- (real-part x)) (- (imag-part x)))
         )
       )
  (put 'print '(complex)
       (lambda (x)
         (print (real-part x))
         (display "+")
         (print (imag-part x))
         (display " i")
         )
       )
  )
(install-complex-package)
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))
(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

(define (install-polynomial-package)
  ; helper
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  (define (variable? x) (symbol? x))

  ; representation of poly
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  
  ; representation of term
  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))
  (define (neg-term term) (make-term (order term) (neg (coeff term))))

  ; representation of term lists
  (define (empty-termlist? term-list) (null? (cdr term-list)))
  (define (the-empty-termlist term-list) (attach-tag (type-tag term-list) nil))
  (define (cons-term term term-list)
    (cons (car term-list) (cons term (cdr term-list))); consider term-list tag
    )
  
  ; sparse term list
  (define (install-sparse-term-list-package)
    (define (first-term term-list) (car term-list))
    (define (rest-terms term-list) (cdr term-list))
    (define (adjoin-term term term-list)
      (if (=zero? (coeff term))
          term-list
          (cons-term term term-list)
          )
      )
      
    (define (tag x) (attach-tag 'sparse x))

    (put 'first-term '(sparse)
         (lambda (x) (first-term x))
         )
    (put 'rest-terms '(sparse)
         (lambda (x) (tag (rest-terms x)))
         )
    (put 'adjoin-term 'sparse
         adjoin-term
         )
    )
  (install-sparse-term-list-package)
   
  ; dense term list
  (define (install-dense-term-list-package)
    (define (first-term term-list) (make-term (- (length term-list) 1)
                                              (car term-list)))
    (define (rest-terms term-list) (cdr term-list))
    (define (adjoin-term term term-list)
      (if (=zero? (coeff term))
          term-list
          (if (= (order term) (- (length term-list) 1)); must -1
              (cons-term (coeff term) term-list)
              (adjoin-term term (cons-term 0 term-list))
              )
          )
        
      )
    
    (define (tag x) (attach-tag 'dense x))
    (put 'first-term '(dense)
         (lambda (x) (first-term x))
         )
    (put 'rest-terms '(dense)
         (lambda (x) (tag (rest-terms x)))
         )
    (put 'adjoin-term 'dense
         adjoin-term)
    )
  (install-dense-term-list-package)
  
  (define (first-term term-list)
    (apply-generic 'first-term term-list)
    )
  (define (rest-terms term-list)
    (apply-generic 'rest-terms term-list)
    )
  (define (adjoin-term term term-list)
    (let ((adjoin-term-func (get 'adjoin-term (type-tag term-list))))
      (adjoin-term-func term term-list)
      )
    )
  
  ; add
  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
           (let ((t1 (first-term L1)) (t2 (first-term L2)))
             (cond ((> (order t1) (order t2))
                    (adjoin-term
                     t1 (add-terms (rest-terms L1) L2)))
                   ((< (order t1) (order t2))
                    (adjoin-term
                     t2 (add-terms L1 (rest-terms L2))))
                   (else
                    (adjoin-term
                     (make-term (order t1)
                                (add (coeff t1) (coeff t2)))
                     (add-terms (rest-terms L1)
                                (rest-terms L2)))))))))
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (add-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- ADD-POLY"
               (list p1 p2))))

  ; mul
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
        (the-empty-termlist L)
        (let ((t2 (first-term L)))
          (adjoin-term
           (make-term (+ (order t1) (order t2))
                      (mul (coeff t1) (coeff t2)))
           (mul-term-by-all-terms t1 (rest-terms L))))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
        (the-empty-termlist L1)
        (add-terms (mul-term-by-all-terms (first-term L1) L2)
                   (mul-terms (rest-terms L1) L2))))
  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (mul-terms (term-list p1)
                              (term-list p2)))
        (error "Polys not in same var -- MUL-POLY"
               (list p1 p2))))
  
  ; =zero?
  (define (=zero?-poly p1)
    (define (=zero-term term-list)
      (if (empty-termlist? term-list)
          #t
          (let ((first-term (first-term term-list)))
            (if (=zero? (coeff first-term))
                (=zero-term (rest-terms term-list))
                #f
                )
            )
          )
      )
    (=zero-term (term-list p1))
    )

  ; neg
  (define (neg-terms term-list)
    (if (empty-termlist? term-list)
        (the-empty-termlist term-list)
        (let ((t1 (first-term term-list)))
          (adjoin-term
           (neg-term t1) (neg-terms (rest-terms term-list)))
          )
        )
    )
  (define (neg-poly p1)
    (make-polynomial (variable p1) (neg-terms (term-list p1)))
    )

  ; sub
  (define (sub-terms p1 p2)
    (add-terms p1
               (neg-terms p2)
               )
    )
  (define (sub-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (sub-terms (term-list p1)
                              (term-list p2)
                              )
                   )
        (error "Polys not in same var -- SUB-POLY"
               (list p1 p2))))

  ; div
  (define (div-terms L1 L2)
    ; return quotient and remainder
    (if (empty-termlist? L1)
        (list (the-empty-termlist L1) (the-empty-termlist L1))
        (let ((t1 (first-term L1))
              (t2 (first-term L2)))
          (if (> (order t2) (order t1))
              (list (the-empty-termlist L1) L1)
              (let ((new-c (div (coeff t1) (coeff t2)))
                    (new-o (- (order t1) (order t2))))
                (let ((new-term (make-term new-o new-c)))
                  (let ((rest-of-result
                         (div-terms (sub-terms L1
                                               (mul-term-by-all-terms new-term
                                                                      L2))
                                    L2)
                         ; <compute rest of result recursively>
                         ))
                    ; new-c : new-coeff
                    ; new-o : new-order
                    (cons (adjoin-term new-term (car rest-of-result)) (cdr rest-of-result))
                    ;<form complete result>
                    )
                  )
                )
              )
          )
        )
    )
  (define (div-poly p1 p2)    
    (if (same-variable? (variable p1) (variable p2))
        (let ((res (div-terms (term-list p1)
                              (term-list p2)
                              )))
          (cons (make-poly (variable p1) (car res)) (make-poly (variable p1) (cadr res)))
          )
        (error "Polys not in same var -- DIV-POLY"
               (list p1 p2)))
    )
  
  ; my-gcd
  (define (remainder-terms L1 L2)
    (let ((res (div-terms L1
                          L2)))
      (cadr res)
      )
    )
  (define (quotient-terms L1 L2)
    (let ((res (div-terms L1
                          L2)))
      (car res)
      )
    )
  (define (pseudoremainder-terms P Q)
    (let ((O1 (order (first-term P)))
          (O2 (order (first-term Q)))
          (c (coeff (first-term Q)))
          )
      (let ((factor (exp c (- (+ 1 O1) O2))))
        (let ((res (div-terms (mul-term-by-all-terms (make-term 0 factor) P)
                              Q)))
          (cadr res)
          ) 
        )
      )
    )
  (define (gcd-terms a b)
    (if (empty-termlist? b)
        (let* ((coeff-list (map coeff (cdr a))) 
               (gcd-coeff (apply gcd coeff-list)))
          (quotient-terms a (attach-tag (type-tag a) (list (make-term 0 gcd-coeff))))
        ) 
        (gcd-terms b (pseudoremainder-terms a b))
        ;a
        ;(gcd-terms b (remainder-terms a b))
        ))
  (define (gcd-poly p1 p2)    
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                   (gcd-terms (term-list p1)
                              (term-list p2)
                              )
                   )
        (error "Polys not in same var -- GCD-POLY"
               (list p1 p2)))
    )

  ; simplify polynomial
  (define (simplify-terms term-list)
    (if (empty-termlist? term-list)
        (the-empty-termlist term-list)
        (let ((t1 (first-term term-list)))  
          (if (=zero? (coeff t1))
              (simplify-terms (rest-terms term-list))
              (adjoin-term t1 (simplify-terms (rest-terms term-list))
               )
              )
          )    
        )
    )
  
  ; equ?
  (define (dense-to-sparse L)
    (define (do-dense-to-sparse term-list)
      (if (empty-termlist? term-list)
          (list 'sparse)
          (let ((t1 (first-term term-list)))
            (if (=zero? (coeff t1))
                (do-dense-to-sparse (rest-terms term-list))
                (adjoin-term t1 (do-dense-to-sparse (rest-terms term-list)))
                )
            )
          )
      )
    (cond ((eq? (type-tag L) 'sparse)
           L)
          ((eq? (type-tag L) 'dense)
           (do-dense-to-sparse L))
          (else
           (error "error term list type : " (type-tag L))
           )
        )
    )
  
  (define (equ-terms L1 L2)
    (cond ((and (empty-termlist? L1) (empty-termlist? L2)) #t)
          ((and (not (empty-termlist? L1)) (not (empty-termlist? L2)))
           (let ((t1 (first-term L1))
                 (t2 (first-term L2)))
             (if (and (equ? (coeff t1) (coeff t2)) (= (order t1) (order t2)))
                 (equ-terms (rest-terms L1) (rest-terms L2))
                 #f
                 )
             )   
           )
          (else #f)
          )
    )
  (define (equ?-ply p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (let ((L1 (term-list p1))
              (L2 (term-list p2)))
          (equ-terms (dense-to-sparse L1)
                     (dense-to-sparse L2)
                     )
          )
        #f
        )
    )
  ; print
  (define (print-poly p1)
    (define (print-terms var terms)
      (if (not (empty-termlist? terms))
          (let ((t1 (first-term terms)))
            (print (coeff t1))
            (display var)
            (display "^")
            (display (order t1))
            (display " ")
            (print-terms var (rest-terms terms))
            ))
      )
    (print-terms (variable p1) (term-list p1))
    )

  ; reduce
  (define (reduce-terms n d)
    (if (empty-termlist? n)
        (list n d)
        (let* ((gcd-n-d (gcd-terms n d))
               (O1 (max (order (first-term n)) (order (first-term d))))
               (O2 (order (first-term gcd-n-d)))
               (c (coeff (first-term gcd-n-d)))
               (factor (exp c (- (+ 1 O1) O2)))
               (n-scale (mul-term-by-all-terms (make-term 0 factor) n))
               (d-scale (mul-term-by-all-terms (make-term 0 factor) d))
               (nn (quotient-terms n-scale gcd-n-d))
               (dd (quotient-terms d-scale gcd-n-d)))
          (list nn dd)
          )
        )
    )
  (define (reduce-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (map (lambda (x)
               (make-poly (variable p1) x))
             (reduce-terms (term-list p1)
                           (term-list p2)))
        (error "Polys not in same var -- REDUCE-POLY"
               (list p1 p2)))
    )
  
  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial) 
       (lambda (p1 p2) (tag (add-poly p1 p2)))
       )
  (put 'mul '(polynomial polynomial) 
       (lambda (p1 p2) (tag (mul-poly p1 p2)))
       )
  (put '=zero? '(polynomial) 
       (lambda (p1) (=zero?-poly p1))
       )
  (put 'neg '(polynomial)
       (lambda (p1) (neg-poly p1) )
       )
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (sub-poly p1 p2)))
       )
  (put 'div '(polynomial polynomial)
       (lambda (p1 p2)
         (let ((res (div-poly p1 p2)))
           (cons (tag (car res)) (tag (cdr res)))
           )
         )
       )
  (put 'equ? '(polynomial polynomial)
       (lambda (p1 p2)
         (equ?-ply p1 p2)
         )
       )
  (put 'project 'polynomial
       (lambda (p1)
         (cond ((=zero?-poly p1)
                (make-scheme-number 0))
               ((and (= (length (term-list p1)) 2)
                     (= (order (first-term (term-list p1))) 0))
                (coeff (first-term (term-list p1)))
                )
               (else #f)
               )
         )
       )
  (put 'print '(polynomial)
       (lambda (p1)
         (print-poly p1)
         )
       )
  (put 'my-gcd '(polynomial polynomial)
       (lambda (p1 p2)
         (tag (gcd-poly p1 p2))
         )
       )
  (put 'reduce '(polynomial polynomial)
       (lambda (p1 p2)
         (map tag (reduce-poly p1 p2))
         )
       )
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var (simplify-terms terms))))
       )
  )

(install-polynomial-package)
(define (make-polynomial-dense var terms)
  ((get 'make 'polynomial) var (attach-tag 'dense terms))
  )
(define (make-polynomial-sparse var terms)
  ((get 'make 'polynomial) var (attach-tag 'sparse terms))
  )
(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms)
  )
(define (div-quotient p1 p2)
  (car (div p1 p2))
  )
(define (div-remainder p1 p2)
  (cdr (div p1 p2))
  )

; test
(define p01 (make-polynomial-sparse 'x '((4 0) (3 1) (0 0))))
(define p02 (make-polynomial-dense 'x '(0 0 2 0 1)))
(define pe1 (make-polynomial-sparse 'x '((5 4) (4 0) (3 2) (2 0))))
(define pe2 (make-polynomial-dense 'x '(4 2 0 0 1)))

(define p3 (make-polynomial-sparse 'x '((4 1) (3 -1) (2 -2) (1 2))))
(define p4 (make-polynomial-sparse 'x '((3 1) (1 -1))))

;(gcd p3 p4)

(define P1 (make-polynomial-sparse 'x '((2 1) (1 -2) (0 1))))
(define P2 (make-polynomial-sparse 'x '((2 11) (0 7))))
(define P3 (make-polynomial-sparse 'x '((1 13) (0 5))))

(define Q1 (mul P1 P2))
(define Q2 (mul P1 P3))

;Q1
;Q2

(my-gcd Q1 Q2)


(define t-p1 (make-polynomial-sparse 'x '((1 1) (0 1))))
(define t-p2 (make-polynomial-sparse 'x '((3 1) (0 -1))))
(define t-p3 (make-polynomial-sparse 'x '((1 1))))
(define t-p4 (make-polynomial-sparse 'x '((2 1) (0 -1))))

(define p1 (make-polynomial-sparse 'x '((2 1) (0 1)))); x^2 + 1
(define p2 (make-polynomial-sparse 'x '((3 1) (0 1)))); x^3 + 1

(define rf (make-rational p2 p1))
(add (add rf rf) rf)

(define r1 (make-rational 2 8))
(define r2 (make-rational -2 8))
(define r3 (make-rational -2 -8))
(define r4 (make-rational 2 -8))
r1
r2
r3
r4