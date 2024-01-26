

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



#### **Exercise 2.7.** 

Alyssa's program is incomplete because she has not specified the implementation of the interval abstraction. 

Here is a definition of the interval constructor:

```lisp
(define (make-interval a b) (cons a b))
```

Define selectors `upper-bound` and `lower-bound` to complete the implementation.

需要实现 区间计算的定义。



#### Exercise 2.8. 

Using reasoning analogous to Alyssa's, describe how the difference of two intervals may be computed. 

Define a corresponding subtraction procedure,  called **sub-interval.**

编写 sub-interval 这个过程。

（1）左端点：最小减最大

（2）右端点：最大减最小



#### **Exercise 2.9.** 

The *width* of an interval is **half of the difference between its upper and lower bounds**. 

区间的宽度是它的上下界之差的一半。

The width is a measure of the uncertainty of the number specified by the interval. 

宽度是对区间所指定的数字的**不确定性的度量**。

For some arithmetic operations the width of the result of combining two intervals is a function only of the widths of the argument intervals, whereas for others the width of the combination is not a function of the widths of the argument intervals. 

运算结果的区间宽度 width **不一定是 参数区间宽度的函数。**

Show that the width of the sum (or difference) of two intervals is a function only of the widths of the intervals being added (or subtracted). 

**加法和减法**的结果区间宽度是参数区间参数的函数

Give examples to show that this is not true for **multiplication or division.**

加法和减法可以直接证明？

乘法和除法可以举例，可以找出不成立的例子。

```
[0, 10] * [0, 2] = [0, 20]
// 5 * 5 =? 10
[-5, 5] * [-1, 1] = [-5, 5]
// 5 * 1 =? 5
```

主要原因可以是乘法和除法都有min 和 max 的运算，非线性？

```
加法：

I1 -> (l1 u1)
I2 -> (l2 u2)
w1 = (u1 - l1) / 2
w2 = (u2 - l2) / 2 
I1 + I2 = I3 
I3 -> (l3 u3)
w3 = (u3 - l3) / 2
u3 = u1 + u2
l3 = l1 + l2
w3 = (u1 + u2 - l1 - l2) / 2 = w1 + w2

减法:

I1 - I2 = I4
I4 -> (l4 u4)
l4 = l1 - u2
u4 = u1 - l2
w4 = (u4 - l4) / 2 = (u1 - l2 - l1 + u2) / 2 = w1 + w2
```

加法和减法是一样的。



#### **Exercise 2.10.** 

Ben Bitdiddle, an expert systems programmer, looks over Alyssa's shoulder and comments that it is not clear what it means to divide **by an interval** that **spans zero**. 

Modify Alyssa's code to check for this condition and to signal an error if it occurs.

除以一个跨度为零的区间是什么意思？

修改，如果发现跨度为0作为“除区间”，那么报错。

加一个assert 就可以了。



#### Exercise 2.11.   

In passing, Ben also cryptically comments: 

"By testing the signs of the endpoints of the intervals, it is possible to break **mul-interval** into **nine cases**, **only one of which requires more than two multiplications**. '' 

Rewrite this procedure using Ben's suggestion.

通过**测试区间端点的符号**，可以将**区间乘法**分解为九种情况，**其中只有一种需要两次以上的乘法**

```
[l1 u1]
[l2 u2]
-> 
[L, U]
保证有 u1 > l1, u2 > l2
区间1有三种情况
(1) l1 >= 0, u1 > 0
(2) l1 < 0, u1 <= 0
(3) l1 < 0, u1 > 0
区间2有三种情况
(1) l2 >= 0, u2 > 0
(2) l2 < 0, u2 <= 0
(3) l2 < 0, u2 > 0
我们已经考虑了 0，那么就是 [-, -]、[+, +] 和 [-,+] 3种 
总共有 3 * 3 = 9 种情况
```

```lisp
; patt |  min  |  max 

; 最大乘以最大，就是最大。
; 最小乘以最小，就是最小。
; ++++ | al bl | ah bh
; ---- | ah bh | al bl

; 负区间的最小乘以正区间的最大，就是最小（负的越多）
; 负区间的最大乘以正区间的最小，就是最大（负得越少）
; ++-- | ah bl | al bh
; --++ | al bh | ah bl

; 最小就是最小的负数乘以最大的正数，
; 最大就是最大的负数乘以最小的负数。(负数乘以负数)
; ---+ | al bh | al bl 
; -+-- | ah bl | al bl 
; 最大就是最大的正数乘以最大的正数。(正数乘以正数)
; -+++ | al bh | ah bh 
; ++-+ | ah bl | ah bh

; -+-+ | trouble case
```



#### **Exercise 2.12.** 

Define a constructor `make-center-percent` that takes a **center** and a percentage **tolerance** and produces the desired **interval**. 

