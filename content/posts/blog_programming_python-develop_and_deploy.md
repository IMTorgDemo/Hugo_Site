
+++
title = "Working through a Progressive Python Application"
date = "2020-03-01"
author = "Jason Beach"
categories = ["Progressive", "BestPractice"]
tags = ["python", "development", "deployment"]
+++


This post walks the developer through a python application as it progresses in development.  It uses linux, docker, vscode, pyenv, pipenv and other tools for developing, building, and deploying an application.

## Environment

Two tools can help you setup your local development environment: pyenv and pipenv.  Pyenv is good for getting the correct python version.  Pipenv is quite good at setting your virtual environment so that your versions of python and dependencies are separate from your actual machine.  It is the next best thing to a docker container

```bash
%%bash
pyenv install 3.7.0
pyenv local 3.7.0

pipenv --three
pipenv install <module>
pipenv shell
```

Not to get ahead of ourselves, but when you want to install your package to your machine

```bash
%%bash
pip3 install .
```

## Local VSCode

* [doc: python](https://code.visualstudio.com/docs/python/python-tutorial)

### Interpreter

Python is an interpreted language, and in order to run Python code and get Python IntelliSense, you must tell VS Code which interpreter to use.

```bash
%%bash
pipenv --where
pipenv --venv
```

Within the UI:
View > CommandPallete > Python: Select Interpretor
```bash
#settings.json
"python.pythonPath": "<path/to/venv>"
```

### Debugger

Linting is done with [PyLint](https://www.pylint.org/).  Linting runs automatically when you save a file.  PyLint messages fall into specific [categories](https://code.visualstudio.com/docs/python/linting#_pylint).

Within the UI:
View > CommandPallete > Python: Enable Linting
```bash
#settings.json
"python.linting.enabled": true
```

Debugger uses the Run button in the left-side pane.  There are two standard configurations that run the active file in the editor in either the `integratedTerminal` (inside VS Code) or the `externalTerminal` (outside of VS Code).

The `pythonPath` configuration defaults to the interpreter identified in the `python.pythonPath` setting, which is equivalent to using the value `${config:python.pythonPath}`. 

Within the UI, open the entrypoint file:
Run > Debug Configuration > Python File > `launch.json` is created

Provide specific startup file and arguments
```bash
#launch.json
	"name": "Python: startup.py",
	...
    "request": "launch",
    "program": "${workspaceFolder}/startup.py",
    "args" : ["--port", "1593"]
```

In the upper-left corner of Debugger, select the correct configuration (Name) and 'Run'.

## Remote VSCode

* [doc: remote](https://code.visualstudio.com/docs/remote/remote-overview)


### Jupyter notebook

TODO:notebook


### Remote server

TODO:remote


### Docker container

https://code.visualstudio.com/docs/remote/containers


### Spark remote server

TODO:spark

## Configure

### Env Variables

Environment variables can be loaded within VSCode, or using a module.

### Logging



### Testing

[doc: vscode python testing](https://code.visualstudio.com/docs/python/testing)


## Development

### Commandline arguments

Some important commandline arguments are subcommands and choices

Subcommands are implicitly mutually exclusive.  In this example, there are only two ways the main command can be run, using `generate_text` or `check_annotations`.  The `defaults` allow for setting an associated function with the subcommand.
```
parser = argparse.ArgumentParser()
subparsers = parser.add_subparsers()    

add_gen = subparsers.add_parser('generate_text')
add_gen.set_defaults(func = run)

add_check = subparsers.add_parser('check_annotations')
add_check.set_defaults(func = check_annotations)
```

Choices ensure the user has only a finite selection from which to choose.  The default is only used in conjunction with `nargs="?"`.
```
parser = argparse.ArgumentParser()
subparsers = parser.add_subparsers()    

add_gen = subparsers.add_parser('generate_text')
add_gen.set_defaults(func = run)
add_gen.add_argument("--output",
                        choices=("drsc_prep","mgen"),
                        help="desired output format, check: `./io/rsc/` to see formats",
                        nargs="?",
                        default="drsc_prep")
```

### Comments and documentation

Create docstrings like:

```python
"""
docstrings for:
* purpose
* parameters
* return values
* exceptions

"""
```

### Directory structure

Some languages, such as Java and C#, require an implementation to be forced into a particular structure.  That is unfortunate because not every nail requires an enterprise-ready hammer.

Python is different in that it allows for very flexible file arrangement and folder structure.  Python can be used as just a simple linear script.

> script.py

## Deployment

### Build egg

```bash
%%bash
#(MANIFEST.in)include hugo2lunr/data/word_association_ref.json
#(setup.py)package_data={'': ['hugo2lunr/data/word_association_ref.json']},
rm -rf build *.egg-info
python3 setup.py install --force
pip3 install .
hugo2lunr ./test/input ./test/output    #input_dir and output_dir
```

### Build bdist_wheel (.whl)

Building a wheel (bdist_wheel) and installing as commandline utility. If you are building a wheel (bdist_wheel), then include_package_data and MANIFEST.in are ignored and you must use package_data and data_files.

```bash
%%bash
#(setup.py)data_files=[('',['hugo2lunr/data/word_association_ref.json'])],
pip3 install spacy
python3 -m spacy download en_core_web_lg

pipenv install
pipenv shell
rm -rf ./dist/*.whl
pip wheel -w dist --verbose .
exit

pip3 uninstall hugo2lunr
#pip3 install -e .    #<<<FAIL
pip3 install . --user
hugo2lunr  -h
hugo2lunr ./test/input ./test/output    #input_dir and output_dir
```

### Build for specific linux distribution

Build with

```bash
%%bash
(venv)$ pip wheel -w dist --verbose .
```

Build for linux

```bash
%%bash
#create dockcross manylinux bash driver script
docker run --rm dockcross/manylinux-x64 > ./dockcross-manylinux-x64
chmod +x ./dockcross-manylinux-x64
#build a distributable Python 2.7 Python wheel
./dockcross-manylinux-x64 /opt/python/cp27-cp27m/bin/pip wheel -w dist .
```

Use on linux

```bash
%%bash
$ unzip sample-0.1.0-py2-none-any.whl
$ pwd
$ python
python>>> import sys
python>>> sys.path.append(<pwd>)
python>>> import sample
```

### Docker image

TODO:docker image

## Conclusion
