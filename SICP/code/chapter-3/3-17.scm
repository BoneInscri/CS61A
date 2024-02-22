#lang sicp

(define (count-pairs x)
  (let ((vis nil))
    (define (iter x)
      (if (or (not (pair? x)) (memq x vis))
          0
          (begin (set! vis (cons x vis))
                 (+ (iter (car x))
                    (iter (cdr x))
                    1))
          )
      )
    (iter x)
    )
  )

(define z1 '(a b c)) 
(count-pairs z1)


; z1 -> ( . ) -> ( . ) -> ( . ) -> null 
;          |        |        | 
;          v        v        v 
;         'a       'b       'c 

(define x '(a)) 
(define y (cons x x)) 
(define z2 (list y)) 
(count-pairs z2)

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
(count-pairs z3)
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
(count-pairs z4) 
;         ,-----------------, 
;         |                 | 
;         v                 | 
; z4 -> ( . ) -> ( . ) -> ( . ) 
;         |        |        | 
;         v        v        v 
;        'a       'b       'c

