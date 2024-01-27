

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



#### **Exercise 2.17.** 

Define a procedure `last-pair` that returns the **list** that contains only the last element of a given (**nonempty**) list:

```lisp
(last-pair (list 23 72 149 34))
; (34)
```



#### **Exercise 2.18.** 

Define a procedure `reverse` that takes a list as argument and returns a list of the same elements in reverse order:

```lisp
(reverse (list 1 4 9 16 25))
; (25 16 9 4 1)
```

并以相反的顺序返回一个相同元素的列表。

```lisp
(cons 1
      (cons 2
            (cons 3
                  (cons 4 nil))))
->
(cons 4
      (cons 3
            (cons 2
                  (cons 1 nil))))
```

递归不好实现，迭代好实现。

```lisp
(define (reverse items) 
  (define (iter items result) 
    (if (null? items) 
        result 
        (iter (cdr items) (cons (car items) result))))   
  (iter items nil))
```



#### **Exercise 2.19.** 

Consider the **change-counting program** of section 1.2.2. 

It would be nice to be able to easily **change the currency used by the program**, so that we could compute the number of ways to change **a British pound**, for example. 

As the program is written, the knowledge of the currency is distributed partly into the procedure `first-denomination` and partly into the procedure `count-change` (which **knows that there are five kinds of U.S. coins**). It would be nicer to be able to supply a list of coins to be used for making change.

如果能够提供一份用于**找零的硬币列表**就更好了。

We want to **rewrite the procedure `cc`** so that its second argument is a list of the values of the coins to use **rather than an integer specifying which coins to use**. 

We could then have lists that defined each kind of currency:

```lisp
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))
```

We could then call `cc` as follows:

```lisp
(cc 100 us-coins)
; 292
```

To do this will require changing the program `cc` somewhat. 

It will still have the same form, **but it will access its second argument differently**, as follows:

```lisp
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))
```

**Define the procedures `first-denomination`, `except-first-denomination`, and `no-more?`** 

in terms of primitive operations on list structures. 

Does **the order of the list `coin-values` affect the answer produced by `cc`?** 

Why or why not?



coin-values 的 顺序是否对 cc 的结果有影响？

没有影响 ！



#### **Exercise 2.20.** 

The procedures `+`, `*`, and `list` take arbitrary numbers of arguments. 

list 的参数数量是不确定的，即可以接受任意数量的参数。

One way to define such procedures is to **use `define` with *dotted-tail notation*.** 

In a procedure definition, a parameter list that has a dot before the last parameter name indicates that, when the procedure is called, the initial parameters (if any) will have as values the initial arguments, as usual, **but the final parameter's value will be a *list* of any remaining arguments.** 

但**最终参数的值将是任何剩余参数的*列表***

For instance, given the definition

```lisp
(define (f x y . z) <body>)
; using lambda
(define f (lambda (x y . z) <body>))
```

the procedure `f` can be called **with two or more arguments.** 

If we evaluate

```
(f 1 2 3 4 5 6)
```

then in the body of `f`, **`x` will be 1, `y` will be 2, and `z` will be the list `(3 4 5 6)`**. 

Given the definition

```lisp
(define (g . w) <body>)
; using lambda
(define g (lambda w <body>))
```

the procedure `g` can be called with zero or more arguments. 

If we evaluate

```
(g 1 2 3 4 5 6)
```

**then in the body of `g`, `w` will be the list `(1 2 3 4 5 6)`.**

Use this notation to write a procedure `same-parity` that takes **one or more integers** and **returns a list of all the arguments that have the same even-odd parity as the first argument.** 

For example,

```lisp
(same-parity 1 2 3 4 5 6 7)
; (1 3 5 7)

(same-parity 2 3 4 5 6 7)
; (2 4 6)
```

**返回参数中所有和第一个参数相同奇偶性的所有参数。**



**这个题目介绍了过程的可变参数是怎么实现的，就是用一个list串起来。**



#### **Exercise 2.21.** 

The procedure `square-list` takes a list of numbers as argument and returns a list of the squares of those numbers.

```lisp
(square-list (list 1 2 3 4))
; (1 4 9 16)
```

