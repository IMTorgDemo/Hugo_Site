
+++
title = "PySpark Refresher Tutorial"
date = "2020-06-15"
author = "Jason Beach"
categories = ["Introduction_Tutorial", "Data_Science"]
tags = ["pyspark", "python", "spark"]
+++


Spark is the primier BigData tool for data science, and PySpark supports a natural move from the local machine to cluster computing.  In fact, you can use PySpark on your local machine in standalone mode just as you would on a cluster.  In this post, we provide a refresher for those working on legacy or other systems, and want to quickly transition back to Spark.

## Environment

When using the pyspark-shell, the `spark.sparkContext` is available via `sc` environment variable.  However, in Jupyter, we will have to create our own session.  Take note of the version, Spark v3.0 had some big changes.

```python
from pyspark.sql import SparkSession
spark = SparkSession.builder \
          .appName("app.name") \
          .config("spark.some.config.option", "some-value") \
          .getOrCreate()
```

```python
spark.sparkContext
```





        <div>
            <p><b>SparkContext</b></p>

            <p><a href="http://7ffeadb3f712:4040">Spark UI</a></p>

            <dl>
              <dt>Version</dt>
                <dd><code>v2.4.4</code></dd>
              <dt>Master</dt>
                <dd><code>local[*]</code></dd>
              <dt>AppName</dt>
                <dd><code>app.name</code></dd>
            </dl>
        </div>
        



```python
sc = spark.sparkContext
sc.version
```




{{< output >}}
```nb-output
'2.4.4'
```
{{< /output >}}



```python
import pandas as pd
import numpy as np
```

## Configuration

Always get a sense of the raw data.  Typically, this can only be done via commandline.  Here, we see there is some metadata as a header, before the actual data.  This would cause some problems if we were loading the data with a simple dataframe command.

```python
! head -n 15 ./Data/spark_Houses/cadata.txt
```

{{< output >}}
```nb-output
S&P Letters Data
We collected information on the variables using all the block groups in California from the 1990 Census. In this sample a block group on average includes 1425.5 individuals living in a geographically compact area. Naturally, the geographical area included varies inversely with the population density. We computed distances among the centroids of each block group as measured in latitude and longitude. We excluded all the block groups reporting zero entries for the independent and dependent variables. The final data contained 20,640 observations on 9 variables. The dependent variable is ln(median house value).

		Bols	tols
INTERCEPT		11.4939	275.7518
MEDIAN INCOME		0.4790	45.7768
MEDIAN INCOME2		-0.0166	-9.4841
MEDIAN INCOME3		-0.0002	-1.9157
ln(MEDIAN AGE)		0.1570	33.6123
ln(TOTAL ROOMS/ POPULATION)	-0.8582	-56.1280
ln(BEDROOMS/ POPULATION)	0.8043	38.0685
ln(POPULATION/ HOUSEHOLDS)	-0.4077	-20.8762
ln(HOUSEHOLDS)		0.0477	13.0792

The file cadata.txt contains all the the variables. Specifically, it contains median house value, median income, housing median age, total rooms, total bedrooms, population, households, latitude, and longitude in that order. 
```
{{< /output >}}

## Resilient Distributed Datasets

The Resilient Distributed Dataset (RDD) is a really fun way for tackling string data.  It has strong support for functional programming, so you can get initial processing completed in a very clean manner.

Its important to note that if you perform operations that require shuffling data among the different Tasks, that your Job will be slowed, considerably.

```python
textFile = sc.textFile("./Data/spark_Houses/cadata.txt")    #"hdfs://<HDFS loc>/data/*.zip")
```

```python
notes = textFile.take(27)
```

```python
#this is incorrect, but a fun exercise
#also possible to use .lookup(1), in-place of filter(lambda x: x[0]>4)
headers = textFile.zipWithIndex().\
    map(lambda x: (x[1],x[0]) ).\
    filter(lambda x: x[0]>4).\
    filter(lambda x: x[0]<13).\
    map(lambda x: (x[1].split("\t"))[0] ).\
    collect()
```

