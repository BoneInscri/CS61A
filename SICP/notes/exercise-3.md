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

- `(rand 'generate)` **produces a new random number;** 
- `((rand 'reset) <*new-value*>)` **resets the internal state variable to the designated <*new-value*>.** 

Thus, by resetting the state, one can generate **repeatable sequences.** 

These are very handy to have when testing and debugging programs **that use random numbers.**

重新设计 rand 这个过程。

（1）传入 'generate，就可以生成一个随机数

（2）传入 'reset，将内部状态设置为 new-value，重置状态，可以生成重复的序列

在测试和调试使用随机数的程序时**非常方便**

即可以**多次生成同一个伪随机数序列**。



#### **Exercise 3.7.** 

Consider the bank account objects created by `make-account`, with the password modification described in exercise 3.3.

Suppose that our banking system requires the ability to make joint accounts. 

Define a procedure `make-joint` that accomplishes this. 

`Make-joint` should take three arguments. 

- The first is a **password-protected account.** 
- The second argument must match the password with which the account was defined in order for the `make-joint` operation to proceed. 
- The third argument is **a new password.** 

**`Make-joint` is to create an additional access to the original account using the new password.** 

For example, if `peter-acc` is a bank account with password `open-sesame`, then

```lisp
(define paul-acc
  (make-joint peter-acc 'open-sesame 'rosebud))
```

will allow one to make transactions on `peter-acc` using the name `paul-acc` and the password `rosebud`.

You may wish to modify your solution to exercise 3.3 to accommodate this new feature.



（1）实现make-join，构建共享账户。

（2）参数：有密码的账户，对应的密码，一个新密码。

（3）效果就是，可以用新密码在新账户上对一个共享的账户进行操作。



问题是如果密码错误呢？



#### **Exercise 3.8.** 

When we defined the evaluation model in section 1.1.3, **we said that the first step in evaluating an expression is to evaluate its subexpressions.** 

But we never specified the order in which the subexpressions **should be evaluated (e.g., left to right or right to left).** 

When we introduce assignment, the order in which the arguments to a procedure are evaluated can make a difference to the result. 

Define a simple procedure `f` such that evaluating `(+ (f 0) (f 1))` will return 0 if the arguments to `+` are evaluated from left to right 

**but will return 1 if the arguments are evaluated from right to left.**



（1）引入set!后，对过程的实参求值的顺序会对结果有影响

（2） (+ (f 0) (f 1)) 从左到右，返回0；从右到左，返回1

```lisp
(define f   
  (let ((init 0)) 
    (lambda (x)  
      (set! init (- x init))  
      (- x init))))
```



#### **Exercise 3.9.** 

In section 1.2.1 we used the **substitution** model to analyze two procedures for computing factorials, 

a recursive version

```lisp
(define (factorial n)
  (if (= n 1)
      1
      (* n (factorial (- n 1)))))
```

and an iterative version

```lisp
(define (factorial n)
  (fact-iter 1 1 n))
(define (fact-iter product counter max-count)
  (if (> counter max-count)
      product
      (fact-iter (* counter product)
                 (+ counter 1)
                 max-count)))
```

**Show the environment structures created by evaluating `(factorial 6)` using each version of the `factorial` procedure.**



（1）计算阶乘有递归和迭代两种方式。

（2）分析两种方式 `(factorial 6)` 的environment 结构。



递归：

（1）define

```
global  ________________________
env     | other var.            |
------->| factorial : *         |
        |             |         |
        |_____________|_________|
                      |     ^
                      |     |
                variables : n
                body: (if (= n 1) 1 (* n (factorial (- n 1))))
```

（2）evaluate

```
(factorial 6)
         _______            ^
  E1 -->| n : 6 |___________| GLOBAL
         -------
        (* 6 (factorial 5))
         _______            ^
  E2 -->| n : 5 |___________| GLOBAL
         -------
        (* 5 (factorial 4))
         _______            ^
  E3 -->| n : 4 |___________| GLOBAL
         -------
        (* 4 (factorial 3))
         _______            ^ 
  E4 -->| n : 3 |___________| GLOBAL
         -------
        (* 3 (factorial 2))
         _______            ^
  E5 -->| n : 2 |___________| GLOBAL
         -------
        (* 2 (factorial 1))
         _______            ^
  E6 -->| n : 1 |___________| GLOBAL
         -------
         1
```