Here are two different definitions of `square-list`. 

Complete both of them by filling in the missing expressions:

```lisp
(define (square-list items)
  (if (null? items)
      nil
      (cons <??> <??>)))
(define (square-list items)
  (map <??> <??>))
```

实现 平方的map



#### **Exercise 2.22.** 

Louis Reasoner tries to rewrite the first `square-list` procedure of exercise 2.21 so that it evolves an iterative process:

```lisp
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things) 
              (cons (square (car things))
                    answer))))
  (iter items nil))
```

Unfortunately, defining `square-list` this way produces the answer list in the reverse order of the one desired. Why?

Louis then tries to fix his bug by interchanging the arguments to `cons`:

```lisp
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items nil))
```

This doesn't work either. Explain.

想用迭代而不是递归来重写 square-list，试了两次都不行。

![image-20240126140722953](exercise-2.assets/image-20240126140722953.png)



#### **Exercise 2.23.** 

The procedure `for-each` is similar to `map`. It takes as arguments a procedure and a list of elements. 

However, rather than forming a list of the results, `for-each` just applies the procedure to each of the elements in turn, from left to right. 

“for-each”不是形成一个结果列表，**而是从左到右依次对每个元素应用该过程**

The values returned by applying the procedure to the elements are not used at all -- `for-each` is used with procedures that perform an action, such as printing. 

不使用返回值。

For example,

```lisp
(for-each (lambda (x) (newline) (display x))
          (list 57 321 88))
; 57
; 321
; 88
```

The value returned by the call to `for-each` (not illustrated above) can be something arbitrary, such as true. 

Give an implementation of `for-each`.



#### **Exercise 2.24.** 

Suppose we evaluate the expression `(list 1 (list 2 (list 3 4)))`. 

Give the **result** printed by the interpreter, **the corresponding box-and-pointer structure, and the interpretation of this as a tree** (as in figure 2.6).

（1）编译器打印的结果

（2）box-and-pointer 结构图

（3）tree的结构图

![image-20240126142626066](exercise-2.assets/image-20240126142626066.png)

```
 (1 (2 (3 4)))
      ^
    /   \
   1     ^ (2 (3 4))
       /   \
      2     ^ (3 4)
          /   \
         3     4
```

```
                 
 (1 (2 (3 4)))  ((2 (3 4)))                                           
   +---+---+    +---+---+
   | * | *-+--->| * | / |
   +-+-+---+    +-+-+---+
     |            |   
     V            V (2 (3 4))   ((3 4))   
   +---+        +---+---+      +---+---+
   | 1 |        | * | *-+----->| * | / | 
   +---+        +-+-+---+      +---+---+
                  |              |
                  V              V (3 4)
                +---+          +---+---+    +---+---+
                | 2 |          | * | *-+--->| * | / |
                +---+          +-+-+---+    +-+-+---+
                                 |            |
                                 V            V
                               +---+        +---+
                               | 3 |        | 4 |
                               +---+        +---+
```



#### **Exercise 2.25.** 

Give combinations of `car`s and `cdr`s that will pick 7 from each of the following lists:

```lisp
(1 3 (5 7) 9)
((7))
(1 (2 (3 (4 (5 (6 7))))))
```

```lisp
(car (cdr (car (cdr (cdr list1)))))
(car (car list2))
(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr list3))))))))))))
```



#### **Exercise 2.26.** 

Suppose we define `x` and `y` to be two lists:

```lisp
(define x (list 1 2 3))
(define y (list 4 5 6))
```

What result is printed by the interpreter in response to evaluating each of the following expressions:

```lisp
(append x y)
(cons x y)
(list x y)
```

![image-20240126144049131](exercise-2.assets/image-20240126144049131.png)



#### **Exercise 2.27.** 

Modify your `reverse` procedure of exercise 2.18 to produce a `deep-reverse` procedure that **takes a list as argument and returns as its value the list with its elements reversed and with all sublists deep-reversed as well**. 

For example,

```lisp
(define x (list (list 1 2) (list 3 4)))

x
; ((1 2) (3 4))

(reverse x)
; ((3 4) (1 2))

(deep-reverse x)
; ((4 3) (2 1))
```



