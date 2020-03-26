
+++
title = "Working with Matrices and Tensors in PyTorch"
date = "2019-08-26"
author = "Jason Beach"
categories = ["Introduction_Tutorial", "Data_Science"]
tags = ["numpy", "pytorch", "python", "deeplearning"]
+++


The Artificial Intelligence field is moving from single-function libraries to frameworks for building different network models.  TensorFlow was one of the first, and has strong production capabilities, such as process optimizations.  However, its syntax is unintuitive, and the library has a reputation for being difficult for testing new models.  This led to many organizations adopting PyTorch, with underlying Numpy, for designing network models.  This post describes the basic data structures for working with Matrices and Tensors in PyTorch.

## Basics of Tensors and Matrices


### Basic terminology

Before we begin performing opertions, we need to have a shared vocabulary on the of the three main data structures using in Artificial Intelligence (AI).

* scalar is a single number
* vector is just one row or column
* matrix is just a 2-D grid of numbers
* tensor is a 'placeholder' for the a multi-dimensional array (vector, matrix, etc.)

We should discuss tensor in more detail because a 'placeholder' is not a very mathematical definition, and it is often confused with a matrix. A tensor is often thought of as a generalized matrix. That is, it could be a 1-D matrix (a vector is actually such a tensor), a 3-D matrix (something like a cube of numbers), even a 0-D matrix (a single number), or a higher dimensional structure that is harder to visualize. The dimension of the tensor is called its rank.

A tensor is a mathematical entity that lives in a structure and interacts with other mathematical entities. If one transforms the other entities in the structure in a regular way, then the tensor must obey a related transformation rule.

This “dynamical” property of a tensor is the key that distinguishes it from a mere matrix. It’s a team player whose numerical values shift around along with those of its teammates when a transformation is introduced that affects all of them.  

Any rank-2 tensor can be represented as a matrix, but not every matrix is really a rank-2 tensor. The numerical values of a tensor’s matrix representation depend on what transformation rules have been applied to the entire system.

Indeed, speaking of a rank-2 tensor is not really accurate. The rank of a tensor has to be given by two numbers. The vector to vector mapping is given by a rank-(1,1) tensor, while the quadratic form is given by a rank-(0,2) tensor. There's also the type (2,0) which also corresponds to a matrix, but which maps two covectors to a number, and which again transforms differently.

So, succinctly, a tensor is different from a matrix in that a tensor can be:

* rank (dimension) greater than 2
* part of a system, such as a neural network, that accounts for inter-related entities
* dynamic, such that, just as a random variable X can have an actualized value, x, a tensor can be a container for actualized values of an array 

The bottom line of this is:

