
+++
title = "Cheatsheet for Documentation"
date = "2021-12-13"
author = "Jason Beach"
categories = ["Cheatsheet", "Computer_Science_and_Programming"]
tags = ["python", "docs"]
+++


## The README.md file


## Docstring

* Single-line for a function
Focus on 'do this, return that'.
```
def multiplier(a,b):
	"""Take in two numbers, return their product."
	product = a*b
	return product
```

* Multi-line for function
The PEP 257 provides standard conventions for usage.
```
def multiplier(a,b):
	"""
	Take in two numbers, return their product.
	
	This is typical multiplication for two scalars
	with no extension to matrices.
	
	Args:
		a(int): a decimal integer
		b(int): another decimal integer
	
	Returns:
		product(str): string of the product of a and b
		
	Raises:
		IOError: an error occurred.
	
	
		----< ALTERNATIVE >----
		
		
		Parameters:
			a (int): A decimal integer
			b (int): Another decimal integer
		Returns:
			product (str): string of the product of a and b
	"""
	product = str(a*b)
	return product
```

* Classes
Summarize behavior and list public methods and instance variables.
```
class Person:
	"""
	A class to represent a person.
	
	Attributes
	----------
	name : str
		first name of the person
	surname : str
		family name fo the person
	age : int
		age of the person
		
	Methods
	-------
	info(additional=""):
		Prints the person's name and age.
	
	"""
	def __init__(self, name, surname, age):
	"""Constructor populates attributes."
		self.name = name
		self.surname = surname
		self.age = age
		
	def info(self, additional=""):
		"""
		Prints the person's name and age.
		
		If the argument 'additional' is passed, then it is appended after the main info.
		
		Parameters
		----------
		additional : str, optional
			More info to be displayed (default is None)
			
		Returns
		-------
		None
		"""
		
		print(f'My name is {self.name} {self.surname}.  I am {self.age} years old.' + additional)
	
	

```

* Modules
List all contents such as classes, functions and exceptions.  The following is an example from pickle.
```
#!/usr/bin/env python3
"""
Create portable serialized representations of Python objects.

See module copyreg for a mechanism for registering custom picklers.
See module pickletools source for extensive comments.

	Typical usage example:
	
	foo = ClassFoo()
	bar = foo.FunctionbBar()
	

	
	----< ALTERNATIVE >---
	
	
Classes:

    Pickler
    Unpickler

Functions:

    dump(object, file)
    dumps(object) -> string
    load(file) -> object
    loads(bytes) -> object

Misc variables:

    __version__
    format_version
    compatible_formats
"""

__author__ = "Your Name"
__version__ = "0.1.0"
__license__ = "MIT"

...
```


## Type Hinting and Annotations

Use PEP-484

```
def hello_name(name: str) -> str:
	return(f"Hello {name}")
```


## Logging

Use logzero in configuration.
```
```


## Tagging

This is very useful with VSCode extension.
```
#TODO: do this in the future
```



## Automated Generation

* pyDoc
* sphinx


## References

* [google](https://github.com/google/styleguide/blob/gh-pages/pyguide.md#38-comments-and-docstrings
* [real python](https://realpython.com/documenting-python-code/)
* [programiz.com](https://www.programiz.com/python-programming/docstrings)
