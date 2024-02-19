#### **Exercise 3.1.** 

An *accumulator* is a procedure that is **called repeatedly with a single numeric argument and accumulates its arguments into a sum.** 

Each time it is called, it returns the currently accumulated sum. 

Write a procedure `make-accumulator` that generates accumulators, each maintaining an independent sum. 

The input to `make-accumulator` **should specify the initial value of the sum**; for example

```lisp
(define A (make-accumulator 5))
(A 10)
; 15
(A 10)
; 25
```

（1）实现 make-accumulator 

（2）每次调用就是进行累加



#### **Exercise 3.2.** 

In software-testing applications, it is useful to be able to **count the number of times a given procedure is called during the course of a computation.** 

Write a procedure `make-monitored` that takes as input a procedure, `f`, that itself takes one input. 

The result returned by `make-monitored` is a third procedure, **say `mf`, that keeps track of the number of times it has been called by maintaining an internal counter.** 

If the input to `mf` is the special symbol `how-many-calls?`, **then `mf` returns the value of the counter.** 

If the input is the special symbol `reset-count`, **then `mf` resets the counter to zero.** 

For **any other input, `mf` returns the result of calling `f` on that input and increments the counter.** 

For instance, we could make a monitored version of the `sqrt` procedure:

```lisp
(define s (make-monitored sqrt))

(s 100)
; 10

(s 'how-many-calls?)
; 1
```

（1）统计一个过程被调用了多少次。

（2）实现 make-monitored。

（3）how-many-calls？返回counter。

（4）reset-count，重设counter为0。

（5）其他的值，就直接将参数作为被监控程序



#### **Exercise 3.3.** 

Modify the `make-account` procedure so that it **creates password-protected accounts.** That is, `make-account` should take a symbol **as an additional argument, as in**

```lisp
(define acc (make-account 100 'secret-password))
```

The resulting account object should process a request only **if it is accompanied by the password with which the account was created, and should otherwise return a complaint:**

```lisp
((acc 'secret-password 'withdraw) 40)
; 60

((acc 'some-other-password 'deposit) 50)
; "Incorrect password"
```

（1）account 需要密码

（2）密码正确，可以进行操作，密码不正确，返回错误信息





#### **Exercise 3.4.** 

Modify the `make-account` procedure of exercise 3.3 by adding another local state variable so that, if an account is accessed more than seven consecutive times with an incorrect password, it invokes the procedure `call-the-cops`.

如果使用错误的密码连续访问帐户超过7次，**它将调用' call-the-cops '过程。**





#### **Exercise 3.5.** 

*Monte Carlo integration* is a method of estimating **definite integrals by means of Monte Carlo simulation.** 

Consider computing the area of a region of space described by a predicate *P*(*x*, *y*) that is true for points (*x*, *y*) in the region and false for points not in the region. 

For example, t**he region contained within a circle of radius 3 centered at (5, 7) is described by the predicate that tests whether $ (x - 5)^2 + (y - 7)^2< 3^2$**. 

To estimate the area of the region described by such a predicate, begin by choosing a rectangle that contains the region. 

For example, **a rectangle with diagonally opposite corners at (2, 4) and (8, 10) contains the circle above.** 

The desired integral is the area of that **portion of the rectangle that lies in the region.** 

We can estimate the integral by picking, at random, points (*x*,*y*) that lie in the rectangle, and testing *P*(*x*, *y*) for each point to **determine whether the point lies in the region.** 

If we try this with many points, then the fraction of points that fall in the region **should give an estimate of the proportion of the rectangle that lies in the region.** 

Hence, multiplying this fraction by the area of the entire rectangle should produce an estimate of the integral.

Implement Monte Carlo integration as a procedure `estimate-integral` that **takes as arguments a predicate `P`, upper and lower bounds `x1`, `x2`, `y1`, and `y2` for the rectangle**, **and the number of trials** to perform in order to produce the estimate. 

Your procedure should use the same `monte-carlo` procedure that was used above to estimate $\pi$

Use your `estimate-integral` to **produce an estimate of $\pi$ by measuring the area of a unit circle.**

You will find it useful to have a procedure that returns a number chosen at random from a given range. 

The following `random-in-range` procedure implements this in terms of the `random` procedure used in section 1.2.6, **which returns a nonnegative number less than its input.**

```lisp
(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))
```

（1）使用蒙特卡罗模拟，估计定积分。

（2）根据随机数找比例，然后利用这个比例计算积分估计值。

（3）实现 estimate-integral，传入 P，x1 ，x2，y1和y2。

（4）estimate-integral 需要用到 mote-carlo，且能够测量单位圆的面积来估计  $\pi$ 。

$$
ration = pi*r^2/(2r)^2
$$
在一个矩形中随机选点，然后给定一个谓词P，**看满足谓词P的点的比例是多少？**
$$
\frac{S_?}{S_r}=factor\\
S_?=factor*S_r
$$


#### **Exercise 3.6.** 

It is useful to be able to **reset a random-number generator** to produce a sequence starting from a given value. 

Design a new `rand` procedure that is called with an argument that is either the symbol `generate` or the symbol `reset` and behaves as follows: 

- `(rand 'generate)` produces a new random number; 
- `((rand 'reset) <*new-value*>)` resets the internal state variable to the designated <*new-value*>. 

Thus, by resetting the state, one can generate repeatable sequences. 

These are very handy to have when testing and debugging programs that use random numbers.

重新设计 rand 这个过程。

（1）传入 'generate，就可以生成一个随机数

（2）传入 'reset，将内部状态设置为 new-value，重置状态，可以生成重复的序列

在测试和调试使用随机数的程序时**非常方便**

