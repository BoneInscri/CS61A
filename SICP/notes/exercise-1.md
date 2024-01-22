#### **Exercise 1.1.** 

Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.

下面是一个表达式序列。解释器在响应每个表达式时打印的结果是什么?假设该序列将按照其呈现的顺序进行评估。

```lisp
10
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))
(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(= a b)
(if (and (> b a) (< b (* a b)))
    b
    a)
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
(+ 2 (if (> b a) b a))
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
```

```
10
12
8
3
6
19
#f
4
16
6
16
```



#### **Exercise 1.2.** 

Translate the following expression into prefix form

![image-20240111140222948](exercise-1.assets/image-20240111140222948.png)

```lisp
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))
```



#### **Exercise 1.3.** 

Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.

定义一个过程，该过程接受三个数字作为参数，并返回两个较大数字的平方和。

```lisp
(define (square x) (* x x))
(define (square_sum x y) (+ (square x) (square y)))

(define (max_square_sum x y z) (cond ( (and (<= x y) (<= x z) ) (square_sum y z))
                                     ( (and (<= z x) (<= z y) ) (square_sum x y))
                                     ( (and (<= y x) (<= y z) ) (square_sum x z))
                                     )
  )
(max_square_sum 1 2 3) 
(max_square_sum 1 1 1) 
(max_square_sum 1 2 2) 
(max_square_sum 1 1 2) 
(max_square_sum 1 4 3) 
```



#### **Exercise 1.4.** 

Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:

注意，我们的求值模型允许操作符为复合表达式的组合。用这个观察来描述以下过程的行为:

```lisp
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
```

运算符也可以作为选择表达式的结果

```
 (a + |b|) 
 A plus the absolute value of B 
```

```lisp
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

(a-plus-abs-b 1 3)
(a-plus-abs-b 1 -3) 
```

```
4
4
```



#### **Exercise 1.5.** 

Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:

Ben Bitdiddle发明了一个测试来确定他所面对的解释器是使用应用顺序评估还是正常顺序评估。

他定义了以下两个程序:

```lisp
(define (p) (p))
(define (test x y)
  (if (= x 0)
      0
      y))
```

Then he evaluates the expression

然后对表达式求值

```lisp
(test 0 (p))
```

What behavior will Ben observe with an interpreter that uses **applicative-order evaluation**? 

What behavior will he observe with an interpreter that uses **normal-order evaluation**? 

Explain your answer. 

(Assume that the evaluation rule for the special form `if` is the same whether the interpreter is using normal or applicative order: **The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression**.)

对于使用应用程序顺序评估的解释器，Ben将观察到什么行为?

对于使用正常顺序求值的解释器，他将观察到什么行为?

解释你的答案。

(假设特殊形式' if '的求值规则是相同的，

无论解释器是使用正常顺序还是应用顺序:

首先求值谓词表达式，结果决定是求值结果表达式还是求值替代表达式。)



程序似乎卡住了。。。

Using *applicative-order* evaluation, the evaluation of `(test 0 (p))` never terminates, 

**because `(p)` is infinitely expanded to itself:**

```
(test 0 (p)) 
(test 0 (p)) 
(test 0 (p)) 
```

lisp 用的是 applicative-order evaluation，所以会先进行替代，将 p 进行替换，

但发现替换后还是自己，于是就死循环了。

如果是normal-order evalution，就不会先替换，而是先展开，

```lisp
(test 0 (p)) 
->
(if (= 0 0) 0 (p)) 
->
(if #t 0 (p)) 
->
0 
```

于是就跳过了 (p) 这个死循环替代。



#### **Exercise 1.6.** 

Alyssa P. Hacker doesn't see why `if` needs to be provided as a special form. "Why can't I just define it as an ordinary procedure in terms of `cond`?'' she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of `if`:

Alyssa P. Hacker不明白**为什么“if”需要作为一个特殊的形式提供**。“为什么我不能把它定义为一个普通的程序呢?”她问道。Alyssa的朋友Eva Lu Ator声称这是可以做到的，她定义了一个新版本的“如果”:

```lisp
(define (new-if predicate then-clause else-clause) 
    (cond (predicate then-clause)    
        (else else-clause)))
```

Eva demonstrates the program for Alyssa:

Eva为Alyssa演示了这个程序:

```lisp
(new-if (= 2 3) 0 5)
(new-if (= 1 1) 0 5)
```

```
5
0
```

Delighted, Alyssa uses `new-if` to rewrite the square-root program:

Alyssa很高兴，用“new-if”重写了平方根程序:

```lisp
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))
```

What happens when Alyssa attempts to use this to compute square roots? Explain.

当Alyssa试图用这个来计算平方根时会发生什么?解释一下。



程序报错：

Interactions disabled; out of memory

内存爆了？

看上去是一直在调用这个new-if函数，然后就栈溢出了。



问题的关键就在于，Lisp是使用应用顺序求值，所以每次会计算new-if的两个参数，即会反复调用自身，从而爆栈。

