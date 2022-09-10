
+++
title = "Cheatsheet for PyTest Configurations"
date = "2021-12-12"
author = "Jason Beach"
categories = ["Cheatsheet", "Computer_Science_and_Programming"]
tags = ["python", "pytest"]
+++


## Multiple tests

Run the same test code with many different parameters to create multiple tests.  All tests will run even if there is a failure.

```
recs = [(1,2),(2,3),(3,4)]
@pytest.mark.parametrize("x, y", recs )
def test_extract_process(x, y):
    val = my_function(x)
    assert val == y
```

## Fixtures

Use fixtures to run code before and after all tests.

### Database fixture


```
@pytest.fixture()
def resource_db():
    # setup
    log_file = Path('./tests/tmp/process.log')
    db_file = Path('./tests/tmp/test.db')
    logger = Logger(log_file).create_logger()
    db = Database(db_file = db_file,
                    tables_list = LIST_ALL_TABLES,
                    meta = meta,
                    logger = logger,
                    path_download = './tests/tmp/downloads'
                    )
    # tests
    yield db

    # tear-down
    delete_folder( db.path_download )
    del db
    log_file.unlink() if log_file.is_file() else None
    db_file.unlink() if db_file.is_file() else None
    log_file.parent.rmdir()
   
    
class TestResourceDb:

    def test_check_db_file(self, resource_db):
        # check after file creation
        check_db = resource_db.check_db_file()
        assert check_db == True

```



### Mock fixture

Mock functionality works by intercepting a call and returning a previously-created return output.

Install with:

```
pip install pytest-mock
```

This mocks a call of the requests module.

```
import pytest

def test_change_in_10k_filing(self, mocker):

        #mock: poll_sec_edgar()
        output_data = {
                    'accessionNumber': ["0001193125-22-138788"],
                    'filingDate': ["2022-05-03"],
                    'form': ['10-Q'],
                    'size': [21073821],
                    'primaryDocument': ["d306477d10q.htm"]
        }
        mock_request = mocker.patch('sec_workflows.utils.api_request', 
                                    return_value = output_data
                                    ) 

                                    
changed_firms = poll_sec_edgar(tgt_firms, after_date)
```



## Commandline

Basic testing can be performed using `pytest`.

Command line testing of a specific test method can be performed using:  `pytest --trace tests/test_scraper.py -k test_get_data_atlantic`.

Use the following commands:

* n(next) – step to the next line within the same function
* s(step) – step to the next line in this function or called function
* b(break) – set up new breakpoints without changing the code
* p(print) – evaluate and print the value of an expression
* c(continue) – continue execution and only stop when a breakpoint is encountered
* unt(until) – continue execution until the line with a number greater than the current one is reached
* q(quit) – quit the debugger/execution



## Test Coverage

Run `pytest --cov=main_module --cov-report=xml tests`, where coverage is for `main_module` and `xml` is the generated `coverage.xml` report file that can be used with vscode extension `coverage gutters`.