You must also define a selector `percent` that produces the percentage tolerance for a given **interval**. The `center` selector is the same as the one shown above.

```
center * tolerance -> upper-bound = center + center * tolerance 
center * tolerance -> lower-bound = center - center * tolerance
```



#### **Exercise 2.13.** 

Show that under the assumption of **small percentage tolerances** there is a simple formula for the **approximate percentage tolerance** of **the product of two intervals** in terms of the tolerances of the factors. 

You may simplify the problem by assuming that all **numbers are positive.**

```
a -> [Ca Ta]
[Ca - Ca * Ta, Ca + Ca * Ta]
b -> [Cb Tb]
[Cb - Cb * Tb, Cb + Cb * Tb]
加设端点都是正的。
a*b ->
[Ca*Cb*(1-Ta)*(1-Tb), Ca*Cb*(1+Ta)*(1+Tb)]
=
[Ca*Cb*(1+Ta*Tb-Ta-Tb), Ca*Cb*(1+Ta*Tb+Ta+Tb)]
Ta*Tb 可以忽略
->
[Ca*Cb*(1-Ta-Tb), Ca*Cb*(1+Ta+Tb)]
->
[Ca*Cb*(1-(Ta+Tb), Ca*Cb*(1+(Ta+Tb)))]
```

it appears that for small tolerances, the tolerance of the product will be approximately **the sum of the component tolerances.**



After considerable work, Alyssa P. Hacker delivers her finished system. 

Several years later, after she has forgotten all about it, she gets a frenzied call from an irate user, Lem E. Tweakit. 

It seems that Lem has noticed that the formula for parallel resistors can be written in two algebraically equivalent ways:
$$
\begin{aligned}

&\frac{1}{1/R_{1}+1/R_{2}}\\
&\frac{R_{1}R_{2}}{R_{1}+R_{2}}
\end{aligned}
$$
He has written the following two programs, each of which computes the parallel-resistors formula differently:

```lisp
(define (par1 r1 r2)
  (let ((one (make-interval 1 1))) 
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))
(define (par2 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))
```

Lem complains that Alyssa's program **gives different answers for the two ways of computing.  This is a serious complaint.**

上面两种计算 并联 公式的结果不一样！



公式1：
$$
\frac{1}{1/R_{1}+1/R_{2}}
$$
分子分母同时乘以 R1R2 就得到了公式2：
$$
\frac{R_{1}R_{2}}{R_{1}+R_{2}}
$$

![image-20240126105457024](exercise-2.assets/image-20240126105457024.png)

可以发现 公式1 是正确的。

```lisp
(define R1 (make-interval-percent 6.8 0.1))
(define R2 (make-interval-percent 4.7 0.05))
```



#### **Exercise 2.14.** 

Demonstrate that Lem is right. Investigate the behavior of the system on a variety of arithmetic expressions. 

Make some intervals *A* and *B*, and use them in computing the expressions *A*/*A* and *A*/*B*. 

You will get the most insight **by using intervals whose width is a small percentage of the center value**. 

Examine the results of the computation in **center-percent form** (see exercise 2.12).

使用 width 占 center 较小的那些interval 进行测试。

tolerance 越小，运算结果的 center 越符合数学算术，

比如 A 的 center 是 Ca，B 的center是Cb，

那么运算A op B 的center 就越接近 Ca op Cb



这里的区间运算的核心前提是 **每个区间都是独立的，如果不独立，那么运算结果就是错的**。

A 和 A 是不独立的，所以 A/A 的结果是错的。

A 和 B 是独立的，所以A/B的结果是正确的。



#### **Exercise 2.15.** 

Eva Lu Ator, another user, has also noticed the different intervals computed by different but algebraically equivalent expressions. 

She says that a formula to compute with intervals using Alyssa's system will produce tighter error bounds **if it can be written in such a form that no variable that represents an uncertain number is repeated.** 

Thus, she says, `par1` is a "better'' program for parallel resistances than "par2". Is she right? Why?



不同的代数等价表达式计算出的不同区间。

只要独立，那么就是正确的。

R1 + R2 和 R1 * R2 是相关的，所以 直接用 R1R2/(R1 + R2) 来代替并联公式是错的。

1/R1 和 1/R2 是独立的，(1, 1) 和  1/R1 + 1/R2 是独立的，所以原始的 并联计算公式是正确的。



#### **Exercise 2.16.** 

Explain, in general, why equivalent algebraic expressions may lead to different answers. 

为什么等价的代数表达式可能导致不同的答案？

Can you devise an interval-arithmetic package that does not have this shortcoming, or is this task impossible? (Warning: This problem is very difficult.)

您能设计一个没有这个缺点的区间算术包吗？

或者这个任务是不可能完成的？



这个任务是不可能完成的，本质应该是一个多元函数求最大值和最小值的问题。

无法用这种区间算术来计算。
