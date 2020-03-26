
+++
title = "An Introduction to Numpy and Pandas"
date = "2020-03-22"
author = "Jason Beach"
categories = ["Introduction_Tutorial", "Data_Science"]
tags = ["numpy", "pandas", "python"]
+++


Numpy and Pandas are the basic data science tools in the Python environment.  Having a good understanding of their capabilities and how they process data is imperative to writing optimal code.  This post provides an introductory overview and a refresher for those who might come back to the libraries after taking a break.  The end of the post explains external interfaces for increasing code execution and performing more sophisticated matrix operations.

## Pandas Series and Dataframe

These are the basic data structures used by Pandas.  Pandas derives its name from Pan(el) da(ta)s. Panel data is an econometrics term for data recorded over time.  Pandas author, Wes McKinney, was working in the finanical industry when he began writing it.

* Series objects: 1D array, similar to a column in a spreadsheet
* DataFrame objects: 2D table, similar to a spreadsheet, dictionary of Series 
* ~~Panel objects: Dictionary of DataFrames, similar to sheet in MS Excel~~removed in 0.25.0

### Config

Let's load our modules.  Numpy is always used with Pandas because it is an underlying dependency.

```python
import numpy as np
import pandas as pd
```

We will create a few DataFrames to work with throughout the post.

Series are similar to R's vector `c()`, and is a column within a Pandas Dataframe.

```python
import pandas as pd
s = pd.Series([1,3,5,np.nan,6,8])
dates = pd.date_range('20130101', periods=6)
df1 = pd.DataFrame(np.random.randn(6,4), index=dates, columns=list('ABCD'))
df1
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
    </tr>
  </tbody>
</table>
</div>



```python
df2 = pd.DataFrame({ 'E' : 1.,
   ....:                      'F' : pd.Timestamp('20130102'),
   ....:                      'G' : pd.Series(1,index=list(range(4)),dtype='float32'),
   ....:                      'H' : np.array([3] * 4,dtype='int32'),
   ....:                      'I' : pd.Categorical(["test","train","test","train"]),
   ....:                      'J' : 'foo' })
df2
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
      <th>E</th>
      <th>F</th>
      <th>G</th>
      <th>H</th>
      <th>I</th>
      <th>J</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3</td>
      <td>test</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3</td>
      <td>train</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3</td>
      <td>test</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3</td>
      <td>train</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



```python
tmpdf2 = df2.copy(deep=True)
tmpdf2.set_index(tmpdf2.F, inplace=True)
df3 = df1.join(tmpdf2, how='outer')
#or: df3 = pd.merge(df1, tmpdf2, how='outer', left_index=True, right_index=True)
df3
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>E</th>
      <th>F</th>
      <th>G</th>
      <th>H</th>
      <th>I</th>
      <th>J</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3.0</td>
      <td>test</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3.0</td>
      <td>train</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3.0</td>
      <td>test</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3.0</td>
      <td>train</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



```python
df4 = pd.DataFrame({'A': ['foo', 'bar', 'foo', 'bar',
   ....:                          'foo', 'bar', 'foo', 'foo'],
   ....:                    'B': ['one', 'one', 'two', 'three',
   ....:                          'two', 'two', 'one', 'three'],
   ....:                    'C': np.random.randn(8),
   ....:                    'D': np.random.randn(8)})
df4
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.870843</td>
      <td>1.255164</td>
    </tr>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>one</td>
      <td>-0.678605</td>
      <td>0.569444</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>0.270890</td>
      <td>0.692131</td>
    </tr>
    <tr>
      <th>3</th>
      <td>bar</td>
      <td>three</td>
      <td>-1.008900</td>
      <td>1.841500</td>
    </tr>
    <tr>
      <th>4</th>
      <td>foo</td>
      <td>two</td>
      <td>0.381278</td>
      <td>0.918376</td>
    </tr>
    <tr>
      <th>5</th>
      <td>bar</td>
      <td>two</td>
      <td>-0.666534</td>
      <td>-0.483262</td>
    </tr>
    <tr>
      <th>6</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.132010</td>
      <td>1.949751</td>
    </tr>
    <tr>
      <th>7</th>
      <td>foo</td>
      <td>three</td>
      <td>1.517630</td>
      <td>-0.458782</td>
    </tr>
  </tbody>
</table>
</div>



### Index and axes

```python
c = df1.columns.tolist()
c
```




{{< output >}}
```nb-output
['A', 'B', 'C', 'D']
```
{{< /output >}}



```python
n = df1.index.tolist()
n
```




{{< output >}}
```nb-output
[Timestamp('2013-01-01 00:00:00', freq='D'),
 Timestamp('2013-01-02 00:00:00', freq='D'),
 Timestamp('2013-01-03 00:00:00', freq='D'),
 Timestamp('2013-01-04 00:00:00', freq='D'),
 Timestamp('2013-01-05 00:00:00', freq='D'),
 Timestamp('2013-01-06 00:00:00', freq='D')]
```
{{< /output >}}



```python
#calculate sum (across rows) for each column
df1.sum(axis=0)
```




{{< output >}}
```nb-output
A   -5.885887
B   -0.973229
C   -3.602993
D   -1.248308
dtype: float64
```
{{< /output >}}



