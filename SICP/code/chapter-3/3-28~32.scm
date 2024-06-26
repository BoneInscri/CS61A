#lang sicp

; queue
(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))

(define (make-queue) (cons '() '()))
(define (empty-queue? queue) (null? (front-ptr queue)))
(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue)))
  )
(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           ;queue
           )
          (else
           (set-cdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           ;queue
           ))))
(define (delete-queue! queue)
  (cond ((empty-queue? queue)
         (error "DELETE! called with an empty queue" queue))
        (else
         (let ((front (front-queue queue)))
           (set-front-ptr! queue (cdr (front-ptr queue)))
           front
           ;queue
           )
         ))
  )

; wire
(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (call-each procedures)
      (if (null? procedures)
          'call-each-is-done
          (begin
            ((car procedures))
            (call-each (cdr procedures)))))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
          (begin (set! signal-value new-value)
                 (call-each action-procedures))
          'set-my-signal-is-done))
    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures))
      (proc)
      )
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
            ((eq? m 'set-signal!) set-my-signal!)
            ((eq? m 'add-action!) accept-action-procedure!)
            (else (error "Unknown operation -- WIRE" m))))
    dispatch))

(define (get-signal wire)
  (wire 'get-signal))
(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))
(define (add-action! wire action-procedure)
  ((wire 'add-action!) action-procedure))

; time segment
(define (make-time-segment time queue)
  (cons time queue))
(define (segment-time s) (car s))
(define (segment-queue s) (cdr s))

; agenda
(define (make-agenda) (list 0))
(define (current-time agenda) (car agenda))
(define (set-current-time! agenda time)
  (set-car! agenda time))
(define (segments agenda) (cdr agenda))
(define (set-segments! agenda segments)
  (set-cdr! agenda segments))
(define (first-segment agenda) (car (segments agenda)))
(define (rest-segments agenda) (cdr (segments agenda)))
(define (empty-agenda? agenda)
  (null? (segments agenda)))
(define (add-to-agenda! time action agenda)
  (define (belongs-before? segments)
    (or (null? segments)
        (< time (segment-time (car segments)))))
  (define (make-new-time-segment time action)
    (let ((q (make-queue)))
      (insert-queue! q action)
      (make-time-segment time q)))
  (define (add-to-segments! segments)
    (if (= (segment-time (car segments)) time)
        (insert-queue! (segment-queue (car segments))
                       action)
        (let ((rest (cdr segments)))
          (if (belongs-before? rest)
              (set-cdr!
               segments
               (cons (make-new-time-segment time action)
                     (cdr segments)))
              (add-to-segments! rest)))))
  (let ((segments (segments agenda)))
    (if (belongs-before? segments)
        (set-segments!
         agenda
         (cons (make-new-time-segment time action)
               segments))
        (add-to-segments! segments))))
(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (first-segment agenda))))
    (delete-queue! q)
    (if (empty-queue? q)
        (set-segments! agenda (rest-segments agenda)))))
(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
      (error "Agenda is empty -- FIRST-AGENDA-ITEM")
      (let ((first-seg (first-segment agenda)))
        (set-current-time! agenda (segment-time first-seg))
        (front-queue (segment-queue first-seg)))))

; propagate and delay
(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda))
                  action
                  the-agenda))
(define (propagate)
  (if (empty-agenda? the-agenda)
      'propagate-is-done
      (let ((first-item (first-agenda-item the-agenda)))
        (first-item)
        (remove-first-agenda-item! the-agenda)
        (propagate))
      )
  )

; probe
(define (probe name wire)
  (add-action! wire
               (lambda ()        
                 (newline)
                 (display "current-time : ")
                 (display (current-time the-agenda))
                 (display ", name : ")
                 (display name)
                 (display ", New-value : ")
                 (display (get-signal wire))
                 (newline)
                 )
               ))