#### **Exercise 2.28.** 

Write a procedure `fringe` that takes as argument **a tree** (represented **as a list**) and returns **a list** whose **elements are all the leaves of the tree arranged in left-to-right order.** 

For example,

```lisp
(define x (list (list 1 2) (list 3 4)))

(fringe x)
; (1 2 3 4)

(fringe (list x x))
; (1 2 3 4 1 2 3 4)
```

从左到右顺序排列的树的所有叶子



思路可以参考  count-leaves的实现



#### **Exercise 2.29.** 

A **binary mobile** consists of two branches, **a left branch and a right branch.** 

Each **branch** is a rod of a certain length, from which hangs either a **weight** or another **binary mobile.** 

We can represent a binary mobile using **compound data** by constructing it from two branches (for example, using `list`) ：

使用list构建一个两个分支的mobile

```lisp
(define (make-mobile left right)
  (list left right))
```

A **branch** is constructed from a `length` (which must be a **number**) together with a `structure`, which may be either a number (representing a simple **weight**) or another **mobile**:

```lisp
(define (make-branch length structure)
  (list length structure))
```

- length 是一个数字，表示branch的长度。
- **structure 可能是一个数字（表示weight），也可能是一个mobile。**

a. Write the corresponding **selectors** `left-branch` and `right-branch`, which return the branches of a mobile, and `branch-length` and `branch-structure`, which return the components of a branch.

- **（1）实现 left-branch、right-branch**
- **（2）实现 branch-length、branch-structure**

b. Using your selectors, define a procedure `total-weight` that returns the total weight of a mobile.

- **（3）实现 total-weight**

c. A **mobile** is said to be *balanced* if the torque applied by its **top-left** branch is equal to that applied by its **top-right** branch (that is, **if the length of the left rod multiplied by the weight hanging from that rod is equal to the corresponding product for the right side**) and if each of the submobiles hanging off its branches is balanced.

- **（4）检验是否平衡？** 

Design a **predicate** that tests whether a binary mobile is balanced.

**平衡要求每个mobile 的左分支重力矩和右分支的重力矩相等。**

d. Suppose we change the representation of mobiles so that the constructors are

```lisp
(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure))
```

How much do you need to change your programs to convert to the new representation?

**（5）如果将make-mobile和make-branch修改为用pair实现，而不是list，所有过程是否需要修改？需要修改多少？**

**修改一下mobile 和 branch的定义和selector函数即可。**



#### **Exercise 2.30.** 

Define a procedure `square-tree` analogous to the `square-list` procedure of exercise 2.21. 

That is, `square-list` should behave as follows:

```lisp
(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
; (1 (4 (9 16) 25) (36 49))
```

Define `square-tree` both directly (i.e., **without using any higher-order procedures) and also by using `map` and recursion.**

直接实现，不要用map或者其他的高阶过程。



#### **Exercise 2.31.** 

Abstract your answer to exercise 2.30 to produce a procedure `tree-map` with the property that `square-tree` could be defined as

```lisp
(define (square-tree tree) (tree-map square tree))
```



#### **Exercise 2.32.** 

We can represent a set as a list of **distinct elements**, and we can represent the set of all subsets of the set as a list of lists. 

- 用不同元素的list作为集合set
- 集合的所有子集可以用一个list的list表示

For example, if the set is `(1 2 3)`, then the set of all subsets is `(() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))`. 

Complete the following definition of a procedure that generates the set of subsets of a set and give a clear explanation of why it works:

```lisp
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map <??> rest)))))
```



```lisp
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x)
                            (cons (car s) x)) rest)))))
```



跟踪 rest的变化，就知道什么原理了

![image-20240126195134920](exercise-2.assets/image-20240126195134920.png)



#### **Exercise 2.33.** 

Fill in the missing expressions to complete the following definitions of some basic list-manipulation operations as accumulations:

```lisp
(define (map p sequence)
    (accumulate (lambda (x y) <??>) nil sequence))
(define (append seq1 seq2)
    (accumulate cons <??> <??>))
(define (length sequence)
    (accumulate <??> 0 sequence))
```