```python
pd.concat([df1,df3], axis=0, sort=False).head()
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>E</th>
      <th>F</th>
      <th>G</th>
      <th>H</th>
      <th>I</th>
      <th>J</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>NaN</td>
      <td>NaT</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



### Data types

NumPy arrays have one dtype for the entire array, while pandas DataFrames have one dtype per column. When you call `DataFrame.to_numpy()`, pandas will find the NumPy dtype that can hold all of the dtypes in the DataFrame. This may end up being object, which requires casting every value to a Python object.

```python
arr = np.array([1,2,3])
pd.Series(arr).values
```




{{< output >}}
```nb-output
array([1, 2, 3])
```
{{< /output >}}



```python
arr.dtype
```




{{< output >}}
```nb-output
dtype('int64')
```
{{< /output >}}



```python
df1.A.to_numpy()
```




{{< output >}}
```nb-output
array([-1.36082656, -0.2104261 , -1.82932214, -1.32563421, -1.18457701,
        0.024899  ])
```
{{< /output >}}



### Locate by column label, index

```python
n[0]
```




{{< output >}}
```nb-output
Timestamp('2013-01-01 00:00:00', freq='D')
```
{{< /output >}}



```python
df1.loc[n[0],]
```




{{< output >}}
```nb-output
A   -1.360827
B   -0.871347
C   -1.603602
D    0.073078
Name: 2013-01-01 00:00:00, dtype: float64
```
{{< /output >}}



```python
df1.loc[:,[c[0],c[1]] ]
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
      <th>A</th>
      <th>B</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
    </tr>
  </tbody>
</table>
</div>



```python
df1.loc[n[0],c[0]]
```




{{< output >}}
```nb-output
-1.3608265619610327
```
{{< /output >}}



```python
df1[c[0]][:5]
```




{{< output >}}
```nb-output
2013-01-01   -1.360827
2013-01-02   -0.210426
2013-01-03   -1.829322
2013-01-04   -1.325634
2013-01-05   -1.184577
Freq: D, Name: A, dtype: float64
```
{{< /output >}}



```python
df1.iloc[0,]
```




{{< output >}}
```nb-output
A   -1.360827
B   -0.871347
C   -1.603602
D    0.073078
Name: 2013-01-01 00:00:00, dtype: float64
```
{{< /output >}}



```python
df1.iloc[:,0]
```




{{< output >}}
```nb-output
2013-01-01   -1.360827
2013-01-02   -0.210426
2013-01-03   -1.829322
2013-01-04   -1.325634
2013-01-05   -1.184577
2013-01-06    0.024899
Freq: D, Name: A, dtype: float64
```
{{< /output >}}



```python
df1.iloc[0,0]
```




{{< output >}}
```nb-output
-1.3608265619610327
```
{{< /output >}}



### Locate by boolean

```python
df1.A > 0
```




{{< output >}}
```nb-output
2013-01-01    False
2013-01-02    False
2013-01-03    False
2013-01-04    False
2013-01-05    False
2013-01-06     True
Freq: D, Name: A, dtype: bool
```
{{< /output >}}



```python
df1[df1.A > 0]
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
    </tr>
  </tbody>
</table>
</div>



```python
df5 = df1.copy()
df5['K'] = ['one', 'one','two','three','four','three']
df5['K']
```




{{< output >}}
```nb-output
2013-01-01      one
2013-01-02      one
2013-01-03      two
2013-01-04    three
2013-01-05     four
2013-01-06    three
Freq: D, Name: K, dtype: object
```
{{< /output >}}



```python
df5[df5['K'].isin(['two','four'])]
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>K</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>two</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>four</td>
    </tr>
  </tbody>
</table>
</div>



### Sort values

```python
#sort
df1.sort_values([c[0]], ascending=False)
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
    </tr>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
    </tr>
  </tbody>
</table>
</div>



### Subset

```python
df1.query('A > 0')
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
    </tr>
  </tbody>
</table>
</div>



```python
df1[ (df1['A'] > 0) ]
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
    </tr>
  </tbody>
</table>
</div>



### Setting values

```python
s1 = pd.Series([1,2,3,4,5,6], index=pd.date_range('20130102', periods=6))
df1['F'] = s1
df1
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
      <td>5.0</td>
    </tr>
  </tbody>
</table>
</div>



```python
df5 = df1.copy()
df5[df5 > 0] = -df5
df5
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>-0.073078</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>-0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>-1.0</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>-0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>-2.0</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>-0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>-3.0</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>-0.798301</td>
      <td>-0.913562</td>
      <td>-4.0</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>-0.024899</td>
      <td>-0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
      <td>-5.0</td>
    </tr>
  </tbody>
</table>
</div>



```python
df5.index.to_series().apply(pd.to_datetime)
```




{{< output >}}
```nb-output
2013-01-01   2013-01-01
2013-01-02   2013-01-02
2013-01-03   2013-01-03
2013-01-04   2013-01-04
2013-01-05   2013-01-05
2013-01-06   2013-01-06
Freq: D, dtype: datetime64[ns]
```
{{< /output >}}



```python
df5.index.to_series().dt.year
```




{{< output >}}
```nb-output
2013-01-01    2013
2013-01-02    2013
2013-01-03    2013
2013-01-04    2013
2013-01-05    2013
2013-01-06    2013
Freq: D, dtype: int64
```
{{< /output >}}



### Calculations

```python
df1.apply(np.cumsum)
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-1.571253</td>
      <td>-0.359628</td>
      <td>-2.641412</td>
      <td>-0.673604</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-3.400575</td>
      <td>-0.016067</td>
      <td>-2.646715</td>
      <td>-1.986209</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-4.726209</td>
      <td>0.158169</td>
      <td>-3.567816</td>
      <td>-2.052103</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-5.910786</td>
      <td>-1.225748</td>
      <td>-2.769514</td>
      <td>-1.138541</td>
      <td>10.0</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>-5.885887</td>
      <td>-0.973229</td>
      <td>-3.602993</td>
      <td>-1.248308</td>
      <td>15.0</td>
    </tr>
  </tbody>
