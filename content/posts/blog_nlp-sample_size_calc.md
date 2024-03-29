
+++
title = "Determining Sample Size for AI Models"
date = "2021-12-09"
author = "Jason Beach"
categories = ["Introduction_Tutorial", "Data_Science"]
tags = ["nlp", "linguistics", "sample_size"]
+++


We are going to dive into the deep disturbing world of sample size in AI.  This work is RARELY done as part of AI solutions.  There are comparatively few research papers on this topic, and the approaches they offer tend to be specific to the underlying problem addressed in the paper.  However, the simple fact that it is poorly understood gives great understanding to the world of AI, which is why I describe it as 'disturbing'.  I've always found this subject to be important, but this is the first time I've had a chance to study and work on it.  So, how many labeled samples do you need to feel confident in model outcomes?  Lets try to answer that question. 

## Introduction

One reason sampling for AI models is not studied more is because AI is a field dominated by computer science, but sampling theory is firmly in the realm of mathematical statistics.  Also, practically speaking, the topic is treated similar to clinical trial sample sizes which are determined more by the amount of time and money available for the study than by any theoretical calculation.  The answer is always get more samples.  

This is a very unsatisfying answer for AI practitioners who strive to master the discipline.  But, it also provides great insight.  This is because it demonstrates a few secrets about neural nets that make you question whether AI is more 'artificial' than 'intelligent'.  

## Weaknesses of Neural Network Models

There are a few weaknesses concerning neural networks that decisively characterize how they perform.  First, neural net model output is based on correlations found in the data.  No 'understanding' is taking place when a neural net model is being trained.  Rather, consistent patterns emerge from training that can be encapsulated in model parameters.  When the data is run through a classification model, it can provide a result that is inferred as the proportion of the time that input will be associated with a particular class label.  There is a 'cult' of AI enthusiasts who totally reject this explanation, but this is the mathematical reality of what is happening.  

Examples of when reasonable models can fail spectacularly is provided by adversarial methods.  This field takes advantage of the correlated patterns to create deceptive input that will cause strange behavior in models.  Adding slight noise to an image of a panda will cause a model trained on animals to output the label as a gibbon, while humans cannot observe differences between the two images.

Second, because of this associative aspect of neural nets, neural nets poorly generalize their results outside of a domain of samples.  For example, you've trained a computer vision model to detect cars using a large number of automobile images.  However, all the images are captured at the ground-level perspective.  What happens if the model is given an image from the top of a building as input?  The model has not seen a car represented like this.  It is not intelligent in the sense that it can abstract the 3-dimensional, vertical-axis rotated, representation from the 2-dimensional images it was trained.  Instead, the AI developer must perform these pre-process steps for all (infinite) possible perspectives and use these images as training data to have any sense of how the model will perform.  The real intelligence is being performed before the model training.

Finally, taking stock of the earlier facts, we must concede that we have very little control over the performance of neural net models, except through: i) the data that is used as input, ii) deployment of the model as a packaged solution.  This characteristic matters because there are many situations when an AI solution absolutely must correctly label an input.  An example for (ii) is a high-stakes solution that determines whether a Death occurred within the description of a report (unstructured text).  There are many ways to describe Death using formal medical terminology.  However, if an obvious statement such as, 'The patient died,' is observed, then it must be labeled correctly.  Because the performance of a neural net model is difficult to control, it is good practice to use other methods (rule-based), in addition to neural net models, as part of a larger solution to ensure proper labeling of some input data.

To address controlling the model through the input data (i), we have to understand the tools we have available.  The definition and scope for labeling input data must be clear.  Also many difficulties arise from using human-based labeling, especially with respect to consistency in labels.  The breadth and depth of the data available for labeling should be critically analyzed by accounting for the larger population, as well as what is sampled and sampling method.  This naturally leads to one factor in particular that affects all of these controls: number of labeled data records.


## Sample Size in AI Practice

This work is not often performed as part of AI solution development.  I could only find a few research papers on this topic, and the approaches they offer are specific to the underlying problem addressed in the paper.  I've always found this subject to be important, but this is the first time I've had a chance to study and work on it.  

Also, the topic is treated similar to clinical trial sample size which is practically based on the amount of time and money available for the study.  The answer is always get more samples.

Many teams use the first few days of the project to label data.  This is an important time to familiarize yourself with the data and learn idiosyncrasies.



However, correctly labeling data is resource intensive.

