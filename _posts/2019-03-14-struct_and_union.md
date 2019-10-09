---
layout: post
title: struct_and_union
---
If you are writing program by C programming language, you may need to care about how many memories to allocate, and when you should deallocate them. That is a heavy work for programmers, but at the same time it is very interesting. You will recognize that when defining a `float` variable, how many memories we need to allocate? Why a function can modify extern variables by passing the pointer of them?

<!-- More -->

As for me, I love dynamic programming language, such as Ruby, JavaScript, Python for creating things quickly. But sometimes I need system programming language like C. In my opinion, comparing to some modern system language C programming language is easy enough. In this article, I want to talk about the memory allocation for `struct` and `union` data structure when using C programming language.

## How many memories I need?

As we know `struct` and `union` are the composite data structure. They are combined by some basic data type, like `float`, `double`, `long`, `pointer`, etc. So if you want to calculate how many memories we need to allocate for a composite data structure, you should know the basic data type first.

Different data type may takes different memory spaces. We also measure the memory costs by **byte** instead of **bit** in machine underlayer. 1 byte usually equals to 8 bits and 1 byte also represented by `char` data type in C programming language. You can use this simple program to valid it.

``` C
#include <stdio.h>

int main() {
  unsigned long size = sizeof(char);
  char * unit = size > 1 ? "bytes" : "byte";
  printf("Char data type take %ld %s.", size, unit);
}

```

The result is

```
Char data type take 1 byte.
```

Also you can check others data type like `long`, `int`, `double` and `float`.

``` C
#include <stdio.h>

char * unit(size) {
  return size > 1 ? "bytes" : "byte";
}

int main() {
  unsigned long c_size = sizeof(char);
  unsigned long i_size = sizeof(int);
  unsigned long l_size = sizeof(long);
  unsigned long f_size = sizeof(float);
  unsigned long d_size = sizeof(double);

  printf("Char data type takes %ld %s\n", c_size, unit(c_size));
  printf("Int data type takes %ld %s\n", i_size, unit(i_size));
  printf("Long data type takes %ld %s\n", l_size, unit(l_size));
  printf("Float data type takes %ld %s\n", f_size, unit(f_size));
  printf("Double data type takes %ld %s\n", d_size, unit(d_size));
}
```

The result is

```
Char data type takes 1 byte
Int data type takes 4 bytes
Long data type takes 8 bytes
Float data type takes 4 bytes
Double data type takes 8 bytes
```

*PS: I ran the program in the 64-bit machine/system, some data type may have different memory costs in different machine/system. But don't worry about that now. Today, most of time we are using the 64-bit operating system.*

## Composite data type

We know that different data type may takes different memory spaces. Sometimes same data type in C may have different memory cost when running in different system/machine. If we alway use the 64-bit machine, how many memories will the composite data structure takes? Different composite data structure have different rule.

### 1. struct

First of all, let's focus on the `struct` composite data type. In short, machine must allocate enough memory to store all the data fields which included in `struct`. I will show you some example, After that you will know how to calculate the memory cost in `struct` data structure. So, How may memories we need for the below data structure?

``` C
struct Info1 {
  int a; // 4 bytes
  long b; // 8 bytes
  char c; // 1 byte
  double d; // 8 bytes
};
```

The answer is 32 bytes. Why? In fact, 21 bytes is enough to store all the data fields, why 32 bytes? This situation is called as `Data Alignment`. Because of that we have some wasted memory spaces. To avoiding wasted we can change the order of the data fields.

``` C
struct Info2 {
  int a; // 4 bytes
  char c; // 1 byte
  long b; // 8 bytes
  double d; // 8 bytes
};
```

Now we just need to allocate 24 bytes, just have 3 bytes wasted memory spaces. Let's valid that by this program.

``` C
#include <stdio.h>

struct Info1 {
  int a; // 4 bytes
  long b; // 8 bytes
  char c; // 1 byte
  double d; // 8 bytes
};

struct Info2 {
  int a; // 4 bytes
  char c; // 1 byte
  long b; // 8 bytes
  double d; // 8 bytes
};

int main() {
  printf("Info1 need %ld bytes\n", sizeof(struct Info1));
  printf("Info2 need %ld bytes\n", sizeof(struct Info2));
}
```

we will get the result

```
Info1 need 32 bytes
Info2 need 24 bytes
```

In this situation it uses **8 bytes aligned**, because the longest field in our `struct` is 8 bytes. Sometimes machine may take others aligned strategy. Let me show you more example.

``` C
...

struct Info3 {
  char a; // 1 byte
  char b; // 1 byte
  char c; // 1 byte
};

struct Info4 {
  char a; // 1 byte
  char b; // 1 byte
  short c; // 2 bytes
};

struct Info5 {
  char a; // 1 byte
  short b; // 1 byte
  int c; // 4 bytes
};

...
```