</table>
</div>



```python
df1.apply(lambda x: x.max() - x.min())
```




{{< output >}}
```nb-output
A    1.854221
B    1.895637
C    2.401903
D    2.226167
F    4.000000
dtype: float64
```
{{< /output >}}



```python
# string ops - vectorized
df1.iloc[:,1].astype('str').str.lower()
```




{{< output >}}
```nb-output
2013-01-01    -0.8713474062085093
2013-01-02     0.5117196166006319
2013-01-03     0.3435604532681823
2013-01-04    0.17423665911328937
2013-01-05    -1.3839171647406576
2013-01-06     0.2525192847352602
Freq: D, Name: B, dtype: object
```
{{< /output >}}



### Missing values

```python
# missing data
df1.dropna(how='any')
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
      <td>5.0</td>
    </tr>
  </tbody>
</table>
</div>



```python
df1.dropna(subset=['F'], how='all')
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
      <td>5.0</td>
    </tr>
  </tbody>
</table>
</div>



```python
df1.fillna(value=5)
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>0.024899</td>
      <td>0.252519</td>
      <td>-0.833479</td>
      <td>-0.109767</td>
      <td>5.0</td>
    </tr>
  </tbody>
</table>
</div>



```python
pd.isnull(df1)
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>True</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
    <tr>
      <th>2013-01-06</th>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
      <td>False</td>
    </tr>
  </tbody>
</table>
</div>



### Merge and shape

```python
df1.append(df2, ignore_index=True, sort=True).head()
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>E</th>
      <th>F</th>
      <th>G</th>
      <th>H</th>
      <th>I</th>
      <th>J</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>NaN</td>
      <td>1</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>NaN</td>
      <td>2</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>NaN</td>
      <td>3</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>NaN</td>
      <td>4</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



```python
pieces = [df1[:3], df1[3:7], df1[7:]]
pd.concat(pieces).head()
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>2013-01-01</th>
      <td>-1.360827</td>
      <td>-0.871347</td>
      <td>-1.603602</td>
      <td>0.073078</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>2013-01-02</th>
      <td>-0.210426</td>
      <td>0.511720</td>
      <td>-1.037810</td>
      <td>-0.746683</td>
      <td>1.0</td>
    </tr>
    <tr>
      <th>2013-01-03</th>
      <td>-1.829322</td>
      <td>0.343560</td>
      <td>-0.005303</td>
      <td>-1.312605</td>
      <td>2.0</td>
    </tr>
    <tr>
      <th>2013-01-04</th>
      <td>-1.325634</td>
      <td>0.174237</td>
      <td>-0.921101</td>
      <td>-0.065894</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>2013-01-05</th>
      <td>-1.184577</td>
      <td>-1.383917</td>
      <td>0.798301</td>
      <td>0.913562</td>
      <td>4.0</td>
    </tr>
  </tbody>
</table>
</div>



### GroupBy

```python
df4.groupby(['A','B']).sum()
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
      <th>C</th>
      <th>D</th>
    </tr>
    <tr>
      <th>A</th>
      <th>B</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="3" valign="top">bar</th>
      <th>one</th>
      <td>-0.678605</td>
      <td>0.569444</td>
    </tr>
    <tr>
      <th>three</th>
      <td>-1.008900</td>
      <td>1.841500</td>
    </tr>
    <tr>
      <th>two</th>
      <td>-0.666534</td>
      <td>-0.483262</td>
    </tr>
    <tr>
      <th rowspan="3" valign="top">foo</th>
      <th>one</th>
      <td>-1.002854</td>
      <td>3.204916</td>
    </tr>
    <tr>
      <th>three</th>
      <td>1.517630</td>
      <td>-0.458782</td>
    </tr>
    <tr>
      <th>two</th>
      <td>0.652168</td>
      <td>1.610507</td>
    </tr>
  </tbody>
</table>
</div>



### Stacked

```python
stacked = df4.stack()
stacked.index[:4]
```




{{< output >}}
```nb-output
MultiIndex([(0, 'A'),
            (0, 'B'),
            (0, 'C'),
            (0, 'D')],
           )
```
{{< /output >}}



```python
stacked.head()
```




{{< output >}}
```nb-output
0  A         foo
   B         one
   C   -0.870843
   D     1.25516
1  A         bar
dtype: object
```
{{< /output >}}



```python
stacked.unstack().head()
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.870843</td>
      <td>1.25516</td>
    </tr>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>one</td>
      <td>-0.678605</td>
      <td>0.569444</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>0.27089</td>
      <td>0.692131</td>
    </tr>
    <tr>
      <th>3</th>
      <td>bar</td>
      <td>three</td>
      <td>-1.0089</td>
      <td>1.8415</td>
    </tr>
    <tr>
      <th>4</th>
      <td>foo</td>
      <td>two</td>
      <td>0.381278</td>
      <td>0.918376</td>
    </tr>
  </tbody>
</table>
</div>



### Pivot table