```python
col_names = [u'longitude: continuous.', u'latitude: continuous.', u'housingMedianAge: continuous. ', u'totalRooms: continuous. ', u'totalBedrooms: continuous. ', u'population: continuous. ', u'households: continuous. ', u'medianIncome: continuous. ', u'medianHouseValue: continuous. ']
header = [x.split(": ")[0] for x in col_names]
header
```




{{< output >}}
```nb-output
['longitude',
 'latitude',
 'housingMedianAge',
 'totalRooms',
 'totalBedrooms',
 'population',
 'households',
 'medianIncome',
 'medianHouseValue']
```
{{< /output >}}



```python
rdd = textFile.zipWithIndex().filter(lambda x: x[1]>27)
```

```python
ln = rdd.sample(0, .0001)
```

```python
import re 
ptrn = re.compile("\s+")
line = (ln.take(1)[0])[0]
re.split(ptrn, line)
```




{{< output >}}
```nb-output
['',
 '4.8900000000000000e+004',
 '1.7197000000000000e+000',
 '3.4000000000000000e+001',
 '1.3790000000000000e+003',
 '3.3300000000000000e+002',
 '1.1560000000000000e+003',
 '3.1500000000000000e+002',
 '3.5369999999999997e+001',
 '-1.1897000000000000e+002']
```
{{< /output >}}



Once the data is prepared, use the Row class to get it into a schema and format that will make import to Spark clean and reproducible.

```python
from pyspark.sql import Row
```

```python
#DO NOT fix dtypes before conversion to DF: 
#   TypeError: not supported type: <class 'numpy.float64'>
rows = rdd.map(lambda x: re.split(ptrn, x[0])).map(lambda x:
                                    Row(longitude= np.float64(x[1]),
                                        latitude= np.float64(x[2]),
                                        housingMedianAge=x[3],
                                        totalRooms=x[4],
                                        totalBedRooms=x[5],
                                        population=x[6],
                                        households=x[7],
                                        medianIncome=x[8],
                                        medianHouseValue=x[9]
                                    ))
```

```python
rows = rdd.map(lambda x: re.split(ptrn, x[0])).map(lambda x:
                                    Row(longitude= x[1],
                                        latitude= x[2],
                                        housingMedianAge=x[3],
                                        totalRooms=x[4],
                                        totalBedRooms=x[5],
                                        population=x[6],
                                        households=x[7],
                                        medianIncome=x[8],
                                        medianHouseValue=x[9]
                                    ))
```

## Dataframe

The Spark DataFrame is the workhorse tool for data scientists.  Operations on DataFrames are optimized, so it is better to provide simple instructions to it, than it is to create your own, in say, a User Defined Function (UDF), or some other manner.

Ensure your types are correct - if you're coming from a RDD, then they will all be strings!

```python
df_raw = rows.toDF()
```

```python
df_raw.dtypes
```




{{< output >}}
```nb-output
[('households', 'string'),
 ('housingMedianAge', 'string'),
 ('latitude', 'string'),
 ('longitude', 'string'),
 ('medianHouseValue', 'string'),
 ('medianIncome', 'string'),
 ('population', 'string'),
 ('totalBedRooms', 'string'),
 ('totalRooms', 'string')]
```
{{< /output >}}



```python
from pyspark.sql.types import *

df = df_raw.withColumn("longitude", df_raw["longitude"].cast(FloatType()) ) \
   .withColumn("latitude", df_raw["latitude"].cast(FloatType()) ) \
   .withColumn("housingMedianAge", df_raw["housingMedianAge"].cast(FloatType()) ) \
   .withColumn("totalRooms", df_raw["totalRooms"].cast(FloatType()) ) \
   .withColumn("totalBedRooms", df_raw["totalBedRooms"].cast(FloatType()) ) \
   .withColumn("population", df_raw["population"].cast(FloatType()) ) \
   .withColumn("households", df_raw["households"].cast(FloatType()) ) \
   .withColumn("medianIncome", df_raw["medianIncome"].cast(FloatType()) ) \
   .withColumn("medianHouseValue", df_raw["medianHouseValue"].cast(FloatType()) )
```

