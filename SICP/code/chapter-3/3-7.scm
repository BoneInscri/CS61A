#lang sicp

(define (make-account balance password)
  (define count 0)
  (define (inc-count)
    (set! count (+ count 1))
    )
  (define (error-password x)
    (display "Incorrect password")
    #f
    )
  (define (login try-password)
    (if (eq? try-password password)
        (begin (display "Login success\n") #t)
        (begin (display "Login fail\n") #f)
        )
    )
  (define (call-the-cops x)
    (error "7 incorrect password attempts, the police is coming, hhh")
    )
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch try-password m)
    (if (eq? m 'login)
        (login try-password)
        (if (eq? try-password password)
            (cond ((eq? m 'withdraw) withdraw)
                  ((eq? m 'deposit) deposit)
                  (else (error "Unknown request -- MAKE-ACCOUNT"
                               m)))
            (begin (inc-count)
                   (if (> count 6) call-the-cops error-password))
            )
        )
    )
  dispatch)

(define (make-join account-to password newpassword)
  (if (account-to password 'login)
      (lambda (p m)
        (if (eq? p newpassword)
            (account-to password m)
            (error "Incorrect password")
            )
        )
      (error "make-join error : password is incorrect")
      )
  )

(define boneinscri-acc (make-account 100 'boneinscri))

(define paul-acc (make-join boneinscri-acc 'boneinscri 'paul))

((paul-acc 'paul 'withdraw) 40)
((boneinscri-acc 'boneinscri 'withdraw) 40)
