#lang sicp

(define (make-table same-key?)
  (let ((local-table (list '*table*)))
    (define (assoc key records)
      (cond ((null? records) false)
            ((same-key? key (caar records)) (car records))
            (else (assoc key (cdr records)))))
    
    (define (lookup . key)
      (define (lookup-iter key-list table)
        (if (null? key-list)
            (cdr table)
            (let* ((key-i (car key-list))
                   (sub-table (assoc key-i (cdr table)))
                   )
              (if sub-table
                  (lookup-iter (cdr key-list) sub-table)
                  false
                  )
              )
            )
        )
      (lookup-iter key local-table)
      )

    (define (insert! . key-value)  
      (let* ((key-last nil)
             (value nil)
             (new-pair nil))
        (define (split-key-value x)
          (if (not (null? x))
              (begin
                (split-key-value (cdr x))
                (cond ((null? (cdr x)) (set! value (car x)))
                      ((null? (cddr x)) (if (null? key-last) (set! key-last (car x))))
                      ((null? (cdddr x)) (set-cdr! x nil))
                      )
                )
              )
        )
        
        ; get key-prev key-last value
        (split-key-value key-value)
        (set! new-pair (cons key-last value))
        
        ; helper
        (define (make-kdim-table key-p)
          (define (kdim-table key-list)
            (if (null? key-list)
                new-pair
                (list (car key-list) (kdim-table (cdr key-list)))
                )
            )
          (kdim-table key-p)
          )
        (define (insert!-iter key-list table)
          (if (null? key-list)
              ; find the last key
              (let ((record (assoc key-last (cdr table))))
                (if record
                    (set-cdr! record value)
                    (set-cdr! table
                            (cons (cons key-last value)
                                  (cdr table)))
                    )
                )
              ; otherwise
              (let* ((key-i (car key-list))
                     (sub-table (assoc key-i (cdr table)))
                     )
                (if sub-table
                    (insert!-iter (cdr key-list) sub-table)
                    (set-cdr! table (cons (make-kdim-table key-list) (cdr table)))
                    )
                )
              )
          )
        (insert!-iter key-value local-table)
        'ok
        ))
    (define (print-proc)
      (display (cdr local-table))
      (newline)
      )
  
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            ((eq? m 'print-proc) print-proc)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define operation-table (make-table equal?)) 
(define get (operation-table 'lookup-proc)) 
(define put (operation-table 'insert-proc!))
(define print-table (operation-table 'print-proc))
  
; test 
(put 10 10 13 'hello)
(put 11 12 15 'world)
(put 11 12 14 'mygod)
(put 11 13 16 'mygod)
(put 11 13 17 'ohhhh)
(put 11 13 16 'wooow)
(print-table)
(get 10 10 13)
(get 11 12 15)
(get 11 13 16)
(get 11 13 17)