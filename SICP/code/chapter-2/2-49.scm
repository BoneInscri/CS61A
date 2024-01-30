#lang sicp 
(#%require sicp-pict) 
 
; vector
(define (make-vect xcor ycor)
  (list xcor ycor))
(define (xcor-vect vec)
  (car vec))
(define (ycor-vect vec)
  (car (cdr vec)))
(define (add-vect vec1 vec2)
  (make-vect (+ (xcor-vect vec1) (xcor-vect vec2))
             (+ (ycor-vect vec1) (ycor-vect vec2))))
(define (sub-vect vec1 vec2)
  (make-vect (- (xcor-vect vec1) (xcor-vect vec2))
             (- (ycor-vect vec1) (ycor-vect vec2))))
(define (scale-vect s vec)
  (make-vect (* s (xcor-vect vec))
             (* s (ycor-vect vec))))

; segment
(define (make-segment vect1 vect2)
  (cons vect1 vect2))
(define (start-segment segment)
  (car segment))
(define (end-segment segment)
  (cdr segment))

; frame
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))
(define (origin-frame frame)
  (car frame))
(define (edge1-frame frame)
  (car (cdr frame)))
(define (edge2-frame frame)
  (car (cdr (cdr frame))))
(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
                           (edge1-frame frame))
               (scale-vect (ycor-vect v)
                           (edge2-frame frame))))))

(define outline 
  (segments->painter 
   (list 
    (segment (vect 0.0 0.0) (vect 0.0 1.0)) 
    (segment (vect 0.0 0.0) (vect 1.0 0.0)) 
    (segment (vect 0.0 1.0) (vect 1.0 1.0)) 
    (segment (vect 1.0 0.0) (vect 1.0 1.0)))))   
(paint outline) 
  
(define x-painter 
  (segments->painter 
   (list 
    (segment (vect 0.0 0.0) (vect 1.0 1.0)) 
    (segment (vect 0.0 1.0) (vect 1.0 0.0))))) 
(paint x-painter) 
  
(define diamond 
  (segments->painter 
   (list 
    (segment (vect 0.0 0.5) (vect 0.5 1.0)) 
    (segment (vect 0.5 1.0) (vect 1.0 0.5)) 
    (segment (vect 1.0 0.5) (vect 0.5 0.0)) 
    (segment (vect 0.5 0.0) (vect 0.0 0.5))))) 
(paint diamond)
; Not sure if the below implementation unnecessarily complicates the process 
; Measurements of frame on kindle x: 1.5 y: 1.8 
(define x 1.5) 
(define y 1.8) 
  
; Define helper functions 
; takes a list of coords with the format x1 y1 x2 y2 and normalises them wrt measurements 
(define (normalize coords) 
  (let ((x1 (car coords)) 
        (y1 (cadr coords)) 
        (x2 (caddr coords)) 
        (y2 (cadddr coords))) 
    (list (/ x1 x) (/ y1 y) (/ x2 x) (/ y2 y))))  
  
; symmetry will be useful 
(define (mirror coords) 
  (list (- x (car coords)) (cadr coords) (- x (caddr coords)) (cadddr coords)))  
  
; takes a list of coords converts to a line segment 
(define (list->line coords) 
  (let ((x1 (car coords)) 
        (y1 (cadr coords)) 
        (x2 (caddr coords)) 
        (y2 (cadddr coords))) 
    (segment (vect x1 y1) (vect x2 y2)))) 
  
; define wave coords 
(define wave-coords 
  (list 
   (list 0.5 1.5 0.65 y) 
   (mirror (list 0.5 1.5 0.65 y)) 
   (list 0.5 1.5 0.65 1.2) 
   (mirror (list 0.5 1.5 0.65 1.2)) 
   (list 0.5 1.22 0.65 1.2) ;; left neck (0.65 1.2) 
   (mirror (list 0.5 1.22 0.65 1.2)) 
   (list 0.5 1.22 0.3 1.05) 
   (mirror (list 0.5 1.22 0.3 1.05)) 
   (list 0.3 1.05 0.0 1.35) 
   (list (- x 0.3) 1.05 x 0.65) 
   (list 0.4 0 0.55 1) ;; left armpit (0.55 1) 
   (mirror (list 0.4 0 0.55 1)) 
   (list 0.55 1 0.25 0.85) 
   (mirror (list 0.4 0 0.55 1)) 
   (list 0.25 0.85 0 1.15) 
   (list (- x 0.55) 1 x 0.5) 
   (list 0.6 0 0.7 0.5) 
   (mirror (list 0.6 0 0.7 0.5)) 
   (list 0.7 0.5 (/ x 2) 0.58) 
   (mirror (list 0.7 0.5 (/ x 2) 0.58)))) 
  
(define wave 
  (segments->painter 
   (map list->line (map normalize wave-coords)))) 

(define (split op1 op2)
  (define (iter painter n)
    (if (= n 0)
        painter
        (let ((smaller (iter painter (- n 1))))
          (op1 painter (op2 smaller smaller)))
        ))
  (lambda (painter n) (iter painter n))
  )
(define right-split (split beside below))
(define up-split (split below beside))
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))
(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))

(paint wave) 
(paint (square-limit wave 10))

(define (my-flip-vert painter)
  (transform-painter painter
                     (vect 0.0 1.0)   ; new origin
                     (vect 1.0 1.0)   ; new end of edge1
                     (vect 0.0 0.0))) ; new end of edge2

(paint (my-flip-vert wave))