; inverter
(define (inverter input output)
  (define (logical-not s)
    (cond ((= s 0) 1)
          ((= s 1) 0)
          (else (error "inverter, invalid signal" s))))
  (define (invert-input)
    ;(display "trigger invert")
    ;(newline)
    (let ((new-value (logical-not (get-signal input))))
      (after-delay inverter-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! input invert-input)
  'set-inverter-ok)


; and-gate
(define (and-gate a1 a2 output)
  (define (logical-and x y)
    (cond ((and (= x 1)
                (= y 1)) 1)
          ((or (and (= x 1) (= y 0))
               (and (= x 0) (= y 1))
               (and (= x 0) (= y 0))
               ) 0)
          (else (error "and-gate, invalid signal" x y))))
  (define (and-action-procedure)
    ;(display "trigger and-gate")
    ;(newline)
    (let ((new-value
           (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'set-and-gate-ok)

; or-gate
(define (or-gate a1 a2 output)
  (define (logical-or x y)
    (cond ((and (= x 0)
                (= y 0)) 0)
          ((or (and (= x 1) (= y 0))
               (and (= x 0) (= y 1))
               (and (= x 1) (= y 1))
               ) 1)
          (else (error "or-gate, invalid signal" x y))))
  (define (or-action-procedure)
    ;(display "trigger or-gate")
    ;(newline)
    (let ((new-value
           (logical-or (get-signal a1) (get-signal a2))))
      (after-delay or-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'set-or-gate-ok
  )

; or-gate using and-gates and inverters
(define (or-gate-slow a1 a2 output)
  (let ((neg-a1 (make-wire))
        (neg-a2 (make-wire))
        (and-two-neg (make-wire))
        )
    (inverter a1 neg-a1)
    (inverter a2 neg-a2)
    (and-gate neg-a1 neg-a2 and-two-neg)
    (inverter and-two-neg output)
    'set-or-gate-slow-ok
    )
  )

; half-adder
(define (half-adder a b s c)
  (let ((d (make-wire)) (e (make-wire)))
    (or-gate a b d)
    (and-gate a b c)
    (inverter c e)
    (and-gate d e s)
    'set-half-adder-ok))

; full-adder
(define (full-adder a b c-in sum c-out)
  (let ((s (make-wire))
        (c1 (make-wire))
        (c2 (make-wire)))
    (half-adder b c-in s c1)
    (half-adder a s sum c2)
    (or-gate c1 c2 c-out)
    'set-full-adder-ok))

; ripple-carry-adder
(define (ripple-carry-adder Ak Bk Sk C)
  (let ((A-n (length Ak))
        (B-n (length Bk))
        (S-n (length Sk))
        )
    
    (define (ripple-carry-adder-iter Ai Bi Si Ci)
      (if (null? Ai)
          'set-ripple-carry-adder-ok
          (let ((C-next (make-wire)))
            (full-adder (car Ai) (car Bi) Ci (car Si) C-next)
            (ripple-carry-adder-iter (cdr Ai) (cdr Bi) (cdr Si) C-next)
            )
          )
      )
    (if (= A-n B-n S-n)
        (ripple-carry-adder-iter Ak Bk Sk C)
        (error "number of wires is error")
        )
    )
  )

; agenda and delay
(define the-agenda (make-agenda))
(define inverter-delay 2)
(define and-gate-delay 3)
(define or-gate-delay 5)

; test for 3-28

;(define input-1 (make-wire))
;(define input-2 (make-wire))
;(define output (make-wire))

;(probe 'output output)

;(or-gate input-1 input-2 output)

;(set-signal! input-1 1)
;(set-signal! input-2 0)
;(propagate)
;(set-signal! input-1 0)
;(set-signal! input-2 0)
;(propagate)


; test for 3-29
;(define input-1 (make-wire))
;(define input-2 (make-wire))
;(define output (make-wire))

;(or-gate-slow input-1 input-2 output)
;(probe 'output output)

;(set-signal! input-1 1)
;(set-signal! input-2 1)
;(propagate)
;(set-signal! input-1 0)
;(set-signal! input-2 0)
;(propagate)
;(set-signal! input-1 1)
;(set-signal! input-2 0)
;(propagate)

; test for 3-30
; 构造排线
;(define (build-wires input-signals) 
;  (if (null? input-signals) 
;      nil 
;      (let ((new-wire (make-wire))) 
;        (set-signal! new-wire (car input-signals)) 
;        (cons new-wire (build-wires (cdr input-signals)))))) 
; 将排线转化为二进制信号         
;(define (get-signals wires) 
;  (map (lambda (w) (get-signal w)) wires)) 
  
;(define (to-binary number) 
;  (if  (< number 2) 
;       (list number) 
;       (cons (remainder number 2) (to-binary (/ number 2)) )))

;(define a (build-wires '(0 0 1 0 0 0))) ;;4 
;(define b (build-wires '(1 1 0 1 0 0))) ;;11 
;(define s (build-wires '(0 0 0 0 0 0))) 
;(define c-in (make-wire)) 
;(ripple-carry-adder a b s c-in) 

;(propagate) 
;(get-signals s)

; 注意，这里的a b s 从左到右是依次低位到高位变化

; test for 3-32
(define input-1 (make-wire))
(define input-2 (make-wire))
(define output (make-wire))

(probe 'output output)

(and-gate input-1 input-2 output)
(set-signal! input-1 0)
(set-signal! input-2 1)
(set-signal! input-1 1)
(set-signal! input-2 0)
(propagate)
