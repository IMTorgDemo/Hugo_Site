
+++
title = "Solving Textual Problems with Regular Expressions"
date = "2019-05-19"
author = "Jason Beach"
categories = ["Process", "DataScience"]
tags = ["NLP", "RegEx"]
+++


Regular Expressions provide an important foundation for learning systems.  They are useful for quick and direct approaches to solving problems without creating mounds of training data, nor the infrastructure for deploying a model.  While they are a common programming technique, and simple enough to employ, they tend to be used so infrequently that you must re-learn them each time you wish to apply.    This post summarizes the basic regex syntax, strategies, and workflow in hopes it will decrease the time needed to implement.  A few different languages are used in examples, for various scenario.  Happy re-learning!

## Regex Basics

### Operators

_Character classes_

__abc__, __123__, __\d__, __\D__: matches exact character, exact digit, any digit, any non-digit

__\s__, __\S__, __\w__, __\W__ : matches white space, non-white space, alphanumeric word, non-alphanumeric word

_Boundaries_

__^__, __$__, __\b__, __\B__: start of string, end of string, word boundary, not word boundary

_Quantifiers_

__x*__: matches zero or multiple x

__x+__: matches one or multiple x

__x{m,n}__: matches x repeat m to n times. a{4} represent aaaa

__x?__: optional - matches one or zero x

_Groups, Ranges, and Capture_

__[xyz]__, __(x|y|z)__: equals x or y or z

__[^xyz]__: not x or y or z

__[x-z]__: matches anyone between x and y

__^x__, __[^xyz]__: means any character that is not x, not any in group x|y|z

__(xyz)__, __(xy(z))__: capture group, capture group and sub-group

### Syntax patterns

RegEx libraries typically provide functionality and components using similar patterns, such as the following:

* `pattern` - encapsulate the expression that is sought using above syntax (mostly language agnostic)
* `find` - apply a pattern, directly to text and return nothing, or a regex object
* `match` - apply the pattern to text and return boolean whether a match, or exact match, exists
* `sub` - substitute a pattern for a string
* convenience functionality 

## Common Solution Approaches

### Example data

We will use the following file for example data.

```bash
%%bash
ls Data/Bloomberg_Chat
```

{{< output >}}
```nb-output
example_chat.txt

```
{{< /output >}}

We will read-in and parse each line using a method similar to the following:

```Groovy
import java.io.InputStream
new File("./Data/Bloomberg_Chat/example_chat.txt").withInputStream { stream ->
    stream.eachLine { line ->
        println line
    }}
```

{{< output >}}
```nb-output
Message#: 0

Message Sent: 02/13/2019 08:42:15

Subject: Instant Bloomberg  Persistent



02/13/2019 08:42:15  User_01,has joined the room

02/19/2019 00:56:29  User_105,Says   Cupiditate voluptas sunt velit. Accusantium aliquid expedita excepturi quis laborum autem. Quas occaecati et atque est repellat dolores. Laudantium in molestiae consequatur voluptate ipsa. 

02/19/2019 00:55:35  User_68,has left the room

```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



### Walking

Walking is one of the most direct approaches.  In the Walking method, you slowly move from the left to the right of your text, matching patterns along the way.  Your target text will everything at the end of the string.

```Groovy
import java.io.InputStream
new File("./Data/Bloomberg_Chat/example_chat.txt").withInputStream { stream ->
    stream.eachLine { line ->
        //find beginning
        trgt = line =~ ~/^Message\sSent:\s(.*)$/
        if(trgt){println trgt[0][1]}
    }}
```

{{< output >}}
```nb-output
02/13/2019 08:42:15
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



### Bracketing

The Bracketing method is taken from the similar technique used in [field artillery](https://encyclopedia2.thefreedictionary.com/bracketing+method) to range your inteded target.  First, pattern the string that begins just before your target text.  Next, pattern the string that ends just after your target text.  Your target text will be in the middle.

```Groovy
import java.io.InputStream
new File("./Data/Bloomberg_Chat/example_chat.txt").withInputStream { stream ->
    stream.eachLine { line ->
        //find beginning
        tmp1 = line =~ ~/^Message\sSent:\s(.*)$/
        if(tmp1){
            //find end
            trgt = tmp1[0][1] =~ ~/.+?(?=\s\d{2}:\d{2}:\d{2})/
            if(trgt){
                println trgt[0]
            }
        }
    }}
