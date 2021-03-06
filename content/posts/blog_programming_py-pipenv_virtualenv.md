
+++
title = "A Cheatsheet for Python's Pipenv"
date = "2020-03-29"
author = "Jason Beach"
categories = ["Cheatsheet", "Computer_Science_and_Programming"]
tags = ["python", "pipenv", "virtual_environment"]
+++


Python's Pipenv and Pyenv make a strong team for creating a consistent development environment for exact specifications.  Pyenv allows you to choose from any Python version for your project.  Pipenv attempts to improve upon the original virtual environment (venv) and requirements.txt file.  It does some things well, including integration of virtual environment with dependecy management, and is straight-forward to use.  Unfortunately, it doesn't always live up to the originally-planned, ambitious, goals.  This cheatsheet provides commands for functionality that works, and some work-arounds when it doesn't.

## Getting Started

__Pyenv__ takes care of the python binary and all related tools. It stores everything under `$PYENV_ROOT`.

__Pipenv__ takes care of:

* calculating the complete set of dependencies;
* (in installation mode) telling virtualenv and pip where to install the dependencies;
* (in runtime mode) making available an environment with the right version of the Python interpreter (via pyenv) and the right set of packages (via virtualenv).

_Note: Pipenv can interact with `setup.py`, but it is easy to confuse Pipenv functionality with that for package distribution and installation.  The two are separate, and packaging is out of scope for Pipenv._

Pipenv creates a directory that maintains your dependencies.  From the repo listed functionality, it has interesting interaction with existing technology:

* Enables truly deterministic builds, while easily specifying only what you want.
* Generates and checks file hashes for locked dependencies.
* Automatically install required Pythons, if pyenv is available.
* Automatically finds your project home, recursively, by looking for a Pipfile.
* Automatically generates a Pipfile, if one doesn't exist.
* Automatically creates a virtualenv in a standard location.
* Automatically adds/removes packages to a Pipfile when they are un/installed.
* Automatically loads `.env` files, if they exist.

You may hear some harping over non-deterministic builds.  This is because Python's requirement.txt file does not dependency resolution of required modules, sub-dependency resolution (at least not well).  This can cause big problems during automated deployments.

Pipenv solves these problems with Pipfile (which is meant to replace requirements.txt) and the Pipfile.lock (which enables deterministic builds).  Pipenv uses pip and virtualenv under the hood but simplifies their usage with a single command line interface.

## Prepare Python

Pyenv is about ensuring your have the correct python interpreter.  This is similar to Node Version Manager (NVM) for Javascript.

### Install pyenv

```python
brew uninstall pyenv
```

### Install Python version

```python
pyenv install <version>    #such as, 3.7.2
```

### Available versions

```python
pyenv install --list
```

### Change global / local (dir) versions

```python
pyenv global <version>   #such as, 3.6.6
```

```python
pyenv local <version>   #such as, 3.6.6
```

## Prepare Development Environment

