
+++
title = "Syntax Comparisons Across Languages"
date = "2020-01-09"
author = "Jason Beach"
categories = ["Process", "DataScience"]
tags = ["machine-learning", "best-practice"]
+++


Scripting languages are quite popular for effectively getting work done.  But, their similarities lead to mental difficulties when remembering syntax and common idioms.  This post is used as a cheatsheet describing fundamental differences in how the languages are used.   

## Introduction

In any one day, I may program in five or six different languages.  This is enjoyable when the syntax is different enough that there is no confusion.  Domain Specific Languages, including R, SQL, Bash, and HTML, are orthogonal in their approach to being productive.  But, the 'Big Three' language families of Python, Javascript, and JVM variety (Java, Groovy, Scala) are so similar that they are easily confused. 

## Common Themes

Python is a dynamically-typed language, and this feature is an important reason why programmers can be more productive with Python; they don’t have to deal with the overhead of Java’s static typing. So the debates about Java/Python productivity inevitably turn into debates about the comparative advantages and drawbacks of static typing versus dynamic typing — or strong typing versus weak typing — in programming languages.  

Dynamic typing is concise, which can lead to smaller source code and fewer errors.  But, this can also be exemplary of fewer features.  To compensate, python uses protocols and other means to provision classes; rather than solely through object-oriented class hierarchies.  It is VERY instructive to look at dynamic-typed language from the perspective of static-typed to understand what problems may occur from the differences.  

Static typing can better ensure certainty of data in IO operations among applications and distributed environments.  Its greater standardization also lends to more automation of code and functionality in specific frameworks, such as Spring.  While less concise, this standardization and straight-forward approach lend Java to large code bases that require many contributors, such as Apache open-source projects.  

We will provide examples of how that is demonstrated in practice.

### Closures (Groovy)

Closures, operator overloading and meta programming are the key tools to adding Grooviness to existing libraries. Even many features that may look like being built into the core syntax are just clever library design. Appending to a list with << is an overloaded operator while looping over its entries with .each is an added method that takes a closure as its parameter.

```Groovy
def myClosure = { x, y -> x + y }		// scala uses =>
[1, 2, 3, 4].each{ println it*2 } 		// it is assumed
[<list>].<iterator>{<param> -> <statment>}
for(<condition>){<logic>} 				// loops can be faster than `.each`
```

### List, dict comprehensions (Py)

Python list comprehensions provide a concise way to create lists.  If this syntax was implemented in Java, it would be unreadable from all of the associated data types.  Comprehensions use the following syntax:  

%%python
 result   = [ expression for item in list if conditional ]
*result*  = [*transform*    *iteration*         *filter*     ]

#the * operator is used to repeat. The filter part answers the question if theitem should be transformed. 

Which corresponds to

%%python
for item in list:
    if conditional:
        expression

```Groovy
%%python
string = "Hello 12345 World"
numbers = [x for x in string if x.isdigit()]
numbers
```




{{< output >}}
```nb-output
['1', '2', '3', '4', '5']
```
{{< /output >}}



```Groovy
%%python
def double(x):
  return x*2
[double(x) for x in range(10)]
[double(x) for x in range(10) if x%2==0]
```




{{< output >}}
```nb-output
[0, 4, 8, 12, 16]
```
{{< /output >}}



```Groovy
%%python
[x+y for x in [10,30,50] for y in [20,40,60]]
```




{{< output >}}
```nb-output
[30, 50, 70, 50, 70, 90, 70, 90, 110]
```
{{< /output >}}



```Groovy
%%python
#dict comprehensions are just as good as list comprehensions
my_phrase = ["No", "one", "expects", "the", "Spanish", "Inquisition"]
my_dict = {key: value for value, key in enumerate(my_phrase)}
reversed_dict = {value: key for key, value in my_dict.items()}
reversed_dict
```




{{< output >}}
```nb-output
{0: 'No', 1: 'one', 2: 'expects', 3: 'the', 4: 'Spanish', 5: 'Inquisition'}
```
{{< /output >}}



### Callback (Js)

