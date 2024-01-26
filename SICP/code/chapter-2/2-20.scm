#lang sicp

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

(define (same-parity x . z)
  (define (check-parity a b)
    (or (and (not (odd? a)) (not (odd? b))) (and (odd? a) (odd? b))))
  
  (define (iter list result)
    (if (null? list)
        result
        (let ((item (car list)))
          (if (check-parity x item)
              (iter (cdr list) (append result (cons item nil)))
              (iter (cdr list) result)
              )
          )
        )
    )
  (iter z (list x))
)

(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)