迭代：

（1）define

```
global  ___________________________________
env     | other var.                       |
------->| factorial : *                    |
        | fact-iter : |               *    |
        |_____________|_______________|____|
                      |       ^       |  ^
                      |       |       |  |
                      |       |       variable : (product counter max-count)
                      |       |       body: (if (> counter max-count) 
                      |       |                 prod 
                      |       |                 (fact-iter (* counter product)
                      |       |                            (+ counter 1)
                      |       |                            max-count))
                      |       |
                variable: n
                body: (fact-iter 1 1 n)
```

（2）evaluate

```
(factorial 6)
         _______              ^
  E1 -->| n : 6 |_____________| GLOBAL  
         -------
         (fact-iter 1 1 n)

  E2 -->| product   : 1       ^
        | counter   : 1    ___| GLOBAL 
        | max-count : 6
         (fact-iter 1 2 6)

  E3 -->| product   : 1       ^
        | counter   : 2   ____| GLOBAL
        | max-count : 6
         (fact-iter 2 3 6)

  E4 -->| product   : 2       ^
        | counter   : 3  _____| GLOBAL
        | max-count : 6
         (fact-iter 6 4 6)

  E5 -->| product   : 6       ^
        | counter   : 4  _____| GLOBAL
        | max-count : 6
         (fact-iter 24 5 6)

  E6 -->| product   : 24      ^
        | counter   : 5  _____| GLOBAL
        | max-count : 6
         (fact-iter 120 6 6)

  E7 -->| product   : 120     ^
        | counter   : 6  _____| GLOBAL
        | max-count : 6
         (fact-iter 720 7 6)

  E8 -->| product   : 720     ^
        | counter   : 7  _____| GLOBAL
        | max-count : 6
         720
```



迭代中间表达式没有参与运算，就是直接在最后返回结果。

递归中间需要用下一个子过程的结果进行运算。





#### **Exercise 3.10.** 

In the `make-withdraw` procedure, the local variable `balance` is created **as a parameter of `make-withdraw`.** 

We could also create the local state variable explicitly, using `let`, as follows:

```lisp
(define (make-withdraw initial-amount)
  (let ((balance initial-amount))
    (lambda (amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))))
```

Recall from section 1.3.2 that `let` is simply syntactic sugar for a procedure call:

```lisp
(let ((<var> <exp>)) <body>)
```

is interpreted as an alternate syntax for

```lisp
((lambda (<var>) <body>) <exp>)
```

Use the environment model to analyze this alternate version of `make-withdraw`, drawing figures like the ones above to illustrate the interactions

```lisp
(define W1 (make-withdraw 100))
(W1 50)
(define W2 (make-withdraw 100))
```

Show that the two versions of `make-withdraw` create objects with the same behavior. How do the environment structures differ for the two versions?



（1）使用lambda 可以**隐式**创建一个local variable。

（2）使用let 可以**显式**创建local variables。

（3）对比两种方法创建的environment的**不同和相同**。



**let 会额外创建一个environment，用来绑定 initial-mount？**



（1）语句1

```lisp
(define W1 (make-withdraw 100))
```

```

global->| make-withdraw : *     |
env.    | W1 :  *         |     |
         -------|---^-----|---^-
                |   |     |   |
                |   |     parameter: initial-mount
                |   |     body: ((lambda (balance) ((...))) initial-mount)
                |   |
                |  _|___Frame_A__________
                | | initial-mount : 100  |<- E0
                |  -^--------------------
                |   |
                |  _|__________Frame_B______
                | | balance : initial-mount | <- E1
                |  -^-----------------------
                |   |
                parameter: amount
                body: (if (>= balance amount) ... )
```

（2）语句2

```lisp
(W1 50)
```

```
global->| make-withdraw : *     |
env.    | W1 :  *         |     |
         -------|---^-----|---^-
                |   |     |   |
                |   |     parameter: initial-mount
                |   |     body: ((lambda (balance) ((...))) initial-mount)
                |   |
                |  _|___Frame_A__________
                | | initial-mount : 100  |<- E0
                |  -^--------------------
                |   |
                |  _|__________Frame_B___
                | | balance : 50         | <- E1
                |  -^--------------------
                |   |
                parameter: amount
                body: (if (>= balance amount) ... )
```

