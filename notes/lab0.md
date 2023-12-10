https://inst.eecs.berkeley.edu/~cs61a/su20/lab/lab00/



## Python Basics

### Expressions and statements

```
python3
```



### Primitive expressions

```python
>>> 3
3
>>> 12.5
12.5
>>> True
True
```

### Arithmetic expressions

- `+` operator (addition)
- `-` operator (subtraction)
- `*` operator (multiplication)
- `**` operator (exponentiation)
- Floating point division (`/`)
- Floor division (`//`)
- Modulo (`%`)

```python
>>> 7 / 4
1.75
>>> (2 + 6) / 4
2.0
>>> 7 // 4        # Floor division (rounding down)
1
>>> 7 % 4         # Modulus (remainder of 7 // 4)
3
```

### Assignment statements

```python
>>> a = (100 + 50) // 2
```

Note that the statement itself doesn't evaluate to anything, because it's a statement and not an expression. 

```python
>>> a
75
```

Note that the name `a` is bound to the *value* 75, *not* the expression `(100 + 50) // 2`. **Names are bound to values, not expressions.**



```python
>>> 10 + 2
12

>>> 7 / 2
3.5

>>> 7 // 2
3

>>> 7 % 2		  
# 7 modulo 2, equivalent to the remainder of 7 // 2
1

>>> x = 20
>>> x + 2
22

>>> x
20

>>> y = 5
>>> y += 3			# Equivalent to y = y + 3
>>> y * 2
16

>>> y //= 4			# Equivalent to y = y // 4
>>> y + x
22
```



本地测试就够了！

patch_requests 直接返回，跳过读取cacert.pem 的过程。



```shell
python ok
```