* [js idioms for java devs](http://softwareloop.com/2015/02/09/javascript-idioms-for-java-developers/)

## Data Structures and Collections

These are some of the most commonly-used objects within a language.  The data structure describes the underlying principles of how the class works with hardware, and the various collection interfaces describe how to interact with the object.

### ArrayList / LinkedList (JVM), iterables / sequences (Py), array (Js)

ArrayList ???

LinkedHashMap is just like HashMap with an additional feature of maintaining an order of elements inserted into it, [ref](https://www.geeksforgeeks.org/linkedhashmap-class-java-examples/).  Like arrays, Linked List is a linear data structure. Unlike arrays, linked list elements are not stored at a contiguous location; the elements are linked using pointers, [ref: java linked lists](https://www.geeksforgeeks.org/linked-list-set-1-introduction/).

There are two `remove` methods available: One that takes an integer and removes an element by its index, and another that will remove the first element that matches the passed value.  If we have a list of integers, use `removeAt` to remove an element by its index, and `removeElement` to remove the first element that matches a value.

```Groovy
//ArrayList
list = [5, 6, 7, 8]
list.add(9)
list << 10
assert list  == [5, 6, 7, 8, 9, 10]
assert list.get(2) == 7

list.remove(5)    
assert list.max() == 9
assert ['a','b','c','b','b'] - 'c' == ['a','b','b','b']  //remove elements from list by value
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
assert [1, 2, 3, 4, 5][-1] == 5             //use negative indices to count from the end

assert list.size() == 5
assert list.getClass() == ArrayList     //the specific kind of list being used
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
assert [1, 2, 3] * 3 == [1, 2, 3, 1, 2, 3, 1, 2, 3]
assert [1, 2, 3].multiply(2) == [1, 2, 3, 1, 2, 3]

assert Collections.nCopies(3, 'b') == ['b', 'b', 'b']
assert Collections.nCopies(2, [1, 2]) == [[1, 2], [1, 2]] //not [1,2,1,2]; nCopies from the JDK has different semantics than multiply for lists
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
def list2 = new ArrayList<String>(list)
assert list2 == list   //== checks that each corresponding element is the same
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
def list3 = list.clone()
assert list3 == list   //clone() can also be called
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



Iterating on elements of a list is usually done calling the `each` and `eachWithIndex` methods, which execute code on each item of a list.  

Mapping is creating a new list by transforming each of its elements into something else, using the `collect` method.

```Groovy
['a', 'b', 'c'].eachWithIndex { it, i -> println "$i: $it"} //`it` is the current element, while `i` is the index
    
assert [1, 2, 3].collect { it * 2 } == [2, 4, 6]
assert [1, 2, 3]*.multiply(2) == [1, 2, 3].collect { it.multiply(2) }  //shortcut syntax instead of collect
```

{{< output >}}
```nb-output
0: a
1: b
2: c
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
assert [1, 2, 3].find { it > 1 } == 2           //find 1st element matching criteria
assert [1, 2, 3].findAll { it > 1 } == [2, 3]   //find all elements matching critieria

assert ['a', 'b', 'c', 'd', 'e'].findIndexOf { it in ['c', 'e', 'g'] } == 2     //find index of 1st element matching criteria
assert ['a', 'b', 'c', 'd', 'c'].indexOf('c') == 2                              //first index returned
assert ['a', 'b', 'c', 'd', 'c'].findIndexValues{it=='c'} == [2,4]              //all indices returned
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
assert [1, 2, 3].every { it < 5 }               // returns true if all elements match the predicate
assert ![1, 2, 3].every { it < 3 }              // negation
assert [1, 2, 3].any { it > 2 }                 // returns true if any element matches the predicate
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
assert [1, 2, 3].join('-') == '1-2-3'           // String joining
assert [1, 2, 3].inject('counting: ') { str, item -> str + item } == 'counting: 123'     // reduce operation
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
Comparator mc = { a, b -> a == b ? 0 : (a < b ? -1 : 1) }
def list = [7, 4, 9, -6, -1, 11, 2, 3, -9, 5, -13]
assert list.max(mc) == 11
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



Sorting is a common list operation.

```Groovy
assert [6, 3, 9, 2, 7, 1, 5].sort() == [1, 2, 3, 5, 6, 7, 9]

def list = ['abc', 'z', 'xyzuvw', 'Hello', '321']
assert list.sort { it.size() } == ['z', 'abc', '321', 'Hello', 'xyzuvw']

def list2 = [7, 4, -6, -1, 11, 2, 3, -9, 5, -13]
assert list2.sort { a, b -> a == b ? 0 : Math.abs(a) < Math.abs(b) ? -1 : 1 } == [-1, 2, 3, 4, 5, -6, 7, -9, 11, -13]
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
//Groovy Iterables???
```

Python provides iterables (the iterator protocol) for the implementation of lists, generators, and other classes that require returning its members one by one.  An iterator is an object representing a stream of data. 

Sequences (list, tuple, string) are a type of iterable that support efficient element access using integer indices via the `__getitem()__` special method (indexing) and define a `__length()__` method that returns the length of the sequence.

Many things in Python are iterables, but not all of them are sequences. 

```Groovy
%%python
def Sort(sub_li): 
    # reverse = None (Sorts in Ascending order) 
    # key is set to sort using second element of  
    # sublist lambda has been used 
    sub_li.sort(key = lambda x: x[1]) 
    return sub_li
 
sub_li =[['rishav', 10], ['akash', 5], ['ram', 20], ['gaurav', 15]] 
print(Sort(sub_li)) 
```

{{< output >}}
```nb-output
[['akash', 5], ['rishav', 10], ['gaurav', 15], ['ram', 20]]
```
{{< /output >}}

```Groovy
%%python
#you can iterate over a list and get its index
mylist = ["It's", 'only', 'a', 'model']
for index, item in enumerate(mylist):
    print(index, item)
```

{{< output >}}
```nb-output
0 It's
1 only
2 a
3 model
```
{{< /output >}}

```javascript
%%javascript
arr = []
```

### Hash map (JVM), collection (py), ??? (Js)

* [ref: groovy maps](https://www.baeldung.com/groovy-maps)
* [ref: arraylist vs hashmap](https://www.geeksforgeeks.org/arraylist-vs-hashmap-in-java/)

```Groovy
map = [name: 'Gromit', likes: 'cheese', id: 1234, "city":"New York"]
map.put('foo', 'bar')
assert map.get('name') == 'Gromit'
assert map.containsKey('city') == true
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



```Groovy
assert map.size() == 5
assert map instanceof java.util.Map
assert map.getClass() == LinkedHashMap     // this is probably what you want
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



Map keys are strings by default.  You must 'escape' a key (parenthesis) if you want to use a variable's value as key.

```Groovy
def a = 'Bob'
def ages = [a: 43]
assert ages['Bob'] == null //`Bob` is not found
assert ages['a'] == 43     //because `a` is a literal!

ages = [(a): 43]            //now we escape `a` by using parenthesis
assert ages['Bob'] == 43   //and the value is found!
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



Maps also act like beans so you can use the property notation to get/set items inside the Map.

```Groovy
assert map.name == 'Gromit'     //can be used instead of map.get('name')
assert map.id == 1234
map.bar = 'foo'
```




{{< output >}}
```nb-output
foo
```
{{< /output >}}



Maps created using the map literal notation are ordered, that is to say that if you iterate on map entries, it is guaranteed that the entries will be returned in the same order they were added in the map.

```Groovy
map.eachWithIndex{entry, i -> println "$i $entry.key: $entry.value"}
```

{{< output >}}
```nb-output
0 name: Gromit
1 likes: cheese
2 id: 1234
3 city: New York
4 foo: bar
5 bar: foo
```
{{< /output >}}



```Groovy
map.sort()																// sort on key
```



```Groovy
map.find{it.value == "New York"}.key == "city"							// returns the first Entry that matches
map.findAll{it.value == "New York"} == [city : "New York"]				// returns all matches to a map
```




{{< output >}}
```nb-output
true
```
{{< /output >}}



```Groovy
map.grep{it.value == "New York"}.each{it -> assertTrue(it.key == "city" && it.value == "New York")}			// returns a list instead of a map
```


{{< output >}}
```nb-output
groovy.lang.MissingMethodException: No signature of method: script1579053864497.assertTrue() is applicable for argument types: (java.lang.Boolean) values: [true]
```
{{< /output >}}

{{< output >}}
```nb-output
	at script1579053864497$_run_closure2.doCall(script1579053864497:1)
```
{{< /output >}}

{{< output >}}
```nb-output
	at this cell line 1
```
{{< /output >}}

{{< output >}}
```nb-output
	at com.twosigma.beakerx.groovy.evaluator.GroovyCodeRunner.runScript(GroovyCodeRunner.java:94)
```
{{< /output >}}

{{< output >}}
```nb-output
	at com.twosigma.beakerx.groovy.evaluator.GroovyCodeRunner.call(GroovyCodeRunner.java:59)
```
{{< /output >}}

{{< output >}}
```nb-output
	at com.twosigma.beakerx.groovy.evaluator.GroovyCodeRunner.call(GroovyCodeRunner.java:32)
```
{{< /output >}}


```Groovy
map.every{it -> it.value instanceof String} == false					// returns a boolean
map.collect{entry -> entry.value.name}									// collect entries into a list
map.findAll{it.value.age < 30}.collect{key, value -> value.name}		// query and collect into new map
map.groupBy{it.value % 2}												// subgroup
```


{{< output >}}
```nb-output
groovy.lang.MissingPropertyException: No such property: name for class: java.lang.String
```
{{< /output >}}

{{< output >}}
```nb-output
	at script1579053917761$_run_closure2.doCall(script1579053917761:2)
```
{{< /output >}}

{{< output >}}
```nb-output
	at this cell line 2
```
{{< /output >}}

{{< output >}}
```nb-output
	at com.twosigma.beakerx.groovy.evaluator.GroovyCodeRunner.runScript(GroovyCodeRunner.java:94)
```
{{< /output >}}

{{< output >}}
```nb-output
	at com.twosigma.beakerx.groovy.evaluator.GroovyCodeRunner.call(GroovyCodeRunner.java:59)
```
{{< /output >}}

{{< output >}}
```nb-output
	at com.twosigma.beakerx.groovy.evaluator.GroovyCodeRunner.call(GroovyCodeRunner.java:32)
```
{{< /output >}}


Python defines a collection (dictionary, set, frozenset) as not having a deterministic ordering.

```Groovy
%%python
#dict
#open an append file when given a file with the following
#a 5
#b 6
#d 7
#a 2
#c 1

d = {}
for line in file('data/keyvalue.txt'):
    key, value = line.split()
    l = d.get(key, [])
    l.append(int(value))
    d[key] = l
    
def sort_by_sum_value(a, b):
...    sum_a = sum(a[1])
...    sum_b = sum(b[1])
...    return cmp(sum_a, sum_b)

items = d.items()
items    #[('a', [5, 2]), ('c', [1]), ('b', [6]), ('d', [7])]
items.sort(sort_by_sum_value)


#iterate over items
my_dict = {'name': 'Lancelot', 'quest': 'Holy Grail', 'favourite_color': 'blue'}
print(my_dict.get('airspeed velocity of an unladen swallow', 'African or European?\n'))
for key, value in my_dict.iteritems():
    print(key, value, sep=": ")
```

### Set and operations

Set operations can be performed on Groovy lists.

```Groovy
assert 'a' in ['a','b','c']             // returns true if an element belongs to the list
assert ['a','b','c'].contains('a')      // equivalent to the `contains` method in Java
assert [1,3,4].containsAll([1,4])       // `containsAll` will check that all elements are found

assert [1,2,3,3,3,3,4,5].count(3) == 4  // count the number of elements which have some value

assert [1,2,4,6,8,10,12].intersect([1,3,6,9,12]) == [1,6,12]

assert [1,2,3].disjoint( [4,6,9] )
assert ![1,2,3].disjoint( [2,4,6] )
```

Python has its own builtin `set` collection.

```Groovy
%%python
s = set((1, 2, 3, 4, 5))
t = set((4, 5, 6))
print( s.union(t) )

set([1, 2, 3, 4, 5, 6])
print( s.intersection(t) )

u = set((4, 5, 6, 7))
print( t.issubset(u) )
print( u.issubset(t) )

sl = list(s)
ss = set(sl)
```

{{< output >}}
```nb-output
{1, 2, 3, 4, 5, 6}
{4, 5}
True
False
```
{{< /output >}}

```javascript
%%javascript
//just JSON???
```

### Iterators

Python doesn't have `for()` loops: `for(initializer; condition; iterator){`.  It has something more akin to a `foreach` loop: `for number in numbers:`.  Python’s for loop is using iterators.

An iterable is an object capable of returning its members one by one - you can apply a `for` loop to it.  Sequences are a common type of iterable.  They support efficient element access using integer indices via the `__getitem()__` special method (indexing), so slicing can be performed on them.

Dictionaries, file objects, sets, and generators are all iterables, but none of them is a sequence.

An iterator is an object representing a stream of data. You can create an iterator object by applying the `iter()` built-in function to an iterable.  You can use an iterator to manually loop over the iterable it came from. A repeated passing of iterator to the built-in function next()returns successive items in the stream. 

```Groovy
%%python
numbers = [10, 12, 15, 18, 20]   #create iterable
print(iter(numbers))

iterator = iter(numbers)         #create iterator
print(next(iterator))
```

{{< output >}}
```nb-output
<list_iterator object at 0x7f568f83b0f0>
10
```
{{< /output >}}

In Python, the iterators are also iterables which act as their own iterators.  However, the difference is that iterators don’t have some of the features that iterables have. They don’t have length `len()` and can’t be indexed `iterartor[0]`.

Common iterators include: enumerate, reverse, zip, map, filter, and the File object.

```Groovy
%%python
numbers = [10, 12, 15, 18, 20]
iterator = enumerate(numbers)
print(next(iterator))             #index, value

squared = map(lambda x: x**2, numbers)
print(next(squared))              #applied function
```

{{< output >}}
```nb-output
(0, 10)
100
```
{{< /output >}}

Because of their laziness, the iterators can help us to deal with infinitely long iterables. Iterators can save us a lot of memory and CPU time.  We can use `itertools.repeat` to create an iterable that provides 100 million 4’s to us.  This iterator takes up 56 bytes of memory on my machine versus the 800 megabytes of a list.

```Groovy
%%python
from itertools import repeat
lots_of_fours = repeat(4, times=100_000_000)

import sys
size_in_bytes = sys.getsizeof(lots_of_fours)
print(size_in_bytes)

lots_of_fours = [4] * 100_000_000
size_in_bytes = sys.getsizeof(lots_of_fours)
print(size_in_bytes)
```

{{< output >}}
```nb-output
56
800000064
```
{{< /output >}}

Python iterators are more general versions of the sequence protocol.  Here, `__iter__` just returns `self`, an object that has the function `next()`, which (when called) either returns a value or raises a `StopIteration` exception.  

```Groovy
%%python
class SillyIter:
    i = 0
    n = 5
    def __iter__(self):
        return self
    def __next__(self):
        self.i += 1
        if self.i > self.n:
            raise StopIteration
        return self.i

si = SillyIter()
for i in si:
    print(i)
```

{{< output >}}
```nb-output
1
2
3
4
5
```
{{< /output >}}

It is much easier to use a generator function or generator expression to create a custom iterator.  A generator function from the Python docs.  A function which returns a generator iterator. It looks like a normal function except that it contains `yield` expressions for producing a series of values one at a time with the `next()`.  `yield` temporarily suspends processing, remembering the location execution state (including local variables and pending try-statements). When the generator iterator resumes, it picks up where it left off (in contrast to functions which start fresh on every invocation).

```Groovy
%%python
def SillyIter():
    i = 0
    n = 5
    while i < n:
        i+=1
        yield i

si = SillyIter()
for i in si:
    print(i)
```

{{< output >}}
```nb-output
1
2
3
4
5
```
{{< /output >}}

A generator expression is similar to a list comprehension.

```Groovy
%%python
squares = (number**2 for number in numbers if number % 2 == 0)
print(next(squares))
```

{{< output >}}
```nb-output
100
```
{{< /output >}}

We’ve actually already met several iterators in disguise; in particular, `enumerate` is an iterator. To drive home the point, here’s a simple reimplementation of enumerate:

```Groovy
%%python
class my_enumerate:
    def __init__(self, some_iter):
        self.some_iter = iter(some_iter)
        self.count = -1
    def __iter__(self):
        return self
    def __next__(self):
        val = self.some_iter.__next__()
        self.count += 1
        return self.count, val
    
for n, val in my_enumerate(['a', 'b', 'c']):
    print(n, val)
```

{{< output >}}
```nb-output
0 a
1 b
2 c
```
{{< /output >}}

Generators are a Python implementation of coroutines. Essentially, they’re functions that let you suspend execution and return a result:

```Groovy
%%python
def g():
    for i in range(0, 5):
        yield i**2
for i in g():
    print(i)
```

{{< output >}}
```nb-output
0
1
4
9
16
```
{{< /output >}}

### Tuple (JVM, Groovy, Py)

* [groovy tuples](https://mrhaki.blogspot.com/2016/03/groovy-goodness-using-tuples.html)
* [tuples in js](https://oli.me.uk/tuples-in-javascript/)

```Groovy
%%python
#tuple unpacking
a = 'Spam'
b = 'Eggs'
print(a, b)
a, b = b, a
print(a, b)
```

{{< output >}}
```nb-output
Spam Eggs
Eggs Spam
```
{{< /output >}}



### Other collections

The Python collections library is great.

```Groovy
%%python
from collections import Counter
from random import randrange
import pprint
mycounter = Counter()
for i in range(100):
    random_number = randrange(10)
    mycounter[random_number] += 1
for i in range(10):
    print(i, mycounter[i])
```

{{< output >}}
```nb-output
0 12
1 10
2 13
3 8
4 12
5 7
6 7
7 14
8 8
9 9
```
{{< /output >}}

## Data Types with Classes

With a protocol, Python agrees to respect anything that supports a particular set of methods as if it were a builtin type. (These protocols appear everywhere in Python; we are taking advantage of the mapping and sequence protocols below, to define `__getitem__` and `__len__`, respectively.)

```Groovy
%%python
class Binner:
    def __init__(self, binwidth, binmax):
        self.binwidth, self.binmax = binwidth, binmax
        nbins = int(binmax / float(binwidth) + 1)
        self.bins = [0] * nbins
    def add(self, value):
        bin = value / self.binwidth
        self.bins[bin] += 1
    def __getitem__(self, index):
        return self.bins[index]
    def __len__(self):
        return len(self.bins)

binner = Binner(5, 20)
for i in range(0, 20):
    binner.add(i)
for i in range(0, len(binner)):
    print( i, binner[i] )
```


{{< output >}}
```nb-output
---------------------------------------------------------------------------
```
{{< /output >}}

{{< output >}}
```nb-output
TypeError                                 Traceback (most recent call last)
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-32-c3e2c25ca8fa> in <module>()
     14 binner = Binner(5, 20)
     15 for i in range(0, 20):
---> 16     binner.add(i)
     17 for i in range(0, len(binner)):
     18     print( i, binner[i] )
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-32-c3e2c25ca8fa> in add(self, value)
      6     def add(self, value):
      7         bin = value / self.binwidth
----> 8         self.bins[bin] += 1
      9     def __getitem__(self, index):
     10         return self.bins[index]
```
{{< /output >}}

{{< output >}}
```nb-output
TypeError: list indices must be integers or slices, not float
```
{{< /output >}}


```Groovy
%%python
#enums in python
class           Color : pass
class Red      (Color): pass
class Yellow   (Color): pass
class Blue     (Color): pass

class Toy: pass
myToy = Toy()
myToy.color = "blue"  # note we assign a string, not an enum
if myToy.color is Color:
    pass
else:
    print("My toy has no color!!!")    # produces:  My toy has no color!!!
 
myToy.color = Blue   # note we use an enum
print("myToy.color is", myToy.color.__name__)  # produces: myToy.color is Blue
print("myToy.color is", myToy.color)           # produces: myToy.color is <class '__main__.Blue'>
if myToy.color is Blue:
    myToy.color = Red
if myToy.color is Red:
    print("my toy is red")   # produces: my toy is red
else:
    print("I don't know what color my toy is.")
```

{{< output >}}
```nb-output
My toy has no color!!!
myToy.color is Blue
myToy.color is <class '__main__.Blue'>
my toy is red
```
{{< /output >}}

## IO Operations

* [groovy with java streams](http://eddelbuettel.net/groovy/groovy-io.html)

```Groovy
//`with` closes the file automatically
new File(baseDir,'haiku.txt').withWriter('utf-8') { writer ->
    writer.writeLine 'Hello World'
}
```

```Groovy
//But for such a simple example, using the << operator would have been enough:
new File(baseDir,'haiku.txt') << '''Hello World'''
```

```Groovy
new File(baseDir, 'haiku.txt').eachLine { line ->
    println line
}

//collect the lines of a text file into a list, you can do:
def list = new File(baseDir, 'haiku.txt').collect {it}
```

```Groovy
//output stream
new File(baseDir,'data.bin').withOutputStream { stream ->
    // do something ...
}

//withInputStream idiom that will take care of closing file connection:
new File(baseDir,'haiku.txt').withInputStream { stream ->
    // do something ...
}
```

```Groovy
boolean b = true
String message = 'Hello from Groovy'
// Serialize data into a file
file.withDataOutputStream { out ->
    out.writeBoolean(b)
    out.writeUTF(message)
}
// ...
// Then read it back
file.withDataInputStream { input ->
    assert input.readBoolean() == b
    assert input.readUTF() == message
}
```

```Groovy
//find files that match the regex, or just use `.eachFile` for each file, or `eachFileRecurse` to search deeper into subdirectories
dir.eachFileMatch(~/.*\.txt/) { file ->     
    println file.name
}
```

```Groovy
//execute external process
def process = "ls -l".execute()             
println "Found text ${process.text}"   
```

Python display directory tree, open files, and execute sub processes.

```Groovy
%%python
import os
os.listdir(path)
```

```Groovy
%%python
file = open("testfile.txt","w") 
file.write("Hello World") 
file.close() 

with open("testfile.txt", "r") as f:
    data = f.readlines()
    
for line in data:
    words = line.split()
    print( words )
```

{{< output >}}
```nb-output
['Hello', 'World']
```
{{< /output >}}

```Groovy
%%python
import subprocess
output = subprocess.check_output('head', shell=True)
print(output)
```

{{< output >}}
```nb-output
b''
```
{{< /output >}}

## Random useful bits

```Groovy
%%python
assert False, "you can't do that here!"
```


{{< output >}}
```nb-output
---------------------------------------------------------------------------
```
{{< /output >}}

{{< output >}}
```nb-output
AssertionError                            Traceback (most recent call last)
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-44-1335db417df4> in <module>()
----> 1 assert False, "you can't do that here!"
```
{{< /output >}}

{{< output >}}
```nb-output
AssertionError: you can't do that here!
```
{{< /output >}}


```Groovy
%%python
#Worried that you’re getting an empty list? 
x = []
assert len(x)
```


{{< output >}}
```nb-output
---------------------------------------------------------------------------
```
{{< /output >}}

{{< output >}}
```nb-output
AssertionError                            Traceback (most recent call last)
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-43-6aa249c95d4b> in <module>()
      1 #Worried that you’re getting an empty list?
      2 x = []
----> 3 assert len(x)
```
{{< /output >}}

{{< output >}}
```nb-output
AssertionError: 
```
{{< /output >}}


```Groovy
%%python
#any and all
x = [ True, False ]
print( any(x))
print( all(x))
```

{{< output >}}
```nb-output
True
False
```
{{< /output >}}

```Groovy
%%python
#Here, *args assigns all of the positional arguments to a tuple ‘args’, and ‘**kwargs’ assigns all of the keyword arguments to a dictionary ‘kwargs’:
def print_me(*args, **kwargs):
    print_me(5, 6, 7, test='me', arg2=None)
#When a function is called with this notation, the args and kwargs are unpacked appropriately and passed into the function. For example, the function test_call
#can be called with a tuple of three args (matching ‘a’, ‘b’, ‘c’):
def test_call(a, b, c, x=1, y=2, z=3): print( a, b, c, x, y, z)
tuple_in = (5, 6, 7)
test_call(*tuple_in)
```

{{< output >}}
```nb-output
5 6 7 1 2 3
```
{{< /output >}}

```Groovy
%%python
#catch exceptions
x=[0,2,4,6]
try:
    y = x[10]
except IndexError:
    y = None
y
```

```Groovy
%%python
#The purpose of try/finally is to ensure that something is done, whether or not an exception is raised:
x = [0, 1, 2]
try:
    y = x[5]
finally:
    x.append('something')
    print( x)
```

{{< output >}}
```nb-output
[0, 1, 2, 'something']
```
{{< /output >}}


{{< output >}}
```nb-output
---------------------------------------------------------------------------
```
{{< /output >}}

{{< output >}}
```nb-output
IndexError                                Traceback (most recent call last)
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-54-07bd9b959038> in <module>()
      2 x = [0, 1, 2]
      3 try:
----> 4     y = x[5]
      5 finally:
      6     x.append('something')
```
{{< /output >}}

{{< output >}}
```nb-output
IndexError: list index out of range
```
{{< /output >}}


```Groovy
%%python
#semantically equivalent to this
#but it’s a bit cleaner, because the exception doesn’t have to be re-raised and you don’t have to catch a specific exception type
try:
    y = x[5]
except IndexError:
    x.append('something')
    raise
```


{{< output >}}
```nb-output
---------------------------------------------------------------------------
```
{{< /output >}}

{{< output >}}
```nb-output
IndexError                                Traceback (most recent call last)
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-55-c1a571ecce91> in <module>()
      2 #but it’s a bit cleaner, because the exception doesn’t have to be re-raised and you don’t have to catch a specific exception type
      3 try:
----> 4     y = x[5]
      5 except IndexError:
      6     x.append('something')
```
{{< /output >}}

{{< output >}}
```nb-output
IndexError: list index out of range
```
{{< /output >}}


```Groovy
%%python
x
```




{{< output >}}
```nb-output
[0, 1, 2, 'something', 'something']
```
{{< /output >}}



```Groovy
%%python
#Exceptions are just classes that derive from Exception, and you can catch exceptions based on their base classes. So, for example, you can catch most standard errors by catching the StandardError exception, from which e.g. IndexError inherits:
print issubclass(IndexError, StandardError)
try:
    y = x[10]
except StandardError:
    print( 'CAUGHT EXCEPTION!', str(e))
    y = None
```

```Groovy
%%python
#define your own exceptions and exception hierarchies:
class MyFavoriteException(Exception):
    pass
raise MyFavoriteException
```


{{< output >}}
```nb-output
  File "<ipython-input-57-4b118fdb119a>", line 2
    print issubclass(IndexError, StandardError)
                   ^
SyntaxError: invalid syntax
```
{{< /output >}}


```Groovy
%%python
#function decorators are functions that take functions as arguments, and return other functions. 
def my_decorator(fn):
    def new_fn(*args, **kwargs):
        if 'something' in kwargs:
            print( 'REMOVING', kwargs['something'])
            del kwargs['something']
        return fn(*args, **kwargs)
    return new_fn
#To apply this decorator, use this funny @ syntax:
@my_decorator
def some_function(a=5, b=6, something=None, c=7):
    print( a, b, something, c)
#OK, now some_function has been invisibly replaced with the result of my_decorator, which is going to be new_fn. Let’s see the result:
some_function(something='MADE IT')
```

{{< output >}}
```nb-output
REMOVING MADE IT
5 6 None 7
```
{{< /output >}}

```Groovy
%%python
#add attributes to functions. (This is why I use them in my testing code sometimes.)
def attrs(**kwds):
    def decorate(f):
        for k in kwds:
            setattr(f, k, kwds[k])
        return f
    return decorate

@attrs(versionadded="2.2", author="Guido van Rossum")
def mymethod(f):
    pass
print( mymethod.versionadded)
print( mymethod.author)
```

{{< output >}}
```nb-output
2.2
Guido van Rossum
```
{{< /output >}}

```Groovy
%%python
#memoize/caching of results
def simple_cache(fn):
    cache = {}
    def new_fn(n):
        if n in cache:
            print( 'FOUND IN CACHE; RETURNING')
            return cache[n]
        #otherwise, call function & record value
        val = fn(n)
        cache[n] = val
        return val
    return new_fn

#Then use this as a decorator to wrap the expensive function:
@simple_cache
def expensive(n):
    print( 'IN THE EXPENSIVE FN:', n)
    return n**2
#Now, when you call this function twice with the same argument, if will only do the calculation once; the second time, the function call will be intercepted and the cached value will be returned.
expensive(55)
expensive(55)
```

{{< output >}}
```nb-output
IN THE EXPENSIVE FN: 55
FOUND IN CACHE; RETURNING
```
{{< /output >}}




{{< output >}}
```nb-output
3025
```
{{< /output >}}



## References

* [docs: groovy](https://groovy-lang.org/groovy-dev-kit.html#Collections-Maps)
* [python idioms](https://intermediate-and-advanced-software-carpentry.readthedocs.io/en/latest/index.html)