```lisp
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(define (map p sequence)
    (accumulate (lambda (x y) (cons (p x) y)) nil sequence))

(define (append seq1 seq2)
    (accumulate cons seq2 seq1))

(define (length sequence)
    (accumulate (lambda (x y) (+ 1 y)) 0 sequence))
```

看着accumulate定义写



#### **Exercise 2.34.** 

Evaluating a polynomial in *x* at a given value of *x* can be formulated as an accumulation. 

We evaluate the polynomial

计算多项式在x处的函数值。
$$
a_{n}x^{n}+a_{n-1}x^{n-1}+\cdots+a_{1}x+a_{0}
$$
using a well-known algorithm called ***Horner's rule***, which structures the computation as
$$
(\cdots(a_{n}x+a_{n-1})x+\cdots+a_{1})x+a_{0}
$$
霍纳规则？秦九韶算法。

In other words, we start with $a_n$, multiply by x, add $a_{n-1}$, multiply by x, and so on, until we reach $a_0$

Fill in the following template to produce a procedure that evaluates a **polynomial using Horner's rule.** 

Assume that **the coefficients of the polynomial are arranged in a sequence,** 

系数在一个list中，就是 $a_0$ 到 $a_n$

from $a_0$ through $a_n.$

```lisp
(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) <??>)
              0
              coefficient-sequence))
```

For example, to compute $1+3x+5x^3 + x^5$ at x=2 you would evaluate

```lisp
(horner-eval 2 (list 1 3 0 5 0 1))
```

```lisp
(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms)
                (+ this-coeff (* x higher-terms)))
              0
              coefficient-sequence))
```

**(...) x + a0**



#### **Exercise 2.35.** 

Redefine `count-leaves` from section 2.2.2 as an accumulation:

```lisp
(define (count-leaves t)
  (accumulate <??> <??> (map <??> <??>)))
```

主要就是这个map 怎么填。没有想到特别好的办法，只能先将t 用enumerate 映射得到一个list，list的每个成员都是list，只有一层。

然后就是用length进行求和

```lisp
(define (count-leaves t)
  (accumulate (lambda (x y) (+ (length x) y)) 0
              (map (lambda (x) (enumerate-tree x)) t)))
```



#### **Exercise 2.36.** 

The procedure `accumulate-n` is similar to `accumulate` except that it **takes as its third argument a sequence of sequences,** which are all assumed to **have the same number of elements.** 

第三个参数是一个序列序列

假定所有序列都具有相同数量的元素

It applies the designated accumulation procedure to combine all the **first** elements of the sequences, all the second elements of the sequences, and so on, and returns a sequence of the results. 

For instance, 

if `s` is a sequence containing four sequences,

 `((1 2 3) (4 5 6) (7 8 9) (10 11 12)),`

 **then the value of `(accumulate-n + 0 s)`** should be the sequence `(22 26 30)`. 

**(1+4+7+10, 2+5+8+11, 3+6+9+12)**

Fill in the **missing expressions** in the following definition of `accumulate-n`:

```lisp
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init <??>)
            (accumulate-n op init <??>))))
```

太难想了，答案居然是map car 和 map cdr

即一次移动一列。。。

```lisp
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))
```



#### **Exercise 2.37.** 

Suppose we represent vectors $v=(v_j)$ **as sequences of numbers**, 

and matrices $m=(m_{ij})$ as sequences of vectors (**the rows of the matrix**). 

For example, the **matrix**
$$
\left.\left[\begin{array}{cccc}1&2&3&4\\4&5&6&6\\6&7&8&9\end{array}\right.\right]
$$
is represented as the sequence `((1 2 3 4) (4 5 6 6) (6 7 8 9))`. 

向量是一个数字的list，矩阵是list的list。

With this representation, we can use sequence operations to concisely express the basic matrix and vector operations. 

These operations (which are described in any book on matrix algebra) are the following:

向量和矩阵的运算：