```python
df4
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.870843</td>
      <td>1.255164</td>
    </tr>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>one</td>
      <td>-0.678605</td>
      <td>0.569444</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>0.270890</td>
      <td>0.692131</td>
    </tr>
    <tr>
      <th>3</th>
      <td>bar</td>
      <td>three</td>
      <td>-1.008900</td>
      <td>1.841500</td>
    </tr>
    <tr>
      <th>4</th>
      <td>foo</td>
      <td>two</td>
      <td>0.381278</td>
      <td>0.918376</td>
    </tr>
    <tr>
      <th>5</th>
      <td>bar</td>
      <td>two</td>
      <td>-0.666534</td>
      <td>-0.483262</td>
    </tr>
    <tr>
      <th>6</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.132010</td>
      <td>1.949751</td>
    </tr>
    <tr>
      <th>7</th>
      <td>foo</td>
      <td>three</td>
      <td>1.517630</td>
      <td>-0.458782</td>
    </tr>
  </tbody>
</table>
</div>



```python
# pivot tables (http://pbpython.com/pandas-pivot-table-explained.html)
df4["A"] = df4["A"].astype("category")
df4["A"].cat.set_categories(["foo", "bar"],inplace=True)
```

```python
pd.pivot_table(df4,index=['A','B'])	#same as:
df4.groupby(['A','B']).mean()
df4.groupby(['A','B'])['D'].agg([np.sum,np.std])
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
      <th>sum</th>
      <th>std</th>
    </tr>
    <tr>
      <th>A</th>
      <th>B</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="3" valign="top">foo</th>
      <th>one</th>
      <td>3.204916</td>
      <td>0.491147</td>
    </tr>
    <tr>
      <th>three</th>
      <td>-0.458782</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>two</th>
      <td>1.610507</td>
      <td>0.159980</td>
    </tr>
    <tr>
      <th rowspan="3" valign="top">bar</th>
      <th>one</th>
      <td>0.569444</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>three</th>
      <td>1.841500</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>two</th>
      <td>-0.483262</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



```python
pd.pivot_table(df4,index=['A','B'], values=['D'], aggfunc=np.sum)
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
      <th>D</th>
    </tr>
    <tr>
      <th>A</th>
      <th>B</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="3" valign="top">foo</th>
      <th>one</th>
      <td>3.204916</td>
    </tr>
    <tr>
      <th>three</th>
      <td>-0.458782</td>
    </tr>
    <tr>
      <th>two</th>
      <td>1.610507</td>
    </tr>
    <tr>
      <th rowspan="3" valign="top">bar</th>
      <th>one</th>
      <td>0.569444</td>
    </tr>
    <tr>
      <th>three</th>
      <td>1.841500</td>
    </tr>
    <tr>
      <th>two</th>
      <td>-0.483262</td>
    </tr>
  </tbody>
</table>
</div>



```python
pd.pivot_table(df4,index=['A'], columns=['B'], values=['D'], aggfunc=np.sum)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="3" halign="left">D</th>
    </tr>
    <tr>
      <th>B</th>
      <th>one</th>
      <th>three</th>
      <th>two</th>
    </tr>
    <tr>
      <th>A</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>foo</th>
      <td>3.204916</td>
      <td>-0.458782</td>
      <td>1.610507</td>
    </tr>
    <tr>
      <th>bar</th>
      <td>0.569444</td>
      <td>1.841500</td>
      <td>-0.483262</td>
    </tr>
  </tbody>
</table>
</div>



```python
pd.pivot_table(df4,index=['A'], columns=['B'], values=['D'], aggfunc=np.sum, fill_value=0,margins=True)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th></th>
      <th colspan="4" halign="left">D</th>
    </tr>
    <tr>
      <th>B</th>
      <th>one</th>
      <th>three</th>
      <th>two</th>
      <th>All</th>
    </tr>
    <tr>
      <th>A</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>foo</th>
      <td>3.204916</td>
      <td>-0.458782</td>
      <td>1.610507</td>
      <td>4.356641</td>
    </tr>
    <tr>
      <th>bar</th>
      <td>0.569444</td>
      <td>1.841500</td>
      <td>-0.483262</td>
      <td>1.927682</td>
    </tr>
    <tr>
      <th>All</th>
      <td>3.774359</td>
      <td>1.382718</td>
      <td>1.127246</td>
      <td>6.284323</td>
    </tr>
  </tbody>
</table>
</div>



```python
pd.pivot_table(df4, index=['A', 'B'], columns=['C'], values='D')
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
      <th>C</th>
      <th>-1.008900</th>
      <th>-0.870843</th>
      <th>-0.678605</th>
      <th>-0.666534</th>
      <th>-0.132010</th>
      <th>0.270890</th>
      <th>0.381278</th>
      <th>1.517630</th>
    </tr>
    <tr>
      <th>A</th>
      <th>B</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="3" valign="top">foo</th>
      <th>one</th>
      <td>NaN</td>
      <td>1.255164</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>1.949751</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>three</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>-0.458782</td>
    </tr>
    <tr>
      <th>two</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0.692131</td>
      <td>0.918376</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th rowspan="3" valign="top">bar</th>
      <th>one</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>0.569444</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>three</th>
      <td>1.8415</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>two</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>-0.483262</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



