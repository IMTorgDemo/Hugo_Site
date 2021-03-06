
+++
title = "Distributing Code in Python"
date = "2020-01-28"
author = "Jason Beach"
categories = ["Best_Practice", "Computer_Science_and_Programming"]
tags = ["python", "setuptools", "pip", "deployment"]
+++


Distributing and deploying products is a necessary step in the solution development process, and an imperative in business.  Each solution must be thoughtfully analyzed for strengths and weaknesses, especially from the perspective of security.  The decisons you make are largely based on the language employed to create the solution.  This post will describe steps taken in distributing a Python solution.

## Introduction to Bytecode

Simple python scripts are a terrific approach to getting work done, quickly.  However, in more professional environments, the ease of use can make distribution tricky.  Python is a 'bytecode interpreted language' so that it is disseminated as scripts.  Compilation is unique to the machine that runs the code.  Providing users with the bytecode (.pyc) is possible, but must be run, by the python interpreter, on the same version of virutal machine.

Compiled Python bytecode files are architecture-independent, but VM-dependent. A .pyc file will only work on a specific set of Python versions determined by the magic number stored in the file, using the following:

```python
! python -V
```

{{< output >}}
```nb-output
Python 3.7.3
```
{{< /output >}}

```python
#testfile.py
import imp
magic_num = imp.get_magic()
print( magic_num )
print( magic_num.hex() )
```

{{< output >}}
```nb-output
b'B\r\r\n'
420d0d0a
```
{{< /output >}}

```python
! python testfile.py
```

{{< output >}}
```nb-output
testfile.py:1: DeprecationWarning: the imp module is deprecated in favour of importlib; see the module's documentation for alternative uses
  import imp
b'B\r\r\n'
420d0d0a
```
{{< /output >}}

```python
! python -m py_compile testfile.py
```

```python
! ls __pycache__
```

{{< output >}}
```nb-output
testfile.cpython-37.pyc
```
{{< /output >}}

```python
#python
f = open('./__pycache__/testfile.cpython-37.pyc')
magic = f.read(4)       #read first 'n' characters
magic.encode('hex')     #output:'b3f20d0a' > not compatible
```

Bytecode is architecture- / platform-independent, so bytecodes compiled by a compiler running in windows will still run in linux/unix/mac.  Machine code is platform-specific, if it is compiled in windows x86, it will run ONLY in windows x86.

This is different from other popular languages, such as Java, which is compiled to a Java Archive (.jar) file, then run using the Java Virtual Machine (jvm).  That was the original popularity of java: it was a _portable_ language.  All you needed was the correct JVM.

Bytecodes are the machine language of the Java Virtual Machine (JVM). When a JVM loads a class file, it gets one stream of bytecodes for each method in the class. The bytecodes' streams are stored in the method area of the JVM. The bytecodes for a method are executed when that method is invoked during the course of running the program. They can be executed by intepretation, just-in-time compiling, or any other technique that was chosen by the designer of a particular JVM.

A method's bytecode stream is a sequence of instructions for the JVM. Each instruction consists of a one-byte opcode followed by zero or more operands. The opcode indicates the action to take. If more information is required before the JVM can take the action, that information is encoded into one or more operands that immediately follow the opcode.

## Distribution Methods

The typical method of disseminating Python solutions is to maintain sourece code in a repository, such as Github, then package and upload the solution distributions (sdist, bdist_wheel) to PyPi, the [Python Package Index](https://pypi.org/).  PyPi allows projects and dependencies to be imported with a simple `pip install <package>`.  

What's more, the packaging process is quite a bit easier than that of more demanding communities, such as R libraries' [ Comprehensive R Archive Network(CRAN)](https://cran.r-project.org/).  This comes at a cost in that PyPi is known to have had imposters (viruses) to popular packages which may have one character different than the actual, desired package.  So, some care should be taken.

Some terminology:

* file - containing random python code
* module - usually a single python script (`name.py`), use with `import my_module`
* package - a module with other modules, and other packages, included; use with `from big.package import specific_function`


The egg and wheel are install artifacts that don’t require building or compilation.  The Egg format was introduced by setuptools in 2004, whereas the Wheel format was introduced by PEP 427 in 2012.  Wheel is currently considered the standard for built and binary packaging for Python.

* egg (.egg) - deprecated built distribution
* setup.py - python file which tells system it has been packaged and distributed using Distutils to create sdist or bdist
* source distribution (sdist) archive - an archive that can then be used to recompile everything on any OS platform; contains .py files, or .c/.cpp for binary modules, and setup.py
* binary distribution (bdist) wheel (.whl) - a built distribution that is specific to OS-platform and Python version, but can be installed and then used directly by extracting it; includes .pyc files(python bytecode), .so/.dll/.dylib for binary modules, but does not include setup.py
* wheel - a package format designed to ship built libraries (.pyc) with compiled artifacts, such as from C, C++, Rust, etc.  In contrast to the source archive, the wheel includes any extensions ready to use.
* executable (.exe) - binary file that includes both the built code with the python interpreter in a self-contained distribution.

While providing the source code is preferred when working in a collaborative environment, it is not ideal when distributing to end-users who are uninterested in the internals.  In addition, providing source code might present security concerns, especially if the python developer is trying to create a closed-source product.  Source code obfuscators exist, but this approach was an after-thought in python's development.

Typically, operating systems provide a format for an 'executable'.  Python can be create an executable by building with the Python interpreter through the process of 'freezing'.  There are many approaches to freezing.

## Packaging

Now that we know the different types of distributions, let's package a wheel for use.  We will use [this boilerplate repo](https://github.com/IMTorgDemo/Boilerplate-Python) as an example.

Build with the following command, and the archive will appear in `/dist` folder.

```python
! (venv)$ pip wheel -w dist --verbose .
```

Perhaps you want to build your distribution for a specific environment, Python version, or over many combinations of the two.  The [dockcross](https://github.com/dockcross/dockcross) project allows you to do this by building your distribution from different docker images.

```python
#create dockcross manylinux bash driver script
docker run --rm dockcross/manylinux-x64 > ./dockcross-manylinux-x64
chmod +x ./dockcross-manylinux-x64
#build a distributable Python 2.7 Python wheel
./dockcross-manylinux-x64 /opt/python/cp27-cp27m/bin/pip wheel -w dist .
```

Once you have your specific distribution, move it to the target environment and install.

```python
pip install .
```

Or, instead of installing, simply use directly from the working directory.

\\( unzip sample-0.1.0-py2-none-any.whl
\\) pwd
$ python
python>>> import sys
python>>> sys.path.append(<pwd>)
python>>> import sample

## Conclusion

This post prepares users with some of the basic terminology to understand different approaches to distributing Python code.  It also provides a small, opinionated example for effectivly building a wheel and installing it on the target machine.  There are many choices in distributing Python code, and the process is still evolving.  Users should consult a variety of sources to better understand the latest fashions and pertinent details.

## References

* [nice discussion on packaging](https://python-packaging-tutorial.readthedocs.io/en/latest/setup_py.html)
* [distributing a package](https://packaging.python.org/guides/distributing-packages-using-setuptools/)