**（1）点乘，(dot-product v w)**
$$
\Sigma_{i}v_{i}w_{i}.
$$
**（2）矩阵乘向量，(matrix-*-vector m v)**
$$
\mathrm{returns~the~vector~t,~where~}t_{i}=\sum_{j}m_{ij}v_{j}.
$$
**（3）矩阵乘矩阵，(matrix-*-matrix m n)**
$$
\mathrm{returns~the~matrix~p,~where~p}_{ij}=\sum_{k}m_{ik}n_{kj}.
$$
**（4）矩阵的转置，(transpose m)**
$$
\mathrm{returns~the~inatrix~}n,\mathrm{~where~}n_{ij}=m_{ji}.
$$

```lisp
(define (dot-product v w)
  (accumulate + 0 (map * v w)))
```

上面用的map是扩展后的map

```lisp
(map + (list 1 2 3) (list 40 50 60) (list 700 800 900))
; (741 852 963)

(map (lambda (x y) (+ x (* 2 y)))
     (list 1 2 3)
     (list 4 5 6))
; (9 12 15)
```

Fill in the missing expressions in the following procedures for computing the other matrix operations. (The procedure `accumulate-n` is defined in exercise 2.36.)

```lisp
(define (matrix-*-vector m v)
  (map <??> m))
(define (transpose mat)
  (accumulate-n <??> <??> mat))
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map <??> m)))
```

答案：

```lisp
; 矩阵乘向量
(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))
; 矩阵转置
(define (transpose mat)
  (accumulate-n cons nil mat))
; 矩阵乘矩阵
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))
```





#### **Exercise 2.38.** 

The `accumulate` procedure is also known as `fold-right`, because **it combines the first element of the sequence with the result of combining all the elements to the right.** 

右折叠，即将第一个元素和右边的所有元素进行 combine

There is also a `fold-left`, which is similar to `fold-right`, except that it combines elements working **in the opposite direction:**

反向运算。

```lisp
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))
```

What are the values of

```lisp
(fold-right / 1 (list 1 2 3))
(fold-left / 1 (list 1 2 3))
(fold-right list nil (list 1 2 3))
(fold-left list nil (list 1 2 3))
```

**Give a property that `op` should satisfy to guarantee that `fold-right` and `fold-left` will produce the same values for any sequence.**



**op 应该满足什么性质，fold-right 和 fold-left 才能有相同的结果？**

```
a b c d
(((a op b) op c) op d) fold-right
(((d op c) op b) op a) fold-left
```

举例，+ 和 * ，即加法和乘法是肯定可以的。

减法和除法是不行的，cons也是不行的。

**op 需要满足 a op b 和 b op a 是等价的才可以。**

即op 的左右两个操作数是可交换的，那么fold-right 和 fold-left 的结果才相同。



#### **Exercise 2.39.**  

Complete the following definitions of `reverse` (exercise 2.18) in terms of `fold-right` and `fold-left` from exercise 2.38:

```lisp
(define (reverse sequence)
  (fold-right (lambda (x y) <??>) nil sequence))
(define (reverse sequence)
  (fold-left (lambda (x y) <??>) nil sequence))
```

用fold-right 实现 reverse 需要借助 append

```lisp
(define (reverse sequence)
  (fold-right (lambda (x y)
                (if (null? y)
                    (list x)
                    (append y (list x))
                ))
              nil sequence))
(define (reverse sequence)
 (fold-left (lambda (x y) (cons y x)) nil sequence))
```



#### **Exercise 2.40.** 

Define a procedure `unique-pairs` that, given an integer *n*, generates the sequence of pairs (*i*,*j*) with 1<= *j*< *i*<= *n*. 

Use `unique-pairs` to simplify the definition of `prime-sum-pairs` given above.

- 先实现 unique-pairs
- 然后 使用 unique-pairs 实现 prime-sum-pairs





#### **Exercise 2.41.** 

Write a procedure to find all **ordered** triples of **distinct** **positive** integers *i*, *j*, and *k* less than or equal to a given integer *n* that sum to a given integer *s*.

1=<k<j<i<=n

i+j+k == s



**和 unique-pairs 不同，这里的unique-triples 需要两次 append !**



#### **Exercise 2.42.** 

**A solution to the eight-queens puzzle.**