实际上 Frame_A 的initial-mount不会动，**只有Frame_B的balance会改变。**



#### **Exercise 3.11.** 

In section 3.2.3 we saw how the environment model described the behavior of procedures **with local state.** 

Now we have seen how internal definitions work. 

**A typical message-passing procedure contains both of these aspects**. 

Consider the bank account procedure of section 3.1.1:

```lisp
(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
          ((eq? m 'deposit) deposit)
          (else (error "Unknown request -- MAKE-ACCOUNT"
                       m))))
  dispatch)
```

Show the environment structure generated by the sequence of interactions

```lisp
(define acc (make-account 50))
((acc 'deposit) 40)
; 90
((acc 'withdraw) 60)
; 30
```

Where is the local state for `acc` kept? Suppose we define another account

```lisp
(define acc2 (make-account 100))
```

How are the local states for the two accounts kept distinct? 

Which parts of the environment structure are shared between `acc` and `acc2`?



（1）分析之前的message passing 风格的代码的environment model

（2）acc 的local variable 保存在哪里？

（3）局部变量如何让 acc 和 acc2 有不同的local variable？

（4）acc 和 acc2 共享哪些部分？



**语句1**

```lisp
(define acc (make-account 50))
```

```
global   _________________________________
env  -->| make-account :*                 |
        | acc : *       |                 |
         -------|-------|---^-----------^-
                |       |   |           |
                |     ( * , * )         |
                |       |               |
                        parameter: balance
                |       body: (define (withdraw ... ))
                |                       |
                |                -------Frame 0-      (parameter, body)
                |               | balance  : 50 |      |
                |           E0->| withdraw : *--|--> ( * , * )  
                |               | deposit  : *--|--> ( * , * ) 
                |               | dispatch : *--|--> ( * , * )     
                |                -------^----^--           |
                |    ___________________|    |_____________| 
                |   |
              ( * , * )
                |
                parameter : m           
                body      : (cond ((eq? m ... ))) 
```

make-account 创建一个E0，这个env中有balance，withdraw，deposit和dispatch的定义。

**acc 的body其实就是 dispatch 的body，只不过其env pointer 指向的是 E0。**



**语句2**

```lisp
((acc 'deposit) 40)
```

```
global   _________________________________
env  -->| make-account :*                 |
        | acc : *                         |
         -------|-----------------------^-
                |                       |
                |                -------Frame 0-
                |               | balance  : 50 |
              ( *, *-)--------->| withdraw : *  |
                                | deposit  : *  |<- E0
                                | dispatch : *  |
                                 -^-----^------- (make-account balance)
                         _________|     |
                        |        -------Frame 1-
                        |       | m : 'deposit  |<- E1 
                        |        --------------- (dispatch m)
                 -------Frame 2-
                | amount : 40   |<- E2
                 --------------- (deposit amount)
```

先忽略 make-account，只看acc：

在E0基础上调用了dispatch，也就会创建一个新的env，也就是E1，m 是 'deposit。

根据m，然后调E0中的deposit，amount是40，然后对balance进行修改，程序结束，E1和E2消失，balance已经变为了 90。

```
global   _________________________________
env  -->| make-account :*                 |
        | acc : *                         |
         -------|-----------------------^-
                |                       |
                |                -------Frame 0-
                |               | balance  : 90 |
              ( *, *-)--------->| withdraw : *  |
                                | deposit  : *  |<- E0
                                | dispatch : *  |
                                 --------------- 
```



**语句3**

```lisp
((acc 'withdraw) 60)
```

```
global   _________________________________
env  -->| make-account :*                 |
        | acc : *                         |
         -------|-----------------------^-
                |                       |
                |                -------Frame 0-
                |               | balance  : 90 |
              ( *, *-)--------->| withdraw : *  |
                                | deposit  : *  |<- E0
                                | dispatch : *  |
                                 -^-----^------- (make-account balance)
                         _________|     |
                        |        -------Frame 3-
                        |       | m : 'withdraw |<- E3
                        |        --------------- (dispatch m)
                 -------Frame 4-
                | amount : 60   |<- E4
                 --------------- (withdraw amount)
```

