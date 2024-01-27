#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (adjoin-position row col rest) 
  (cons (list row col) rest)
  ) 
  
(define (check a b)    ; returns true if two positions are compatible 
  (let ((ax (car a))   ; x-coord of pos a 
        (ay (cadr a))  ; y-coord of pos a 
        (bx (car b))   ; x- coord of pos b 
        (by (cadr b))) ; y-coord of pos b 
    (and (not (= ax bx)) (not (= ay by))  ; checks col / row 
         (not (= (abs (- ax bx)) (abs (- ay by)))))))
; checks diag 对角线上不能有 
  
(define (safe? y)
  (= 0 (accumulate + 0 
                   (map (lambda (x) 
                          (if (check (car y) x) 0 1)) 
                        (cdr y))))) 
  
(define (queens board-size) 
  (define (queen-cols k) 
    (if (= k 0) 
        (list nil) 
        (filter
         (lambda (positions) (safe? positions)) 
         (flatmap (lambda (rest-of-queens) 
                    (map (lambda (new-row) 
                           (adjoin-position new-row
                                            k rest-of-queens)
                           ) 
                         (enumerate-interval 1 board-size)
                         )
                    ) 
                  (queen-cols (- k 1))
                  )
         )
        )
    )
  (queen-cols board-size)) 

(queens 8)
(length (queens 8))