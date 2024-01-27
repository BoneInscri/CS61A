#lang sicp

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))
; 点乘
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

; 矩阵乘以向量
(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))

; 矩阵转置
(define (transpose mat)
  (accumulate-n cons nil mat))

; 矩阵乘矩阵
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))
; 好好体会 matrix-*-matrix
; cols 就是 n 的转置
; 核心思想就是 cols 的每一列 和 m 进行矩阵乘以向量运算
; 太妙了

; test
(define M (list (list 1 2 3)
                (list 4 5 6)
                (list 7 8 9)
                (list 10 11 12)))
(define M2 (list (list 2 0 0 0)
                 (list 0 2 0 0)
                 (list 0 0 2 0)))
(define v1 (list 1 2 3))
(define v2 (list 2 2 2))

(accumulate-n + 0 M)
; (22 26 30)
(dot-product v1 v2)

(matrix-*-vector M v2)

(transpose M)
; 太奇妙了，居然可以这么实现矩阵的转置。

(matrix-*-matrix M M2)