The model learning curve provides a good understanding of how many samples are needed.

However, it does not explain whether the samples are representative of the population we are interested in.




## Ensuring Representative Samples

To ensure repr we need a proper sampling methodology.  If done correctly, then we obtain an unbiased sample with the minimum required sample necessary to ensure our model can reasonably generalize.

With a classification model, we are primarily concerned with getting a representative proportion.  We can use the confidence interval expression to formulate a sample size, given a margin of error.

<expression>

However, we will need to know the sample variance.  For a problem consisting of two labels, we determine the maximum variance using Bernoulli distribution

<expression>

This is an important point that the sample size is determined by variance, and the maximum variance can be taken without regard to the actual distribution.  This leads to ~1,100 samples be an appropriate sample size for any scenario with a large population.  This result is very counter-intuitive, as most people expect some type of linear relationship between the sample needed and the population size.  Andrew Gelman explains this for surveys by saying, "You must first assume that the survey respondents have been sampled at random from the population"[^1].  He continues with caveat, "The margin of error is a mathematical abstraction, and there are a number of reasons why actual errors in surveys are larger."  

But, it is also fortuitous as many labeling studies can afford 1,100 samples

Stratification ???


This are some basic foundations for understanding sample size.  This is not a popular topic in the literature, and the conclusions vary greatly [^3][^4].  For instance Alwosheel, etc. [^2] found that 50 times the number of weights should determine the number of samples needed.  This is an extraordinary requirement considering that most transformer models measure their model size in millions of weights. Very few manually-labeled datasets would be able to meet this requirement.  However, the paper does not discuss fine-tuning or transfer learning where only a small proportion of the original weights are trained.  In addition, zero-shot or few-shot learning attempts to address classification with little or no training.


## Rare Event Populations




## Validate with the Prediction Interval

Say the data is already labeled and the model is fit: how can we determine if our model classifies at the appropriate level?  We can construct a prediction interval from the output prediction probability.




## Using Samples to Inform Model Selection

Once final sampling is complete, the labeled data can be used to select models more effectively.  The AI practitioner has a many models to choose from, but should not immediately move to using the newest and most sophisticated.  The AI field is primarily directed to larger and more complex models that will fit whatever data is fed.  However, this comes with drawbacks, including large model files, as well as slower prediction latency.

An alternative is to use multiple simpler models with groups of similarly-patterned text.  For example, the FastText architecture is the simplest possible for a neural network because it uses just one hidden layer.  However, it is also quite fast and produces strong results.  The low-complexity of the model does not allow it to fit any diversity of data used for training.

Instead, labeled data can be grouped by similarity and a single model used for each group.  This both maximizes the information found in each labeled data, and ensures text patterns do not contain contradicting information.  Thereby, the resulting model groups may have similar scoring results, but with a much smaller disk footprint and resource demands.  The difficulty is effectively determining how the data should be grouped.  The number of samples needed for each group will also need to be calculated.


## Dangers from Large Manually-Labeled Data


## Conclusions



However, we already invested many weeks labeling data.  I realize the minimal figure I offer, 1100 reports, seems small when compared to the great diversity in sentences available.  A typical response is one such as found in this Scientific American article.  This result follows from:
mathematically, the proportion we are interested in is based on maximum variability of two outcomes: Death, NonDeath
the hypothesis testing performed supports the basic assumptions for the two outcomes
Furthermore, it may make more sense if you think of it from the perspective that there are a finite number of ways to describe Death, despite infinite ways the many different devices could kill someone. 

My assumptions and reasoning are quite conservative, as their is very little basis for beginning this work.  You stated that similar CDRH sampling investigations concluded much larger samples are necessary.  I would really enjoy hearing some of this work.  In addition, I fully accept that no one on this team has a background in sampling, so I'd be happy to discuss the technical aspects with a subject matter expert.



## References

[^1]: [How can a poll of only 1,004 Americans represent 260 million?](https://www.scientificamerican.com/article/howcan-a-poll-of-only-100/)
[^2]: [Is your dataset big enough? Sample size requirements when using artificial neural networks for discrete choice analysis](https://www.sciencedirect.com/science/article/abs/pii/S1755534518300058)
[^3]: [Deep Neural Networks for High Dimension, Low Sample Size Data](https://www.ijcai.org/proceedings/2017/0318.pdf)
[^4]: [Small sample size problems in designing artificial neural networks](https://www.sciencedirect.com/science/article/pii/B9780444887405500086)

