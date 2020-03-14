
+++
title = "Python Functional Programming"
date = "2020-03-13"
author = "Jason Beach"
categories = ["Modeling", "BestPractice"]
tags = ["python", "development", "functional"]
+++


## Introduction

Most programming languages are procedural or are written in an imperative style: programs are lists of instructions that tell the computer what to do with the program’s input.  Even 'purely' OOP languages, such as Java, are typically written in an imperative style with little thought give in actual OOP modeling.

Functional code is characterised by one thing: the absence of side effects. It doesn’t rely on data outside the current function, and it doesn’t change data that exists outside the current function. Every other “functional” thing can be derived from this property.  Ideally, functions only take inputs and produce outputs, and don’t have any internal state that affects the output produced for a given input. 

Programming in this respect requires one to think in terms of data state.  Because of this and other attributes, functional programming is good at modeling processes, such as data ETL.

## Principles

Just three principles can provide guidance for programming in a functional manner.

* Pure and Higher-Order functions do not change external data, and they can accept other functions as parameters and can return functions as output.
* Immutability, all values are immutable by default. Any “mutating” operations copy the value, change it and pass back the changed copy. This eliminates bugs that arise from a programmer’s incomplete model of the possible states their program may enter.
* First class functions allow functions to be treated like any other value. This means they can be created, passed to functions, returned from functions and stored inside data structures.

It is also helpful to keep in-mind a few unique aspects of functional languages.  Unfortunately, these are missing from Python, but are available in languages where functional characteristics are important, such as Scala:

* tail call optimisation is used for recursion
* currying is used for decomposing a function (that takes multiple arguments) into a function that takes the first argument, and returns a function that takes the next argument
* parallelization ensures running the same code concurrently without synchronization. These concurrent processes are often run on multiple processors
* lazy evaluation is a compiler technique that avoids running code until the result is needed
* a process is deterministic only if repetitions yield the same result every time

## Functional Methods

These basic methods for not iterating over data use Higher Order Functions.  Developers with Hadoop or Spark experience should be familiar with these techniques.

* list comprehensions
* map
* filter
* reduce

Try not thinking about the operations on the data. Think of the states the data will go through.  Change of state is a process.

```python
from functools import reduce
from operator import add
```

```python
people = [{'name': 'Mary', 'height': 160},
          {'name': 'Isla', 'height': 80},
          {'name': 'Sam'}]
```

```python
heights = map(lambda x: x['height'],
              filter(lambda x: 'height' in x, people))
heights
```




{{< output >}}
```nb-output
<map at 0x7ffafa47a1d0>
```
{{< /output >}}



```python
lst = list(heights)
```

```python
if len(lst) > 0:
    average_height = reduce(add, lst) / len(lst)
    
average_height 
```




{{< output >}}
```nb-output
120.0
```
{{< /output >}}



Here, map is a generator.  So, we must run it as a list in order to use the `len()` method.

## Declarative Approach

A functional version of code is declarative. It describes what to do, rather than how to do it.  Convert imperative to declarative by the following steps:

* bundle pieces of the code into functions -> 
  - accomplished: the code describes itself (no need for comments).  Splitting code into functions is a great, low brain power way to make code more readable.
  - lacking: functions used as sub-routines, they affect the code around them by changing external variables, rather than by returning values. 
* remove state ->
  - accomplished: 
    i) no shared state, everything performed on function parameters, then passed out
    ii) each function has parameters, those parameters are the system component state
    iii) no variables are instantiated inside functions, all data changes are done with return values
* structure
  - main functions call auxiliary functions
  - pipeline of one function to another

## Sequences into Pipelines

Gets to the heart of what is needed in ETL.

* `deepcopy()` - if the data must be worked inside the function

## Functional Elements Python Lacks

Functional things I miss in Python:

* Pattern matching
* Tail recursion
* Large library of list functions
* Functional dictionary class
* Automatic currying
* Concise way to compose functions
* Lazy lists
* Simple, powerful expression syntax (Python's simple block syntax prevents Guido from adding it)

Reasons why these are important:

* No pattern matching and no tail recursion mean your basic algorithms have to be written imperatively. Recursion is ugly and slow in Python.
* A small list library and no functional dictionaries mean that you have to write a lot of stuff yourself.
* No syntax for currying or composition means that point-free style is about as full of punctuation as explicitly passing arguments.
* Iterators instead of lazy lists means that you have to know whether you want efficiency or persistence, and to scatter calls to list around if you want persistence. (Iterators are use-once)
* Python's simple imperative syntax, along with its simple LL1 parser, mean that a better syntax for if-expressions and lambda-expressions is basically impossible. Guido likes it this way, and I think he's right.


## References

* [non-functional vs functional examples ](https://maryrosecook.com/blog/post/a-practical-introduction-to-functional-programming)
* [docs: python3's functools and itertools ](https://docs.python.org/3/howto/functional.html)
* [video tutorial series on python functional programming ](https://realpython.com/courses/functional-programming-python/)