if 不是这样，if计算谓词后，判断true 和 false，然后只会调用一个。



- 使用if时，只计算两个表达式中的一个
- 而使用new-if计算两个表达式



```
(define (try a)
  (if (= a 0) 1 (/ 1 0))
```

Calling `(try 0)` does not result in an error, **because the else-clause is never evaluated.**

`new-if` is a procedure, not a special-form, **which means that all sub-expressions are evaluated before `new-if` is applied to the values of the operands.** 





#### **Exercise 1.7.** 

The `good-enough?` test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing `good-enough?` is to watch how `guess` changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers?

“足够好?”在计算平方根时使用的测试对于求非常小的数的平方根不是很有效。此外，在真实的计算机中，算术运算几乎总是以有限的精度执行。这使得我们的测试不适用于非常大的数字。解释这些语句，并举例说明对于小数和大数，测试是如何失败的。另一种实现“足够好?”就是观察“guess”从一次迭代到下一次迭代是如何变化的，当变化只是猜测的很小一部分时就停止。设计一个使用这种结束测试的平方根程序。这对于小数字和大数字是否更有效?



大的数和小的数都不准确。就是因为这个tolerance没有随着传入的数字的大小变化而变化。

增加测试：

```
(sqrt 0.0001) // -> 0.01 不正常
(sqrt 1000000000000) // 12 个0 正常
(sqrt 10000000000000) // 13 个0 卡住
```





两种方法进行改进：

（1）要么tolerance不固定

（2）要么看guess的变化差是否校于恒定的tolerance？



##### method 1

```lisp
;iterates until guess and next guess are equal, 
;automatically produces answer to limit of system precision 
(define (good-enough? guess x) 
    (= (improve guess x) guess)) 
```

如果 对 guess 进行修正后还和guess一样，那么就停下来！

if the answer is some form of **repeating fractional numbe**r, then the equal comparison will never succeed, resulting in an infinite loop.



##### method 2

还可以有下面的改法

```lisp
;Modified version to look at difference between iterations 
(define (good-enough? guess x) 
    (< (abs (- (improve guess x) guess)) 
       (* guess .001))) 

;Another take on the good-enough? function 
(define (good-enough? guess x) 
    (< (/ (abs (- (square guess) x)) guess) 
       (* guess 0.0001))) 
```

figure out how far guess is from improved guess and then see if that amount is less than .1% of guess. 

If it is, stop the program

如果修改后的guess的变化量小于 0.1%，那么程序就停下来，即表示已经没有什么变化了



##### method 3

```lisp
; A guess is good enough when: 
;    abs(improved-guess - original-guess) / original-guess < 0.001 

(define (good-enough? guess x) 
    (< (abs (/ (- (improve guess x) guess) 
               guess)) 
       0.001)) 
```

先计算修正后的guess，然后看这个修正后的guess和原先的guess的改变量占原guess的百分比是否小于1%

watch how guess changes from one iteration to the next and to stop **when the change is a very small fraction of the guess**

using the classic (X1 - X0) / X0

X1 就是 修正量

X0 就是 原始值

In this case **X1 = (improve guess x)** and **X0 = guess**





##### method 4

```lisp
(define (good-enough? guess x) 
    (< (abs (- x (square guess)))
       (* 0.0001 x)))   
```

o stop iteration when the error (i.e. abs(guess^2 - x)) is less than a given proportion of x.

改进

```lisp
(define (good-enough? guess x) 
    (< (abs (- (improve guess x) guess)) 
       (cond ((< x 1) (* guess 0.001)) 
           (else 0.001)))) 
```



回顾一下这个问题

There are two main risks in it. 

For a small number x, 0.001 simply might be too large to be a tolerance threshold. 

For a large number x, and this is where people get confused, the real reason for hanging is because (improve guess x) never actually improve the result because of the limitation of bits, **the "improved guess" will simply be equal to "old guess" at some point, results in (- y^2 x) never changes and hence never reach inside the tolerance range**



小的数字出问题的原因是 tolerance 太大

大的数字出问题的原因是 精读不够，导致 imporved guess 的值和 old guess 一样，然后就一直循环





#### **Exercise 1.8.** 

Newton's method for cube roots is based on the fact that if *y* is an approximation to the cube root of *x*, then a better approximation is given by the value

牛顿求立方根的方法是基于这样一个事实:

如果*y*是*x*的立方根的近似值，那么一个更好的近似值是由这个值给出的

![image-20240122131619092](exercise-1.assets/image-20240122131619092.png)

Use this formula to implement a **cube-root procedure** analogous to the square-root procedure. 

(In section 1.3.4 we will see how to implement Newton's method in general as an abstraction of these square-root and cube-root procedures.)



注意需要处理负数！

```lisp
(define (cube-root x)
    (if (< x 0)
        (* -1 (cube-root-iter 1.0 (abs x)))
        (cube-root-iter 1.0 x)
        ))
```







