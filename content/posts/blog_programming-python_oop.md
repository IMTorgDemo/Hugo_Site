
+++
title = "Object Oriented Programming with Python"
date = "2020-03-10"
author = "Jason Beach"
categories = ["Modeling", "BestPractice"]
tags = ["python", "development", "oop"]
+++


Object Oriented Programming (OOP) programming became popular with Java.  Microsoft quickly followed-up with the C# language.  Now, OOP concepts are available in many languages.  Python inherits alot of these OOP attributes, but performs it in its usual pythonic minimalism.  The concepts are the same, but much of the cruft, such as accessor modifiers, are limited, leaving an succinct and enjoyable object modeling experience. 

## Introduction

OOP deals with classes (blueprints) and objects (instances of blueprint).  Relationships between these two include:
* encapsulation - refers to object state and hiding it from the outside, implemented with access modifiers such as public, protected, private
* inheritance - how a child class can inherit a parent class to utilise its properties and functions, python has two types
  - multiple inheritance
  - multilevel inheritance
* polymorphism - using the same functions on different classes
* abstractions - describe in simpler terms, such as inheritance hierarchy, where more abstract concepts are at the top and more concrete ideas, at the bottom, build upon their abstractions. 


## Object Creation and Class (Static) Variables

Both `__new__` (Python defines this function for every class by default) and `__init__` together forms a constructor.

```python
class Example:
    def __init__(self):
        self.var = 'studytonight'

#creating object of the class Example
mutantObj = Example()
```

function `__del__` is the counter-part of function `__new__`

If we had wanted to create a class-level variable, then we would place it between the class definition and class methods, and not using `.self`.  In other languages, the `static` keyword would be used.

```python
class Example:
    var = None
    def __init__(self):
        Example.var = 'studytonight'
```

Static methods can be implemented using a Decorator, and not using `self` as an argument.

```python
class Shape:
    
    @staticmethod
    def info(msg):
        # show custom message
        print(msg)
        print("This class is used for representing different shapes.")

Shape.info("Welcome to Shape class")
```

{{< output >}}
```nb-output
Welcome to Shape class
This class is used for representing different shapes.
```
{{< /output >}}

## Encapsulation

Python makes the use of underscores to specify the access modifier for a specific data member and member function in a class.

```python
# defining a class Employee with public variables
class Employee:
    # constructor
    def __init__(self, name, sal):
        self.name = name
        self.sal = sal
```

```python
# defining a class Employee
class Employee:
    # constructor
    def __init__(self, name, sal):
        self._name = name   # protected attribute 
        self._sal = sal     # protected attribute
```

```python
# defining class Employee
class Employee:
    def __init__(self, name, sal):
        self.__name = name    # private attribute 
        self.__sal = sal      # private attribute
```

If we want to access the private member variable, we will get an error.

```python
emp = Employee("Bill", 10000)
emp.__sal
```


{{< output >}}
```nb-output
---------------------------------------------------------------------------
```
{{< /output >}}

{{< output >}}
```nb-output
AttributeError                            Traceback (most recent call last)
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-9-d9e08f1374dc> in <module>
      1 emp = Employee("Bill", 10000)
----> 2 emp.__sal
```
{{< /output >}}

{{< output >}}
```nb-output
AttributeError: 'Employee' object has no attribute '__sal'
```
{{< /output >}}


## Inheritance

Inheriting the property of multiple classes into one.

### Multiple Inheritance


```python
class A:
    a = None
    # functions of class A

class B:
    b = None
    # functions of class B

class C(A, B):
    c = None
    # class C inheriting property of both class A and B
    # add more properties to class C
```

```python
cls = C()
cls.a == cls.b == cls.c
```




{{< output >}}
```nb-output
True
```
{{< /output >}}



### Multilevel Inheritance

We inherit the classes at multiple separate levels. We have three classes A, B and C, where A is the super class, B is its sub(child) class and C is the sub class of B.

```python
class A:
    a = None
    # properties of class A

class B(A):
    b = None
    # class B inheriting property of class A
    # more properties of class B

class C(B):
    c = None
    # class C inheriting property of class B
    # thus, class C also inherits properties of class A
    # more properties of class C
```

```python
cls = C()
print( issubclass(C,B) )
print( issubclass(C,A) )
```

{{< output >}}
```nb-output
True
True
```
{{< /output >}}

Use `issubclass(Child, Parent)` when verifying classes.

### Method Overriding

Overriding is possible if:
* inheritance exists between a parent and child classes
* function that is redefined in the child class should have the same signature, i.e. same number of parameters.

```python
class Animal:
    # properties
	multicellular = True
	# Eukaryotic means Cells with Nucleus
	eukaryotic = True
	
	# function breathe
	def breathe(self):
	    print("I breathe oxygen.")
    
    # function feed
	def feed(self):
	    print("I eat food.")
```

Let's create a child class Herbivorous which will extend the class Animal:

```python
class Herbivorous(Animal):
    
    # function feed
	def feed(self):
	    print("I eat only plants. I am vegetarian.")
```

In the child class Herbivorous we have overridden the method feed().  So now when we create an object of the class Herbivorous and call the method feed() the overridden version will be executed.

```python
herbi = Herbivorous()
herbi.feed()
```

{{< output >}}
```nb-output
I eat only plants. I am vegetarian.
```
{{< /output >}}

## Polymorphism and Method Overloading

Method Overloading is a type of polymorphism in which we can define a number of methods with the same name but with parameters can be of different types.  Similar to Overriding, it requires the same signature.

```python
class Square:
    side = 5     
    def calculate_area(self):
        return self.side * self.side

class Triangle:
    base = 5
    height = 4
    def calculate_area(self):
        return 0.5 * self.base * self.height
```

```python
def find_area_of_shape(obj):
    print( obj.calculate_area() )

sq = Square()
tri = Triangle()

# calling the method with different objects
find_area_of_shape(sq)
find_area_of_shape(tri)
```

{{< output >}}
```nb-output
25
10.0
```
{{< /output >}}

## Abstractness

### Abstract Classes

Abstract classes are classes that contain one or more abstract methods. An abstract method is a method that is declared, but contains no implementation. Abstract classes cannot be instantiated, and require subclasses to provide implementations for the abstract methods.

The following Python code uses the abc module and defines an abstract base class:

```python
from abc import ABC, abstractmethod
 
class AbstractClassExample(ABC):
 
    def __init__(self, value):
        self.value = value
        super().__init__()
    
    @abstractmethod
    def do_something(self):
        pass
```

Must override the method; otherwise, it will error-out.  A class that is derived from an abstract class cannot be instantiated unless all of its abstract methods are overridden.

```python
class DoAdd42(AbstractClassExample):

    def do_something(self):
        return self.value + 42
    
x = DoAdd42(10)
print(x.do_something())
```

{{< output >}}
```nb-output
52
```
{{< /output >}}

### MetaClasses

Create classes like classes create objects.  Important when classes should be configured based upon runtime specifications.

* [ref: metaclasses](https://www.python-course.eu/python3_metaclasses.php)
* [ref: shallow and deep copies](https://www.python-course.eu/python3_deep_copy.php)

## References

* [examples when garbage collection fails ](https://www.studytonight.com/python/destructors-in-python)
* [ref: python course](https://www.python-course.eu)