What about the struct `struct Info3`, `struct Info4`, `struct Info5`? the result is

```
Info3 need 3 bytes
Info4 need 4 bytes
Info5 need 8 bytes
```

1. All fields in `struct Info3` are 1 byte cost, it is 1 byte aligned. Totally, machine just need to allocate 3 bytes.
2. The longest field in `struct Info4` is `short c`, it will takes 2 bytes. So machine will use 2 bytes aligned strategy. The field `char a`, `char b` can store in the first 2-bytes space, and the `short c` will store in the second one. Totally, machine need to allocate 4 bytes.
3. Similar to `struct Info4`, the longest field in `struct Info5` is `int c`, it will take 4 bytes. So machine will use 4 bytes aligned strategy. The field `char a`, `short b` can store in the first 4-bytes space, and `int c` will store in the second one. Finally, machine need to allocate 8 bytes.

That is all about `struct` data structure memory allocation. So easy, right? Next, let's go to the `union` composite data type.

### 2. union

`union` is another important composite data structure in C programming language, it is similar to `struct`, except the memory allocation strategy. In short, The memories we need for `union` is decided by the longest field in it. As an example, let's create `union Info6`, it's fields are same as `struct Info1`

``` C
union Info6 {
  int a; // 4 bytes
  long b; // 8 bytes
  char c; // 1 byte
  double d; // 8 bytes
};
```

The result is

```
Info6 need 8 bytes
```

We just need 8 bytes now. Comparing to `struct Info1`, it saves too many memories. The longest field in this `union` is 8 bytes, all fields will share the same memory spaces. You can image that we just store what we want to store in it, and then tell the machine how to read them. All data in it just the binary, so reading them in the different way may get the different result. Let's valid them by a program.

``` C
....

union Info6 {
  int a;
  long b;
  char c;
  double d;
};

int main() {
  union Info6 info;
  info.b = 0xffffffffffffffff; // Set all bits are 1
  printf("Read by double is %lf.\n", info.d);
  printf("Read by int is %d.\n", info.a);
  printf("Read by long is %ld.\n", info.b);
  printf("Read by char is %d.\n", info.c);
}
```

The result is

```
Read by double is nan.
Read by int is -1.
Read by long is -1.
Read by char is -1.
```

As the conclusion above, we need to allocate 8 bytes for `union Info6`. First of all, we define an variable `info`, and then set all bits in it are `1`.

```
1111111111111111111111111111111111111111111111111111111111111111
```

If we recognize this bit strings as `double` type we will got

```
1 11111111111 1111111111111111111111111111111111111111111111111111
```

Following the IEEE775 standard, it is the schema of `NaN`. If we recognize this as `int` type we just need to calculate the low 32-bits

```
11111111111111111111111111111111
```

The value of this bit strings is `-1`. If we recognize this as `long` type, the bit strings we need to calculate will be the entire 64-bits

```
1111111111111111111111111111111111111111111111111111111111111111
```

The value of this bit strings is `-1`. If we recognize this as `char` type we just need to calculate the low 8-bits

```
11111111
```

So the value is the same `-1`.

### 3. conclusion

Both `struct` and `union` are composite data structure but have different memory allocation strategy. In summary, `struct` need to store all the fields in the limited memory spaces as possible as it can. `union` will share the memory spaces between all fields, so sometimes you need an extra field to target that which type you would like to use.

## "Hard" Example

Finally, let's practice what we have learned so far. How many memories we need for this data structure?

``` C
struct HardExample {
  union {
    int a; // 4 bytes
    long b; // 8 bytes
  } union1;

  union {
    int c; // 4 bytes
    double d; // 8 bytes
  } union2;

  struct {
    long e; // 8 bytes
    char f; // 1 byte
    double g; // 8 bytes
    int h; // 4 bytes
  } struct1;
};
```

It looks hard, but easy in fact, right? The memories required for `union1` and `union2` is decided by the longest fields in them. The longest field in `union1` is `long` type, 8-bytes cost. The longest field in `union2` is `long` type, 8-bytes cost. So each of them takes 8 bytes memory spaces. The longest field in `struct1` is `double` or `long`, it will be 8-bytes data alignment. So it need `8 + (1 + 7) + 8 + (4 + 4) = 32` bytes. Totally, we need `32 + 8 + 8 = 48` bytes for `struct HardExample`.

```
HardExample need 48 bytes
```

## End

Thank you for your reading. I think that is all what I want to talk about. Is it clear enough for you? If not, please contact me and give me some advice.