Pipenv creates all your virtual environments in a default location. If you want to change Pipenv’s default behavior, there are some [environmental variables for configuration](https://docs.pipenv.org/advanced/#configuration-with-environment-variables).

### Install pipenv

```python
pip3 install pipenv
```

### Initiate directory

```python
mkdir project; cd project;
pipenv --three   #or --two
```

### Develop from existing repo

When an exact version isn’t specified in the Pipfile, the install command gives the opportunity for dependencies (and sub-dependencies) to update their versions.

```python
pipenv install --dev
```

### Activate

```python
pipenv shell
```

### Locate Virtualenv

```python
pipenv --where          #output project home information.
```

```python
pipenv --venv           #output virtualenv information.
```

```python
whereis python
```

### Check python version

```python
python --version
```

### Check path

```python
python
>>> import sys
>>> sys.executable
quit()
```

### Run with pipenv

```python
pipenv run <command>    #such as, `python manage.py runserver`
```

### Add scripts to Pipfile
```
#Pipfile
[scripts]
server = "python manage.py runserver"
```

And run with the following

```python
pipenv run server
```

## Managing Dependencies

Pipenv generates the file Pipfile.lock, which is used to produce deterministic builds.  Issues can occur with Pipfile.lock, so it is sometimes prudent to create a requirements.txt file from your Pipenv, as a backup.

You specify the locations similarly to how you’d do so with pip. For example, to install the requests library from version control, do the following.  Note the -e argument above to make the installation editable, this is required for Pipenv to do sub-dependency resolution.

### Install from VCS

```python
pipenv install -e git+https://github.com/requests/requests.git#egg=requests
```

### Install from requirements.txt

```python
pipenv install -r ./requirements.txt
```

### Check local packages

```python
pipenv lock -r
```

### Create requirements.txt

You may want to generate requirements.txt file from existing Pipfile.lock without locking.  When you run `pipenv lock -r` it ignores existing Pipfile.lock and does locking process again.   There are issues around running this that are documented in this github [issue](https://github.com/pypa/pipenv/issues/3493).

```python
pipenv run pip freeze > requirements.txt
```

Another approach is to use:

```python
pipenv lock --keep-outdated -d -r > requirements.txt
```

### Install and uninstall a package

```python
pipenv install <module>    #such as, camelcase
```

```python
pipenv uninstall <module>    #such as, camelcase
```

```python
pipenv uninstall <module>
pipenv uninstall --all
pipenv uninstall --all-dev
```

```python
pipenv install <module> --dev    #only for development, such as, nose
```

### Check dependency graph

If there are conflicting dependencies (package_a needs package_c>=1.0, but package_b needs package_c<1.0), Pipenv will not be able to create a lock file and wil output an error like the following:
```    
Warning: Your dependencies could not be resolved. You likely have a mismatch in your sub-dependencies.
  You can use \\( pipenv install --skip-lock to bypass this mechanism, then run \\) pipenv graph to inspect the situation.
Could not find a version that matches package_c>=1.0,package_c<1.0
```

As the warning says, you can also show a dependency graph to understand your top-level dependencies and their sub-dependencies.  This command will print out a tree-like structure showing your dependencies. 

```python
pipenv graph
pipenv graph --reverse
```

You can reverse, `--reverse`, the tree to show the sub-dependencies with the parent that requires it.

### Ignore pipfile

```python
pipenv install --ignore-pipfile
```

## Prepare Deployment

Let’s say you’ve got everything working in your local development environment and you’re ready to push it to production. To do that, you need to lock your environment so you can ensure you have the same one in production.  

This will create/update your Pipfile.lock, which you’ll never need to (and are never meant to) edit manually. You should always use the generated file.

### Set lockfile - before deployment

```python
pipenv lock
```

### Production deployment

Now, once you get your code and Pipfile.lock in your production environment, you should install the last successful environment recorded.  

This tells Pipenv to ignore the Pipfile for installation and use what’s in the Pipfile.lock. Given this Pipfile.lock, Pipenv will create the exact same environment you had when you ran pipenv lock, sub-dependencies and all.

The lock file enables deterministic builds by taking a snapshot of all the versions of packages in an environment (similar to the result of a pip freeze).

```python
pipenv install --ignore-pipfile
```

### Env variables

Pipenv supports the automatic loading of environmental variables when a `.env` file exists in the top-level directory. That way, when you pipenv shell to open the virtual environment, it loads your environmental variables from the file. The `.env` file just contains key-value pairs:
```
#.env
SOME_ENV_CONFIG=some_value
SOME_OTHER_ENV_CONFIG=some_other_value
```

### Check security vulnerabilities

Check for security vulnerabilities (and PEP 508 requirements) in your environment.

```python
pipenv check
```

## Package Distribution and Installation

How does Pipenv work with setup.py files?  There are a lot of nuances to that question. First, a setup.py file is necessary when you’re using setuptools as your build/distribution system. This has been the de facto standard for a while now, but recent changes have made the use of setuptools optional.

Remember: Pipenv can help in distribution, but that is not within project scope.

### Install module's into virtual environment 

```python
pipenv install -e .
```

### Install module onto machine

```python
pip install .
```

## Wrapping Up

### Exiting the virtualenv

```python
exit
```

### Remove the virtualenv

```python
pipenv --rm
```