```python
#automate column
from pyspark.sql.types import *

# Write a custom function to convert the data type of DataFrame columns
def convertColumn(df, names, newType):
    for name in names:
        df = df.withColumn(name, df[name].cast(newType))
    return df 

# Assign all column names to `columns`
columns = df_raw.columns

# Conver the `df` columns to `FloatType()`
df = convertColumn(df_raw, columns, FloatType())
```

```python
df.dtypes
```




{{< output >}}
```nb-output
[('households', 'float'),
 ('housingMedianAge', 'float'),
 ('latitude', 'float'),
 ('longitude', 'float'),
 ('medianHouseValue', 'float'),
 ('medianIncome', 'float'),
 ('population', 'float'),
 ('totalBedRooms', 'float'),
 ('totalRooms', 'float')]
```
{{< /output >}}



Once the data starts looking complete, you can begin executing SQL-like commands against the DataFrame.

```python
df.groupBy("housingMedianAge").count().sort("housingMedianAge", ascending=False).show(5)
```

{{< output >}}
```nb-output
+----------------+-----+
|housingMedianAge|count|
+----------------+-----+
|            52.0| 1273|
|            51.0|   48|
|            50.0|  136|
|            49.0|  134|
|            48.0|  177|
+----------------+-----+
only showing top 5 rows

```
{{< /output >}}

```python
df.select('MedianHouseValue').describe().show()
```

{{< output >}}
```nb-output
+-------+-------------------+
|summary|   MedianHouseValue|
+-------+-------------------+
|  count|              20639|
|   mean|-119.56957555201876|
| stddev|  2.003494699348379|
|    min|            -124.35|
|    max|            -114.31|
+-------+-------------------+

```
{{< /output >}}

## Data Preparation

Preparing data for models can be more involved than in libraries specific to your local machine.  These are a few of the steps that will need to be completed.  Some of these methods look similar to those of SKLearn.

### Add columns

We will add a few more columns using the `.withColumn()` method.

```python
df_prep1 = df
```

```python
from pyspark.sql.functions import *

# Adjust the values of `medianHouseValue`
df = df.withColumn("medianHouseValue", col("medianHouseValue")/100000)
```

```python
df.select('MedianHouseValue').describe().show()
```

{{< output >}}
```nb-output
+-------+--------------------+
|summary|    MedianHouseValue|
+-------+--------------------+
|  count|               20639|
|   mean|-0.00119569575552...|
| stddev|2.003494699348537...|
|    min|-0.00124349998474...|
|    max|-0.00114309997558...|
+-------+--------------------+

```
{{< /output >}}

```python
from pyspark.sql.functions import *

# Add the new columns to `df`
df = df.withColumn("roomsPerHousehold", col("totalRooms")/col("households")) \
   .withColumn("populationPerHousehold", col("population")/col("households")) \
   .withColumn("bedroomsPerRoom", col("totalBedRooms")/col("totalRooms"))

df.select("roomsPerHousehold", "populationPerHousehold", "bedroomsPerRoom").first()
```




{{< output >}}
```nb-output
Row(roomsPerHousehold=6.238137082601054, populationPerHousehold=2.109841827768014, bedroomsPerRoom=0.15579659106916466)
```
{{< /output >}}



### Create a DenseVector