<img src="exercise-2.assets/image-20240127153220905.png" alt="image-20240127153220905" style="zoom:50%;" />

The "eight-queens puzzle'' asks how to place eight queens on a chessboard so that no queen is in check from any other (i.e., no two queens are in the same row, column, or diagonal). 

**没有两个皇后在同一行、同列或同对角线上**

One possible solution is shown in figure 2.8. 

One way to solve the puzzle is to work across the board, placing a queen in each column. 

**Once we have placed *k* - 1 queens, we must place the *k*th queen in a position where it does not check any of the queens already on the board.** 

We can formulate this approach **recursively**: 

**Assume** that we have already generated the sequence of all possible ways to place *k* - 1 queens in the first *k* - 1 columns of the board. 

加定此时我们已经再前k - 1 列放置了 k - 1 个 皇后

For each of these ways, generate an extended set of positions by placing a queen in each row of the *k*th column. 

在 第 k 列的每一行放置一个皇后

Now filter these, **keeping only the positions for which the queen in the *k*th column is safe with respect to the other queens**.

检查每种情况，过滤掉不安全的情况。 

This produces the sequence of all ways to place *k* queens in the first *k* columns. 

于是就完成了将k个皇后放在前k列中的所有方法序列。

By continuing this process, we will produce not only one solution, but all solutions to the puzzle.

**于是就可以得到解决方法了。**

We implement this solution as a procedure `queens`, 

**which returns a sequence of all solutions to the problem of placing *n* queens on an *n*× *n* chessboard.** 

参数就是一个n，即表示一个 n x n 大小的棋盘。

`Queens` has an internal procedure `queen-cols` that **returns the sequence of all ways to place queens in the first *k* columns of the board.**

' Queens '有一个内部过程' queen-cols '，

它返回将皇后放置在棋盘前k列中的所有方法的序列。

```lisp
(define (queens board-size)
  (define (queen-cols k)  
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))
```

In this procedure `rest-of-queens` is a way to place *k* - 1 queens in the first *k* - 1 columns, and `new-row` is a proposed row **in which to place the queen for the *k*th column**. 

Complete the program by implementing the representation for sets of board positions, including the procedure `adjoin-position`, **which adjoins a new row-column position to a set of positions**, and `empty-board`, which **represents an empty set of positions**. 

You must also write the procedure `safe?`, **which determines for a set of positions, whether the queen in the *k*th column is safe with respect to the others**. 

(Note that we need **only** check **whether the new queen is safe** -- the other queens are already guaranteed safe with respect to each other.)

实现：

（1）rest-of-queens

（2）new-row

（**3）adjoin-position**

（4）empty-board

**（5）safe?**



想半天，为什么 safe? 需要用到k？居然是可以不需要用k的。。。

**初始返回的空棋盘 是一个 (( ))**

最外层括号表示所有解的集合，里层的括号表示一个空解，即棋盘上没有放皇后。

- **一个点** 用 一个括号括起来，
- 多个点 用 一个括号括起来就是一个**解**，
- 多个解 用括号 括起来，就是**所有解的集合**，
- 解的数量就是 length的值。

```
(enumerate-interval 1 board-size)
```

加设 是 4 * 4 的棋盘，那么 上面的表达式就可以生成 ( 1 2 3 4) 的list

```lisp
(map (lambda (new-row) 
             (adjoin-position new-row
                              k rest-of-queens)) 
     (enumerate-interval 1 board-size))
```

这个map就是得到 **((1 k) (2 k) (3 k) (4 k))** 这个list



看清楚，这里map 和 flatmap 是两层的map。

所以会用乘法枚举所有情况。

(queen-cols (- k 1)) 就是前k-1列解的情况。

比如 k = 1 时， (queen-cols (- k 1)) 就是 (())

那么经过 flatmap 和 map 处理之后就会变成

( ((1 1)) ((2 1)) ((3 1)) ((4 1)) )

flapmap 的直观含义就是对一个list的每个元素**从左到右执行某个特定的过程**，最后将结果用list串起来。

继续一轮，就会得到 ：