```

{{< output >}}
```nb-output
02/13/2019
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



### Divide and conquer

Here, you have a few targets that you are interested in capturing.  Create nested capture groups within the original capture.

```Groovy
import java.io.InputStream
new File("./Data/Bloomberg_Chat/example_chat.txt").withInputStream { stream ->
    stream.eachLine { line ->
        trgt = line =~ ~/^((\d{2}\S\d{2}\S\d{4}\s\d{2}:\d{2}:\d{2})\s([^,]+))(.*)$/
        if(trgt){
            println ("--------Begin line---------")
            println trgt[0][2]                //dtv
            println trgt[0][3]                //member
            println trgt[0][4]                //content
            println ("---------End line----------")
        }
    }}
```

{{< output >}}
```nb-output
--------Begin line---------
02/13/2019 08:42:15
 User_01
,has joined the room
---------End line----------
--------Begin line---------
02/19/2019 00:56:29
 User_105
,Says   Cupiditate voluptas sunt velit. Accusantium aliquid expedita excepturi quis laborum autem. Quas occaecati et atque est repellat dolores. Laudantium in molestiae consequatur voluptate ipsa. 
---------End line----------
--------Begin line---------
02/19/2019 00:55:35
 User_68
,has left the room
---------End line----------
```
{{< /output >}}




{{< output >}}
```nb-output
null
```
{{< /output >}}



### Parsing

In this approach, you want to parse all pieces of a data into their respective fields.  This is often used when getting semi-structured data, such as log files, into a structured format, such as a table.  This is an example from pyspark.

```Groovy
%python #METHOD-1: RegEx
from pyspark.sql import Row
import re
parts = [
    r'(?P<host>\S+)',                   # host 
    r'\S+',                             # indent (unused)
    r'(?P<user>\S+)',                   # user 
    r'\[(?P<time>.+)\]',                # time 
    r'"(?P<request>.*)"',               # request 
    r'(?P<status>[0-9]+)',              # status 
    r'(?P<size>\S+)',                   # size 
    r'"(?P<referrer>.*)"',              # referrer 
    r'"(?P<agent>.*)"',                 # user agent 
]
pattern = re.compile(r'\s+'.join(parts)+r'\s*\Z')

prs = logs.map(lambda x: pattern.match(x).groupdict() )
rows = prs.map(lambda x: Row(**x))
dfLogs = rows.toDF()
dfLogs.show()
```
```
+--------------------+-------------+--------------------+--------------------+-----+------+--------------------+----+
|               agent|         host|            referrer|             request| size|status|                time|user|
+--------------------+-------------+--------------------+--------------------+-----+------+--------------------+----+
|Mozilla/5.0 (comp...| 66.249.69.97|                   -|GET /071300/24215...|  514|   404|24/Sep/2014:22:25...|   -|
|Mozilla/5.0 (X11;...|71.19.157.174|                   -| GET /error HTTP/1.1|  505|   404|24/Sep/2014:22:26...|   -|
|Mozilla/5.0 (X11;...|71.19.157.174|                   -|GET /favicon.ico ...| 1713|   200|24/Sep/2014:22:26...|   -|
|Mozilla/5.0 (X11;...|71.19.157.174|                   -|      GET / HTTP/1.1|18785|   200|24/Sep/2014:22:26...|   -|
|Mozilla/5.0 (X11;...|71.19.157.174|http://www.holden...|GET /jobmineimg.p...|  222|   200|24/Sep/2014:22:26...|   -|
|Mozilla/5.0 (X11;...|71.19.157.174|                   -|GET /error78978 H...|  505|   404|24/Sep/2014:22:26...|   -|
+--------------------+-------------+--------------------+--------------------+-----+------+--------------------+----+
```
### Convenience structures

