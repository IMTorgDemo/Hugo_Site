
+++
title = "Formatting for Jupyter (.ipynb) Notebooks"
date = "2019-05-08"
author = "Jason Beach"
categories = ["Blog", "Category"]
tags = ["jupyter", "tag"]
+++


This is a test posts for formatting Jupyter Notebooks for Hugo.

This workflow makes use of the code at repository [nb2hugo](https://github.com/vlunot/nb2hugo).

Cupiditate voluptas sunt velit. Accusantium aliquid expedita excepturi quis laborum autem. Quas occaecati et atque est repellat dolores. Laudantium in molestiae consequatur voluptate ipsa. Nulla quia non qui sed. Voluptatem et enim nesciunt sunt pariatur. Libero eius excepturi voluptatibus reprehenderit. Facere enim neque dolorem sed ullam non. Dolor sit molestias repellendus. 

## Headers

Cupiditate voluptas sunt velit. Accusantium aliquid expedita excepturi quis laborum autem. Quas occaecati et atque est repellat dolores. Laudantium in molestiae consequatur voluptate ipsa. Nulla quia non qui sed. Voluptatem et enim nesciunt sunt pariatur. Libero eius excepturi voluptatibus reprehenderit. Facere enim neque dolorem sed ullam non. Dolor sit molestias repellendus. 


```python
print('goodbye!')
```

    goodbye!


## Formatting Requirements

Must conform to the following:

* notebook-filename_must_be_lowercase.ipynb
* apply metadata formatting

```
# Formatting for Jupyter (.ipynb) Notebooks

Date: 2019-05-08  
Author: Jason Beach  
Categories: Blog, Category  
Tags: jupyter, tag 

<!--eofm-->
```

* #Title as above (.ipynb) within metadata
* use opening paragraph just beneath metadata
* ##All Other Sections (to ensure proper smartToc)
* for graphs, always use `plt.show()` as below
* ensure no trailing cells at the end of the notebook and no empty space


```python
import matplotlib.pyplot as plt
import numpy as np

a=[x for x in range(10)]
b=np.square(a)
plt.plot(a,b)
plt.show()
```


![png](output_7_0.png)

