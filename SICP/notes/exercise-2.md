

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