```python
pd.pivot_table(df4, index=['A'], columns=['B','C'], values='D')
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead tr th {
        text-align: left;
    }

    .dataframe thead tr:last-of-type th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr>
      <th>B</th>
      <th colspan="3" halign="left">one</th>
      <th colspan="2" halign="left">three</th>
      <th colspan="3" halign="left">two</th>
    </tr>
    <tr>
      <th>C</th>
      <th>-0.870843</th>
      <th>-0.678605</th>
      <th>-0.132010</th>
      <th>-1.008900</th>
      <th>1.517630</th>
      <th>-0.666534</th>
      <th>0.270890</th>
      <th>0.381278</th>
    </tr>
    <tr>
      <th>A</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>foo</th>
      <td>1.255164</td>
      <td>NaN</td>
      <td>1.949751</td>
      <td>NaN</td>
      <td>-0.458782</td>
      <td>NaN</td>
      <td>0.692131</td>
      <td>0.918376</td>
    </tr>
    <tr>
      <th>bar</th>
      <td>NaN</td>
      <td>0.569444</td>
      <td>NaN</td>
      <td>1.8415</td>
      <td>NaN</td>
      <td>-0.483262</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
  </tbody>
</table>
</div>



### Timeseries

```python
rng = pd.date_range('1/1/2012', periods=100, freq='S')
ts = pd.Series(np.random.randint(0, 500, len(rng)), index=rng)
ts.head()
```




{{< output >}}
```nb-output
2012-01-01 00:00:00    114
2012-01-01 00:00:01    279
2012-01-01 00:00:02     32
2012-01-01 00:00:03    495
2012-01-01 00:00:04    433
Freq: S, dtype: int64
```
{{< /output >}}



```python
## frequency conversion (e.g., converting secondly data into 5-minutely data)
ts.resample('5Min').sum()
```




{{< output >}}
```nb-output
2012-01-01    24652
Freq: 5T, dtype: int64
```
{{< /output >}}



```python
## time zones
ts_utc = ts.tz_localize('UTC')
ts_utc.tz_convert('US/Eastern').head()
```




{{< output >}}
```nb-output
2011-12-31 19:00:00-05:00    114
2011-12-31 19:00:01-05:00    279
2011-12-31 19:00:02-05:00     32
2011-12-31 19:00:03-05:00    495
2011-12-31 19:00:04-05:00    433
Freq: S, dtype: int64
```
{{< /output >}}



```python
## format
rng = pd.date_range('1/1/2012', periods=5, freq='M')
ts = pd.Series(np.random.randn(len(rng)), index=rng)
ps = ts.to_period()
ps.to_timestamp()
```




{{< output >}}
```nb-output
2012-01-01    2.490119
2012-02-01    0.237758
2012-03-01    0.249177
2012-04-01   -0.015938
2012-05-01   -0.314638
Freq: MS, dtype: float64
```
{{< /output >}}



```python
## timestamp conversion
prng = pd.period_range('1990Q1', '2000Q4', freq='Q-NOV')
ts = pd.Series(np.random.randn(len(prng)), prng)
ts.index = (prng.asfreq('M', 'e') + 1).asfreq('H', 's') + 9
ts.head()
```




{{< output >}}
```nb-output
1990-03-01 09:00   -0.546684
1990-06-01 09:00    0.091767
1990-09-01 09:00   -1.180808
1990-12-01 09:00    0.929530
1991-03-01 09:00    1.646660
Freq: H, dtype: float64
```
{{< /output >}}



### Categorical data

```python
df5 = df4.copy(deep=True)
```

```python
## create categories
df5['incomeranges'] = pd.cut(df5['C'], 14)
df5["A"] = df5["A"].astype('category')
df5.head()
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>incomeranges</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.870843</td>
      <td>1.255164</td>
      <td>(-1.011, -0.828]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>one</td>
      <td>-0.678605</td>
      <td>0.569444</td>
      <td>(-0.828, -0.648]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>0.270890</td>
      <td>0.692131</td>
      <td>(0.254, 0.435]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>bar</td>
      <td>three</td>
      <td>-1.008900</td>
      <td>1.841500</td>
      <td>(-1.011, -0.828]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>foo</td>
      <td>two</td>
      <td>0.381278</td>
      <td>0.918376</td>
      <td>(0.254, 0.435]</td>
    </tr>
  </tbody>
</table>
</div>



```python
df5.A
```




{{< output >}}
```nb-output
0    foo
1    bar
2    foo
3    bar
4    foo
5    bar
6    foo
7    foo
Name: A, dtype: category
Categories (2, object): [foo, bar]
```
{{< /output >}}



```python
#rename to more meaningful
df5["A"].cat.categories = ["foo", "bar"]
df5.head()
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>incomeranges</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.870843</td>
      <td>1.255164</td>
      <td>(-1.011, -0.828]</td>
    </tr>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>one</td>
      <td>-0.678605</td>
      <td>0.569444</td>
      <td>(-0.828, -0.648]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>0.270890</td>
      <td>0.692131</td>
      <td>(0.254, 0.435]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>bar</td>
      <td>three</td>
      <td>-1.008900</td>
      <td>1.841500</td>
      <td>(-1.011, -0.828]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>foo</td>
      <td>two</td>
      <td>0.381278</td>
      <td>0.918376</td>
      <td>(0.254, 0.435]</td>
    </tr>
  </tbody>
</table>
</div>



```python
# domain of categories
df5["A"] = df5["A"].cat.set_categories(["very bad", "bar", "medium", "foo", "very good"])
df5.sort_values(by="A").head()
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>incomeranges</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>bar</td>
      <td>one</td>
      <td>-0.678605</td>
      <td>0.569444</td>
      <td>(-0.828, -0.648]</td>
    </tr>
    <tr>
      <th>3</th>
      <td>bar</td>
      <td>three</td>
      <td>-1.008900</td>
      <td>1.841500</td>
      <td>(-1.011, -0.828]</td>
    </tr>
    <tr>
      <th>5</th>
      <td>bar</td>
      <td>two</td>
      <td>-0.666534</td>
      <td>-0.483262</td>
      <td>(-0.828, -0.648]</td>
    </tr>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.870843</td>
      <td>1.255164</td>
      <td>(-1.011, -0.828]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>0.270890</td>
      <td>0.692131</td>
      <td>(0.254, 0.435]</td>
    </tr>
  </tbody>
