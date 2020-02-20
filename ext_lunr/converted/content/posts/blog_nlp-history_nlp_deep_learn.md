+++
author = "Jason Beach"
categories = ["datascience", "math", "computerscience"]
date = "2019-11-01"
tags = ["nlp", "deeplearning", "tag3"]
title = "Historical Background of NLP with Deep Learning"

+++


The automated linguistic annotation of natural languages kept linguists and computer scientists hard at work for many decades.  This work focused on the syntax of language as well as basic understanding and includes part-of-speech, named entity categorization, and syntatic dependency.  Language meta-data tagging became much more accurate with the introduction of neural network and deep learning models.  Because pairing meta-data with more powerful models is sure to allow for an explosion of new applications, it is important to understand the developments that allowed for the creation of this technology.

This post explores the development of Deep Learning and Natural Language Processing.  It also highlights strengths and weaknesses for future application. 

## History of Deep Learning

This section is a summary of an excellent three-part series by [Andrey Kurenkov](http://www.andreykurenkov.com/writing/ai/a-brief-history-of-neural-nets-and-deep-learning/).

### Perceptron and ArtificialNNs

Neuron built by Warren McCulloch and Walter Pitts Mcculoch-Pitts, who showed that a neuron model that sums binary inputs and outputs a 1 if the sum exceeds a certain threshold value, and otherwise outputs a 0, can model the basic OR/AND/NOT functions [ref](http://www.minicomplexity.org/pubs/1943-mcculloch-pitts-bmb.pdf). 

A psychologist, Rosenblatt conceived of the Perceptron as a simplified mathematical model of how the neurons in our brains operate: it takes a set of binary inputs (nearby neurons), multiplies each input by a continuous valued weight (the synapse strength to each nearby neuron), and thresholds the sum of these weighted inputs to output a 1 if the sum is big enough and otherwise a 0 (in the same way neurons either fire or do not) [ref](http://psycnet.apa.org/index.cfm?fa=buy.optionToBuy&id=1959-09865-001).

Hebb put forth the unexpected and hugely influential idea that knowledge and learning occurs in the brain primarily through the formation and change of synapses between neurons - concisely stated as Hebb’s Rule:

>    “When an axon of cell A is near enough to excite a cell B and repeatedly or persistently takes part in firing it, some growth process or metabolic change takes place in one or both cells such that A’s efficiency, as one of the cells firing B, is increased.”

Multiple outputs can be learned by having multiple Perceptrons in a layer, such that all these Perceptrons receive the same input and each one is responsible for one output of the function. Indeed, neural nets (or, formally, ‘Artificial Neural Networks’ - ANNs) are nothing more than layers of Perceptrons.  Only one of the 10 neurons output 1, the highest weighted sum is taken to be the correct output, and the rest output 0.  Finding the right weights using the derivatives of the training error with respect to each weight is exactly how neural nets are typically trained to this day.

Minsky and Papert’s 1969 analysis of Perceptrons did not merely show the impossibility of computing XOR with a single Perceptron, but specifically argued that it had to be done with multiple layers of Perceptrons. 

AI Winter 1, 1969, multiple layers are necessary for practical usefulness, but no obvious approach for doing this.

### Hidden layer networks


The reason hidden layers are good, in basic terms, is that the hidden layers can find features within the data and allow following layers to operate on those features rather than the noisy and large raw data.  Similar to Feature Extraction in machine learning.  

How to get weights for these hidden layers?  Calculus' Chain Rule - The key realization was that if the neural net neurons were not quite Perceptrons, but were made to compute the output with an activation function that was still non-linear but also differentiable, as with Adaline, not only could the derivative be used to adjust the weight to minimize error, but the chain rule could also be used to compute the derivative for all the neurons in a prior layer and thus the way to adjust their weights would also be known.

Assign some error to the Output Layer, then some to Hidden Layer before it, and Hidden Layer before it - __backpropagate__ the error.  Werbos stated it in his 1974 PHD thesis, but did not publish on the application of backprop to neural nets until 1982.  [“Learning internal representations by error propagation” ](https://www.iro.umontreal.ca/~vincentp/ift3395/lectures/backprop_old.pdf), specifically addressed the problems discussed by Minsky in Perceptrons. 

[“Multilayer feedforward networks are universal approximators”](http://cognitivemedium.com/magic_paper/assets/Hornik.pdf) mathematically proved that multiple layers allow neural nets to theoretically implement any function, and certainly XOR.

### Convolutional networks

Yann LeCun et al. at the AT&T Bell Labs demonstrated a very significant real-world application of backpropagation in classifying handwritten numbers for USPS in ["Backpropagation Applied to Handwritten Zip Code Recognition"](http://yann.lecun.com/exdb/publis/pdf/lecun-89e.pdf).

The first hidden layer of the neural net was convolutional - instead of each neuron having a different weight for each pixel of the input image (40x60=2400 weights), the neurons only have a small set of weights (5x5=25) that were applied a whole bunch of small subsets of the image of the same size.  a single neuron could learn to detect 45 degree lines on subsets of the image and do that everywhere within it.

Moreover, since the pixel-exact locations of such features do not matter the neuron could basically skip neighboring subsets of the image - subsampling, now known as a type of pooling - when applying the weights, further reducing the training time. 

The addition of Convolutional and Pooling layers distinguishes CNNs from NNs.

More developments
* auto-encoders - here’s another neat thing you can do with neural nets: approximate probability distributions.
* Boltzmann Machine formulation - leads to a domain-independent learning algorithm that modifies the connection strengths between units in such a way that the whole network develops an internal model which captures the underlying structure of its environment. 
* Helmholtz Machine - have separate sets of weights for inferring hidden variables from visible variables (recognition weights) and vice versa (generative weights) allows training to be done faster.

Skepticism of neural nets since they seemed so intuition-based and since computers were still barely able to meet their computational needs. 
 
AI Winter 2, 1990, not enough processing or data resources to produce useful results.

### Recurrent CNN with LSTM

[ref: understanding lstm](https://colah.github.io/posts/2015-08-Understanding-LSTMs/)

To tackle the problem of understanding speech, researchers sought to modify neural nets to process input as a stream of input as in speech rather than one batch as with an image.

All the networks that have been discussed so far have been feedforward networks, meaning that the output of neurons in a given layer acts as input to only neurons in a next layer. But, it does not have to be so - there is nothing prohibiting us brave computer scientists from connecting output of the last layer act as an input to the first layer, or just connecting the output of a neuron to itself.

The answer is backpropagation through time. Basically, the idea is to ‘unroll’ the recurrent neural network by treating each loop through the neural network as an input to another neural network, and looping only a limited number of times.  But there was a problem.  Although recurrent networks can outperform static networks, they appear more difficult to train optimally. Their parameters settle in a suboptimal solution which takes into account short term dependencies but not long term dependencies.

The core reason that recurrent nets are more exciting than CNN is that they allow us to operate over sequences of vectors: Sequences in the input, the output, or in the most general case both. 

With many layers the CNN calculus-based splitting of blame ends up with either huge or tiny numbers and the resulting neural net just does not work very well - the ‘vanishing or exploding gradient problem’.

In 1997, [LSTM](http://deeplearning.cs.cmu.edu/pdfs/Hochreiter97_lstm.pdf) was developed.  Some of the units are called Constant Error Carousels (CECs). Each CEC uses as an activation function f, the identity function, and has a connection to itself with ﬁxed weight of 1.0. Due to f’s constant derivative of 1.0, errors backpropagated through a CEC cannot vanish or explode (Sec. 5.9) but stay as they are (unless they “ﬂow out” of the CEC to other, typically adaptive parts of the NN).

AI Winter 3, 1993, SVMs and Random Forests were all the rage.  RNN was slow and difficult.

### Deep Learning: big data, parallelism (gpu), and algorithms

In 2004, Canadian Institute for Advanced Research (CIFAR) decided to “rebrand” the frowned-upon field of neural nets with the moniker “Deep Learning”.  In 2006, the paper [](https://www.cs.toronto.edu/~hinton/absps/fastnc.pdf) was released which provided a way to train weights well, if the weights are initialized in a clever way rather than randomly.  The basic idea is to train each layer, as a Restricted Boltzmann Machine (RBM), one by one with unsupervised training, which starts off the weights much better than just giving them random values, and then finishing with a round of supervised learning just as is normal for neural nets. 

Yoshua Bengio et al. followed up on this work in 2007 with [“Greedy Layer-Wise Training of Deep Networks” ](http://papers.nips.cc/paper/3048-greedy-layer-wise-training-of-deep-networks.pdf), in which they present a strong argument that deep machine learning methods (that is, methods with many processing steps, or equivalently with hierarchical feature representations of the data) are more efficient for difficult problems than shallow methods (which two-layer ANNs or support vector machines are examples of).  Also, using RBMs is not that important - unsupervised pre-training of normal neural net layers using backpropagation with plain Autoencoders layers proved to also work well. 

Hinton used these methods on standard speech recognition dataset because ML had already performed so well on MNIST.  They did this using GPUs over CPUs and the paper [“Large-scale Deep Unsupervised Learning using Graphics Processors” ](http://www.machinelearning.org/archive/icml2009/papers/218.pdf)
shows and improvement in training of 70 times faster. 

Andrew Ng's work with Google Brain led an effort to build truly giant neural nets and explore what they could do. The work resulted in unsupervised neural net learning of 16,000 CPU cores powering the learning of 1 billion weights.

Why didn't supervised learning with backpropagation not work well in the past? Geoffrey Hinton summarized the findings up to today in these four points:

* Our labeled datasets were thousands of times too small.
* Our computers were millions of times too slow.
* We initialized the weights in a stupid way.
* We used the wrong type of non-linearity.

### Additional Improvements

Old methods: 

* pooling layers
* convolution layers
* variations on the input data

used with new methods:

* gpu usage - for improved computation
* activation function - less intuitive approach, such as ReLU, can be most useful
* dropout - to prevent overfitting, randomly pretend some neurons are not there while training

## History of NLP

* [ref: comparison of NLP frameworks](https://spacy.io/usage/facts-figures)
* [ref: comparison of NLP with image analysis](https://thegradient.pub/nlp-imagenet/)

Since introduction of word vectors, the standard way of conducting NLP projects has largely remained unchanged: word embeddings pretrained on large amounts of unlabeled data via algorithms such as word2vec and GloVe are used to initialize the first layer of a neural network, the rest of which is then trained on data of a particular task.  The downside is that previous knowledge is only used in the first layer.  It does not acquire meaning from a sequence of words. 

At the core of the recent advances of ULMFiT, ELMo, and the OpenAI transformer is one key paradigm shift: going from just initializing the first layer of our models to pretraining the entire model with hierarchical representations.

"ImageNet for language"---that is, a task that enables models to learn higher-level nuances of language, similarly to how ImageNet has enabled training of CV models that learn general-purpose features of images.  In 2012, the deep neural network submitted by Alex Krizhevsky, Ilya Sutskever, and Geoffrey Hinton performed 41% better than the next model in the ImageNet Large Scale Visual Recognition Challenge (ILSVRC). It also enabled transfer learning through re-use of weights, achieving good performance with as little as one positive example per category (Donahue et al., 2014).  A key property of an ImageNet-like dataset is thus to encourage a model to learn features that will likely generalize to new tasks in the problem domain.  

Empirical proof: Embeddings from Language Models ([ELMo](https://arxiv.org/abs/1802.05365)), Universal Language Model Fine-tuning ([ULMFiT](https://arxiv.org/abs/1801.06146)), and the [OpenAI Transformer](https://s3-us-west-2.amazonaws.com/openai-assets/research-covers/language-unsupervised/language_understanding_paper.pdf), that demonstrate how language modeling can be used for pretraining.  These models perform:

* 10-20% better than the state-of-the-art on widely studied benchmarks
* extremely sample-efficient with only hundreds of examples

It is very likely that in a year’s time NLP practitioners will download pretrained language models rather than pretrained word embeddings for use in their own models, similarly to how pre-trained ImageNet models are the starting point for most CV projects nowadays.

Open question: how to transfer the information from a pre-trained language model to a downstream task?

* ELMo - use the pre-trained language model as a fixed feature extractor and incorporate its representation as features into a randomly initialized model 
* ULMFiT - fine-tune the entire language model, typically done in CV where either the top-most or several of the top layers are fine-tuned

The next months will show the impact of each of the core components of transfer learning for NLP: an expressive language model encoder such as a deep BiLSTM or the Transformer, the amount and nature of the data used for pretraining, and the method used to fine-tune the pretrained model.

### Word Embeddings

* [ref: Word embeddings](http://mccormickml.com/2019/05/14/BERT-word-embeddings-tutorial/)
* [ref: Word2Vec Tutorial](http://mccormickml.com/2016/04/19/word2vec-tutorial-the-skip-gram-model/)
* [ref: CBOW and SkipGram Architectures](https://www.quora.com/What-are-the-continuous-bag-of-words-and-skip-gram-architectures)

CBOW: The input to the model could be 𝑤𝑖−2,𝑤𝑖−1,𝑤𝑖+1,𝑤𝑖+2, the preceding and following words of the current word we are at. The output of the neural network will be 𝑤𝑖.  Hence you can think of the task as "predicting the word given its context".  Note that the number of words we use depends on your setting for the window size.

Skip-gram: The input to the model is 𝑤𝑖, and the output could be 𝑤𝑖−1,𝑤𝑖−2,𝑤𝑖+1,𝑤𝑖+2. So the task here is "predicting the context given a word". In addition, more distant words are given less weight by randomly sampling them. When you define the window size parameter, you only configure the maximum window size. The actual window size is randomly chosen between 1 and max size for each training sample, resulting in words with the maximum distance being observed with a probability of 1/c while words directly next to the given word are always(!) observed.

### Application

#### Tensors and matrices

* [ref: difference between tensors and matrices] (https://math.stackexchange.com/questions/412423/what-are-the-differences-between-a-matrix-and-a-tensor#412454)
* the components of a rank-2 tensor can be written in a matrix.
* the tensor is not that matrix, because different types of tensors can correspond to the same matrix.
* the differences between those tensor types are uncovered by the basis transformations (hence the physicist's definition: "A tensor is what transforms like a tensor").




#### FastText

* [ref: FastText](https://towardsdatascience.com/fasttext-under-the-hood-11efc57b2b3)

Both the continuous bag of words and the Skip-gram model update the weights for a context of size between a random uniform distribution between 1 and the value determined by -ws, i.e the window size is stochastic.

The target vector for the loss function is computed via a normalized sum of all the input vectors. The input vectors are the vector representation for the original word, and all the n-grams of that word. The loss is computed which sets the weights for the forward pass, which propagate their way all the way back to the vectors for the input layer in the back propagation pass. This tuning of the input vector weights that happens during the back propagation pass is what allows us to learn representations that maximize co occurrence similarity. The learning rate -lr affects how much each particular instance affects the weights.

* [ref: many diff applications of RNN] (https://karpathy.github.io/2015/05/21/rnn-effectiveness/)



### Evaluation

* [evaluation of language modeling](https://thegradient.pub/understanding-evaluation-metrics-for-language-models/)