和语句2过程基本一致，只不过E3中的m变为了'withdraw，调用的是withdraw这个过程，最后让 balance变为了30。

```
global   _________________________________
env  -->| make-account :*                 |
        | acc : *                         |
         -------|-----------------------^-
                |                       |
                |                -------Frame 0-
                |               | balance  : 30 |
              ( *, *-)--------->| withdraw : *  |
                                | deposit  : *  |<- E0
                                | dispatch : *  |
                                 ---------------
```



其实，你会发现acc的local variables 就存放在 make-account创建的env中。

acc 和 acc2 各自的local variables 存放在 各自make-account 创建的 env 中。

两者唯一共享的部分就是 global env。



#### **Exercise 3.12.** 

The following procedure for appending lists was introduced in section 2.2.1:

```lisp
(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))
```

`Append` forms a new list by successively `cons`ing the elements of `x` onto `y`. 

**The procedure `append!` is similar to `append`, but it is a mutator rather than a constructor.** 

It appends the lists by splicing them together, modifying the final pair of `x` so that its `cdr` is now `y`. 

(It is an error to call `append!` with an empty `x`.)

```lisp
(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)
```

**Here `last-pair` is a procedure that returns the last pair in its argument:**

```lisp
(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))
```

Consider the interaction

```lisp
(define x (list 'a 'b))
(define y (list 'c 'd))
(define z (append x y))
z
(a b c d)
(cdr x)
; <response>
; (b)
(define w (append! x y))
w
(a b c d)
(cdr x)
; <response>
; (b c d)
```

What are the missing <*response*>s ? 

Draw box-and-pointer diagrams to explain your answer.

（1）对比 append 和 append!

（2）缺失的 response 是什么？

（3）绘制 box-and-pointer 。



`append` 不会改变原先的变量，但是 `append!` 会。





#### **Exercise 3.13.** 

Consider the following `make-cycle` procedure, which uses the `last-pair` procedure defined in exercise 3.12:

```lisp
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)
```

Draw a box-and-pointer diagram that shows the structure `z` created by

```lisp
(define z (make-cycle (list 'a 'b 'c)))
```

What happens if we try to compute `(last-pair z)`?

（1）使用 last-pair 定义make-cycle。

（2）(last-pair z) 会发生什么？估计会死循环。

```lisp
;  ,-------------------,
;  |                   |
;  v                   |
; ( . ) -> ( . ) -> ( . )
;  |        |        |
;  v        v        v
;  'a       'b       'c
```

(make-cycle) 会 无限递归。



#### **Exercise 3.14.** 

The following procedure is quite useful, although obscure:

```lisp
(define (mystery x)
  (define (loop x y)
    (if (null? x)
        y
        (let ((temp (cdr x)))
          (set-cdr! x y)
          (loop temp x))))
  (loop x '()))
```

`Loop` uses the "temporary'' variable `temp` to hold the old value of the `cdr` of `x`, since the `set-cdr!` on the next line destroys the `cdr`. 

Explain what `mystery` does in general.

**Suppose `v` is defined by `(define v (list 'a 'b 'c 'd))`.** 

Draw the box-and-pointer diagram that represents the list to which `v` is bound. 

**Suppose that we now evaluate `(define w (mystery v))`.** 

Draw box-and-pointer diagrams that show the structures `v` and `w` after evaluating this expression. 

What would be printed as the values of `v` and `w` ?

（1）分析 mystery 这个过程。

（2）使用 temp 保存 x 的cdr，原因是 set-cdr! 会丢失 原先x 的 cdr。

（3）分析代码结果。

```lisp
v
; (a)
w
; (d c b a)
```

w 就是原先 v 的逆序。



set-cdr! 的作用就是每次将 x 的car 和 y 进行拼接，不断按照这种方式进行递归。

当 x 空了，那么y就是逆序后的结果。

**v 在第一次 set-cdr! 后就已经变为了 (a)，后续的过程都是在 'a 的前面进行修改。**



#### **Exercise 3.15.** 

Draw box-and-pointer diagrams to explain the effect of `set-to-wow!` on the structures `z1` and `z2` above.

