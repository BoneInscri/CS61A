
(define (make-serializer)
(let ((mutex (make-mutex)))
  (lambda (p)
    (define (serialized-p . args)
      (mutex 'acquire)
      (let ((val (apply p args)))
        (mutex 'release)
        val))
    serialized-p)))

(define (test-and-set! cell)
(if (car cell)
    true
    (begin (set-car! cell true)
            false)))

(define (clear! cell)
(set-car! cell false))

(define (make-mutex)
(let ((cell (list false)))            
  (define (the-mutex m)
    (cond ((eq? m 'acquire)
            (if (test-and-set! cell)
                (the-mutex 'acquire)
                )) ; retry
          ((eq? m 'release) (clear! cell))))
  the-mutex))

(define (parallel-execute . thunks)
  (let ((my-threads '()))
    (define (terminator)
      (without-interrupts
       (lambda ()
         (for-each kill-thread my-threads)
         (set! my-threads '())
         unspecific)))
    (without-interrupts
     (lambda ()
       (set! my-threads
             (map (lambda (thunk)
                    (let ((thread (create-thread #f thunk)))
                      (detach-thread thread)
                      thread))
                  thunks))
       unspecific))
    terminator))


(define x 10)

(define s (make-serializer))
(parallel-execute (s (lambda () (set! x ((s (lambda () (* x x))) ))))
              (s (lambda () (set! x (+ x 1)))))
(display x)