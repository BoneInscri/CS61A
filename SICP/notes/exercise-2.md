

#### **Exercise 2.1.** 

Define a better version of `make-rat` that handles both positive and negative arguments. `Make-rat` should normalize the sign so that 

if the rational number is positive, **both the numerator and denominator are positive**, and 

if the rational number is negative, **only the numerator is negative**.

（1）如果有理数是正数，那么其分子和分母都是正数

（2）如果有理数是负数，那么其分母是正数，分子是负数





#### **Exercise 2.2.** 

Consider the problem of **representing line segments in a plane**. 

平面上表示线段

Each segment is represented as a pair of points: **a starting point and an ending point.** 

每个段表示为一对点：**一个起点和一个终点。**

Define a constructor `make-segment` and selectors `start-segment` and `end-segment` that define the representation of segments in terms of points. 

make、start、end

Furthermore, a point can be represented as a pair of numbers: **the *x* coordinate and the *y* coordinate.** 

一个点可以表示为一对数字：***x*坐标和*y*坐标**。

Accordingly, specify a constructor `make-point` and selectors `x-point` and `y-point` that define this representation. 

相应地，指定一个构造函数make-point和选择器x-point和y-point来定义这种表示。

Finally, using your selectors and constructors, define a procedure `midpoint-segment` that takes a line segment as argument and **returns its midpoint** (the point whose coordinates are the average of the coordinates of the endpoints)

定义过程，返回线段的中点。 

To try your procedures, you'll need a way to print points:

```lisp
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))
```



#### **Exercise 2.3.** 

Implement a representation for rectangles in a plane. 

实现平面中矩形的表示。

(Hint: You may want to make use of exercise 2.2.) 

In terms of your **constructors and selectors**, create procedures that compute the perimeter and the area of a given rectangle. 

计算矩形的周长和面积

Now implement a different representation for rectangles. 

Can you design your system with suitable abstraction barriers, so that the same perimeter and area procedures will work using either representation?



使用抽象屏障构建两种不同的矩形的表示？

（1）左上角point + 右下角point

（2）左上角point + 长 + 宽



第二种的右下角point可以通过第一种的左上角point + 长 + 宽推导出来。



**实现的方法和具体的数据结构细节没有关系**

**也就是说如果我们修改了数据结构的定义，计算周长和面积的定义是不需要改的。**



**等等，这里平面中的矩形可以是倾斜的！！！**

https://sicp-solutions.net/post/sicp-solution-exercise-2-3/

<img src="exercise-2.assets/image-20240125100121950.png" alt="image-20240125100121950" style="zoom:50%;" />

<img src="exercise-2.assets/image-20240125100135865.png" alt="image-20240125100135865" style="zoom:50%;" />



#### **Exercise 2.4.** 

Here is an alternative procedural representation of pairs. 

For this representation, verify that `(car (cons x y))` yields `x` for any objects `x` and `y`.

```lisp
(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))
```

What is the corresponding definition of `cdr`? 

(Hint: To verify that this works, make use of the substitution model of section 1.1.5.)

验证合理性，并写出cdr？

```
(car (cons x y))
->
((cons x y) (lambda (p q) p))
->
((lambda (p q) p) (x y))
->
x
```



#### **Exercise 2.5.** 

Show that we can represent pairs of nonnegative integers using only numbers and arithmetic operations if we represent **the pair *a* and *b* as the integer that is the product $2^a 3^b$.** 

Give the corresponding definitions of the procedures `cons`, `car`, and `cdr`.

（1）cons返回 $2^a3^b$

（2）car返回 a 

（3）cdr返回 b



#### **Exercise 2.6.** 

In case **representing pairs as procedures** wasn't mind-boggling enough, consider that, in a language that can manipulate procedures, we can get by without numbers (at least insofar as nonnegative integers are concerned) by implementing 0 and the operation of adding 1 as

```lisp
(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))
```

可以用多种不同的方法表示 pair 。

This representation is known as ***Church numerals***, after its inventor, Alonzo Church, the logician who invented the $\lambda$ calculus.

**丘奇数字，Church numerals，即$\lambda $ 算术。**

Define `one` and `two` **directly** (not in terms of `zero` and `add-1`). 

**直接**按照上面的方法定义 数字 1 和 数字 2 

(Hint: Use substitution to evaluate `(add-1 zero)`). 

**Give a direct definition of the addition procedure `+`** 

(not in terms of repeated application of `add-1`).

给出加法 '+' 的**直接定义**，不要用 add - 1 进行运算。

```lisp
(add-1 zero)
->
(lambda (f)
        (lambda (x)
                (f
                 (((lambda (f)
                           (lambda (x) x)) f) x))))
->
(lambda (f)
        (lambda (x)
                (f ((lambda (x) x) x))))
->
(lambda (f)
        (lambda (x)
                (f x)))
```

```lisp
(add-1 one)
->
(lambda (f)
        (lambda (x)
                (f (
                    ((lambda (f) (lambda (x) (f x))) f)
                    x))))
->
(lambda (f)
        (lambda (x)
                (f ((lambda (x) (f x)) x))))
->
(lambda (f)
        (lambda (x)
                (f (f x))))
```

丘奇数的加法？

对 b 施加 a 次 add-1 就可以。

```lisp
; 对 b 施加一次 add-1
(lambda (f) (lambda (x) (f ((b f) x))))

; 对 b 施加两次 add-1
(lambda (f)
        (lambda (x)
                (f (((lambda (f) (lambda (x) (f ((b f) x)))) f) x))))
->
(lambda (f)
        (lambda (x)
                (f ((lambda (x) (f ((b f) x))) x))))
->
(lambda (f)
        (lambda (x)
                (f (f ((b f) x)))))
; 所以对 b 施加 a 次 add-1,就是在((b f) x)外层施加 a 次 f
->
(lambda (f)
        (lambda (x)
                ((a f) ((b f) x))))
; 比如 a = 2
(lambda (f)
        (lambda (x)
                ((two f) ((b f) x))))
->
(lambda (f)
        (lambda (x)
                (((lambda (f) (lambda (x) (f (f x)))) f) ((b f) x))))
->
(lambda (f)
        (lambda (x)
                ((lambda (x) (f (f x))) ((b f) x))))
->
(lambda (f)
        (lambda (x)
                (f (f ((b f) x)))))
```