```lisp
(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))

(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)
z1
; ((a b) a b)
(set-to-wow! z1)
;((wow b) wow b)

z2
; ((a b) a b)
(set-to-wow! z2)
;((wow b) a b)
```

```
; z1 -> ( . )
;        | |
;        v v
; x --> ( . ) -> ( . ) -> null
;        |        |
;        v        v
;       'wow     'b
```

```
; z2 -> ( . ) -> ( . ) -> ( . ) -> null
;        |        |        |
;        |        v        v
;        |       'a       'b
;        |                 ^
;        |                 |
;        `-----> ( . ) -> ( . ) -> null
;                 |
;                 v
;                'wow
```

```
(set-car! (car x) 'wow)
```

其实就是将x的car指针所指向的地方修改为'wow



#### **Exercise 3.16.** 

Ben Bitdiddle decides to write a procedure to count **the number of pairs in any list structure.**

It's "easy," he reasons. "The number of pairs in any structure is the number in the `car` plus the number in the `cdr` plus one more to count the current pair.'' 

So Ben writes the following procedure:

```lisp
(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
         (count-pairs (cdr x))
         1)))
```

Show that this procedure is not correct. 

In particular, draw box-and-pointer diagrams representing list structures made up of **exactly three pairs for which Ben's procedure would return 3; return 4; return 7; never return at all.**



（1）计算任意list中pair的个数？

（2）构造四个只有3个pair的list，让其过程返回3 4 7 死循环



出现不同结果的本质原因是 pair 可以被共享，出现了重复计数



死循环就是构造最后一个指针向前指，即出现“环”



#### **Exercise 3.17.** 

Devise a correct version of the `count-pairs` procedure of exercise 3.16 that returns the number of distinct pairs in any structure. 

(Hint: Traverse the structure, maintaining an **auxiliary data structure** that is used to keep track of which pairs have already been counted.)

修正 3.16 的代码，可以使用辅助数据结构跟踪那些pair已经被计数。



使用什么数据结构？怎么得到一个pair的唯一标记？

可以直接使用一个list即可，可以通过memq过程来判断一个pair是否在一个list中。

```lisp
(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))
(memq 'apple '(pear banana prune))
; false
(memq 'apple '(x (apple sauce) y apple pear))
; (apple pear)
```

```lisp
(define (count-pairs x)
  (let ((vis nil))
    (define (iter x)
      (if (or (not (pair? x)) (memq x vis))
          0
          (begin (set! vis (cons x vis))
                 (+ (iter (car x))
                    (iter (cdr x))
                    1))
          )
      )
    (iter x)
    )
  )
```



#### **Exercise 3.18.** 

Write a procedure that examines a list and determines whether it contains a cycle, that is, **whether a program that tried to find the end of the list by taking successive `cdr`s would go into an infinite loop.** 

Exercise 3.13 constructed such lists.

写一个过程，确定一个list是否包含 一个 cycle？。

这里只需要看 cdr 即可，不用看 car，虽然连续的car也可能造成cycle。



#### **Exercise 3.19.** 

Redo exercise 3.18 using an algorithm **that takes only a constant amount of space.** 

(This requires a very clever idea.)

只用常数空间复杂度的算法实现 3.18 

不会是快慢指针的思路把？

This is a well studied problem. Robert Floyd came up with an algorithm to solve this in the 1960s. 

**(Yes, the same Floyd of the from the more famous Floyd-Warshall algorithm.)** 

More infomation at: http://en.wikipedia.org/wiki/Cycle_detection



设置两个指针，一个每次移动一个pair，一个每次移动两个pair

如果发现某个时刻两个指针指向的pair相同，那么就存在cycle

为了加速找到答案，如果在中途发现 快指针和慢指针只有一个pair的距离就相同了，那么也说明存在cycle。

```lisp
(define (exist-cycle? x) 
  (define (scdr l) 
    (if (pair? l) 
        (cdr l) 
        nil )) 
  (define (iter a b) 
    (cond ((not (pair? a)) #f) 
          ((not (pair? b)) #f) 
          ((eq? a b) #t) 
          ((eq? a (scdr b)) #t) 
          (else (iter (scdr a) (scdr (scdr b)))))) 
  (iter (scdr x) (scdr (scdr x))))
```

scdr 就是 safe-cdr 的简写







