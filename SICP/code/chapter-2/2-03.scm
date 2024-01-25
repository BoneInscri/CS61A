#lang sicp

(define (square x) (* x x))
(define (sum-of-square x y)
  (+ (square x) (square y)))

(define (average x y) (/ (+ x y) 2))

; point
(define (make-point x y)
  (cons x y))
(define (x-point x) (car x))
(define (y-point x) (cdr x))

(define (distance start-point end-point)
  (sqrt (sum-of-square (- (x-point start-point) (x-point end-point))
                       (- (y-point start-point) (y-point end-point))
                      )))

(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

; rectangle 计算周长和面积的通用接口 
(define (perimeter-rect rect)
  (* 2 (+ (w rect) (h rect))))
(define (area-rect rect)
  (* (w rect) (h rect)))

; type 1, w + h + angle + origin
; (define (make-rect point-origin angle w h)
;  (cons point-origin (cons angle (cons w h))))
; (define (w rect)
;  (car (cdr (cdr rect))))
; (define (h rect)
;  (cdr (cdr (cdr rect))))

; (define origin1 (make-point 1 1))
; (define height1 4.0)
; (define width1 5.0)
; (define angle1 0.2)
; (define r1 (make-rect origin1 angle1 height1 width1))
; (display "Rectangle 1: ") (newline)
; (display "Perimeter: ") (display (perimeter-rect r1)) (newline)
; (display "Area ") (display (area-rect r1)) (newline) (newline)

; type 2, p1 + p2 + p3, angle(p2p1p3) = 90
(define (make-rect p1 p2 p3)
 (cons p1 (cons p2 p3)))
(define (p1-rect rect)
 (car rect))
(define (p2-rect rect)
 (car (cdr rect)))
(define (p3-rect rect)
 (cdr (cdr rect)))

(define (w rect)
 (distance (p1-rect rect) (p2-rect rect)))
(define (h rect)
 (distance (p1-rect rect) (p3-rect rect)))

(define p4 (make-point 0 0))
(define p5 (make-point 10 -2))
(define p6 (make-point 1 5))
(define r2 (make-rect p4 p5 p6))

(display "Rectangle 2: ") (newline)
(display "Perimeter: ") (display (perimeter-rect r2)) (newline)
(display "Area ") (display (area-rect r2)) (newline) (newline)
