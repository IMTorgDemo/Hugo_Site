
+++
title = "The R and Pandas Dataframe"
date = "2020-03-02"
author = "Jason Beach"
categories = ["Comparison", "Data_Science"]
tags = ["python", "pandas", "r_language", "dataframe"]
+++


Although Pandas uses the Dataframe as its primary data structure, just as R does, the Pandas syntax and underlying fundamentals can be disorienting for R users.  This post will describe some basic comparisons and inconsistencies between the two languages.  It will also provide some examples of very non-intuitive solutions to common problems.

## Introduction

In the Datascience R versus Pandas debate, it is really an apples and oranges comparison.  R is a domain specific language in the field of statistics, analytics, and data visualization.  This makes R great for consulting, research, and basic analysis, especially within a careful academic context.  

In contrast, Python's statistics packages are woefully inadequate and rarely mention details which are of great importance to statistical practicioners.  An example of this is the use of contrasts in linear models.  The different Types (I-IV) of Analysis Of Variance models use different encodings for data.  Determining their estimators is not trivial.

However, if you want tight integration with other applications, the strengths of typical programming languages, and want to 'just get models done', then Python / Pandas is a great solution.  Pandas is quite good at data manipulation.  Python has the very strong NumPy and SciKit Learn module, which are very good for matrix operations and predictive modeling.  And the Python language is a really good general scripting language with strong support for strings and datetime types.

### Setup

Ensure to import the proper libraries.  Let's compare with R syntax, directly, using `rpy2`.

```python
import pandas as pd
import numpy as np
```

```python
%load_ext rpy2.ipython
```

```python
%R require(ggplot2)
```




{{< output >}}
```nb-output
array([1], dtype=int32)
```
{{< /output >}}



These Dataframes will be used for the various problems.

```python
trades = pd.DataFrame(
    [
        ["2016-05-25 13:30:01.023", "MSFT", 51.95, 75],
        ["2016-05-25 13:30:01.038", "MSFT", 51.95, 155],
        ["2016-05-25 13:30:03.048", "GOOG", 720.77, 100],
        ["2016-05-25 13:30:03.048", "GOOG", 720.92, 100],
        ["2016-05-25 13:30:03.048", "AAPL", 98.00, 100],
    ],
    columns=["timestamp", "ticker", "price", "quantity"],   #set index during assignment: `, index_col='timestamp'`
)
trades['timestamp'] = pd.to_datetime(trades['timestamp'])
trades.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2016-05-25 13:30:01.023</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2016-05-25 13:30:01.038</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>GOOG</td>
      <td>720.92</td>
      <td>100</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>AAPL</td>
      <td>98.00</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



We then set the index to the timestamp.  The index allows selecting rows with the `loc` and `at` methods.

```python
trades_idx = trades.set_index('timestamp')
trades_idx.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
    <tr>
      <th>timestamp</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2016-05-25 13:30:01.023</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:01.038</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:03.048</th>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:03.048</th>
      <td>GOOG</td>
      <td>720.92</td>
      <td>100</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:03.048</th>
      <td>AAPL</td>
      <td>98.00</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



## Syntax Differences

### Basic selection

The primary purpose of the DataFrame indexing operator, `df[ ]` is to select columns.

```python
trades['ticker'].head(3)
```




{{< output >}}
```nb-output
0    MSFT
1    MSFT
2    GOOG
Name: ticker, dtype: object
```
{{< /output >}}



```python
trades[['ticker','price']].head(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ticker</th>
      <th>price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>MSFT</td>
      <td>51.95</td>
    </tr>
    <tr>
      <th>1</th>
      <td>MSFT</td>
      <td>51.95</td>
    </tr>
    <tr>
      <th>2</th>
      <td>GOOG</td>
      <td>720.77</td>
    </tr>
  </tbody>
</table>
</div>



```r
%%R -i trades
head( trades['ticker'], 3)
```

{{< output >}}
```nb-output
  ticker
0   MSFT
1   MSFT
2   GOOG
```
{{< /output >}}

```r
%%R -i trades
head( trades[c('ticker','price')], 3)
```

{{< output >}}
```nb-output
  ticker  price
0   MSFT  51.95
1   MSFT  51.95
2   GOOG 720.77
```
{{< /output >}}

When the indexing operator is passed a string or integer, it attempts to find a column with that particular name and return it as a Series.

For example, `df[2]` searches for a column name matching the integer value 2. This column does not exist and a `KeyError` is raised.  

```python
try:
    trades[2]
