+++
author = "Jason Beach"
categories = ["Programming", "DataScience"]
date = "2019-06-20"
tags = ["groovy", "jvm", "data_visualization"]
title = "Introduction to Groovy for Data Science on the JVM"

+++


Groovy is a scripting language that compiles to the Java Virtual Machine.  It would be more-aptly named _JavaScript_ if that name were not already taken, but it has many similarities to Python.  In fact, some of the libraries implemented for Groovy, such as [TableSaw](https://jtablesaw.github.io/tablesaw/), attempt to take it in the same _Data Science_ direction as Python.

This post will provide an introduction to the Groovy language using Jupyter notebook with BeakerX, and provides specific applications to Data Science.  It begins with a tour of the Groovy language, then describes some of the most interesting features that the language provides.  We give a comparison to Java with some notes for making integration with Java environments easier.  We finish-off with applications and examples in Data Science. 

This notebook takes code and examples from this github repo: [https://github.com/twosigma/beakerx](https://github.com/twosigma/beakerx)

## Getting Started

You can get started with Groovy in a few different ways.  After installing Groovy, the console (comes with Groovy distribution) is a Java Swing application where we can write and run code, interactively.
```
\\( groovyconsole
```

Or you can run a script, directly.
```
\\) groovy your-script.groovy
```

In this post we will use Jupyter with the [BeakerX JVM kernel](https://github.com/twosigma/beakerx).  BeakerX provides a variety of languages and support transforming data structures among them.  This makes it ideal for learning and prototyping.  You can get started with BeakerX using Docker.
```
$ docker run -p 8888:8888 beakerx/beakerx
```

## Introduction

### Basic syntax

We provide the obligatory _hello world_ example using a simple println statement to print output to the console.

```Groovy
class Example {
   static void main(String[] args) {
      println('Hello World');
   }
}
Example.main()
```

{{< output >}}
```nb-output
Hello World
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



By default, Groovy includes the following libraries in your code, so you don’t need to explicitly import them.

```Groovy
import java.lang.* 
import java.util.* 
import java.io.* 
import java.net.* 

import groovy.lang.* 
import groovy.util.* 

import java.math.BigInteger 
import java.math.BigDecimal
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



Groovy supports all Java types (primitive and reference types).

All primitive types are auto-converted to their wrapper types. So `int a = 2` will become `Integer a = 2`

When declaring variables we can do one of the followings:

* Do not use any type (that will create a global variable): `a = 2`
* Use keyword def (that will create a local variable): `def a = 2`
* Use the actual type (that will create a local variable of strict type Integer): `int a = 3`

When no type is used, variables act like they are of type Object, so they can be reassigned to different types.

```Groovy
a = 2
printf "%s - %s%n", a.getClass().getName(), a
a = "apple"
printf "%s - %s%n", a.getClass().getName(), a
```

{{< output >}}
```nb-output
java.lang.Integer - 2
java.lang.String - apple
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



### Running the code

The code outside methods but still in a script is copied to at run to an object method.  So during runtime everything is inside methods. In that sense, this feature allows the variables declared in a method to be accessible to other methods.

Groovy keeps these global variables in a map like object (`groovy.lang.Binding`).

When def is used, variables act like they are of type Object, so they can be reassigned to different types (same as when no type is used): 

```Groovy
//';' should be used after each statement, but is not necessary in beakerx cells
//def is a keyword used in Groovy to define an identifier
def c = 1;    //local variable
d = 2;        //global variable - var with no type are global so they can be accessed across methods
```




{{< output >}}
```nb-output
2
```
{{< /output >}}



```Groovy
c //error - var declared with def are local, so they cannot be accessed across methods
```


{{< output >}}
```nb-output
groovy.lang.MissingPropertyException: No such property: c for class: script1561051888331
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
d //this works
```




{{< output >}}
```nb-output
2
```
{{< /output >}}



### Data types

Using actual types (same as Java types).  They follow strict typing rules (just like Java). So they cannot be reassigned to different types:

```Groovy
int a = 2
println a
a = "apple"
println a
```

{{< output >}}
```nb-output
2
```
{{< /output >}}


{{< output >}}
```nb-output
org.codehaus.groovy.runtime.typehandling.GroovyCastException: Cannot cast object 'apple' with class 'java.lang.String' to class 'int'
```
{{< /output >}}

{{< output >}}
```nb-output
	at this cell line 3
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


Like `def` variables they are also local, so they cannot be accessed across methods.

```Groovy
int e = 2
void printVars() {
    println e;
}
printVars();
```


{{< output >}}
```nb-output
groovy.lang.MissingPropertyException: No such property: e for class: script1561051968611
```
{{< /output >}}

{{< output >}}
```nb-output
	at script1561051968611.printVars(script1561051968611:4)
```
{{< /output >}}

{{< output >}}
```nb-output
	at this cell line 7
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
//remove variables
binding.variables.remove 'a'
binding.variables.remove 'b' 
binding.variables.remove 'c' 
binding.variables.remove 'd' 
binding.variables.remove 'e'
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



As seen above, Groovy uses Objects for everything (int is printed as java.lang.Integer). Primitives are auto-converted to their wrapper type.

```Groovy
int a = 2
printf("%s - %s%n", a.getClass(), a.getClass().isPrimitive())

def b = 2
printf "%s - %s%n", b.getClass(), b.getClass().isPrimitive()

c = 2
printf "%s - %s%n", c.getClass(), c.getClass().isPrimitive()

double d = 2.2
printf "%s - %s%n", d.getClass(), d.getClass().isPrimitive()

e = 2.3//no type
printf "%s - %s%n", e.getClass(), e.getClass().isPrimitive()
```

{{< output >}}
```nb-output
class java.lang.Integer - false
class java.lang.Integer - false
class java.lang.Integer - false
class java.lang.Double - false
class java.math.BigDecimal - false
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



All of the variables are initialized (even local) with their default values (just like instance variable).

```Groovy
def a //initialized with null
println a

String s //initialized with null
println s

int b//initialized with 0
println b
println b + 3

boolean bool//initialized with false
println bool
```

{{< output >}}
```nb-output
null
null
0
3
false
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



Using actual types.

```Groovy
int sum(int x, int y) {
    x + y;
}
println sum(1, 3)
```

{{< output >}}
```nb-output
4
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



Using `def`.

```Groovy
def sum(def x, def y) {
    x + y;
}
println sum(1, 3)
```

{{< output >}}
```nb-output
4
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



Using no types with parameters.

```Groovy
def sum(x, y) {
    x + y;
}
println sum(1, 3)
```

{{< output >}}
```nb-output
4
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



Methods must return def or actual type.

```Groovy
sum(x, y) {
    x + y;
}
println sum(1, 3)
```


{{< output >}}
```nb-output
groovy.lang.MissingPropertyException: No such property: x for class: script1561052241554
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
class Example { 
   static void main(String[] args) { 
      //Example of a int datatype 
      int x = 5; 
		
      //Example of a long datatype 
      long y = 100L; 
		
      //Example of a floating point datatype 
      float a = 10.56f; 
		
      //Example of a double datatype 
      double b = 10.5e40; 
		
      //Example of a BigInteger datatype 
      BigInteger bi = 30g; 
		
      //Example of a BigDecimal datatype 
      BigDecimal bd = 3.5g; 
		
      println(x); 
      println(y); 
      println(a); 
      println(b); 
      println(bi); 
      println(bd); 
   } 
}
Example.main()
```

{{< output >}}
```nb-output
5
100
10.56
1.05E41
30
3.5
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



## Features

Groovy has many different features.  We have seen a few of these, earlier, but the others are mentioned, here.

* Support for both static and dynamic typing
* Support for operator overloading
* Native syntax for lists and associative arrays
* Native support for regular expressions
* Native support for various markup languages such as XML and HTML.
* Similar syntax to Java
* Use of existing Java libraries
* Extends the java.lang.Object

### Support for regular expressions

```Groovy
def m = "Groovy is groovy" =~ /(G|g)roovy/
println m[0][0] // The first whole match (i.e. the first word Groovy)
println m[0][1] // The first group in the first match (i.e. G)
println m[1][0] // The second whole match (i.e. the word groovy)
println m[1][1] // The first group in the second match (i.e. g)
```

{{< output >}}
```nb-output
Groovy
G
groovy
g
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



### Support for markup languages

One of the most used classes for creating HTML or XML markup.

```Groovy
import groovy.xml.MarkupBuilder 
def xml = new MarkupBuilder() 
```




{{< output >}}
```nb-output
groovy.xml.MarkupBuilder@7500ce0e
```
{{< /output >}}



### Liberal use of closures

```Groovy
//closure example
timesTwo = {x -> x*2}
```




{{< output >}}
```nb-output
script1556559307332$_run_closure1@cad3663
```
{{< /output >}}



```Groovy
timesTwo(4)
```




{{< output >}}
```nb-output
8
```
{{< /output >}}



```Groovy
timesTwo("Multiplying Strings!")
```




{{< output >}}
```nb-output
Multiplying Strings!Multiplying Strings!
```
{{< /output >}}



```Groovy
sin(3.1415)
```




{{< output >}}
```nb-output
9.265358966049026E-5
```
{{< /output >}}



## Comparison of Groovy with Java

### Basic differences

* automatically a wrapping a class called Script for every program
* default access specifier is public
* getters and setters are automatically generated for class members 
* abbreviated commands, such as `println`
* semicolons `;` and paraentheses `()` are optional
* dynamic typing with the `def <var>` keyword (locar var), or with no prefix `<var>` (global var)
* string interpolation (GString) is performed with `\\(` operator, such as `"Hello, \\){firstName[0]}. $name"`
* """multi-line strings are also allowed"""
* implicit truthy `if(100)` because 100 exists

### New operators

* conditional operators
  - __safe navigation__`?` operator checks for properties, such as `if(company.getContact()?.getAddress()?.getCountry() == Country.NEW_ZEALAND) { ... }` means If the contact or the address are null, the result of the left side will just be null, but no exception will be thrown.
  - __ternary / elvis__ `?` operator `def name = client.getName() ?: ""` will assign client.getName() if it isn’t false and the empty string, otherwise

* type operators
  - __spaceship__ `<=>` delegates to the compareTo() method: `def x = 1 <=> 2; println x; // calls Integer.compareTo`
  - __identity__ `is()` tests object reference equality, while `==` checks equality with `.equals()`
  - __coercion__ `as` converts an object from one type to another (using `.asType()`), without assignment compatibility, which is different from casting: `String s = "1.1"; BigDecimal bd = s as BigDecimal; println bd.class.name`

### Using methods

* a function used in a script will be compiled to a method within an object
* `return` keyword is optional
* method operators
  - __method pointer__ `.&` stores a reference to a method in a variable: `def power = Math.&pow; def result = power(2, 4);`
  - __call operator__ `()` an object with a call method can be called directly: `class A{def call(println("hi"){}}; def a = new A(); a();`
* closures 
  - like Java8 lambdas
  - anonymous first-class functions are often called lambda functions
  - `def power = { int x, int y -> return Math.pow(x, y) }; println power(2, 3)`
* currying 
* memoization

### Collections: list and map

* list and map operators
  - __subscript__ `[]` allows to read/write to collections and maps: `def list = [2, 4]; println list[0]; def map = [x: 2, y: 4]; println map['x']`
  - __membership__ `in` test whether value is in the target collection: `def numbers = [2,4,6,8]; println 2 in numbers`
  - __spread-dot__ `*.` invokes an action on all items of an aggregate object: `def lists = [[1], [10, 20, 30], [6, 8]]; def sizes = lists*.size(); //[1, 3, 2]`
  __range__ `..` to create ranges of objects: `def numbers = 1..5; println numbers`
* create an ArrayList with the given numbers: `def list = [1,1,2,3,5]`
* closures make it easy to iterate, filter and transform lists
  - iterate a list using a passed closure executed once for each element, implicitly passed, as a parameter to the closure: `list.each { println it }`
  - filter a list: `list.findAll { it % 2 == 0 }`
  - transform a list: `list.collect { it * it }`
  - improve: `["Hello", "World"].collect { it.toUpperCase() }` using the spread-dot: `["Hello", "World"]*.toUpperCase()`
  - Collection (and Iterable) interfaces provide some more methods, like `any` or `every`
* maps act similar to lists
  ```
  def key = 'Key3'
  def aMap = [
    'Key1': 'Value 1', // Put key1 -> Value 1 to the map
    Key2: 'Value 2', // You can also skip the quotes, the key will automatically be a String
    (key): 'Another value' // If you want the key to be the value of a variable, you need to put it in parantheses
  ]
  ```

## Applications in Data Science

### Dataframes with Tablesaw

[Tablesaw](https://tablesaw.tech/) is easy to add to the BeakerX Groovy kernel.
Tablesaw provides the ability to easily transform, summarize, and filter data, as well as computing descriptive statistics and fundamental machine learning algorithms.

Two helpful demo notebooks (scala) include:
* [Recommnder System](https://github.com/IMTorgDemo/IMTorgDemo-Notebooks/blob/master/demo_RS-WhitehawkRecommendSystem.ipynb)
* [Evolution to a Data-Driven System](https://github.com/IMTorgDemo/IMTorgDemo-Notebooks/blob/master/demo_RS-WhitehawkEvolutionDataDriven.ipynb)

Add using `mvn`.

```Groovy
%%classpath add mvn
tech.tablesaw tablesaw-plot 0.11.4
tech.tablesaw tablesaw-smile 0.11.4
tech.tablesaw tablesaw-beakerx 0.11.4
```





```Groovy
%import tech.tablesaw.aggregate.*
%import tech.tablesaw.api.*
%import tech.tablesaw.api.ml.clustering.*
%import tech.tablesaw.api.ml.regression.*
%import tech.tablesaw.columns.*

// display Tablesaw tables with BeakerX table display widget
tech.tablesaw.beakerx.TablesawDisplayer.register()
```




{{< output >}}
```nb-output
null
```
{{< /output >}}



Read .csv data.

```Groovy
tornadoes = Table.read().csv("../doc/resources/data/tornadoes_2014.csv")
```



Print the dataset structure.

```Groovy
tornadoes.structure()
```



Get header names.

```Groovy
tornadoes.columnNames()
```




{{< output >}}
```nb-output
[Date, Time, State, State No, Scale, Injuries, Fatalities, Start Lat, Start Lon, Length, Width]
```
{{< /output >}}



Displays the row and column counts.

```Groovy
tornadoes.shape()
```




{{< output >}}
```nb-output
908 rows X 11 cols
```
{{< /output >}}



Displays the first n rows.

```Groovy
tornadoes.first(3)
```



```Groovy
import static tech.tablesaw.api.QueryHelper.column
tornadoes.structure().selectWhere(column("Column Type").isEqualTo("FLOAT"))
```



Summarize the data in each column.

```Groovy
tornadoes.summary()
```




{{< output >}}
```nb-output

Table summary for: tornadoes_2014.csv
       Column: Date        
 Measure   |    Value     |
---------------------------
    Count  |         908  |
  Missing  |           0  |
 Earliest  |  2014-01-11  |
   Latest  |  2014-12-29  |
     Column: Time     
 Measure   |  Value  |
----------------------
    Count  |    908  |
  Missing  |      0  |
 Earliest  |  00:01  |
   Latest  |  23:59  |
    Column: State     
 Category  |  Count  |
----------------------
       GA  |     32  |
       NM  |     15  |
       MT  |      8  |
       CO  |     49  |
       WV  |      9  |
       IN  |     28  |
       MD  |      2  |
       CA  |      9  |
       AL  |     55  |
       TN  |     18  |
      ...  |    ...  |
       MO  |     47  |
       ME  |      4  |
       LA  |     15  |
       MI  |     13  |
       SC  |      7  |
       KY  |     28  |
       MA  |      3  |
       CT  |      1  |
       NH  |      2  |
   Column: State No   
 Measure   |  Value  |
----------------------
        n  |  908.0  |
      sum  |    0.0  |
     Mean  |    0.0  |
      Min  |    0.0  |
      Max  |    0.0  |
    Range  |    0.0  |
 Variance  |    0.0  |
 Std. Dev  |    0.0  |
       Column: Scale       
 Measure   |    Value     |
---------------------------
        n  |       908.0  |
      sum  |       567.0  |
     Mean  |   0.6244493  |
      Min  |         0.0  |
      Max  |         4.0  |
    Range  |         4.0  |
 Variance  |   0.6272737  |
 Std. Dev  |  0.79200613  |
     Column: Injuries      
 Measure   |    Value     |
---------------------------
        n  |       908.0  |
      sum  |       684.0  |
     Mean  |  0.75330395  |
      Min  |         0.0  |
      Max  |       193.0  |
    Range  |       193.0  |
 Variance  |    57.68108  |
 Std. Dev  |    7.594806  |
     Column: Fatalities     
 Measure   |     Value     |
----------------------------
        n  |        908.0  |
      sum  |         48.0  |
     Mean  |  0.052863438  |
      Min  |          0.0  |
      Max  |         16.0  |
    Range  |         16.0  |
 Variance  |   0.44262686  |
 Std. Dev  |    0.6653021  |
    Column: Start Lat     
 Measure   |    Value    |
--------------------------
        n  |      908.0  |
      sum  |  34690.984  |
     Mean  |   38.20593  |
      Min  |        0.0  |
      Max  |      48.86  |
    Range  |      48.86  |
 Variance  |  22.448586  |
 Std. Dev  |  4.7379937  |
    Column: Start Lon     
 Measure   |    Value    |
--------------------------
        n  |      908.0  |
      sum  |  -83613.02  |
     Mean  |  -92.08483  |
      Min  |   -122.946  |
      Max  |        0.0  |
    Range  |    122.946  |
 Variance  |   91.84773  |
 Std. Dev  |   9.583722  |
      Column: Length      
 Measure   |    Value    |
--------------------------
        n  |      908.0  |
      sum  |    3014.49  |
     Mean  |   3.319923  |
      Min  |        0.0  |
      Max  |      45.68  |
    Range  |      45.68  |
 Variance  |  28.736567  |
 Std. Dev  |  5.3606496  |
      Column: Width       
 Measure   |    Value    |
--------------------------
        n  |      908.0  |
      sum  |   149778.0  |
     Mean  |  164.95375  |
      Min  |        0.0  |
      Max  |     2640.0  |
    Range  |     2640.0  |
 Variance  |  57764.465  |
 Std. Dev  |  240.34239  |

```
{{< /output >}}



Mapping operations.

```Groovy
def month = tornadoes.dateColumn("Date").month()
tornadoes.addColumn(month);
tornadoes.columnNames()
```




{{< output >}}
```nb-output
[Date, Time, State, State No, Scale, Injuries, Fatalities, Start Lat, Start Lon, Length, Width, Date month]
```
{{< /output >}}



Sorting by column.

```Groovy
tornadoes.sortOn("-Fatalities")
```



Descriptive statistics.

```Groovy
tornadoes.column("Fatalities").summary()
```



Performing totals and sub-totals.

```Groovy
def injuriesByScale = tornadoes.median("Injuries").by("Scale")
injuriesByScale.setName("Median injuries by Tornado Scale")
injuriesByScale
```



Cross tabulation.

```Groovy
CrossTab.xCount(tornadoes, tornadoes.categoryColumn("State"), tornadoes.shortColumn("Scale"))
```



### Example with Tablesaw

You can fetch data from [Quandl](https://www.quandl.com/) and load it directly into Tablesaw

```Groovy
%classpath add mvn com.jimmoores quandl-tablesaw 2.0.0
%import com.jimmoores.quandl.*
%import com.jimmoores.quandl.tablesaw.*
```





```Groovy
TableSawQuandlSession session = TableSawQuandlSession.create();
Table table = session.getDataSet(DataSetRequest.Builder.of("WIKI/AAPL").build());
```

```Groovy
// Create a new column containing the year
ShortColumn yearColumn = table.dateColumn("Date").year();
yearColumn.setName("Year");
table.addColumn(yearColumn);
// Create max, min and total volume tables aggregated by year
Table summaryMax = table.groupBy("year").max("Adj. Close");
Table summaryMin = table.groupBy("year").min("Adj. Close");
Table summaryVolume = table.groupBy("year")sum("Volume");
// Create a new table from each of these
summary = Table.create("Summary", summaryMax.column(0), summaryMax.column(1), 
                       summaryMin.column(1), summaryVolume.column(1));
// Add back a DateColumn to the summary...will be used for plotting
DateColumn yearDates = new DateColumn("YearDate");
for(year in summary.column('Year')){
    yearDates.append(java.time.LocalDate.of(year,1,1));
}
summary.addColumn(yearDates)

summary
```

```Groovy
years = summary.column('YearDate').collect()

plot = new TimePlot(title: 'Price Chart for AAPL', xLabel: 'Time', yLabel: 'Max [Adj. Close]')
plot << new YAxis(label: 'Volume')
plot << new Points(x: years, y: summary.column('Max [Adj. Close]').collect())
plot << new Line(x: years, y: summary.column('Max [Adj. Close]').collect(), color: Color.blue)
plot << new Stems(x: years, y: summary.column('Sum [Volume]').collect(), yAxis: 'Volume')
```

### Auto-Translation in BeakerX

Auto-Translation is the act of converting a data structure in one language to another.  In the context of data science, the obvious data structures are lists and data frames.

```Groovy
//start with groovy
beakerx.foo = "a groovy value"
```




{{< output >}}
```nb-output
a groovy value
```
{{< /output >}}



```Groovy
//to javascript
%%javascript
beakerx.bar = [23, 48, 7, "from JS"];
beakerx.foo
```

```Groovy
//back to groovy
beakerx.bar 
```

```Groovy
//to python
%%python
from beakerx import beakerx
beakerx.foo
```




{{< output >}}
```nb-output
'a groovy value'
```
{{< /output >}}



```Groovy
//to scala
%%scala
beakerx.foo
```




{{< output >}}
```nb-output
a groovy value
```
{{< /output >}}



### Graphing with BeakerX

Both BeakerX and Tablesaw do a good job of addressing the need to visualize data. 

```Groovy
rates = new CSV().read("../doc/resources/data/interest-rates.csv")
def f = new java.text.SimpleDateFormat("yyyy MM dd")
lehmanDate = f.parse("2008 09 15")
bubbleBottomDate = f.parse("2002 10 09")
inversion1 = [f.parse("2000 07 22"), f.parse("2001 02 16")]
inversion2 = [f.parse("2006 08 01"), f.parse("2007 06 07")]
def size = rates.size()
(0 ..< size).each{row = rates[it]; row.spread = row.y10 - row.m3}

OutputCell.HIDDEN
```

```Groovy
// The simplest chart function with all defaults:
new SimpleTimePlot(rates, ["y1", "y10"])
```



```Groovy
//scatter plot
def c = new Color(120, 120, 120, 100)
new Plot() << new Points(x: rates.y1, y: rates.y30, displayName: "y1 vs y30") \
           << new Points(x: rates.m3, y: rates.y5, displayName: "m3 vs y5") \
           << new Line(x: rates.m3, y: rates.y5, color: c) \
           << new Line(x: rates.y1, y: rates.y30, color: c)
```



```Groovy
def ch = new Crosshair(color: Color.gray, width: 2, style: StrokeType.DOT)

// The top plot has 2 lines.
p1 = new TimePlot(yLabel: "Interest Rate", crosshair: ch)
p1 << new Line(x: rates.time, y: rates.m3, displayName: "3 month")
p1 << new Line(x: rates.time, y: rates.y10, displayName: "10 year")

// The bottom plot has an area filled in.
p2 = new TimePlot(yLabel: "Spread", crosshair: ch)
p2 << new Area(x: rates.time, y: rates.spread, color: new Color(120, 60, 0))

// Highlight the inversion intervals
def b1 = new ConstantBand(x: inversion1, color: new Color(240, 100, 100, 55))
def b2 = new ConstantBand(x: inversion2, color: new Color(240, 100, 100, 55))

// Add notation and line for Lehman Bankruptcy.
p1 << new Text(x: lehmanDate, y: 7.5, text: "Lehman Brothers Bankruptcy")
def l1 = new ConstantLine(x: lehmanDate, style: StrokeType.DOT, color: Color.gray)

// Add notation and line for Stocks Nadir.
p1 << new Text(x: bubbleBottomDate, y: 5.75, text: "Stocks Hit Bottom")
def l2 = new ConstantLine(x: bubbleBottomDate, style: StrokeType.DOT, color: Color.gray)

// add the notations and highlight bands to both plots
p1 << l1 << l2 << b1 << b2
p2 << l1 << l2 << b1 << b2

OutputCell.HIDDEN
```

```Groovy
// Then use a CombinedPlot to get stacked plots with linked X axis.
def c = new CombinedPlot(title: "US Treasuries", initWidth: 1000)

// add both plots to the combined plot, and including their relative heights.
c.add(p1, 3)
c.add(p2, 1)
```



### Integration with D3js

Being able to prototype for the frontend is key for deliverying quickly.  The BeakerX integration with D3js is great for this.

```Groovy
def r = new Random()
def nnodes = 100
def nodes = []
def links = []

for (x in (0..nnodes)){
  nodes.add(name:"" + x, group:((int) x*7/nnodes))
}

for (x in (0..(int) nnodes*1.15)) { 
  source = x % nnodes
  target = ((int) log(1 + r.nextInt(nnodes))/log(1.3))
  value = 10.0 / (1 + abs(source - target))
  links.add(source: source, target: target, value: value*value)
}

beakerx.graph = [nodes: nodes, links: links]
OutputCell.HIDDEN
```

```javascript
%%javascript
require.config({
  paths: {
      d3: '//cdnjs.cloudflare.com/ajax/libs/d3/4.9.1/d3.min'
  }});
```






```Groovy
%%html
<style>
.node {
  stroke: #fff;
  stroke-width: 1.5px;
}

.link {
  stroke: #999;
  stroke-opacity: .6;
}
</style>
```




<html><style>
.node {
  stroke: #fff;
  stroke-width: 1.5px;
}

.link {
  stroke: #999;
  stroke-opacity: .6;
}
</style></html>



```javascript
%%javascript

beakerx.displayHTML(this, '<div id="fdg"></div>');

var graph = beakerx.graph

var d3 = require(['d3'], function (d3) {
    
    var width = 600,
        height = 500;

    var color = d3.scaleOrdinal(d3.schemeCategory20);

    var simulation = d3.forceSimulation()
        .force("link", d3.forceLink().distance(30))
        .force("charge", d3.forceManyBody().strength(-200))
        .force("center", d3.forceCenter(width / 2, height / 2))
        .force("y", d3.forceY(width / 2).strength(0.3))
        .force("x", d3.forceX(height / 2).strength(0.3));

    var svg = d3.select("#fdg")
                .append("svg")
                .attr("width", width)
                .attr("height", height)
                .attr("transform", "translate("+[100, 0]+")");

    simulation
          .nodes(graph.nodes)
          .force("link")
          .links(graph.links);

    var link = svg.selectAll(".link")
          .data(graph.links)
          .enter().append("line")
          .attr("class", "link")
          .style("stroke-width", function(d) { return Math.sqrt(d.value); });

    var node = svg.selectAll(".node")
          .data(graph.nodes)
          .enter().append("circle")
          .attr("class", "node")
          .attr("r", 10)
          .style("fill", function(d) { return color(d.group); });

    node.append("title")
          .text(function(d) { return d.name; });

    simulation.on("tick", function() {
        link.attr("x1", function(d) { return d.source.x; })
            .attr("y1", function(d) { return d.source.y; })
            .attr("x2", function(d) { return d.target.x; })
            .attr("y2", function(d) { return d.target.y; });

        node.attr("cx", function(d) { return d.x; })
            .attr("cy", function(d) { return d.y; });
    });
    
    node.call(d3.drag()
        .on("start", dragstarted)
        .on("drag", dragged)
        .on("end", dragended)
    );
    
    function dragstarted(d) {
        if (!d3.event.active) simulation.alphaTarget(0.3).restart();
        d.fx = d.x;
        d.fy = d.y;
    }

    function dragged(d) {
        d.fx = d3.event.x;
        d.fy = d3.event.y;
    }

    function dragended(d) {
        if (!d3.event.active) simulation.alphaTarget(0);
        d.fx = null;
        d.fy = null;
    }
});
```






## References

### Table of keywords

The following table lists the keywords which are defined in Groovy

|   |   |   |   |   |
|---|---|---|---|---|
| as |      assert |      break |        case |
| catch |	class  |     const 	|   continue |
| def | 	default |	do 	   |      else |
| enum |	extends |	false 	|     Finally |
| for |	goto 	|    if 	  |       implements |
| import |	in 	  |      instanceof |	 interface |
| new |	pull 	|    package |	 return |
| super |	switch 	  |  this 	  |   throw |
| throws |	trait 	|    true 	 |    try |
| while |			


Groovy but not Java:

|   |   |   |   |   |
|---|---|---|---|---|
| as  |  def  |  in  |  trait |


### Data types

Primitive data types
```
    byte − represent a byte value. An example is 2
    short − represent a short number. An example is 10
    int − represent whole numbers. An example is 1234
    long − represent a long number. An example is 10000090
    float − represent 32-bit floating point numbers. An example is 12.34
    double − represent 64-bit floating point numbers which are longer decimal numbers which may be required at times. An example is 12.3456565
    char − defines a single character literal. An example is ‘a’
    Boolean − represents a Boolean value which can either be true or false
    String − text literals which are represented in the form of chain of characters. For example “Hello World”.
```

In addition to the primitive types, the following object types (sometimes referred to as wrapper types) are allowed −
```
    java.lang.Byte
    java.lang.Short
    java.lang.Integer
    java.lang.Long
    java.lang.Float
    java.lang.Double
```
For arbitrary precision artithemetic
```
java.math.BigInteger
java.math.BigDecimal
```

### Online

* [official website and documentation](http://groovy-lang.org/documentation.html)
* [getting started with groovy in IntelliJ](https://www.jetbrains.com/help/idea/getting-started-with-groovy.html)
* [groovy for java developers](https://www.timroes.de/groovy-tutorial-for-java-developers)
* [groovy tutorial](https://www.guru99.com/groovy-tutorial.html)
* [detailed groovy tutorials](https://www.logicbig.com/tutorials/misc/groovy.html)