</table>
</div>



```python
df5['A'].value_counts()
```




{{< output >}}
```nb-output
foo          5
bar          3
very good    0
medium       0
very bad     0
Name: A, dtype: int64
```
{{< /output >}}



```python
## subset on category
tmp = df5[df5['A'] == "foo"]
tmp
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
      <th>A</th>
      <th>B</th>
      <th>C</th>
      <th>D</th>
      <th>incomeranges</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.870843</td>
      <td>1.255164</td>
      <td>(-1.011, -0.828]</td>
    </tr>
    <tr>
      <th>2</th>
      <td>foo</td>
      <td>two</td>
      <td>0.270890</td>
      <td>0.692131</td>
      <td>(0.254, 0.435]</td>
    </tr>
    <tr>
      <th>4</th>
      <td>foo</td>
      <td>two</td>
      <td>0.381278</td>
      <td>0.918376</td>
      <td>(0.254, 0.435]</td>
    </tr>
    <tr>
      <th>6</th>
      <td>foo</td>
      <td>one</td>
      <td>-0.132010</td>
      <td>1.949751</td>
      <td>(-0.287, -0.107]</td>
    </tr>
    <tr>
      <th>7</th>
      <td>foo</td>
      <td>three</td>
      <td>1.517630</td>
      <td>-0.458782</td>
      <td>(1.337, 1.518]</td>
    </tr>
  </tbody>
</table>
</div>



```python
##TODO:subset with limited column
df5[A & B][['C', 'D']][:10]
```

```python
#TODO:Plotting
## options
### Make the graphs a bit prettier, and bigger
pd.set_option('display.mpl_style', 'default') 
### Always display all the columns
pd.set_option('display.line_width', 5000) 
pd.set_option('display.max_columns', 60) 
figsize(15, 5)
```

### Series calculations

```python
df2
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
      <th>E</th>
      <th>F</th>
      <th>G</th>
      <th>H</th>
      <th>I</th>
      <th>J</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3</td>
      <td>test</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3</td>
      <td>train</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3</td>
      <td>test</td>
      <td>foo</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.0</td>
      <td>2013-01-02</td>
      <td>1.0</td>
      <td>3</td>
      <td>train</td>
      <td>foo</td>
    </tr>
  </tbody>
</table>
</div>



```python
df2.H.values
```




{{< output >}}
```nb-output
array([3, 3, 3, 3], dtype=int32)
```
{{< /output >}}



```python
df2.H.abs().tolist()
```




{{< output >}}
```nb-output
[3, 3, 3, 3]
```
{{< /output >}}



```python
df2.H.mean().tolist()
```




{{< output >}}
```nb-output
3.0
```
{{< /output >}}



## Numpy

Pandas uses Numpy's ndarray for many of its underlying operations.  For example, you can use the DataFrame attribute `.values` to represent a DataFrame df as a NumPy array. You can also pass pandas data structures to NumPy methods.

Now that we've looked into Pandas columns (Series), lets take at what is driving these operations.  This low-level perspective will help us understand strengths and weeknesses, as well as give us a much better look into how to improve our code.

_References_

