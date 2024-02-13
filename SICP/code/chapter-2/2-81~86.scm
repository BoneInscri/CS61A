#lang sicp

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

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (if (eq? type1 type2)
                    (error "No method for these types"
                           (list op type-tags))
                    (let ((t1->t2 (get-coercion type1 type2))
                          (t2->t1 (get-coercion type2 type1)))
                      (cond (t1->t2
                             (apply-generic op (t1->t2 a1) a2))
                            (t2->t1
                             (apply-generic op a1 (t2->t1 a2)))
                            (else
                             (error "No method for these types"
                                    (list op type-tags)))))
                    ))
              (error "No method for these types"
                     (list op type-tags)))))))

; generic ops
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
(define (equ? x y) (apply-generic 'equ? x y))
(define (=zero? x) (apply-generic '=zero? x))
(define (exp x y) (apply-generic 'exp x y))


; scheme-number
(define (install-scheme-number-package) 
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (+ x y))
       ;(lambda (x y) (tag (+ x y)))
       )
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (- x y))
       ;(lambda (x y) (tag (- x y)))
       )
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (* x y))
       ;(lambda (x y) (tag (* x y)))
       )
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (/ x y))
       ;(lambda (x y) (tag (/ x y)))
       )
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (= x y))
       )
  (put '=zero? '(scheme-number)
       (lambda (x) (= x 0))
       )
  (put 'exp '(scheme-number scheme-number)
     (lambda (x y) (expt x y)))
  
  (put 'make 'scheme-number
       (lambda (x) x)
       ;(lambda (x) (tag x)))
       ))
(install-scheme-number-package)
(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

; rational number
(define (install-rational-package)
  ;; internal procedures
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (if (= d 0)
        (error "denom can't be 0"))
    (let ((g (gcd n d)))
      (cons (/ n g) (/ d g))))
  (define (add-rat x y)
    (make-rat (+ (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (- (* (numer x) (denom y))
                 (* (numer y) (denom x)))
              (* (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (* (numer x) (numer y))
              (* (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (* (numer x) (denom y))
              (* (denom x) (numer y))))
  (define (equ?-rat x y)
    (and (= (numer x) (numer y))
         (= (denom x) (denom y))))
  (define (=zero?-rat x)
    (= (numer x) 0))
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
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d)))))
(install-rational-package)
(define (make-rational n d)
  ((get 'make 'rational) n d))

; complex number
(define (install-complex-package)
  (define (square x) (* x x))
  ; 直角坐标表示的complex
  (define (install-rectangular-package)
    ;; internal procedures
    (define (real-part z) (car z))
    (define (imag-part z) (cdr z))
    (define (make-from-real-imag x y) (cons x y))
    (define (magnitude z)
      (sqrt (+ (square (real-part z))
               (square (imag-part z)))))
    (define (angle z)
      (atan (imag-part z) (real-part z)))
    (define (make-from-mag-ang r a) 
      (cons (* r (cos a)) (* r (sin a))))
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
    (define (magnitude z) (car z))
    (define (angle z) (cdr z))
    (define (make-from-mag-ang r a) (cons r a))
    (define (real-part z)
      (* (magnitude z) (cos (angle z))))
    (define (imag-part z)
      (* (magnitude z) (sin (angle z))))
    (define (make-from-real-imag x y) 
      (cons (sqrt (+ (square x) (square y)))
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
    (make-from-real-imag (+ (real-part z1) (real-part z2))
                         (+ (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (- (real-part z1) (real-part z2))
                         (- (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                       (+ (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                       (- (angle z1) (angle z2))))
  (define (equ?-complex z1 z2)
    (and (= (real-part z1) (real-part z2))
         (= (imag-part z1) (imag-part z2))))
  (define (=zero?-complex z1)
    (and (= (real-part z1) 0)
         (= (imag-part z1) 0)))
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
       (lambda (r a) (tag (make-from-mag-ang r a)))))
(install-complex-package)
(define (make-complex-from-real-imag x y)
  ((get 'make-from-real-imag 'complex) x y))
(define (make-complex-from-mag-ang r a)
  ((get 'make-from-mag-ang 'complex) r a))
(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'magnitude z))
(define (angle z) (apply-generic 'angle z))

; set coercion table
(define (scheme-number->complex n)
  (make-complex-from-real-imag (contents n) 0))
(define (scheme-number->scheme-number n) n)
(define (complex->complex z) z)

(put-coercion 'scheme-number 'complex scheme-number->complex)
(put-coercion 'scheme-number 'scheme-number
              scheme-number->scheme-number)
(put-coercion 'complex 'complex complex->complex)

; test
(define n1 (make-scheme-number 2))
(define n2 (make-scheme-number 4))
(define r1 (make-rational 2 3))
(define r2 (make-rational 4 5))
(define z1 (make-complex-from-real-imag 3 4))   
(define z2 (make-complex-from-real-imag 2 5))
(exp n1 n2)
;(exp z1 z2)