except:
    print("got key error")
```

{{< output >}}
```nb-output
got key error
```
{{< /output >}}

```r
%%R -i trades
head(trades[2], 3)
```

{{< output >}}
```nb-output
  ticker
0   MSFT
1   MSFT
2   GOOG
```
{{< /output >}}

```r
%%R -i trades
head(trades[,2], 3)
```

{{< output >}}
```nb-output
[1] "MSFT" "MSFT" "GOOG"
```
{{< /output >}}

We can use integer indexing of columns, in R.  Its not necessary to use the `c()` concatenate function to create a vector, but it can often make your code cleaner.

```r
%%R -i trades
head(trades[,c(2:3)], 3)
```

{{< output >}}
```nb-output
  ticker  price
0   MSFT  51.95
1   MSFT  51.95
2   GOOG 720.77
```
{{< /output >}}

However, the DataFrame indexing operator completely changes behavior to select rows when slice notation is used.  The DataFrame indexing operator selects rows in this manner, and can also do so by integer location, or by index label.

```python
trades[:3]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2016-05-25 13:30:00.023</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2016-05-25 13:30:00.038</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2016-05-25 13:30:00.048</td>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



```r
%%R -i trades
head(trades[1:3,], 3)
```

{{< output >}}
```nb-output
            timestamp ticker  price quantity
0 2016-05-25 13:30:00   MSFT  51.95       75
1 2016-05-25 13:30:00   MSFT  51.95      155
2 2016-05-25 13:30:00   GOOG 720.77      100
```
{{< /output >}}

The following selects rows beginning at integer location 1, up to but not including 6, by every third row.

```python
trades[1:6:3]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>2016-05-25 13:30:00.038</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2016-05-25 13:30:00.048</td>
      <td>AAPL</td>
      <td>98.00</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



You can also use slices consisting of string labels if your DataFrame index has strings in it.  Here we have new operators, `.iloc` to explicity support only integer indexing, and `.loc` to explicity support only label indexing.

```python
trades.iloc[1:6:3]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>2016-05-25 13:30:00.038</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2016-05-25 13:30:00.048</td>
      <td>AAPL</td>
      <td>98.00</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



With the timestamp index, we can subset using a variety of input string-formats.