Spark uses [breeze](https://github.com/scalanlp/breeze) under the hood for high performance Linear Algebra in Scala.

In Spark MLlib and ML some algorithms depends on `org.apache.spark.mllib.libalg.Vector` type which is rather dense (`DenseVector`) or sparse (`SparseVector`).

Their is no implicit conversion between a scala Vector or array into a dense Vector from mllib, so you must ensure this is complete before feeding it to a model. 

```python
df_prep2 = df
```

```python
# Re-order and select columns
df = df.select("medianHouseValue", 
              "totalBedRooms", 
              "population", 
              "households", 
              "medianIncome", 
              "roomsPerHousehold", 
              "populationPerHousehold", 
              "bedroomsPerRoom")
```

```python
from pyspark.ml.linalg import DenseVector

# Define the `input_data` 
input_data = df.rdd.map(lambda x: (x[0], DenseVector(x[1:])))
```

```python
input_data.take(3)
```




{{< output >}}
```nb-output
[(-0.0012222000122070313,
  DenseVector([1106.0, 2401.0, 1138.0, 37.86, 6.2381, 2.1098, 0.1558])),
 (-0.0012223999786376953,
  DenseVector([190.0, 496.0, 177.0, 37.85, 8.2881, 2.8023, 0.1295])),
 (-0.0012225,
  DenseVector([235.0, 558.0, 219.0, 37.85, 5.8174, 2.5479, 0.1845]))]
```
{{< /output >}}



```python
# Replace `df` with the new DataFrame
df = spark.createDataFrame(input_data, ["label", "features"])
```

```python
df.take(3)
```




{{< output >}}
```nb-output
[Row(label=-0.0012222000122070313, features=DenseVector([1106.0, 2401.0, 1138.0, 37.86, 6.2381, 2.1098, 0.1558])),
 Row(label=-0.0012223999786376953, features=DenseVector([190.0, 496.0, 177.0, 37.85, 8.2881, 2.8023, 0.1295])),
 Row(label=-0.0012225, features=DenseVector([235.0, 558.0, 219.0, 37.85, 5.8174, 2.5479, 0.1845]))]
```
{{< /output >}}



### Standardize columns

The `StandardScaler` is used to transform a column to zero mean and a standard deviation of 1.

```python
# Import `StandardScaler` 
from pyspark.ml.feature import StandardScaler

standardScaler = StandardScaler(inputCol="features", outputCol="features_scaled")   #initialize
scaler = standardScaler.fit(df)    #fit
scaled_df = scaler.transform(df)   #scale
```

```python
# Inspect the result
scaled_df.select("features_scaled").take(2)
```




{{< output >}}
```nb-output
[Row(features_scaled=DenseVector([2.6255, 2.1202, 2.9765, 17.7252, 2.5213, 0.2031, 2.6851])),
 Row(features_scaled=DenseVector([0.451, 0.438, 0.463, 17.7205, 3.3498, 0.2698, 2.2321]))]
```
{{< /output >}}



## Model

Once the data is prepared, we can choose from a number of different models to apply to the data.

### Split and Train

```python
train_data, test_data = scaled_df.randomSplit([.8,.2],seed=1234)
```

```python
from pyspark.ml.regression import LinearRegression

# Initialize `lr`
lr = LinearRegression(labelCol="label", maxIter=10, regParam=0.3, elasticNetParam=0.8)
linearModel = lr.fit(train_data)
```

### Predict

```python
# Generate predictions
predicted = linearModel.transform(test_data)

# Extract the predictions and the "known" correct labels
predictions = predicted.select("prediction").rdd.map(lambda x: x[0])
labels = predicted.select("label").rdd.map(lambda x: x[0])
```

```python
# Zip `predictions` and `labels` into a list
predictionAndLabel = predictions.zip(labels).collect()
```

```python
# Print out first 5 instances of `predictionAndLabel` 
predictionAndLabel[:5]
```




{{< output >}}
```nb-output
[(-0.0011958166787652167, -0.001243499984741211),
 (-0.0011958166787652167, -0.0012430000305175782),
 (-0.0011958166787652167, -0.0012430000305175782),
 (-0.0011958166787652167, -0.0012419000244140626),
 (-0.0011958166787652167, -0.0012416999816894532)]
```
{{< /output >}}



### Model results

```python
# Coefficients for the model
linearModel.coefficients
```




{{< output >}}
```nb-output
DenseVector([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
```
{{< /output >}}



```python
# Intercept for the model
linearModel.intercept
```




{{< output >}}
```nb-output
-0.0011958166787652167
```
{{< /output >}}



```python
# Get the RMSE
linearModel.summary.rootMeanSquaredError
```




{{< output >}}
```nb-output
2.004643282977487e-05
```
{{< /output >}}



```python
# Get the R2
linearModel.summary.r2
```




{{< output >}}
```nb-output
-1.3034018309099338e-13
```
{{< /output >}}



## Conclusion

These are the basic steps taken in every Spark machine learning application.