```
((1 2) (1 1))
((2 2) (1 1))
((3 2) (1 1))
((4 2) (1 1))
((1 2) (2 1))
((2 2) (2 1))
((3 2) (2 1))
((4 2) (2 1))
((1 2) (3 1))
((2 2) (3 1))
((3 2) (3 1))
((4 2) (3 1))
((1 2) (4 1))
((2 2) (4 1))
((3 2) (4 1))
((4 2) (4 1))
```

然后就是过滤一些不满足要求的

如何理解safe？

```lisp
(define (safe? y)
  (= 0 (accumulate + 0 
                   (map (lambda (x) 
                          (if (check (car y) x) 0 1)) 
                        (cdr y))))) 
```

这里传递到safe? 的y是所有可能的棋盘情况。

就是一个点的集合，我们需要过滤掉所有不满足条件的情况。

- (car y) 得到的是第一个点，刚好就是第k列新加入的点。
- (cdr y) 得到的是多个点的list，刚好就是前k-1列满足条件的点的集合。

所以这个accumulate 的 map 就好理解了，就是遍历前k-1列的所有点，如果发现这个点和第一个点不满足条件，就map成0，否则map成1，最后用accumulate累加，如果发现是0，则说明所有的点都满足条件，那么就是safe的。



**这个题目想写对，很不容易。**





#### **Exercise 2.43.** 

Louis Reasoner is having a terrible time doing exercise 2.42. 

His `queens` procedure seems to work, but it runs extremely slowly.

 (Louis never does manage to wait long enough for it to solve even the 6× 6 case.) 

When Louis asks Eva Lu Ator for help, she points out that he has interchanged the order of the nested mappings in the `flatmap`, writing it as

```lisp
(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
          (adjoin-position new-row k rest-of-queens))
        (queen-cols (- k 1))))
 (enumerate-interval 1 board-size))
```

Explain why this interchange makes the program run slowly. 

Estimate how long it will take Louis's program to solve the eight-queens puzzle, assuming that the program in exercise 2.42 solves the puzzle in time *T*.

（1）解释为什么变慢了？

（2）相对于2.42 的写法来说花费的时间是多少？

这里应该是交换了 map 和 flatmap 里面操作的对象吧。。

```
(queen-cols (- k 1))
```

- 放到了里面，就会导致每次都会重新计算一次。。。
- 放到外面，只需要计算一次，就可以得到list。

如果是 8 * 8 的棋盘，那么对于每一列，都会有 8 次的重复计算，由于有 8 列，所以 总时间就是 (8 * 8) T 





#### **Exercise 2.44.** 

Define the procedure `up-split` used by `corner-split`. 

It is similar to `right-split`, except that **it switches the roles of `below` and `beside`.**

定义corner-split 使用的 up-split。

可以参考 right-split 实现。



问题就是没法测试代码？

If you are using DrRacket, follow these steps:

\1) Install the package sicp.plt (Go to file>Install Package, type 'sicp.plt' in package source)

\2) Paste this code '(require (planet "sicp.ss" ("soegaard" "sicp.plt" 2 1)))' in your rkt file.

\3) Test the file with the code '(paint einstein)'. You should see a picture of Einstein in your command line.

https://www.zhihu.com/question/20789155



```
#lang sicp
(#%require sicp-pict)
```

别搞错意思了，这个题目就是实现 up-split，只不过这个up-split被corner-split所使用。



#### **Exercise 2.45.** 

`Right-split` and `up-split` can be expressed **as instances of a general splitting operation**. 

Define a procedure `split` with the property that evaluating

```lisp
(define right-split (split beside below))
(define up-split (split below beside))
```

produces procedures `right-split` and `up-split` with the same behaviors **as the ones already defined.**

左拆分和右拆分可以统一为一个抽象。

需要注意的是这里的split返回的是一个递归的lambda表达式，所以按照下面的方式即进行定义会更好一些。

```lisp
(define (split op1 op2)
  (define (iter painter n)
    (if (= n 0)
        painter
        (let ((smaller (iter painter (- n 1))))
          (op1 painter (op2 smaller smaller)))
        ))
  (lambda (painter n) (iter painter n)))
```