Languages can have sytax conveniences to make working with regex much easier.  This can include making patterns part of case statements, such as is done in groovy and scala, and allowing for raw string input, such as in groovy and python.

In addition, programmers can make their life easier by creating specific data structures that can hold the output of target matches.

## Language: Groovy

The following functionality is commonly used with groovy:
    
* `~string` - pattern operator
* `=~` - find pattern 
* `==~` - exact match operator
* `switch-case` - convenience functionality

### The pattern operator (~string)

```Groovy
import java.util.regex.Pattern

def pattern = ~/([Gg])roovy/
pattern.class == Pattern
```




{{< output >}}
```nb-output
true
```
{{< /output >}}



```Groovy
//The slashy form of a Groovy string has a huge advantage over double (or single) quoted string - you don’t have to escape backslashes.
( /Version \d+\.\d+\.\d+/ == 'Version \\d+\\.\\d+\\.\\d+' )
```




{{< output >}}
```nb-output
true
```
{{< /output >}}



```Groovy
p = ~/foo/
p = ~'foo'                                                        
p = ~"foo"                                                        
p = ~$/dollar/slashy $ string/$                                   
//p = ~"${pattern}"
```




{{< output >}}
```nb-output
dollar/slashy $ string
```
{{< /output >}}



### The find operator (=~)

```Groovy
import java.util.regex.Matcher

def matcher = "My code is groovier and better when I use Groovy there" =~ /\S+er\b/ 
println matcher.find()
println matcher.size() == 2 
matcher[0..-1] == ["groovier", "better"] 
```

{{< output >}}
```nb-output
true
true
```
{{< /output >}}




{{< output >}}
```nb-output
true
```
{{< /output >}}



```Groovy
if ("My code is groovier and better when I use Groovy there" =~ /\S+er\b/) {
    "At least one element matches the pattern"
}
```




{{< output >}}
```nb-output
At least one element matches the pattern
```
{{< /output >}}



```Groovy
def (first,second) = "My code is groovier and better when I use Groovy there" =~ /\S+er\b/
first == "groovier" & second == "better"
```




{{< output >}}
```nb-output
true
```
{{< /output >}}



```Groovy
// With grouping we get a multidimensional array
def group = ('groovy and grails, ruby and rails' =~ /(\w+) and (\w+)/)
println group.hasGroup()
println 2 == group.size()
println ['groovy and grails', 'groovy', 'grails'] == group[0]
println 'rails' == group[1][2]
```

### The exact match operator (==~)

```Groovy
"My code is groovier and better when I use Groovy there" ==~ /\S+er\b/    //no exact match => only two words
```




{{< output >}}
```nb-output
false
```
{{< /output >}}



```Groovy
"My code is groovier and better when I use Groovy there" ==~ /^My code .* there$/    //exact match of beginning and end of string
```




{{< output >}}
```nb-output
true
```
{{< /output >}}



### The pattern with switch case

```Groovy
def input = "test"

switch (input) {
    case ~/\d{3}/:
        "The number has 3 digits"
        break

    case ~/\w{4}/:
        "The word has 4 letters"
        break

    default:
        "Unrecognized..."
}
```




{{< output >}}
```nb-output
The word has 4 letters
```
{{< /output >}}



## Language: Python

### Reading files

You can read-in a file with the following:

`file_object  = open(“filename”, “mode”)`

The mode argument has a default value of `r` - read value, if omitted. The modes are: 

* `r` – Read mode which is used when the file is only being read 
* `w` – Write mode which is used to edit and write new information to the file (any existing files with the same name will be erased when this mode is activated) 
* `a` – Appending mode, which is used to add new data to the end of the file; that is new information is automatically amended to the end 
* `r+` – Special read and write mode, which is used to handle both actions when working with a file 

By using the `with` statement, you ensure proper handling of the file, including closing it when work is completed.

```Groovy
%%python
with open("./Data/Bloomberg_Chat/example_chat.txt") as file:
    data = file.read() 
    print(data) 
```