```python
trades_idx.loc['2016-05'].head(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
    <tr>
      <th>timestamp</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2016-05-25 13:30:00.023</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.038</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.048</th>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



```python
trades_idx.loc['May 2016'].head(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
    <tr>
      <th>timestamp</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2016-05-25 13:30:00.023</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.038</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.048</th>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



The `.loc` / `.iloc` operators can select on both rows and columns, simultaneously, the indexing operator `[ ]` cannot.

```python
trades_idx.loc['May 2016', 'ticker']
```




{{< output >}}
```nb-output
timestamp
2016-05-25 13:30:00.023    MSFT
2016-05-25 13:30:00.038    MSFT
2016-05-25 13:30:00.048    GOOG
2016-05-25 13:30:00.048    GOOG
2016-05-25 13:30:00.048    AAPL
Name: ticker, dtype: object
```
{{< /output >}}



```python
try:
    trades[2, 'ticker']
except:
    print('use R')
```

{{< output >}}
```nb-output
use R
```
{{< /output >}}

This all seems very tideous for R users - just get on with it.

```r
%%R -i trades
head(trades[2,'ticker'], 3)
```

{{< output >}}
```nb-output
[1] "MSFT"
```
{{< /output >}}

### Dataframe Index

One of the fundamental differences between R and pandas is that pandas leans heavily upon the dataframe index.  For R users, it can seem like an annoyance; however, using it is required because many results of pandas methods return a dataframe with an index.

The index is already set for `trades_idx`, but if we want to replace it with a new one, it is easily done.

```python
trades_idx.set_index('price')
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ticker</th>
      <th>quantity</th>
    </tr>
    <tr>
      <th>price</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>51.95</th>
      <td>MSFT</td>
      <td>75</td>
    </tr>
    <tr>
      <th>51.95</th>
      <td>MSFT</td>
      <td>155</td>
    </tr>
    <tr>
      <th>720.77</th>
      <td>GOOG</td>
      <td>100</td>
    </tr>
    <tr>
      <th>720.92</th>
      <td>GOOG</td>
      <td>100</td>
    </tr>
    <tr>
      <th>98.00</th>
      <td>AAPL</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



There are two ways to move the index into a column.

```python
new_trades_idx = trades_idx.copy()
new_trades_idx['timestamp'] = trades_idx.index
new_trades_idx
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
      <th>timestamp</th>
    </tr>
    <tr>
      <th>timestamp</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2016-05-25 13:30:00.023</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
      <td>2016-05-25 13:30:00.023</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.038</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
      <td>2016-05-25 13:30:00.038</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.048</th>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
      <td>2016-05-25 13:30:00.048</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.048</th>
      <td>GOOG</td>
      <td>720.92</td>
      <td>100</td>
      <td>2016-05-25 13:30:00.048</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.048</th>
      <td>AAPL</td>
      <td>98.00</td>
      <td>100</td>
      <td>2016-05-25 13:30:00.048</td>
    </tr>
  </tbody>
</table>
</div>



```python
trades_idx.reset_index(level=0, inplace=False)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2016-05-25 13:30:00.023</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2016-05-25 13:30:00.038</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2016-05-25 13:30:00.048</td>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2016-05-25 13:30:00.048</td>
      <td>GOOG</td>
      <td>720.92</td>
      <td>100</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2016-05-25 13:30:00.048</td>
      <td>AAPL</td>
      <td>98.00</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



When using a timestamp as an index, default datetime format ISO8601 (“yyyy-mm-dd hh:mm:ss”) is used when selecting data with partial string indexing. 

```python
try:
    trades_idx.loc['2016-05-25 13:30:00.023']
except:
    print('cannot use fractions of seconds')
```

{{< output >}}
```nb-output
cannot use fractions of seconds
```
{{< /output >}}

```python
trades_idx.loc['2016-05-25 13:30:01':'2016-05-25 13:30:02']
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
    <tr>
      <th>timestamp</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2016-05-25 13:30:01.023</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:01.038</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
  </tbody>
</table>
</div>



While the index of a R dataframe is immutable, the index of a pandas dataframe can expand, or even lose arbitrary items.  In this example, some rows are removed, and the index goes with them.  If we don't `reset_index()`, then those rows will always be missing.

```python
tmp2
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
      <th>timestamp</th>
    </tr>
    <tr>
      <th>timestamp</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2016-05-25 13:30:00.023</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
      <td>2016-05-25 13:30:00.023</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.038</th>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
      <td>2016-05-25 13:30:00.038</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.048</th>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
      <td>2016-05-25 13:30:00.048</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.048</th>
      <td>GOOG</td>
      <td>720.92</td>
      <td>100</td>
      <td>2016-05-25 13:30:00.048</td>
    </tr>
    <tr>
      <th>2016-05-25 13:30:00.048</th>
      <td>AAPL</td>
      <td>98.00</td>
      <td>100</td>
      <td>2016-05-25 13:30:00.048</td>
    </tr>
  </tbody>
</table>
</div>



```python
tmp2 = trades.copy()
tmp3 = tmp2[0:4:2]
tmp3
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2016-05-25 13:30:01.023</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



```python
tmp3.reset_index(inplace=True)
tmp3
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>index</th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>2016-05-25 13:30:01.023</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2</td>
      <td>2016-05-25 13:30:03.048</td>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



Forgetting to `reset_index()` can cause serious problems.

You can also create a multi-index to make things even more confusing.

```python
index = pd.MultiIndex.from_product([['TX', 'FL', 'CA'], 
                                    ['North', 'South']], 
                                   names=['State', 'Direction'])

df = pd.DataFrame(index=index, 
                  data=np.random.randint(0, 10, (6,4)), 
                  columns=list('abcd'))
```

```python
df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>a</th>
      <th>b</th>
      <th>c</th>
      <th>d</th>
    </tr>
    <tr>
      <th>State</th>
      <th>Direction</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" valign="top">TX</th>
      <th>North</th>
      <td>6</td>
      <td>4</td>
      <td>1</td>
      <td>5</td>
    </tr>
    <tr>
      <th>South</th>
      <td>0</td>
      <td>9</td>
      <td>3</td>
      <td>2</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">FL</th>
      <th>North</th>
      <td>3</td>
      <td>2</td>
      <td>9</td>
      <td>3</td>
    </tr>
    <tr>
      <th>South</th>
      <td>7</td>
      <td>2</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th rowspan="2" valign="top">CA</th>
      <th>North</th>
      <td>9</td>
      <td>6</td>
      <td>3</td>
      <td>4</td>
    </tr>
    <tr>
      <th>South</th>
      <td>5</td>
      <td>6</td>
      <td>9</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



### Subset replacement (the `SettingWithCopy` warning)

Conditionally replacing values in R is straightforward because we can use simultaneous selection.

```r
%%R -i trades

tmp1 <- trades
tmp1[tmp1$quantity > 80, c('price')] <- 100
tmp1
```

{{< output >}}
```nb-output
            timestamp ticker  price quantity
0 2016-05-25 13:30:01   MSFT  51.95       75
1 2016-05-25 13:30:01   MSFT 100.00      155
2 2016-05-25 13:30:03   GOOG 100.00      100
3 2016-05-25 13:30:03   GOOG 100.00      100
4 2016-05-25 13:30:03   AAPL 100.00      100
```
{{< /output >}}

We know that we cannot use simultaneous selection in pandas using the indexing operator.

```python
tmp1 = trades.copy()
try:
    tmp1[tmp1.quantity > 80, 'price'] = 100
except:
    print("TypeError: 'Series' objects are mutable, thus they cannot be hashed")
```

{{< output >}}
```nb-output
TypeError: 'Series' objects are mutable, thus they cannot be hashed
```
{{< /output >}}

Replacing by index doesn't give us what we want, either>

The direct way fails, too!  Oh, pandas, why must you be so difficult...

```python
tmp1 = trades.copy()
tmp1[tmp1.quantity > 80]['price'] = 100
tmp1
```

{{< output >}}
```nb-output
/opt/conda/lib/python3.7/site-packages/ipykernel_launcher.py:2: SettingWithCopyWarning: 
A value is trying to be set on a copy of a slice from a DataFrame.
Try using .loc[row_indexer,col_indexer] = value instead

See the caveats in the documentation: http://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#returning-a-view-versus-a-copy
  
```
{{< /output >}}




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2016-05-25 13:30:01.023</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2016-05-25 13:30:01.038</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>GOOG</td>
      <td>720.77</td>
      <td>100</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>GOOG</td>
      <td>720.92</td>
      <td>100</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>AAPL</td>
      <td>98.00</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



To understand, we must look under the hood:
```
df.loc[df.A > 5, 'B'] = 4
# becomes
df.__setitem__((df.A > 5, 'B'), 4)
```

With a single `__setitem__` call to df. On the otherhand, consider this code:
```
df[df.A > 5]['B'] = 4
# becomes
df.__getitem__(df.A > 5).__setitem__('B", 4)
```

Now, depending on whether `__getitem__` returned a view or a copy, the `__setitem__` operation may not work.

The documentation addresses these issues, [here](https://pandas-docs.github.io/pandas-docs-travis/user_guide/indexing.html#returning-a-view-versus-a-copy).  But, to summarize:

> Whenever an array of labels or a boolean vector are involved in the indexing operation, the result will be a copy.  With single label / scalar indexing and slicing, e.g. df.ix[3:6] or df.ix[:, 'A'], a view will be returned.

Finally, the `.loc` method gives us what we want because we can use it with boolean indexing.

```python
tmp1.quantity > 80
```




{{< output >}}
```nb-output
0    False
1     True
2     True
3     True
4     True
Name: quantity, dtype: bool
```
{{< /output >}}



```python
tmp1 = trades.copy()
tmp1.loc[tmp1.quantity > 80, 'price'] = 100
tmp1
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>timestamp</th>
      <th>ticker</th>
      <th>price</th>
      <th>quantity</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2016-05-25 13:30:01.023</td>
      <td>MSFT</td>
      <td>51.95</td>
      <td>75</td>
    </tr>
    <tr>
      <th>1</th>
      <td>2016-05-25 13:30:01.038</td>
      <td>MSFT</td>
      <td>100.00</td>
      <td>155</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>GOOG</td>
      <td>100.00</td>
      <td>100</td>
    </tr>
    <tr>
      <th>3</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>GOOG</td>
      <td>100.00</td>
      <td>100</td>
    </tr>
    <tr>
      <th>4</th>
      <td>2016-05-25 13:30:03.048</td>
      <td>AAPL</td>
      <td>100.00</td>
      <td>100</td>
    </tr>
  </tbody>
</table>
</div>



## General Usage

### Timestamps

A pandas object type is used for text or mixed numeric and non-numeric values. To get the correct order of the timestamp column we need to change it to the datetime64 type.

Replacing datetime values has its own unique manner, of course.  Don't want to lose this:

```python
df.timestamp = pd.to_datetime(df.timestamp.str.replace("D", "T"))
```

### Merge

Merge with an indicator for where the rows came from

```python
df_merge = left.merge(right, on='key', how='left', indicator=True)
```

The `_merge` column is used to check for unexpected rows

```python
df_merge._merge.value_counts()
```

Merge by the nearest (not exact) timestamp

```python
pd.merge_asof(trades, quotes, on="timestamp", by='ticker', tolerance=pd.Timedelta('10ms'), direction='backward')
```

### Missing values

Because Numpy has no native NA type, pandas uses multiple values denote a missing value:
* NaN for numeric/object missing values
* NaT for DateTime missing values
* None, which comes from Python

What surprised me is that None equals None in Python, but nan doesn’t equal nan in numpy.

```python
None == None
```

```python
pd.np.nan == pd.np.nan
```

This is important so that we don’t filter values by None:

```python
df[df.some_column == None]# instead use:
df[df.some_column.isnull()]
```

### Report creation

Pandas (with XlsxWriter library) allows us to make an Excel sheet with graphs and other Excel functionality.  We need to define the type of the chart (line chart in our example) and the data series for the chart (the data series needs to be in the Excel spreadsheet).

```python
report_name = 'example_report.xlsx'
sheet_name = 'Sheet1'
writer = pd.ExcelWriter(report_name, engine='xlsxwriter')
df.to_excel(writer, sheet_name=sheet_name, index=False)
# writer.save()

# define the workbook
workbook = writer.book
worksheet = writer.sheets[sheet_name]
# create a chart line object
chart = workbook.add_chart({'type': 'line'})
# configure the series of the chart from the spreadsheet
# using a list of values instead of category/value formulas:
#     [sheetname, first_row, first_col, last_row, last_col]
chart.add_series({
    'categories': [sheet_name, 1, 0, 3, 0],
    'values':     [sheet_name, 1, 1, 3, 1],
})
# configure the chart axes
chart.set_x_axis({'name': 'Index', 'position_axis': 'on_tick'})
chart.set_y_axis({'name': 'Value', 'major_gridlines': {'visible': False}})
# place the chart on the worksheet
worksheet.insert_chart('E2', chart)
# output the excel file
writer.save()
```

### Saving objects

When we save this file as CSV, it takes almost 300 MB on the hard drive.

```python
df.to_csv('random_data.csv', index=False)
```

With a single argument compression='gzip', we can reduce the file size to 136 MB.

df.to_csv('random_data.gz', compression='gzip', index=False)

It is also easy to read the gzipped data to the DataFrame, so we don’t lose any functionality.

```python
df = pd.read_csv('random_data.gz')
```

## Specific examples

### Negate a string replacement

You can use negative look ahead `(?!)` assertion; `^(?!.*fish).*\\(` will firstly assert the pattern doesn't contain the word fish and then match every thing till the end of string and replace it with foo:

* `^` denotes the beginning of string, combined with `(?!.*fish)`, it asserts at BOS that there is no pattern like `.*fish` in the string;
* If the assertion succeeds, it matches everything till the end of string `.*\\)`, and replaces it with `foo`; If the assertion fails, the pattern doesn't match, nothing would happen;

so:

```python
df.replace(r'^(?!.*fish).*$', 'foo', regex=True)
```

### Remove Outliers


```python
df['size_clip'] = df['size'].clip(df['size'].quantile(0.01),
                                  df['size'].quantile(0.99))
df.size_clip.plot(kind='box')
```

### Bin / group data

```python
df['price_discrete_labels'] = pd.cut(df.price, 5, labels=['very low', 'low', 'mid', 'high', 'very high'])
df['price_discrete_labels'].value_counts()
```

Equal-sized groups

```python
df['price_discrete_equal_bins'] = pd.qcut(df.price, 5)
df['price_discrete_equal_bins'].value_counts()
```

## Conclusion

After reviewing these examples, we hope you agree that R is a terse, minimalistic, and powerful language.  You can do so many things with just the dataframe operator that it makes interacting with R a joy.  It is so much of a joy that I typically don't know how the operations are actually being performed - they just work.

Pandas is different.  It is bolted-on to Python, and its syntax is either not consistent or is just un-wieldly.  But maybe that is a good thing, because with Python I'm typically automating a process - not performing an interactive investigation.  I want to be forced to understand how the data is actually being worked, and I want to optimize operations for performance because it is a process that will be automated.

Let's stop the impassioned vitrioles of one clan against another, and use each of these tools for their respective strengths.
