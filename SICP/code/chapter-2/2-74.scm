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

; binary set
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))
(define (list->tree elements)
  (define (partial-tree elts n)
    (if (= n 0)
        (cons '() elts)
        (let ((left-size (quotient (- n 1) 2)))
          (let ((left-result (partial-tree elts left-size)))
            (let ((left-tree (car left-result))
                  (non-left-elts (cdr left-result))
                  (right-size (- n (+ left-size 1))))
              (let ((this-entry (car non-left-elts))
                    (right-result (partial-tree (cdr non-left-elts)
                                                right-size)))
                (let ((right-tree (car right-result))
                      (remaining-elts (cdr right-result)))
                  (cons (make-tree this-entry left-tree right-tree)
                        remaining-elts)
                  )
                )
              )
            )
          )
        )
    )
  (car (partial-tree elements (length elements))))

; add tag for procedure
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


; table entry = key + record
(define (key r)
  (car r))

; unordered list
(define (install-A-package)
  (define (A-get-name record)
    (cadr record))
  (define (A-get-salary record)
    (caddr record))
  (define (A-get-age record)
    (cadddr record))

  (define (A-get-record set-of-records)
    (define (iter check? records)
      (cond ((null? records) false)
            ((check? (car records))
             (car records))
            (else (iter check? (cdr records))))
      )
    (lambda (check?) (iter check? set-of-records))
    )
  
  (define (tag x)
    (attach-tag 'A x))
  (put 'make-table-A 'A (lambda (x) (tag (map (lambda (table-entry) (tag table-entry)) x))))

  (put 'get-record 'A A-get-record)
  (put 'get-salary 'A A-get-salary)
  (put 'get-age 'A A-get-age)
  (put 'get-name 'A A-get-name)
  
  )

; unordered list
(define (install-B-package)
  (define (B-get-name record)
    (caadr record))
  (define (B-get-salary record)
    (cadadr record))
  (define (B-get-age record)
    (cadadr record))
  (define (B-get-address record)
    (caddr record))

  (define (B-get-record set-of-records)
    (define (iter check? records)
      (cond ((null? records) false)
            ((check? (car records))
             (car records))
            (else (iter check? (cdr records))))
      )
    (lambda (check?) (iter check? set-of-records))
    )
  (define (tag x)
    (attach-tag 'B x))
  (put 'make-table-B 'B (lambda (x) (tag (map (lambda (table-entry) (tag table-entry)) x))))

  (put 'get-record 'B B-get-record)
  (put 'get-name 'B B-get-name)
  (put 'get-salary 'B B-get-salary)
  (put 'get-age 'B B-get-age)
  (put 'get-address 'B B-get-address))

; binary tree
(define (install-C-package)
  (define (C-get-name record)
    (caadr record))
  (define (C-get-salary record)
    (car (cadadr record)))
  (define (C-get-work-year record)
    (cadr (cadadr record)))

  (define (C-get-record set-of-records)
    (define (iter check? records)
      (cond ((null? records) false)
            ((check? (entry records))
             (entry records))
            (else
             (let ((left (iter check? (left-branch records))))
               (if (not left)
                   (let ((right (iter check? (right-branch records))))
                     (if (not right)
                         false
                         right
                         )
                     )
                   left
                   )
               )
             ))
      )
    (lambda (check?) (iter check? set-of-records))
    )
  (define (tag x)
    (attach-tag 'C x))
 
  (put 'make-table-C 'C (lambda (x) (tag (list->tree (map (lambda (table-entry) (tag table-entry)) x)))))
  
  (put 'get-record 'C C-get-record)
  (put 'get-name 'C C-get-name)
  (put 'get-salary 'C C-get-salary)
  (put 'get-work-year 'C C-get-work-year)
  )

(install-A-package)
(install-B-package)
(install-C-package)

; use data tag to get generic interfaces
(define (apply-generic op . args)
  (let ((type-tags (car (map type-tag args))))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
           "No method for these types -- APPLY-GENERIC"
           (list op type-tags))))))

(define (get-salary record) (apply-generic 'get-salary record))
(define (get-name record) (apply-generic 'get-name record))
(define (get-work-year record) (apply-generic 'get-work-year record))
(define (get-age record) (apply-generic 'get-age record))
(define (get-record table check?) ((apply-generic 'get-record table) check?))
(define (find-employee-record Table-list name)
  (define (iter-table table-list)
    (if (null? table-list)
        false
        (let ((find-result (get-record (car table-list) (lambda (x) (equal? (get-name x) name)))))
          (if (not find-result)
              (iter-table (cdr table-list))
              find-result)
          ))
    )
  (iter-table Table-list))

(define (make-table-A table)
  ((get 'make-table-A 'A) table))
(define (make-table-B table)
  ((get 'make-table-B 'B) table))
(define (make-table-C table)
  ((get 'make-table-C 'C) table))

(define Table-A (make-table-A (list (list 1 'Harry 2000 18)
                                    (list 2 'Rone 3000 20)
                                    (list 3 'Dagua 2500 21)
                                    )))
(define Table-B (make-table-B (list (list 1 (list 'Jonh 1800 21) 'Street_1)
                                    (list 2 (list 'Jack 2100 23) 'Street_3)
                                    (list 3 (list 'Rose 4000 23) 'Street_2)
                                    (list 4 (list 'Kitty 4500 28) 'Street_8)
                                    )))
(define Table-C (make-table-C (list (list 1 (list 'Hallen (list 3100 10)))
                                    (list 2 (list 'Jane (list 2400 3)))
                                    (list 3 (list 'Hack (list 4000 1)))
                                    (list 4 (list 'Qiao (list 3000 5)))
                                    (list 5 (list 'Luffy (list 7000 6)))
                                    )
                              ))
(define Table-list (list Table-A Table-B Table-C))

; test
(define record-1 (get-record Table-A (lambda (x) (equal? (get-name x) 'Rone))))
(define record-2 (get-record Table-B (lambda (x) (equal? (get-name x) 'Rose))))
(define record-3 (get-record Table-C (lambda (x) (equal? (get-name x) 'Qiao))))

record-1
record-2
record-3

(get-salary record-1)
(get-salary record-2)
(get-salary record-3)

(get-age record-1)
(get-work-year record-3)

(find-employee-record Table-list 'Hack)
(find-employee-record Table-list 'Dagua)