* [doc: numpy](https://docs.scipy.org/doc/numpy/reference/generated/numpy.ndarray.html)
* [doc: ndarray](https://docs.scipy.org/doc/numpy/reference/arrays.ndarray.html)

### Introduction

NumPy's arrays are more compact than Python lists -- a list of lists as you describe, in Python, would take at least 20 MB or so, while a NumPy 3D array with single-precision floats in the cells would fit in 4 MB. Access in reading and writing items is also faster with NumPy.

The difference is mostly due to "indirectness" -- a Python list is an array of pointers to Python objects, at least 4 bytes per pointer plus 16 bytes for even the smallest Python object (4 for type pointer, 4 for reference count, 4 for value -- and the memory allocators rounds up to 16). A NumPy array is an array of uniform values -- single-precision numbers takes 4 bytes each, double-precision ones, 8 bytes. Less flexible, but you pay substantially for the flexibility of standard Python lists!

Because Numpy's popularity is based on optimization, lets focus work on memory and speed during our discussion.

__Memory layout__

The following attributes contain information about the memory layout of the array:

* `ndarray.flags`   Information about the memory layout of the array.
* `ndarray.shape`   Tuple of array dimensions.
* `ndarray.ndim`  Number of array dimensions.
* `ndarray.strides`   Tuple of bytes to step in each dimension when traversing an array.
* `ndarray.data`  Python buffer object pointing to the start of the array’s data 
* `ndarray.size`  Number of elements in the array.
* `ndarray.itemsize`  Length of one array element in bytes.
* `ndarray.Dtype` Type of elements in the array, i.e., int64, character
* `ndarray.nbytes`  Total bytes consumed by the elements of the array.
* `ndarray.base`  Base object if memory is from some other object.

`ndarray.__sizeof__()` is somewhat bigger (includes the object overhead), than `ndarray.nbytes`, which is the number of bytes in the allocated array.

```python
import sys
```

```python
arr = np.random.randn(10**3)
lst = list(arr)
arr2d = arr.reshape(20,50)
```

```python
print( len(lst) )
print( arr.shape )
print( arr2d.shape )
```

{{< output >}}
```nb-output
1000
(1000,)
(20, 50)
```
{{< /output >}}

```python
print( type(lst) )
print( type(arr) )
print( type(arr2d) )

print( type(lst[0]) )
print( arr.dtype )
```

{{< output >}}
```nb-output
<class 'list'>
<class 'numpy.ndarray'>
<class 'numpy.ndarray'>
<class 'numpy.float64'>
float64
```
{{< /output >}}

```python
#item
print( sys.getsizeof( lst[0] ) )
print( arr.itemsize )

#total
print( sys.getsizeof( lst ) )
print( sys.getsizeof( arr ) )
print( sys.getsizeof( arr2d ) )

print( arr.nbytes )
print( arr2d.nbytes )
```

{{< output >}}
```nb-output
32
8
9112
8096
112
8000
8000
```
{{< /output >}}

```python
print( arr.tobytes()[:100] )
```

{{< output >}}
```nb-output
b',!1\xcdk\\\xf0?\x8b\x0f\x93\x19)\xf0\xe7?v\xec3\xcb}e\xbf?\x89\x92\x0b\xac\xc4_\xb7?\x1d\xdb\\*\xdaG\xe2?}\x16\xf8n\x99\xcd\xd7\xbfc\xf3\xf9g\x87\xb5\x03\xc0\x04&\x86\xc7\x08*\xf4?\xb8j\xd6\x03}\xed\xef\xbf\xe6\xcf\xb0\x0e\x90\xe1\xd8\xbf{\xa2\x1dn\xe1\xef\xe1\xbfF\x90{\xfd\xf2\x14\xde\xbf\\\xb8pv'
```
{{< /output >}}

### Comparison of ndarry to list

Numpy array is easier to assign values than a list.

```python
a = np.array([1, 2, 5, 7, 8])
a[1:3] = -1
a
```




{{< output >}}
```nb-output
array([ 1, -1, -1,  7,  8])
```
{{< /output >}}



```python
b = [1, 2, 5, 7, 8]
try:
    b[1:3] = -1
except:
    print("TypeError: can only assign an iterable")
```

{{< output >}}
```nb-output
TypeError: can only assign an iterable
```
{{< /output >}}

ndarray slices are actually views on the same data buffer. If you modify it, it is going to modify the original ndarray as well.

```python
a=[1,2,5,7,8]
b=a[1:5]
b[1]=3
print(a)
print(b)
```

{{< output >}}
```nb-output
[1, 2, 5, 7, 8]
[2, 3, 7, 8]
```
{{< /output >}}

```python
a = np.array([1, 2, 5, 7, 8])
a_slice = a[1:5]
a_slice[1] = 1000
print( a )
print( a_slice)
```

{{< output >}}
```nb-output
[   1    2 1000    7    8]
[   2 1000    7    8]
```
{{< /output >}}

```python
a = np.array([1, 2, 5, 7, 8])
a_slice = a[1:5].copy()
a_slice[1] = 1000
print( a )
print( a_slice)
```

{{< output >}}
```nb-output
[1 2 5 7 8]
[   2 1000    7    8]
```
{{< /output >}}

ndarray slicing is different.  It uses: `arr[row_start:row_end, col_start:col_end]`

ndarray also allows boolean indexing.

```python
a = np.array([0, 1, 2, 5, 7, 8]).reshape(3,2)
a
```




{{< output >}}
```nb-output
array([[0, 1],
       [2, 5],
       [7, 8]])
```
{{< /output >}}



```python
rows_on = np.array([True, False, True])
a[rows_on,:]
```




{{< output >}}
```nb-output
array([[0, 1],
       [7, 8]])
```
{{< /output >}}



```python
(arr != 2)[:10]
```




{{< output >}}
```nb-output
array([ True,  True,  True,  True,  True,  True,  True,  True,  True,
        True])
```
{{< /output >}}



```python
arr[arr != 2] [:10]
```




{{< output >}}
```nb-output
array([ 1.02256375,  0.74806647,  0.12264239,  0.09130506,  0.57127102,
       -0.37192379, -2.46363717,  1.26026228, -0.99774028, -0.38876726])
```
{{< /output >}}



A comparison test of speed.

```python
from numpy import arange
from timeit import Timer

Nelements = 10000
Ntimeits = 10000

x = arange(Nelements)
y = range(Nelements)

t_numpy = Timer("x.sum()", "from __main__ import x")
t_list = Timer("sum(y)", "from __main__ import y")
print("numpy: %.3e" % (t_numpy.timeit(Ntimeits)/Ntimeits,))
print("list:  %.3e" % (t_list.timeit(Ntimeits)/Ntimeits,))
```

{{< output >}}
```nb-output
numpy: 1.171e-05
list:  1.768e-04
```
{{< /output >}}

### Creating matrices

Your typical arrays of random initializers are always useful.

```python
print( np.random.randint(1,10, 5) )
print( np.arange(1,10) )
```

{{< output >}}
```nb-output
[8 8 7 4 3]
[1 2 3 4 5 6 7 8 9]
```
{{< /output >}}

A matrix of random numbers.

```python
print( np.random.rand(3,3) )
```

{{< output >}}
```nb-output
[[0.24273703 0.4428199  0.51066964]
 [0.66546027 0.83538717 0.92546135]
 [0.63670416 0.83450213 0.57655533]]
```
{{< /output >}}

A matrix of zeros.

```python
np.zeros((4,3))
```




{{< output >}}
```nb-output
array([[0., 0., 0.],
       [0., 0., 0.],
       [0., 0., 0.],
       [0., 0., 0.]])
```
{{< /output >}}



The identity matrix.

```python
np.eye(4)
```




{{< output >}}
```nb-output
array([[1., 0., 0., 0.],
       [0., 1., 0., 0.],
       [0., 0., 1., 0.],
       [0., 0., 0., 1.]])
```
{{< /output >}}



### Scalar operations

```python
arr = np.arange(1,10)
np.append(arr, 12)
```




{{< output >}}
```nb-output
array([ 1,  2,  3,  4,  5,  6,  7,  8,  9, 12])
```
{{< /output >}}



```python
print( arr.size )
print( arr.mean() )
```

{{< output >}}
```nb-output
9
5.0
```
{{< /output >}}

```python
print( arr.min() )
print( arr.max() )
```

{{< output >}}
```nb-output
1
9
```
{{< /output >}}

```python
print( type(arr.tolist()) )
```

{{< output >}}
```nb-output
<class 'list'>
```
{{< /output >}}

```python
print( arr.astype('str') )
print( arr.astype('int') )
```

{{< output >}}
```nb-output
['1' '2' '3' '4' '5' '6' '7' '8' '9']
[1 2 3 4 5 6 7 8 9]
```
{{< /output >}}

### Matrix operations

```python
arr = np.arange(1,10)
np.append(arr, 12)
```




{{< output >}}
```nb-output
array([ 1,  2,  3,  4,  5,  6,  7,  8,  9, 12])
```
{{< /output >}}



```python
print( arr + arr )
print( arr - arr )
```

{{< output >}}
```nb-output
[ 2  4  6  8 10 12 14 16 18]
[0 0 0 0 0 0 0 0 0]
```
{{< /output >}}

```python
#A[n+1]-A[n]
np.diff(arr, n=1)
```




{{< output >}}
```nb-output
array([1, 1, 1, 1, 1, 1, 1, 1])
```
{{< /output >}}



Broadcasting provides a means of vectorizing array operations so that looping occurs in an implementation of C, instead of in Python.  The term refers how numpy treats arrays with different shapes during arithmetic operations.  The smaller array is repeated so that it matches the size of the larger array.

* [doc: broadcasting](https://docs.scipy.org/doc/numpy-1.10.0/user/basics.broadcasting.html)

```python
arr * 2
```




{{< output >}}
```nb-output
array([ 2,  4,  6,  8, 10, 12, 14, 16, 18])
```
{{< /output >}}



```python
arr + 4
```




{{< output >}}
```nb-output
array([ 5,  6,  7,  8,  9, 10, 11, 12, 13])
```
{{< /output >}}



```python
%%timeit 
arr * 2
```

{{< output >}}
```nb-output
1.36 µs ± 22 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)
```
{{< /output >}}

```python
twos = np.ones(9) * 2
```

```python
%%timeit
arr * twos
```

{{< output >}}
```nb-output
1.45 µs ± 153 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)
```
{{< /output >}}

```python
M = np.arange(1,10).reshape(3,3)
M
```




{{< output >}}
```nb-output
array([[1, 2, 3],
       [4, 5, 6],
       [7, 8, 9]])
```
{{< /output >}}



```python
M.T
```




{{< output >}}
```nb-output
array([[1, 4, 7],
       [2, 5, 8],
       [3, 6, 9]])
```
{{< /output >}}



```python
M.diagonal()
```




{{< output >}}
```nb-output
array([1, 5, 9])
```
{{< /output >}}



```python
np.dot(M, M)
```




{{< output >}}
```nb-output
array([[ 30,  36,  42],
       [ 66,  81,  96],
       [102, 126, 150]])
```
{{< /output >}}



```python
np.sum( M )
```




{{< output >}}
```nb-output
45
```
{{< /output >}}



```python
np.sum(M, axis=1)    #sum along rows, use `axis=0` for columns
```




{{< output >}}
```nb-output
array([ 6, 15, 24])
```
{{< /output >}}



## External Interfaces

### Using CUDA with Numba 

* [doc: nividia](https://devblogs.nvidia.com/numba-python-cuda-acceleration/)
* [ref: nyu intro to numba](https://nyu-cds.github.io/python-numba/05-cuda/)
* [ref: code-maven](https://code-maven.com/showing-speed-improvement-with-gpu-cuda-numpy)

### Basic C++

* [ref: using C++ with pandas](https://blog.esciencecenter.nl/irregular-data-in-pandas-using-c-88ce311cb9ef)

### Working with Eigen

* [ref: eigen3topython](https://github.com/jrl-umi3218/Eigen3ToPython)

## Conclusion

Pandas provides fast and thorough means of manipulating data in Python.  It is powered by the operations in Numpy.  While Pandas is useful for preparing data, actual analysis and computations are typically performed on the Numpy set.  This is part of the reason Numpy is adopted by so many important libraries, such as SciKitLearn, PyTorch, and many others.
