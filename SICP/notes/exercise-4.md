#### **Exercise 4.1.** 

Notice that we cannot **tell whether the metacircular evaluator evaluates operands from left to right or from right to left.** 

Its evaluation order is inherited from the underlying Lisp: 

If the arguments to `cons` in `list-of-values` are evaluated from left to right, **then `list-of-values` will evaluate operands from left to right**; and if the arguments to `cons` are evaluated from right to left, then `list-of-values` will evaluate operands from right to left.

Write a version of `list-of-values` that evaluates operands **from left to right regardless of the order of evaluation in the underlying Lisp.** 

Also write a version of `list-of-values` that evaluates operands from right to left.

（1）无法判断 eval 是 从左到右进行求值，还是从右到左求值

（2）编写一个' list-of-values '的版本，从左到右计算操作数，而不管底层Lisp中的计算顺序。

（3）还要编写一个从右到左计算操作数的' list-of-values '版本。