* components of a rank-2 tensor can be written in a matrix.
* the tensor is not that matrix, because different types of tensors can correspond to the same matrix.
* the differences between those tensor types are uncovered by the basis transformations (hence the physicist's definition: "A tensor is what transforms like a tensor").

### The need for the Tensor construct

You can specify a linear transformation 𝑎 between vectors by a matrix. Let's call that matrix 𝐴. Now if you do a basis transformation, this can also be written as a linear transformation, so that if the vector in the old basis is 𝑣, the vector in the new basis is \\(T^{-1}𝑣\\) (where v is a column vector). Now you can ask what matrix describes the transformation 𝑎 in the new basis. Well, it's the matrix \\(T^{-1}AT\\).

Well, so far, so good. What I memorized back then is that under basis change a matrix transforms as \\(T^{-1}AT\\).

But then, we learned about quadratic forms. Those are calculated using a matrix 𝐴 as \\(u^TAv\\). Still no problem, until we learned about how to do basis changes. Now, suddenly the matrix did not transform as \\(T^{-1}AT\\), but rather as \\(T^TAT\\). Which confused me like hell: How could one and the same object transform differently when used in different contexts?

Well, the solution is: Because we are actually talking about different objects! In the first case, we are talking about a tensor which takes vectors to vectors. In the second case, we are talking about a tensor which takes two vectors into a scalar, or equivalently, which takes a vector to a covector.

Proof basis change rule for quadratic form, with 𝑃 being the change of basis matrix between 𝑥,𝑦,𝑧 and 𝑢,𝑣,𝑤

\begin{align}q&= \begin{bmatrix}x&y&z\end{bmatrix}\begin{bmatrix}\text A\end{bmatrix}\begin{bmatrix}x\\y\\z\end{bmatrix}\\ &=\begin{bmatrix}x\\y\\z\end{bmatrix}^\top\begin{bmatrix}\text A\end{bmatrix}\begin{bmatrix}x\\y\\z\end{bmatrix}\\ &=\left(P\begin{bmatrix}u\\v\\w\end{bmatrix}\right)^\top \begin{bmatrix}\text A\end{bmatrix}P\begin{bmatrix}u\\v\\w\end{bmatrix}\\ &=\begin{bmatrix}u&v&w\end{bmatrix}P^\top\begin{bmatrix}\text A\end{bmatrix}P\begin{bmatrix}u\\v\\w\end{bmatrix} \end{align}

This concludes our discussion of tensors.

## Numpy ndarray

PyTorch is 'A replacement for Numpy to use the power of GPUs.'  PyTorch provides both matrices and tensors.  Let's dive into Numpy to see what PyTorch is replacing.

### Configure environment

```python
import torch
import numpy as np
```

### Background

At the core, numpy provides the excellent ndarray objects, short for n-dimensional arrays.

In a ‘ndarray’ object, aka ‘array’, you can store multiple items of the same data type. It is the facilities around the array object that makes numpy so convenient for performing math and data manipulations.

* arrays are designed to handle vectorized operations while a python list is not
* array size cannot be increased (unlike list), so a new array must be created
* array memory size is much smaller than list
* an array must have all items be of the same data type, unlike lists

```python
list1 = [0,1,2,3,4]
arr1d = np.array(list1)

try:
    list1 + 2
except:
    print("lack of vectorization on base lists makes this operation impossible")
    
print( arr1d + 2 )
```

{{< output >}}
```nb-output
lack of vectorization makes this impossible
```
{{< /output >}}




{{< output >}}
```nb-output
array([2, 3, 4, 5, 6])
```
{{< /output >}}



The most commonly used numpy dtypes are: 

* `float`
* `int`
* `bool`
* `str`
* `object`

```python
# Create a 2d array from a list of lists
list2 = [[0,1,2], [3,4,5], [6,7,8]]
arr2d = np.array(list2, dtype='float')
arr2d
```




{{< output >}}
```nb-output
array([[0., 1., 2.],
       [3., 4., 5.],
       [6., 7., 8.]])
```
{{< /output >}}



```python
arr2d.astype('str')
```




{{< output >}}
```nb-output
array([['0.0', '1.0', '2.0'],
       ['3.0', '4.0', '5.0'],
       ['6.0', '7.0', '8.0']], dtype='<U32')
```
{{< /output >}}



```python
arr2d.tolist()
```




{{< output >}}
```nb-output
[[0.0, 1.0, 2.0], [3.0, 4.0, 5.0], [6.0, 7.0, 8.0]]
```
{{< /output >}}



```python
# memory address
print('Memory: ', arr2d.data)
# shape
print('Shape: ', arr2d.shape)
# dtype
print('Datatype: ', arr2d.dtype)
# size
print('Size: ', arr2d.size)
# ndim
print('Num Dimensions: ', arr2d.ndim)
```

{{< output >}}
```nb-output
Shape:  (3, 3)
Datatype:  float64
Size:  9
Num Dimensions:  2
```
{{< /output >}}

### Operations

```python
np.identity(3)
```




{{< output >}}
```nb-output
array([[1., 0., 0.],
       [0., 1., 0.],
       [0., 0., 1.]])
```
{{< /output >}}



```python
np.concatenate(arr2d)
```




{{< output >}}
```nb-output
array([ 0.,  1.,  2.,  3., -1., -1.,  6.,  7.,  8.])
```
{{< /output >}}



```python
#transpose
arr2d.T
```




{{< output >}}
```nb-output
array([[ 0.,  3.,  6.],
       [ 1., -1.,  7.],
       [ 2., -1.,  8.]])
```
{{< /output >}}



```python
#matrix inversion
linalg.inv(arr2d)
```




{{< output >}}
```nb-output
array([[-0.04166667,  0.25      ,  0.04166667],
       [-1.25      , -0.5       ,  0.25      ],
       [ 1.125     ,  0.25      , -0.125     ]])
```
{{< /output >}}



```python
#norm
linalg.norm(arr2d)
```

```python
#determinent
linalg.det(arr2d)
```




{{< output >}}
```nb-output
24.000000000000004
```
{{< /output >}}



### Selection

```python
#slicing
arr2d[:2,:2]
```




{{< output >}}
```nb-output
array([[0., 1.],
       [3., 4.]])
```
{{< /output >}}



```python
#boolean indexing
arr2d > 4
```




{{< output >}}
```nb-output
array([[False, False, False],
       [False, False,  True],
       [ True,  True,  True]])
```
{{< /output >}}



```python
#reverse the array on one dimen (rows)
arr2d[::-1,]
```




{{< output >}}
```nb-output
array([[6., 7., 8.],
       [3., 4., 5.],
       [0., 1., 2.]])
```
{{< /output >}}



### Creation

```python
#deep copy of array
tmp = arr2d.copy()

#NaN or Infinity
arr2d[1,1] = np.nan  # not a number
arr2d[1,2] = np.inf  # infinite
print( arr2d )
print()

# Replace nan and inf with -1. Don't use arr2 == np.nan
missing_bool = np.isnan(arr2d) | np.isinf(arr2d)
arr2d[missing_bool] = -1  
print( arr2d )
print()

print( tmp )
```

{{< output >}}
```nb-output
[[ 0.  1.  2.]
 [ 3. nan inf]
 [ 6.  7.  8.]]

[[ 0.  1.  2.]
 [ 3. -1. -1.]
 [ 6.  7.  8.]]

[[0. 1. 2.]
 [3. 4. 5.]
 [6. 7. 8.]]
```
{{< /output >}}

```python
#reshape
print( (arr2d.reshape(9, 1)).transpose())

#flatten
print( arr2d.flatten())

#ravel - new array is reference to the parent array, no copy()
print( arr2d.ravel())
```

{{< output >}}
```nb-output
[[ 0.  1.  2.  3. -1. -1.  6.  7.  8.]]
[ 0.  1.  2.  3. -1. -1.  6.  7.  8.]
[ 0.  1.  2.  3. -1. -1.  6.  7.  8.]
```
{{< /output >}}

```python
# Lower limit is 0 by default
print(np.arange(5))  

# 0 to 9
print(np.arange(0, 10))  

# 0 to 9 with step of 2
print(np.arange(0, 10, 2))  

# 10 to 1, decreasing order
print(np.arange(10, 0, -1))

# Exactly 10 numbers, Start at 1 and end at 50 (not equally spaced because of the int rounding)
print( np.linspace(start=1, stop=50, num=10, dtype=int))


# LogSpace - start value is actually base^start and ends with base^stop (default base 10)
# Limit the number of digits after the decimal to 2
np.set_printoptions(precision=2)  
# Start at 10^1 and end at 10^50
print( np.logspace(start=1, stop=50, num=10, base=10)) 
```

{{< output >}}
```nb-output
[0 1 2 3 4]
[0 1 2 3 4 5 6 7 8 9]
[0 2 4 6 8]
[10  9  8  7  6  5  4  3  2  1]
[ 1  6 11 17 22 28 33 39 44 50]
```
{{< /output >}}

```python
#zeros
print( np.zeros([2,2]))

#ones
print( np.ones([2,2]))
```

{{< output >}}
```nb-output
[[0. 0.]
 [0. 0.]]
[[1. 1.]
 [1. 1.]]
```
{{< /output >}}

```python
a = [1,2,3] 
# Repeat whole of 'a' two times
print('Tile:   ', np.tile(a, 2))

# Repeat each element of 'a' two times
print('Repeat: ', np.repeat(a, 2))
```

{{< output >}}
```nb-output
Tile:    [1 2 3 1 2 3]
Repeat:  [1 1 2 2 3 3]
```
{{< /output >}}

```python
# Create random integers of size 10 between [0,10)
np.random.seed(100)
arr_rand = np.random.randint(0, 10, size=10)
print(arr_rand)

# Get the unique items and their counts
uniqs, counts = np.unique(arr_rand, return_counts=True)
print("Unique items : ", uniqs)
print("Counts       : ", counts)
```

{{< output >}}
```nb-output
[8 8 3 7 7 0 4 2 5 2]
Unique items :  [0 2 3 4 5 7 8]
Counts       :  [1 2 1 1 1 2 2]
```
{{< /output >}}

Now that we have a good understanding how to work with Numpy, lets see how the PyTorch Tensor may be a 'replacement' as it states in its purpose.

## PyTorch Tensor

Let's forget our original discussion of a Tensor, for a moment, and focus on the concrete PyTorch implementation.  A `torch.Tensor` is a multi-dimensional matrix containing elements of a single data type.  When an uninitialized matrix is created, whatever values were in the allocated memory at the time will appear as the initial values.  `torch.Tensor` is an alias for the default tensor type, `torch.FloatTensor`.

### Creation

Since the `torch.Tensor` attempts to be a replacement for `ndarray`, we expect to see a similar class API.

```python
x = torch.empty(5, 3)    #construct a 5x3 matrix, uninitialized
x = torch.rand(5, 3)     #randomly initialized matrix
x = torch.zeros(5, 3, dtype=torch.long)    #matrix filled zeros and of dtype long
```

```python
type(x)
```




{{< output >}}
```nb-output
torch.Tensor
```
{{< /output >}}



```python
print( x.type() )

print( x.shape )
print( x.size() )
print( x.dim() )
```

{{< output >}}
```nb-output
torch.LongTensor
torch.Size([5, 3])
torch.Size([5, 3])
2
```
{{< /output >}}

A tensor can be constructed from a Python list or sequence using the torch.tensor() constructor.  

`torch.tensor()` always copies data. If you have a Tensor data and just want to change its `requires_grad` flag, use `requires_grad_()` or `detach()` to avoid a copy. If you have a numpy array and want to avoid a copy, use `torch.as_tensor()`.

```python
x = torch.tensor([5.5, 3])    #create a tensor from data
```

```python
# create a tensor
new_tensor = torch.Tensor([[1, 2], [3, 4]])    # create a 2 x 3 tensor with random values
empty_tensor = torch.Tensor(2, 3)    # create a 2 x 3 tensor with random values between -1and 1
uniform_tensor = torch.Tensor(2, 3).uniform_(-1, 1)    # create a 2 x 3 tensor with random values from a uniform distribution on the interval [0, 1)
rand_tensor = torch.rand(2, 3)    # create a 2 x 3 tensor of zeros
zero_tensor = torch.zeros(2, 3)
```

### Selection and reshaping

```python
## slicing examples
slice_tensor = torch.Tensor([[1, 2, 3], [4, 5, 6], [7, 8, 9]])    # elements from every row, first column
```

```python
print( slice_tensor[1][0] )
print( slice_tensor[1][0].item() )
```

{{< output >}}
```nb-output
tensor(4.)
4.0
```
{{< /output >}}

```python
print(slice_tensor[:, 0])         # tensor([ 1.,  4.,  7.])# elements from every row, last column
print(slice_tensor[:, -1])        # tensor([ 3.,  6.,  9.])# all elements on the second row
print(slice_tensor[2, :])         # tensor([ 4.,  5.,  6.])# all elements from first two rows
print(slice_tensor[:2, :])        # tensor([[ 1.,  2.,  3.],
                                  #         [ 4.,  5.,  6.]])
```

{{< output >}}
```nb-output
tensor([1., 4., 7.])
tensor([3., 6., 9.])
tensor([7., 8., 9.])
tensor([[1., 2., 3.],
        [4., 5., 6.]])
```
{{< /output >}}

```python
reshape_tensor = torch.Tensor([[1, 2], [3, 4]])

print( reshape_tensor.view(1,4) ) 
print( reshape_tensor.view(4,1) )
```

{{< output >}}
```nb-output
tensor([[1., 2., 3., 4.]])
tensor([[1.],
        [2.],
        [3.],
        [4.]])
```
{{< /output >}}

```python
my_tensor = torch.rand(2,3)
print(my_tensor)
```

{{< output >}}
```nb-output
tensor([[0.7329, 0.2473, 0.8068],
        [0.5935, 0.4460, 0.9787]])
```
{{< /output >}}

### Operations

There are multiple syntaxes for operations.  Any operation that mutates a tensor in-place is post-fixed with an underscore, `_`. For example: `x.copy_(y)`, `x.t_()`, will change x.  While this is a convenient syntax, as opposed to Pandas `inplace=True` argument, take care to shun this mutability if you prefer the functional programming style.

The documentation for all operations is [here](https://pytorch.org/docs/stable/torch.html).

```python
x = x.new_ones(5, 3, dtype=torch.double)      # new_* methods take in sizes
print(x)
x = torch.randn_like(x, dtype=torch.float)    # override dtype!
print(x)   
```

{{< output >}}
```nb-output
tensor([[1., 1., 1.],
        [1., 1., 1.],
        [1., 1., 1.],
        [1., 1., 1.],
        [1., 1., 1.]], dtype=torch.float64)
tensor([[-0.2641,  0.1227,  0.8318],
        [-0.8145, -0.3912,  0.3452],
        [-0.9334, -1.3681,  0.3499],
        [-1.9163, -0.0799, -0.7764],
        [ 0.7414,  1.4728,  0.0776]])
```
{{< /output >}}

```python
y = torch.rand(5, 3)
```

```python
#method
print(torch.add(x, y))

#output tensor as argument
result = torch.empty(5, 3)
torch.add(x, y, out=result)
print(result)

#Addition: in-place
y.add_(x)
print(y)
```

{{< output >}}
```nb-output
tensor([[ 0.2509,  0.9078,  0.9634],
        [-0.5009,  0.2014,  0.7240],
        [-0.5479, -0.4745,  0.5204],
        [-1.4827,  0.4353, -0.4762],
        [ 1.0552,  1.4836,  0.3999]])
tensor([[ 0.2509,  0.9078,  0.9634],
        [-0.5009,  0.2014,  0.7240],
        [-0.5479, -0.4745,  0.5204],
        [-1.4827,  0.4353, -0.4762],
        [ 1.0552,  1.4836,  0.3999]])
tensor([[ 0.2509,  0.9078,  0.9634],
        [-0.5009,  0.2014,  0.7240],
        [-0.5479, -0.4745,  0.5204],
        [-1.4827,  0.4353, -0.4762],
        [ 1.0552,  1.4836,  0.3999]])
```
{{< /output >}}

```python
print( my_tensor.t() )             # regular transpose function
print( my_tensor.permute(-1,0) )   # transpose via permute function
```

{{< output >}}
```nb-output
tensor([[0.7329, 0.5935],
        [0.2473, 0.4460],
        [0.8068, 0.9787]])
tensor([[0.7329, 0.5935],
        [0.2473, 0.4460],
        [0.8068, 0.9787]])
```
{{< /output >}}

```python
cross_prod = my_tensor.cross(my_tensor)
print( cross_prod )
```

{{< output >}}
```nb-output
tensor([[ 4.3144e-09,  8.3869e-09,  3.0715e-09],
        [ 4.7199e-09,  6.7144e-09, -7.1207e-09]])
```
{{< /output >}}

```python
maxtrix_prod = my_tensor.mm( my_tensor.t() )
print( maxtrix_prod )
```

{{< output >}}
```nb-output
tensor([[1.2493, 1.3350],
        [1.3350, 1.5091]])
```
{{< /output >}}

```python
element_mult = my_tensor.mul(my_tensor)
print( element_mult )
```

{{< output >}}
```nb-output
tensor([[0.5371, 0.0612, 0.6510],
        [0.3523, 0.1989, 0.9579]])
```
{{< /output >}}

### Operations on the GPU

The crux of the `torch.Tensor` is application to the GPU for faster use in network-based modeling.

```python
if torch.cuda.is_available():
    my_tensor.cuda(True)
```

```python
my_tensor.is_cuda
```




{{< output >}}
```nb-output
False
```
{{< /output >}}



```python
# Create a numpy array
x = np.array([[1, 2], [3, 4]])
print(x)
```

{{< output >}}
```nb-output
[[1 2]
 [3 4]]
```
{{< /output >}}

```python
# Convert the numpy array to a torch tensor
y = torch.from_numpy(x)
print(y)
```

{{< output >}}
```nb-output
tensor([[1, 2],
        [3, 4]])
```
{{< /output >}}

```python
# Convert the torch tensor to a numpy array
z = y.numpy()
print(z)
```

{{< output >}}
```nb-output
[[1 2]
 [3 4]]
```
{{< /output >}}

## Conclusion

This post explains the basic operations of the `ndarray` and how `Tensor` adds value.  Later posts will explore how the `Tensor` is used in PyTorch and network modeling.

### References: framemworks

__Numpy__

* [ref: datacamp numpy cheatsheet](https://s3.amazonaws.com/assets.datacamp.com/blog_assets/Numpy_Python_Cheat_Sheet.pdf)
* [docs: numpy quickstart](https://docs.scipy.org/doc/numpy/user/quickstart.html)
* [docs: numpy api](https://docs.scipy.org/doc/numpy/reference/)


__PyTorch__

* [docs: pytorch cheatsheet](https://pytorch.org/tutorials/beginner/ptcheat.html)
* [docs: pytorch api](https://pytorch.org/docs/stable/index.html)
* [ref: kdnuggets pytorch](https://www.kdnuggets.com/2019/08/pytorch-cheat-sheet-beginners.html)
* [ref: pytorch cheat](https://github.com/Tgaaly/pytorch-cheatsheet/blob/master/README.md)
* [ref: kaggle pytorch starter with helper functions](https://github.com/bfortuner/pytorch-kaggle-starter)
