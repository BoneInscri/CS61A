#lang sicp


(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (display "car s : ")
        (display (car s))
        (newline)
        (display "rest : ")
        (display rest)
        (newline)
        (append rest (map (lambda (x)
                            (cons (car s) x)) rest)))))

(subsets (list 1 2 3))