#lang sicp

(define (exist-cycle? x) 
  (define (scdr l) 
    (if (pair? l) 
        (cdr l) 
        nil )) 
  (define (iter a b) 
    (cond ((not (pair? a)) #f) 
          ((not (pair? b)) #f) 
          ((eq? a b) #t) 
          ((eq? a (scdr b)) #t) 
          (else (iter (scdr a) (scdr (scdr b)))))) 
  (iter (scdr x) (scdr (scdr x))))

(define z1 '(a b c)) 
(exist-cycle? z1)

; z1 -> ( . ) -> ( . ) -> ( . ) -> null 
;          |        |        | 
;          v        v        v 
;         'a       'b       'c 

(define x '(a)) 
(define y (cons x x)) 
(define z2 (list y)) 
(exist-cycle? z2)

; z2 -> ( . ) -> null 
;         | 
;         v 
;       ( . ) 
;        | | 
;        v v 
;       ( . ) -> null 
;         | 
;         v 
;        'a 

(define z3 (cons y y)) 
(exist-cycle? z3)
; z3 -> ( . ) 
;        | | 
;        v v 
;       ( . ) 
;        | | 
;        v v 
;       ( . ) -> null 
;        | 
;        v 
;       'a

  
(define z4 '(a b c)) 
(set-cdr! (cddr z4) z4) 
(exist-cycle? z4) 
;         ,-----------------, 
;         |                 | 
;         v                 | 
; z4 -> ( . ) -> ( . ) -> ( . ) 
;         |        |        | 
;         v        v        v 
;        'a       'b       'c

(define xx (list 'a 'b))
(define z5 (cons xx xx))
(define z6 (cons (list 'a 'b) (list 'a 'b)))
; z5 -> ( . )
;        | |
;        v v
; x --> ( . ) -> ( . ) -> null
;        |        |
;        v        v
;       'a       'b

; z6 -> ( . ) -> ( . ) -> ( . ) -> null
;        |        |        |
;        |        v        v
;        |       'a       'b
;        |        ^        ^
;        |        |        |
;        `-----> ( . ) -> ( . ) -> null
(exist-cycle? z5)
(exist-cycle? z6)