{{< output >}}
```nb-output
Message#: 0

Message Sent: 02/13/2019 08:42:15

Subject: Instant Bloomberg  Persistent



02/13/2019 08:42:15  User_01,has joined the room

02/19/2019 00:56:29  User_105,Says   Cupiditate voluptas sunt velit. Accusantium aliquid expedita excepturi quis laborum autem. Quas occaecati et atque est repellat dolores. Laudantium in molestiae consequatur voluptate ipsa. 

02/19/2019 00:55:35  User_68,has left the room


```
{{< /output >}}

### Ordinary string manipulation

Before moving straight to regular expressions, users should take advantage of Python's built-in string manipulation functionality.  _Bracketing_ textual start/end anchors with simple tools can keep your code clean and readable.  The following is an example of adding all text as a string, then using string methods and list comprehensions to select targets. 

```Groovy
%%python
with open("./Data/Bloomberg_Chat/example_chat.txt") as file:
    data = file.read()
    content = (data.split(',has left the room')[0]).split('has joined the room')[1]
    lines = content.replace('\n', ' ').split('.')
    quote = [x.strip() for x in lines]
quote  
```




{{< output >}}
```nb-output
['02/19/2019 00:56:29  User_105,Says   Cupiditate voluptas sunt velit',
 'Accusantium aliquid expedita excepturi quis laborum autem',
 'Quas occaecati et atque est repellat dolores',
 'Laudantium in molestiae consequatur voluptate ipsa',
 '02/19/2019 00:55:35  User_68']
```
{{< /output >}}



### Using RegEx

Regualar expressions are more powerful not only for their patterns, but also because they can be compiled and used over large amounts of data.

Use raw strings instead of regular Python strings. Raw strings begin with `r"some text"` and tell Python not to interpret backslashes and special metacharacters in the string.  This allows you to pass them to the regular expression engine, directly.

An example is using `r"\n\w"` instead of `"\\n\\w"`.

Below, we use the following methods from the `re` module:

* `re.search()` - stop with first match
* `re.findall() / re.finditer()` - search over entire string, returns a list (or iterator) of all captured data
* `re.compile()` method to speed-up processing on larger data.  This is especially useful with a big data framework, such as Apache Spark
* `re.sub()` - find and replace

```Groovy
%%python
import re

regexDate = re.compile(r"Message#:\s(\d+)")

with open("./Data/Bloomberg_Chat/example_chat.txt") as file:
    data = file.read() 
    grp = (re.search(regexDate, data)).group(0) 
    print(grp)
```

{{< output >}}
```nb-output
Message#: 0
```
{{< /output >}}

## Language: JavaScript


* `/\w+\d+/` - match a string of alpha-numeric characters
* `RegExp("\\w+\\d+")` - constructor notation
* `RegExp.test()` - test for a match
* `RegExp.exec()` - returns matching results
* `inputStr.search()` - find a match
* `inputStr.match()` - returns an index of matches
* `inputStr.replace()` - substitute a match with a string

The flags are either appended after the regular expression in the literal notation, or passed into the constructor in the normal notation.

* `g` - allows you to run RegExp.exec() multiple times to find every match in the input string until the method returns null.
* `i` - makes the pattern case insensitive so that it matches strings of different capitalizations
* `m` - is necessary if your input string has newline characters (\n), this flag allows the start and end metacharacter (^ and $ respectively) to match at the beginning and end of each line instead of at the beginning and end of the whole input string
* `u` - interpret the regular expression as unicode codepoints


```javascript
%%javascript
var fs = require('fs');
fs.readFile( __dirname + '/Data/Bloomberg_Chat/example_chat.txt', function (err, data) {
  if (err) {
    throw err; 
  }
  console.log(data.toString());
});
```






```javascript
%%javascript

console.log('hi')
//process.stdout.write("hello: ");
process.stdout.write("Downloading ");
```






## References

* [groovy regex operators](https://e.printstacktrace.blog/groovy-regular-expressions-the-definitive-guide/)
* [thorough cheatsheet](https://www.cheatography.com/davechild/cheat-sheets/regular-expressions/)
* [well-designed exercises](https://regexone.com/)
* [match until a pattern](https://stackoverflow.com/questions/7124778/how-to-match-anything-up-until-this-sequence-of-characters-in-a-regular-expres)
