+++
author = "Jason Beach"
categories = ["datascience", "category2"]
date = "2019-11-18"
tags = ["nlp", "spacy", "nltk"]
title = "Processing Natural Language with Python and Friends"

+++


Python is a typical language chosen for Data Science work, and its strengths with strings make it especially useful for working with natural language.  While the `nltk` library opened-up this work for python users, the newer `spacy` improves upon processing power by implementing Cython code.  Tests display its power in production when compared with more traditional approaches, such as with Stanford's CoreNLP.  This post is an outline of examples from the [spacy coursework](https://course.spacy.io/) and [examples](https://spacy.io/usage/examples).  It also uses `nltk` for providing datasets.  Additional examples come from:

* [tutorials](https://github.com/cytora/pycon-nlp-in-10-lines/blob/master/00_spacy_intro.ipynb)
* [spacy usage documentation](https://spacy.io/usage/spacy-101#whats-spacy)
* [linguistic features](https://spacy.io/usage/linguistic-features)
* [api documentation](https://spacy.io/api/top-level#displacy.serve)

This tutorial introduces the basics of working with natural languages in python, including the following topics:

* Extract linguistic features: part-of-speech tags, dependencies, named entities
* Work with pre-trained statistical models
* Find words and phrases using Matcher and PhraseMatcher match rules
* Best practices for working with data structures Doc, Token Span, Vocab, Lexeme
* Find semantic similarities using word vectors
* Write custom pipeline components with extension attributes

## Configure Environment

Ensure that spacy is installed.  Language models are also necessary:
```
\\( python -m spacy download en\_core\_web\_sm
#or, pip install https://github.com/explosion/spacy-models/releases/download/en\_core\_web\_sm-2.0.0/en\_core\_web\_sm-2.0.0.tar.gz --no-deps
\\) python -m spacy validate
$ python -m spacy download en_core_web_lg --force
```

```python
import numpy as np
```

```python
from spacy.lang.en import English

nlp = English()
```

```python
import nltk
print( nltk.corpus.gutenberg.fileids())
```

```python
emma = nltk.corpus.gutenberg.raw('austen-emma.txt')
emma = emma.replace('\n',' ')
docEmma = nlp(emma)
```

## Finding words, phrases, names and concepts

### Documents, spans, and tokens

```python
# Process the text
doc = nlp("I like tree kangaroos and narwhals.")

# Select the first token
first_token = doc[0]

# Print the first token's text
print(first_token.text)
```

{{< output >}}
```nb-output
I
```
{{< /output >}}

```python
# Process the text
doc = nlp("I like tree kangaroos and narwhals.")

# A slice of the Doc for "tree kangaroos"
tree_kangaroos = doc[2:4]
print(tree_kangaroos.text)

# A slice of the Doc for "tree kangaroos and narwhals" (without the ".")
tree_kangaroos_and_narwhals = doc[2:6]
print(tree_kangaroos_and_narwhals.text)
```

{{< output >}}
```nb-output
tree kangaroos
tree kangaroos and narwhals
```
{{< /output >}}

### Lexical attributes

```python
# Process the text
doc = nlp("In 1990, more than 60% of people in East Asia were in extreme poverty. "
    "Now less than 4% are.")

# Iterate over the tokens in the doc
for token in doc:
    # Check if the token resembles a number
    if token.like_num:
        # Get the next token in the document
        next_token = doc[token.i + 1]
        # Check if the next token's text equals '%'
        if next_token.text == "%":
            print("Percentage found:", token.text)
```

{{< output >}}
```nb-output
Percentage found: 60
Percentage found: 4
```
{{< /output >}}

### Context-specific linguistic attributes (using models)

The model provides the binary weights that enable spaCy to make predictions.  It also includes the vocabulary, and meta information to tell spaCy which language class to use and how to configure the processing pipeline.  All models include a `meta.json` that defines the language to initialize, the pipeline component names to load as well as general meta information like the model name, version, license, data sources, author and accuracy figures (if available).  Model packages include a `strings.json` that stores the entries in the model’s vocabulary and the mapping to hashes. This allows spaCy to only communicate in hashes and look up the corresponding string if needed.

The en_core_web_lg (788 MB) compared to en_core_web_sm (10 MB):

* LAS: 90.07% vs 89.66%
* POS: 96.98% vs 96.78%
* UAS: 91.83% vs 91.53%
* NER F-score: 86.62% vs 85.86%
* NER precision: 87.03% vs 86.33%
* NER recall: 86.20% vs 85.39%

All that while en_core_web_lg is 79 times larger, hence loads a lot more slowly.


In spaCy, attributes that return strings usually end with an underscore (`pos_`) – attributes without the underscore return an ID.

* The `dep_` attribute returns the predicted dependency label.
* The `head` attribute returns the syntactic head token. You can also think of it as the parent token this word is attached to.
* The `doc.ents` property lets you access the named entities predicted by the model.

```python
#model package
#$ python -m spacy download en_core_web_sm
```

```python
#load models
import spacy
nlp = spacy.load('en_core_web_sm')
```

```python
doc = nlp("She ate the pizza")
```

```python
#iterate over the tokens
for token in doc:
    #print the text and the predicted part-of-speech tag
    print(token.i, token.text, token.pos_)
```

{{< output >}}
```nb-output
0 She PRON
1 ate VERB
2 the DET
3 pizza NOUN
```
{{< /output >}}

```python
#syntatic dependency
for token in doc:
    print(token.text, token.pos_, token.dep_, token.head.text)
```

{{< output >}}
```nb-output
She PRON nsubj ate
ate VERB ROOT ate
the DET det pizza
pizza NOUN dobj ate
```
{{< /output >}}

```python
#process a text
doc = nlp(u"Apple is looking at buying U.K. startup for $1 billion")

# Iterate over the predicted entities
for ent in doc.ents:
    # Print the entity text and its label
    print(ent.text, ent.label_)
```

{{< output >}}
```nb-output
Apple ORG
U.K. GPE
$1 billion MONEY
```
{{< /output >}}

```python
for tok in doc:
    print( tok.text, tok.ent_type_, end=" ")
```

{{< output >}}
```nb-output
Apple ORG is  looking  at  buying  U.K. GPE startup  for  $ MONEY 1 MONEY billion MONEY 
```
{{< /output >}}

```python
#common tags and labels
print( spacy.explain('GPE') )
print( spacy.explain('NNP') )
print( spacy.explain('dobj') )
```

{{< output >}}
```nb-output
Countries, cities, states
noun, proper singular
direct object
```
{{< /output >}}

```python
import spacy
from spacy import displacy
nlp = spacy.load("en_core_web_sm")
doc1 = nlp("This is a sentence.")
doc2 = nlp("This is another sentence.")
displacy.render([doc1, doc2], style="dep")
```


<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:lang="en" id="98185150183a41159336f6bbe30e0f1c-0" class="displacy" width="750" height="312.0" direction="ltr" style="max-width: none; height: 312.0px; color: #000000; background: #ffffff; font-family: Arial; direction: ltr">
<text class="displacy-token" fill="currentColor" text-anchor="middle" y="222.0">
    <tspan class="displacy-word" fill="currentColor" x="50">This</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="50">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="222.0">
    <tspan class="displacy-word" fill="currentColor" x="225">is</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="225">AUX</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="222.0">
    <tspan class="displacy-word" fill="currentColor" x="400">a</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="400">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="222.0">
    <tspan class="displacy-word" fill="currentColor" x="575">sentence.</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="575">NOUN</tspan>
</text>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-98185150183a41159336f6bbe30e0f1c-0-0" stroke-width="2px" d="M70,177.0 C70,89.5 220.0,89.5 220.0,177.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-98185150183a41159336f6bbe30e0f1c-0-0" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M70,179.0 L62,167.0 78,167.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-98185150183a41159336f6bbe30e0f1c-0-1" stroke-width="2px" d="M420,177.0 C420,89.5 570.0,89.5 570.0,177.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-98185150183a41159336f6bbe30e0f1c-0-1" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M420,179.0 L412,167.0 428,167.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-98185150183a41159336f6bbe30e0f1c-0-2" stroke-width="2px" d="M245,177.0 C245,2.0 575.0,2.0 575.0,177.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-98185150183a41159336f6bbe30e0f1c-0-2" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">attr</textPath>
    </text>
    <path class="displacy-arrowhead" d="M575.0,179.0 L583.0,167.0 567.0,167.0" fill="currentColor"/>
</g>
</svg>

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:lang="en" id="98185150183a41159336f6bbe30e0f1c-1" class="displacy" width="750" height="312.0" direction="ltr" style="max-width: none; height: 312.0px; color: #000000; background: #ffffff; font-family: Arial; direction: ltr">
<text class="displacy-token" fill="currentColor" text-anchor="middle" y="222.0">
    <tspan class="displacy-word" fill="currentColor" x="50">This</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="50">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="222.0">
    <tspan class="displacy-word" fill="currentColor" x="225">is</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="225">AUX</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="222.0">
    <tspan class="displacy-word" fill="currentColor" x="400">another</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="400">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="222.0">
    <tspan class="displacy-word" fill="currentColor" x="575">sentence.</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="575">NOUN</tspan>
</text>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-98185150183a41159336f6bbe30e0f1c-1-0" stroke-width="2px" d="M70,177.0 C70,89.5 220.0,89.5 220.0,177.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-98185150183a41159336f6bbe30e0f1c-1-0" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M70,179.0 L62,167.0 78,167.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-98185150183a41159336f6bbe30e0f1c-1-1" stroke-width="2px" d="M420,177.0 C420,89.5 570.0,89.5 570.0,177.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-98185150183a41159336f6bbe30e0f1c-1-1" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M420,179.0 L412,167.0 428,167.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-98185150183a41159336f6bbe30e0f1c-1-2" stroke-width="2px" d="M245,177.0 C245,2.0 575.0,2.0 575.0,177.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-98185150183a41159336f6bbe30e0f1c-1-2" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">attr</textPath>
    </text>
    <path class="displacy-arrowhead" d="M575.0,179.0 L583.0,167.0 567.0,167.0" fill="currentColor"/>
</g>
</svg>


```python
import spacy
from spacy import displacy
nlp = spacy.load("en_core_web_sm")

options = {"compact": True, "bg": "#09a3d5","color": "white", "font": "Source Sans Pro"}

text = """In ancient Rome, some neighbors live in three adjacent houses. In the center is the house of Senex, who lives there with wife Domina, son Hero, and several slaves, including head slave Hysterium and the musical's main character Pseudolus."""
doc = nlp(text)
sentence_spans = list(doc.sents)
displacy.render(sentence_spans, style="dep", options=options, jupyter=True)
```


<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:lang="en" id="c2baa64957a84bfb9ce5180baa2e949c-0" class="displacy" width="1550" height="437.0" direction="ltr" style="max-width: none; height: 437.0px; color: white; background: #09a3d5; font-family: Source Sans Pro; direction: ltr">
<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="50">In</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="50">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="200">ancient</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="200">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="350">Rome,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="350">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="500">some</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="500">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="650">neighbors</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="650">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="800">live</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="800">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="950">in</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="950">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1100">three</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1100">NUM</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1250">adjacent</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1250">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1400">houses.</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1400">NOUN</tspan>
</text>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-0" stroke-width="2px" d="M62,302.0 62,202.0 800.0,202.0 800.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-0" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M62,304.0 L58,296.0 66,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-1" stroke-width="2px" d="M212,302.0 212,277.0 341.0,277.0 341.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-1" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M212,304.0 L208,296.0 216,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-2" stroke-width="2px" d="M62,302.0 62,252.0 344.0,252.0 344.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-2" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M344.0,304.0 L348.0,296.0 340.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-3" stroke-width="2px" d="M512,302.0 512,277.0 641.0,277.0 641.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-3" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M512,304.0 L508,296.0 516,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-4" stroke-width="2px" d="M662,302.0 662,277.0 791.0,277.0 791.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-4" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M662,304.0 L658,296.0 666,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-5" stroke-width="2px" d="M812,302.0 812,277.0 941.0,277.0 941.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-5" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M941.0,304.0 L945.0,296.0 937.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-6" stroke-width="2px" d="M1112,302.0 1112,252.0 1394.0,252.0 1394.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-6" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nummod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1112,304.0 L1108,296.0 1116,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-7" stroke-width="2px" d="M1262,302.0 1262,277.0 1391.0,277.0 1391.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-7" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1262,304.0 L1258,296.0 1266,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-0-8" stroke-width="2px" d="M962,302.0 962,227.0 1397.0,227.0 1397.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-0-8" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1397.0,304.0 L1401.0,296.0 1393.0,296.0" fill="currentColor"/>
</g>
</svg>

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:lang="en" id="c2baa64957a84bfb9ce5180baa2e949c-1" class="displacy" width="4550" height="437.0" direction="ltr" style="max-width: none; height: 437.0px; color: white; background: #09a3d5; font-family: Source Sans Pro; direction: ltr">
<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="50">In</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="50">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="200">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="200">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="350">center</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="350">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="500">is</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="500">AUX</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="650">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="650">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="800">house</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="800">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="950">of</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="950">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1100">Senex,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1100">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1250">who</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1250">PRON</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1400">lives</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1400">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1550">there</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1550">ADV</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1700">with</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1700">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="1850">wife</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1850">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="2000">Domina,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2000">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="2150">son</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2150">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="2300">Hero,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2300">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="2450">and</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2450">CCONJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="2600">several</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2600">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="2750">slaves,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2750">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="2900">including</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2900">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="3050">head</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3050">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="3200">slave</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3200">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="3350">Hysterium</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3350">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="3500">and</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3500">CCONJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="3650">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3650">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="3800">musical</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3800">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="3950">'s</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3950">PART</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="4100">main</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4100">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="4250">character</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4250">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="347.0">
    <tspan class="displacy-word" fill="currentColor" x="4400">Pseudolus.</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4400">PROPN</tspan>
</text>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-0" stroke-width="2px" d="M62,302.0 62,227.0 497.0,227.0 497.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-0" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M62,304.0 L58,296.0 66,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-1" stroke-width="2px" d="M212,302.0 212,277.0 341.0,277.0 341.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-1" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M212,304.0 L208,296.0 216,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-2" stroke-width="2px" d="M62,302.0 62,252.0 344.0,252.0 344.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-2" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M344.0,304.0 L348.0,296.0 340.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-3" stroke-width="2px" d="M662,302.0 662,277.0 791.0,277.0 791.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-3" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M662,304.0 L658,296.0 666,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-4" stroke-width="2px" d="M512,302.0 512,252.0 794.0,252.0 794.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-4" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M794.0,304.0 L798.0,296.0 790.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-5" stroke-width="2px" d="M812,302.0 812,277.0 941.0,277.0 941.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-5" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M941.0,304.0 L945.0,296.0 937.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-6" stroke-width="2px" d="M962,302.0 962,277.0 1091.0,277.0 1091.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-6" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1091.0,304.0 L1095.0,296.0 1087.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-7" stroke-width="2px" d="M1262,302.0 1262,277.0 1391.0,277.0 1391.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-7" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1262,304.0 L1258,296.0 1266,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-8" stroke-width="2px" d="M1112,302.0 1112,252.0 1394.0,252.0 1394.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-8" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">relcl</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1394.0,304.0 L1398.0,296.0 1390.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-9" stroke-width="2px" d="M1412,302.0 1412,277.0 1541.0,277.0 1541.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-9" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">advmod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1541.0,304.0 L1545.0,296.0 1537.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-10" stroke-width="2px" d="M1412,302.0 1412,252.0 1694.0,252.0 1694.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-10" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1694.0,304.0 L1698.0,296.0 1690.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-11" stroke-width="2px" d="M1712,302.0 1712,277.0 1841.0,277.0 1841.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-11" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1841.0,304.0 L1845.0,296.0 1837.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-12" stroke-width="2px" d="M1862,302.0 1862,277.0 1991.0,277.0 1991.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-12" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">appos</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1991.0,304.0 L1995.0,296.0 1987.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-13" stroke-width="2px" d="M2162,302.0 2162,277.0 2291.0,277.0 2291.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-13" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">compound</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2162,304.0 L2158,296.0 2166,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-14" stroke-width="2px" d="M2012,302.0 2012,252.0 2294.0,252.0 2294.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-14" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">conj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2294.0,304.0 L2298.0,296.0 2290.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-15" stroke-width="2px" d="M2312,302.0 2312,277.0 2441.0,277.0 2441.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-15" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">cc</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2441.0,304.0 L2445.0,296.0 2437.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-16" stroke-width="2px" d="M2612,302.0 2612,277.0 2741.0,277.0 2741.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-16" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2612,304.0 L2608,296.0 2616,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-17" stroke-width="2px" d="M2312,302.0 2312,227.0 2747.0,227.0 2747.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-17" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">conj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2747.0,304.0 L2751.0,296.0 2743.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-18" stroke-width="2px" d="M2762,302.0 2762,277.0 2891.0,277.0 2891.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-18" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2891.0,304.0 L2895.0,296.0 2887.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-19" stroke-width="2px" d="M3062,302.0 3062,252.0 3344.0,252.0 3344.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-19" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">compound</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3062,304.0 L3058,296.0 3066,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-20" stroke-width="2px" d="M3212,302.0 3212,277.0 3341.0,277.0 3341.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-20" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">compound</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3212,304.0 L3208,296.0 3216,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-21" stroke-width="2px" d="M2912,302.0 2912,227.0 3347.0,227.0 3347.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-21" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3347.0,304.0 L3351.0,296.0 3343.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-22" stroke-width="2px" d="M3362,302.0 3362,277.0 3491.0,277.0 3491.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-22" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">cc</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3491.0,304.0 L3495.0,296.0 3487.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-23" stroke-width="2px" d="M3662,302.0 3662,277.0 3791.0,277.0 3791.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-23" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3662,304.0 L3658,296.0 3666,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-24" stroke-width="2px" d="M3812,302.0 3812,227.0 4247.0,227.0 4247.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-24" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">poss</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3812,304.0 L3808,296.0 3816,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-25" stroke-width="2px" d="M3812,302.0 3812,277.0 3941.0,277.0 3941.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-25" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">case</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3941.0,304.0 L3945.0,296.0 3937.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-26" stroke-width="2px" d="M4112,302.0 4112,277.0 4241.0,277.0 4241.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-26" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4112,304.0 L4108,296.0 4116,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-27" stroke-width="2px" d="M3362,302.0 3362,202.0 4250.0,202.0 4250.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-27" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">conj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4250.0,304.0 L4254.0,296.0 4246.0,296.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-1-28" stroke-width="2px" d="M4262,302.0 4262,277.0 4391.0,277.0 4391.0,302.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-1-28" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">appos</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4391.0,304.0 L4395.0,296.0 4387.0,296.0" fill="currentColor"/>
</g>
</svg>

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:lang="en" id="c2baa64957a84bfb9ce5180baa2e949c-2" class="displacy" width="2150" height="362.0" direction="ltr" style="max-width: none; height: 362.0px; color: white; background: #09a3d5; font-family: Source Sans Pro; direction: ltr">
<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="50">A</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="50">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="200">slave</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="200">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="350">belonging</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="350">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="500">to</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="500">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="650">Hero,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="650">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="800">Pseudolus</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="800">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="950">wishes</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="950">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="1100">to</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1100">PART</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="1250">buy,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1250">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="1400">win,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1400">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="1550">or</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1550">CCONJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="1700">steal</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1700">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="1850">his</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1850">PRON</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="272.0">
    <tspan class="displacy-word" fill="currentColor" x="2000">freedom.</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2000">NOUN</tspan>
</text>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-0" stroke-width="2px" d="M62,227.0 62,202.0 194.0,202.0 194.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-0" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M62,229.0 L58,221.0 66,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-1" stroke-width="2px" d="M212,227.0 212,152.0 950.0,152.0 950.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-1" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">npadvmod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M212,229.0 L208,221.0 216,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-2" stroke-width="2px" d="M212,227.0 212,202.0 344.0,202.0 344.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-2" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">acl</textPath>
    </text>
    <path class="displacy-arrowhead" d="M344.0,229.0 L348.0,221.0 340.0,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-3" stroke-width="2px" d="M362,227.0 362,202.0 494.0,202.0 494.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-3" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M494.0,229.0 L498.0,221.0 490.0,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-4" stroke-width="2px" d="M512,227.0 512,202.0 644.0,202.0 644.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-4" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M644.0,229.0 L648.0,221.0 640.0,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-5" stroke-width="2px" d="M812,227.0 812,202.0 944.0,202.0 944.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-5" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M812,229.0 L808,221.0 816,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-6" stroke-width="2px" d="M1112,227.0 1112,202.0 1244.0,202.0 1244.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-6" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">aux</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1112,229.0 L1108,221.0 1116,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-7" stroke-width="2px" d="M962,227.0 962,177.0 1247.0,177.0 1247.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-7" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">xcomp</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1247.0,229.0 L1251.0,221.0 1243.0,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-8" stroke-width="2px" d="M1262,227.0 1262,202.0 1394.0,202.0 1394.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-8" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">conj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1394.0,229.0 L1398.0,221.0 1390.0,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-9" stroke-width="2px" d="M1412,227.0 1412,202.0 1544.0,202.0 1544.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-9" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">cc</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1544.0,229.0 L1548.0,221.0 1540.0,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-10" stroke-width="2px" d="M1412,227.0 1412,177.0 1697.0,177.0 1697.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-10" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">conj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1697.0,229.0 L1701.0,221.0 1693.0,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-11" stroke-width="2px" d="M1862,227.0 1862,202.0 1994.0,202.0 1994.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-11" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">poss</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1862,229.0 L1858,221.0 1866,221.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-2-12" stroke-width="2px" d="M1712,227.0 1712,177.0 1997.0,177.0 1997.0,227.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-2-12" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">dobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1997.0,229.0 L2001.0,221.0 1993.0,221.0" fill="currentColor"/>
</g>
</svg>

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:lang="en" id="c2baa64957a84bfb9ce5180baa2e949c-3" class="displacy" width="6050" height="587.0" direction="ltr" style="max-width: none; height: 587.0px; color: white; background: #09a3d5; font-family: Source Sans Pro; direction: ltr">
<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="50">One</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="50">NUM</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="200">of</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="200">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="350">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="350">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="500">neighboring</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="500">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="650">houses</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="650">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="800">is</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="800">AUX</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="950">owned</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="950">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="1100">by</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1100">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="1250">Marcus</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1250">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="1400">Lycus,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1400">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="1550">who</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1550">PRON</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="1700">is</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1700">AUX</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="1850">a</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1850">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="2000">buyer</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2000">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="2150">and</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2150">CCONJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="2300">seller</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2300">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="2450">of</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2450">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="2600">beautiful</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2600">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="2750">women;</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2750">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="2900">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2900">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="3050">other</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3050">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="3200">belongs</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3200">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="3350">to</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3350">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="3500">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3500">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="3650">ancient</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3650">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="3800">Erronius,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3800">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="3950">who</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3950">PRON</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="4100">is</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4100">AUX</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="4250">abroad</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4250">ADV</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="4400">searching</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4400">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="4550">for</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4550">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="4700">his</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4700">PRON</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="4850">long-</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="4850">ADV</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="5000">lost</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="5000">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="5150">children (</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="5150">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="5300">stolen</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="5300">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="5450">in</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="5450">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="5600">infancy</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="5600">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="5750">by</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="5750">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="497.0">
    <tspan class="displacy-word" fill="currentColor" x="5900">pirates).</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="5900">NOUN</tspan>
</text>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-0" stroke-width="2px" d="M62,452.0 62,327.0 947.0,327.0 947.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-0" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubjpass</textPath>
    </text>
    <path class="displacy-arrowhead" d="M62,454.0 L58,446.0 66,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-1" stroke-width="2px" d="M62,452.0 62,427.0 185.0,427.0 185.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-1" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M185.0,454.0 L189.0,446.0 181.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-2" stroke-width="2px" d="M362,452.0 362,402.0 638.0,402.0 638.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-2" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M362,454.0 L358,446.0 366,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-3" stroke-width="2px" d="M512,452.0 512,427.0 635.0,427.0 635.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-3" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M512,454.0 L508,446.0 516,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-4" stroke-width="2px" d="M212,452.0 212,377.0 641.0,377.0 641.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-4" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M641.0,454.0 L645.0,446.0 637.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-5" stroke-width="2px" d="M812,452.0 812,427.0 935.0,427.0 935.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-5" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">auxpass</textPath>
    </text>
    <path class="displacy-arrowhead" d="M812,454.0 L808,446.0 816,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-6" stroke-width="2px" d="M962,452.0 962,302.0 3200.0,302.0 3200.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-6" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">ccomp</textPath>
    </text>
    <path class="displacy-arrowhead" d="M962,454.0 L958,446.0 966,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-7" stroke-width="2px" d="M962,452.0 962,427.0 1085.0,427.0 1085.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-7" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">agent</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1085.0,454.0 L1089.0,446.0 1081.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-8" stroke-width="2px" d="M1262,452.0 1262,427.0 1385.0,427.0 1385.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-8" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">compound</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1262,454.0 L1258,446.0 1266,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-9" stroke-width="2px" d="M1112,452.0 1112,402.0 1388.0,402.0 1388.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-9" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1388.0,454.0 L1392.0,446.0 1384.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-10" stroke-width="2px" d="M1562,452.0 1562,427.0 1685.0,427.0 1685.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-10" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1562,454.0 L1558,446.0 1566,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-11" stroke-width="2px" d="M1412,452.0 1412,402.0 1688.0,402.0 1688.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-11" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">relcl</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1688.0,454.0 L1692.0,446.0 1684.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-12" stroke-width="2px" d="M1862,452.0 1862,427.0 1985.0,427.0 1985.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-12" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1862,454.0 L1858,446.0 1866,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-13" stroke-width="2px" d="M1712,452.0 1712,402.0 1988.0,402.0 1988.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-13" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">attr</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1988.0,454.0 L1992.0,446.0 1984.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-14" stroke-width="2px" d="M2012,452.0 2012,427.0 2135.0,427.0 2135.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-14" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">cc</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2135.0,454.0 L2139.0,446.0 2131.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-15" stroke-width="2px" d="M2012,452.0 2012,402.0 2288.0,402.0 2288.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-15" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">conj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2288.0,454.0 L2292.0,446.0 2284.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-16" stroke-width="2px" d="M2012,452.0 2012,377.0 2441.0,377.0 2441.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-16" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2441.0,454.0 L2445.0,446.0 2437.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-17" stroke-width="2px" d="M2612,452.0 2612,427.0 2735.0,427.0 2735.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-17" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2612,454.0 L2608,446.0 2616,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-18" stroke-width="2px" d="M2462,452.0 2462,402.0 2738.0,402.0 2738.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-18" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2738.0,454.0 L2742.0,446.0 2734.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-19" stroke-width="2px" d="M2912,452.0 2912,427.0 3035.0,427.0 3035.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-19" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2912,454.0 L2908,446.0 2916,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-20" stroke-width="2px" d="M3062,452.0 3062,427.0 3185.0,427.0 3185.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-20" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3062,454.0 L3058,446.0 3066,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-21" stroke-width="2px" d="M3212,452.0 3212,427.0 3335.0,427.0 3335.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-21" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3335.0,454.0 L3339.0,446.0 3331.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-22" stroke-width="2px" d="M3512,452.0 3512,402.0 3788.0,402.0 3788.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-22" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3512,454.0 L3508,446.0 3516,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-23" stroke-width="2px" d="M3662,452.0 3662,427.0 3785.0,427.0 3785.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-23" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3662,454.0 L3658,446.0 3666,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-24" stroke-width="2px" d="M3362,452.0 3362,377.0 3791.0,377.0 3791.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-24" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3791.0,454.0 L3795.0,446.0 3787.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-25" stroke-width="2px" d="M3962,452.0 3962,427.0 4085.0,427.0 4085.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-25" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3962,454.0 L3958,446.0 3966,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-26" stroke-width="2px" d="M3812,452.0 3812,402.0 4088.0,402.0 4088.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-26" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">relcl</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4088.0,454.0 L4092.0,446.0 4084.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-27" stroke-width="2px" d="M4112,452.0 4112,427.0 4235.0,427.0 4235.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-27" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">advmod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4235.0,454.0 L4239.0,446.0 4231.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-28" stroke-width="2px" d="M4112,452.0 4112,402.0 4388.0,402.0 4388.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-28" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">advcl</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4388.0,454.0 L4392.0,446.0 4384.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-29" stroke-width="2px" d="M4412,452.0 4412,427.0 4535.0,427.0 4535.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-29" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4535.0,454.0 L4539.0,446.0 4531.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-30" stroke-width="2px" d="M4712,452.0 4712,377.0 5141.0,377.0 5141.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-30" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">poss</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4712,454.0 L4708,446.0 4716,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-31" stroke-width="2px" d="M4862,452.0 4862,427.0 4985.0,427.0 4985.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-31" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">advmod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M4862,454.0 L4858,446.0 4866,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-32" stroke-width="2px" d="M5012,452.0 5012,427.0 5135.0,427.0 5135.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-32" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M5012,454.0 L5008,446.0 5016,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-33" stroke-width="2px" d="M4562,452.0 4562,352.0 5144.0,352.0 5144.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-33" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M5144.0,454.0 L5148.0,446.0 5140.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-34" stroke-width="2px" d="M5162,452.0 5162,427.0 5285.0,427.0 5285.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-34" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">acl</textPath>
    </text>
    <path class="displacy-arrowhead" d="M5285.0,454.0 L5289.0,446.0 5281.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-35" stroke-width="2px" d="M5312,452.0 5312,427.0 5435.0,427.0 5435.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-35" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M5435.0,454.0 L5439.0,446.0 5431.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-36" stroke-width="2px" d="M5462,452.0 5462,427.0 5585.0,427.0 5585.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-36" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M5585.0,454.0 L5589.0,446.0 5581.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-37" stroke-width="2px" d="M5312,452.0 5312,377.0 5741.0,377.0 5741.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-37" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">agent</textPath>
    </text>
    <path class="displacy-arrowhead" d="M5741.0,454.0 L5745.0,446.0 5737.0,446.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-3-38" stroke-width="2px" d="M5762,452.0 5762,427.0 5885.0,427.0 5885.0,452.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-3-38" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M5885.0,454.0 L5889.0,446.0 5881.0,446.0" fill="currentColor"/>
</g>
</svg>

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:lang="en" id="c2baa64957a84bfb9ce5180baa2e949c-4" class="displacy" width="2450" height="512.0" direction="ltr" style="max-width: none; height: 512.0px; color: white; background: #09a3d5; font-family: Source Sans Pro; direction: ltr">
<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="50">One</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="50">NUM</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="200">day,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="200">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="350">Senex</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="350">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="500">and</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="500">CCONJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="650">Domina</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="650">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="800">go</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="800">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="950">on</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="950">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1100">a</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1100">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1250">trip</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1250">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1400">and</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1400">CCONJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1550">leave</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1550">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1700">Pseudolus</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1700">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1850">in</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1850">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2000">charge</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2000">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2150">of</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2150">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2300">Hero.</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2300">PROPN</tspan>
</text>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-0" stroke-width="2px" d="M62,377.0 62,352.0 188.0,352.0 188.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-0" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nummod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M62,379.0 L58,371.0 66,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-1" stroke-width="2px" d="M212,377.0 212,277.0 797.0,277.0 797.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-1" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">npadvmod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M212,379.0 L208,371.0 216,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-2" stroke-width="2px" d="M362,377.0 362,302.0 794.0,302.0 794.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-2" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M362,379.0 L358,371.0 366,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-3" stroke-width="2px" d="M362,377.0 362,352.0 488.0,352.0 488.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-3" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">cc</textPath>
    </text>
    <path class="displacy-arrowhead" d="M488.0,379.0 L492.0,371.0 484.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-4" stroke-width="2px" d="M362,377.0 362,327.0 641.0,327.0 641.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-4" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">conj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M641.0,379.0 L645.0,371.0 637.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-5" stroke-width="2px" d="M812,377.0 812,352.0 938.0,352.0 938.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-5" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M938.0,379.0 L942.0,371.0 934.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-6" stroke-width="2px" d="M1112,377.0 1112,352.0 1238.0,352.0 1238.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-6" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1112,379.0 L1108,371.0 1116,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-7" stroke-width="2px" d="M962,377.0 962,327.0 1241.0,327.0 1241.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-7" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1241.0,379.0 L1245.0,371.0 1237.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-8" stroke-width="2px" d="M812,377.0 812,277.0 1397.0,277.0 1397.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-8" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">cc</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1397.0,379.0 L1401.0,371.0 1393.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-9" stroke-width="2px" d="M812,377.0 812,252.0 1550.0,252.0 1550.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-9" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">conj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1550.0,379.0 L1554.0,371.0 1546.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-10" stroke-width="2px" d="M1562,377.0 1562,352.0 1688.0,352.0 1688.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-10" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">dobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1688.0,379.0 L1692.0,371.0 1684.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-11" stroke-width="2px" d="M1562,377.0 1562,327.0 1841.0,327.0 1841.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-11" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1841.0,379.0 L1845.0,371.0 1837.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-12" stroke-width="2px" d="M1862,377.0 1862,352.0 1988.0,352.0 1988.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-12" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1988.0,379.0 L1992.0,371.0 1984.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-13" stroke-width="2px" d="M2012,377.0 2012,352.0 2138.0,352.0 2138.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-13" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2138.0,379.0 L2142.0,371.0 2134.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-4-14" stroke-width="2px" d="M2162,377.0 2162,352.0 2288.0,352.0 2288.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-4-14" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2288.0,379.0 L2292.0,371.0 2284.0,371.0" fill="currentColor"/>
</g>
</svg>

<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:lang="en" id="c2baa64957a84bfb9ce5180baa2e949c-5" class="displacy" width="3950" height="512.0" direction="ltr" style="max-width: none; height: 512.0px; color: white; background: #09a3d5; font-family: Source Sans Pro; direction: ltr">
<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="50">Hero</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="50">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="200">confides</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="200">VERB</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="350">in</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="350">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="500">Pseudolus</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="500">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="650">that</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="650">SCONJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="800">he</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="800">PRON</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="950">is</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="950">AUX</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1100">in</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1100">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1250">love</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1250">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1400">with</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1400">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1550">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1550">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1700">lovely</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1700">ADJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="1850">Philia,</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="1850">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2000">one</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2000">NUM</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2150">of</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2150">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2300">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2300">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2450">courtesans</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2450">NOUN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2600">in</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2600">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2750">the</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2750">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="2900">House</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="2900">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="3050">of</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3050">ADP</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="3200">Lycus (</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3200">PROPN</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="3350">albeit</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3350">SCONJ</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="3500">still</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3500">ADV</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="3650">a</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3650">DET</tspan>
</text>

<text class="displacy-token" fill="currentColor" text-anchor="middle" y="422.0">
    <tspan class="displacy-word" fill="currentColor" x="3800">virgin).</tspan>
    <tspan class="displacy-tag" dy="2em" fill="currentColor" x="3800">NOUN</tspan>
</text>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-0" stroke-width="2px" d="M62,377.0 62,352.0 188.0,352.0 188.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-0" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M62,379.0 L58,371.0 66,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-1" stroke-width="2px" d="M212,377.0 212,352.0 338.0,352.0 338.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-1" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M338.0,379.0 L342.0,371.0 334.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-2" stroke-width="2px" d="M362,377.0 362,352.0 488.0,352.0 488.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-2" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M488.0,379.0 L492.0,371.0 484.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-3" stroke-width="2px" d="M662,377.0 662,327.0 941.0,327.0 941.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-3" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">mark</textPath>
    </text>
    <path class="displacy-arrowhead" d="M662,379.0 L658,371.0 666,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-4" stroke-width="2px" d="M812,377.0 812,352.0 938.0,352.0 938.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-4" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">nsubj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M812,379.0 L808,371.0 816,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-5" stroke-width="2px" d="M212,377.0 212,277.0 947.0,277.0 947.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-5" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">ccomp</textPath>
    </text>
    <path class="displacy-arrowhead" d="M947.0,379.0 L951.0,371.0 943.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-6" stroke-width="2px" d="M962,377.0 962,352.0 1088.0,352.0 1088.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-6" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1088.0,379.0 L1092.0,371.0 1084.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-7" stroke-width="2px" d="M1112,377.0 1112,352.0 1238.0,352.0 1238.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-7" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1238.0,379.0 L1242.0,371.0 1234.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-8" stroke-width="2px" d="M1262,377.0 1262,352.0 1388.0,352.0 1388.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-8" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1388.0,379.0 L1392.0,371.0 1384.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-9" stroke-width="2px" d="M1562,377.0 1562,327.0 1841.0,327.0 1841.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-9" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1562,379.0 L1558,371.0 1566,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-10" stroke-width="2px" d="M1712,377.0 1712,352.0 1838.0,352.0 1838.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-10" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">amod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1712,379.0 L1708,371.0 1716,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-11" stroke-width="2px" d="M1412,377.0 1412,302.0 1844.0,302.0 1844.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-11" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1844.0,379.0 L1848.0,371.0 1840.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-12" stroke-width="2px" d="M1862,377.0 1862,352.0 1988.0,352.0 1988.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-12" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">appos</textPath>
    </text>
    <path class="displacy-arrowhead" d="M1988.0,379.0 L1992.0,371.0 1984.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-13" stroke-width="2px" d="M2012,377.0 2012,352.0 2138.0,352.0 2138.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-13" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2138.0,379.0 L2142.0,371.0 2134.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-14" stroke-width="2px" d="M2312,377.0 2312,352.0 2438.0,352.0 2438.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-14" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2312,379.0 L2308,371.0 2316,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-15" stroke-width="2px" d="M2162,377.0 2162,327.0 2441.0,327.0 2441.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-15" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2441.0,379.0 L2445.0,371.0 2437.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-16" stroke-width="2px" d="M2462,377.0 2462,352.0 2588.0,352.0 2588.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-16" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2588.0,379.0 L2592.0,371.0 2584.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-17" stroke-width="2px" d="M2762,377.0 2762,352.0 2888.0,352.0 2888.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-17" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2762,379.0 L2758,371.0 2766,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-18" stroke-width="2px" d="M2612,377.0 2612,327.0 2891.0,327.0 2891.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-18" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M2891.0,379.0 L2895.0,371.0 2887.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-19" stroke-width="2px" d="M2912,377.0 2912,352.0 3038.0,352.0 3038.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-19" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">prep</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3038.0,379.0 L3042.0,371.0 3034.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-20" stroke-width="2px" d="M3062,377.0 3062,352.0 3188.0,352.0 3188.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-20" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3188.0,379.0 L3192.0,371.0 3184.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-21" stroke-width="2px" d="M962,377.0 962,252.0 3350.0,252.0 3350.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-21" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">advmod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3350.0,379.0 L3354.0,371.0 3346.0,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-22" stroke-width="2px" d="M3512,377.0 3512,327.0 3791.0,327.0 3791.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-22" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">advmod</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3512,379.0 L3508,371.0 3516,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-23" stroke-width="2px" d="M3662,377.0 3662,352.0 3788.0,352.0 3788.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-23" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">det</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3662,379.0 L3658,371.0 3666,371.0" fill="currentColor"/>
</g>

<g class="displacy-arrow">
    <path class="displacy-arc" id="arrow-c2baa64957a84bfb9ce5180baa2e949c-5-24" stroke-width="2px" d="M3362,377.0 3362,302.0 3794.0,302.0 3794.0,377.0" fill="none" stroke="currentColor"/>
    <text dy="1.25em" style="font-size: 0.8em; letter-spacing: 1px">
        <textPath xlink:href="#arrow-c2baa64957a84bfb9ce5180baa2e949c-5-24" class="displacy-label" startOffset="50%" side="left" fill="currentColor" text-anchor="middle">pobj</textPath>
    </text>
    <path class="displacy-arrowhead" d="M3794.0,379.0 L3798.0,371.0 3790.0,371.0" fill="currentColor"/>
</g>
</svg>


```python
import spacy
from spacy import displacy

text = "When Sebastian Thrun started working on self-driving cars at Google in 2007, few people outside of the company took him seriously."

nlp = spacy.load("en_core_web_sm")
doc = nlp(text)
displacy.render(doc, style="ent")
```


<div class="entities" style="line-height: 2.5; direction: ltr">When 
<mark class="entity" style="background: #aa9cfc; padding: 0.45em 0.6em; margin: 0 0.25em; line-height: 1; border-radius: 0.35em;">
    Sebastian Thrun
    <span style="font-size: 0.8em; font-weight: bold; line-height: 1; border-radius: 0.35em; text-transform: uppercase; vertical-align: middle; margin-left: 0.5rem">PERSON</span>
</mark>
 started working on self-driving cars at 
<mark class="entity" style="background: #7aecec; padding: 0.45em 0.6em; margin: 0 0.25em; line-height: 1; border-radius: 0.35em;">
    Google
    <span style="font-size: 0.8em; font-weight: bold; line-height: 1; border-radius: 0.35em; text-transform: uppercase; vertical-align: middle; margin-left: 0.5rem">ORG</span>
</mark>
 in 
<mark class="entity" style="background: #bfe1d9; padding: 0.45em 0.6em; margin: 0 0.25em; line-height: 1; border-radius: 0.35em;">
    2007
    <span style="font-size: 0.8em; font-weight: bold; line-height: 1; border-radius: 0.35em; text-transform: uppercase; vertical-align: middle; margin-left: 0.5rem">DATE</span>
</mark>
, few people outside of the company took him seriously.</div>


```python
colors = {"ORG": "linear-gradient(90deg, #aa9cfc, #fc9ce7)"}
options = {"ents": ["ORG"], "colors": colors}

displacy.render(doc, style="ent", options=options)
```


<div class="entities" style="line-height: 2.5; direction: ltr">When Sebastian Thrun started working on self-driving cars at 
<mark class="entity" style="background: linear-gradient(90deg, #aa9cfc, #fc9ce7); padding: 0.45em 0.6em; margin: 0 0.25em; line-height: 1; border-radius: 0.35em;">
    Google
    <span style="font-size: 0.8em; font-weight: bold; line-height: 1; border-radius: 0.35em; text-transform: uppercase; vertical-align: middle; margin-left: 0.5rem">ORG</span>
</mark>
 in 2007, few people outside of the company took him seriously.</div>


```python
{
    "words": [
        {"text": "This", "tag": "DT"},
        {"text": "is", "tag": "VBZ"},
        {"text": "a", "tag": "DT"},
        {"text": "sentence", "tag": "NN"}
    ],
    "arcs": [
        {"start": 0, "end": 1, "label": "nsubj", "dir": "left"},
        {"start": 2, "end": 3, "label": "det", "dir": "left"},
        {"start": 1, "end": 3, "label": "attr", "dir": "right"}
    ]
}

ex = [{"text": "But Google is starting from behind.",
       "ents": [{"start": 4, "end": 10, "label": "ORG"}],
       "title": None}]
html = displacy.render(ex, style="ent", manual=True)
```


<div class="entities" style="line-height: 2.5; direction: ltr">But 
<mark class="entity" style="background: #7aecec; padding: 0.45em 0.6em; margin: 0 0.25em; line-height: 1; border-radius: 0.35em;">
    Google
    <span style="font-size: 0.8em; font-weight: bold; line-height: 1; border-radius: 0.35em; text-transform: uppercase; vertical-align: middle; margin-left: 0.5rem">ORG</span>
</mark>
 is starting from behind.</div>


### Rule-based matching

* Match exact token texts: `[{'TEXT': 'iPhone'}, {'TEXT': 'X'}]`
* Match lexical attributes: `[{'LOWER': 'iphone'}, {'LOWER': 'x'}]`
* Match any token attributes: `[{'LEMMA': 'buy'}, {'POS': 'NOUN'}]`

```python
# Import the Matcher
from spacy.matcher import Matcher

text = "New iPhone X release date leaked as Apple reveals pre-orders by mistake"

# Initialize the matcher with the shared vocab
matcher = Matcher(nlp.vocab)

# Add the pattern to the matcher
pattern = [{'TEXT': 'iPhone'}, {'TEXT': 'X'}]
matcher.add('IPHONE_PATTERN', None, pattern)

# Process some text
doc = nlp("New iPhone X release date leaked")

# Call the matcher on the doc
matches = matcher(doc)

#match_id: hash value of the pattern name
#start: start index of matched span
#end: end index of matched span

# Iterate over the matches
for match_id, start, end in matches:
    # Get the matched span
    matched_span = doc[start:end]
    print(matched_span.text)
```




{{< output >}}
```nb-output
[(9528407286733565721, 1, 3)]
```
{{< /output >}}



```python
# Write a pattern that matches a form of "download" plus proper noun
pattern = [{"LEMMA": "download"}, {"POS": "PROPN"}]
# Write a pattern for adjective plus one or two nouns
pattern = [{"POS": ____}, {"POS": ____}, {"POS": ____, "OP": ____}]
```

## Large-scale data analysis with spaCy

### Vocab, hashes, lexeme

`vocab` stores data shared across multiple documents.  The `doc` contains words in context with their part-of-speech tags and dependencies. The `string store` maintains the text of the vocab hashes.

A `lexeme` object is an hash entry in the vocabulary `vocab`.  `lexemes` hold context-independent information about a word, like the text, or whether the the word consists of alphabetic characters.  Don't have part-of-speech tags, dependencies or entity labels. Those depend on the context.

```python
nlp.vocab.length
```




{{< output >}}
```nb-output
498
```
{{< /output >}}



```python
#Hashes can't be reversed – that's why we need to provide the shared vocab
coffee_hash = nlp.vocab.strings['coffee']
print(coffee_hash)
```

{{< output >}}
```nb-output
3197928453018144401
```
{{< /output >}}

```python
# Raises an error if we haven't seen the string before
string = nlp.vocab.strings[3197928453018144401]
```

```python
doc = nlp("I love coffee")
print('hash value:', nlp.vocab.strings['coffee'], doc.vocab.strings['coffee'])
print('string value:', nlp.vocab.strings[3197928453018144401])
```

{{< output >}}
```nb-output
hash value: 3197928453018144401 3197928453018144401
string value: coffee
```
{{< /output >}}

```python
#contains the context-independent information
doc = nlp("I love coffee")
lexeme = nlp.vocab['coffee']

# Print the lexical attributes
print(lexeme.text, lexeme.orth, lexeme.is_alpha)
```

{{< output >}}
```nb-output
coffee 3197928453018144401 True
```
{{< /output >}}

### Doc, span, and token

`Doc` is created automatically when you process a text with the `nlp` object. But you can also instantiate the class manually.  It takes three arguments: the shared vocab, the words and the spaces.

A `Span` is a slice of a `Doc` consisting of one or more tokens. The `Span` takes at least three arguments: the doc it refers to, and the start and end index of the span (with end index exclusive).

Doc and Span are very powerful and hold references and relationships of words and sentences

* Convert result to strings as late as possible
* Use token attributes if available – for example, token.i for the token index.  This will let you reuse it in spaCy.

```python
# Create an nlp object
from spacy.lang.en import English
nlp = English()

# Import the Doc class
from spacy.tokens import Doc

# The words and spaces to create the doc from
words = ['Hello', 'world', '!']
spaces = [True, False, False]

# Create a doc manually
doc = Doc(nlp.vocab, words=words, spaces=spaces)
doc
```




{{< output >}}
```nb-output
Hello world!
```
{{< /output >}}



```python
# Import the Doc class
from spacy.tokens import Span

# Create a doc manually
doc = Doc(nlp.vocab, words=words, spaces=spaces)

# Create a span manually
span = Span(doc, 0, 2)

# Create a span with a label
span_with_label = Span(doc, 0, 2, label="GREETING")

# Add span to the doc.ents
doc.ents = [span_with_label]

# Print entities' text and labels
print([(ent.text, ent.label_) for ent in doc.ents])
```

{{< output >}}
```nb-output
[('I like', 'GREETING')]
```
{{< /output >}}

### Similarity and vectors

In order to use similarity, you need a larger spaCy model that has word vectors included (`en_core_web_lg`, `en_core_web_md` – but not `_sm`).  That is because `similarity` is determined using word vectors.  Word vectors are generated using an algorithm like Word2Vec and lots of text.  The default distance is `cosine` similarity, but can be adjusted.

For a more in-depth look, the [source code](https://spacy.io/docs/usage/word-vectors-similarities) for `.similarity` shows:

`return numpy.dot(self.vector, other.vector) / (self.vector_norm * other.vector_norm)`

```python
# Load a larger model with vectors
nlp = spacy.load('en_core_web_lg')

# Compare two documents
doc1 = nlp("I like fast food")
doc2 = nlp("I like pizza")
print(doc1.similarity(doc2))

doc = nlp("I like pizza and pasta")
token1 = doc[2]
token2 = doc[4]
print(token1.similarity(token2))
```

{{< output >}}
```nb-output
0.8627203210548107
0.7369546
```
{{< /output >}}

```python
nlp = spacy.load('en_core_web_sm')
doc1 = nlp("I")
print( doc1.vector.shape )
```

{{< output >}}
```nb-output
(96,)
```
{{< /output >}}

```python
nlp = spacy.load('en_core_web_lg')
doc1 = nlp("I")
print( doc1.vector.shape )
```

{{< output >}}
```nb-output
(300,)
```
{{< /output >}}

```python
nlp = spacy.load('en_core_web_sm')

doc1 = nlp("I")
doc2 = nlp("like")
doc3 = nlp("I like")
doc4 = nlp("I like pizza")

print( doc1.vector.shape, ' ', doc1.vector_norm )
print( doc2.vector.shape, ' ', doc2.vector_norm )
print( doc3.vector.shape, ' ', doc3.vector_norm )
print( doc4.vector.shape, ' ', doc4.vector_norm )
```

{{< output >}}
```nb-output
(96,)   23.1725315055188
(96,)   21.75560300132138
(96,)   17.23478412191207
(96,)   14.848700829346688
```
{{< /output >}}

```python
doc1[0].vector == doc3[0].vector
```




{{< output >}}
```nb-output
array([False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False, False, False, False,
       False, False, False, False, False, False])
```
{{< /output >}}



```python
print( np.dot(doc1.vector, doc2.vector) )
print( np.linalg.norm(doc2.vector, ord=2) )
print( np.linalg.norm(doc1.vector, ord=2) == np.linalg.norm(doc2.vector, ord=2) )
print( doc2.vector_norm )
```

{{< output >}}
```nb-output
21.871986
4.6767497
True
4.676749731219555
```
{{< /output >}}

```python
doc1 = nlp("pizza like I")
doc2 = nlp("I like pizza")
doc3 = nlp("pizza I like")
doc4 = nlp("like pizza I")
doc5 = nlp("I pizza like")
doc6 = nlp("like I pizza")

lDoc = [doc1, doc2, doc3, doc4, doc5, doc6]
result = np.zeros((6,6))
for i,doc1 in enumerate(lDoc):
    for j, doc2 in enumerate(lDoc):
        result[i,j] = doc1.similarity(doc2)
```

```python
result
```




{{< output >}}
```nb-output
array([[1.        , 0.99999994, 0.99999994, 0.99999995, 0.99999994,
        0.99999994],
       [0.99999994, 1.        , 0.99999993, 0.99999994, 0.99999993,
        0.99999992],
       [0.99999994, 0.99999993, 1.        , 0.99999994, 0.99999993,
        0.99999993],
       [0.99999995, 0.99999994, 0.99999994, 1.        , 0.99999994,
        0.99999994],
       [0.99999994, 0.99999993, 0.99999993, 0.99999994, 1.        ,
        0.99999993],
       [0.99999994, 0.99999992, 0.99999993, 0.99999994, 0.99999993,
        1.        ]])
```
{{< /output >}}



```python
nlp = spacy.load('en_core_web_lg')

doc1 = nlp("apples oranges fruit")
print( doc1[0].vector_norm )
print( doc1[1].vector_norm )
print( doc1[2].vector_norm )

print( doc1[0].similarity(doc1[1]))
print( doc1[0].similarity(doc1[2]))
```

{{< output >}}
```nb-output
6.895898
6.949064
7.294794
0.77809423
0.72417974
```
{{< /output >}}

```python
doc1 = nlp("apples")
doc2 = nlp("apples apples apples apples apples apples apples apples apples apples apples apples apples apples apples apples apples apples")

print(doc1.vector_norm)
print(doc2.vector_norm)
print(doc1.similarity(doc2))
```

{{< output >}}
```nb-output
6.895897646384268
6.895897762990182
1.0000000930092277
```
{{< /output >}}

```python
doc1 = nlp("apples fruit")
doc2 = nlp("apples apples apples apples apples apples apples apples apples apples apples apples apples apples apples apples apples apples fruit")

print(doc1.vector_norm)
print(doc2.vector_norm)
print(doc1.similarity(doc2))
```

{{< output >}}
```nb-output
6.588359567392134
6.816139083280562
0.9383865534490474
```
{{< /output >}}

```python
# Load a larger model with vectors
#nlp = spacy.load('en_core_web_lg')

doc = nlp("I have a banana")
# Access the word vector via the token.vector attribute
vector = doc[3].vector
print( type(vector) )
print( vector.shape)
```

{{< output >}}
```nb-output
<class 'numpy.ndarray'>
(300,)
```
{{< /output >}}

```python
vector[0:10]
```




{{< output >}}
```nb-output
array([ 0.20228 , -0.076618,  0.37032 ,  0.032845, -0.41957 ,  0.072069,
       -0.37476 ,  0.05746 , -0.012401,  0.52949 ], dtype=float32)
```
{{< /output >}}



```python
#no universal definition for similarity 
doc1 = nlp("I like cats")
doc2 = nlp("I hate cats")

print(doc1.similarity(doc2))
```

{{< output >}}
```nb-output
0.9501447503553421
```
{{< /output >}}

### Pattern matching

```python
import spacy
from spacy.matcher import Matcher

nlp = spacy.load("en_core_web_sm")
doc = nlp(
    "Twitch Prime, the perks program for Amazon Prime members offering free "
    "loot, games and other benefits, is ditching one of its best features: "
    "ad-free viewing. According to an email sent out to Amazon Prime members "
    "today, ad-free viewing will no longer be included as a part of Twitch "
    "Prime for new members, beginning on September 14. However, members with "
    "existing annual subscriptions will be able to continue to enjoy ad-free "
    "viewing until their subscription comes up for renewal. Those with "
    "monthly subscriptions will have access to ad-free viewing until October 15."
)

# Create the match patterns
pattern1 = [{"LOWER": "Amazon"}, {"IS_TITLE": True, "POS": "PROPN"}]
pattern2 = [{"LOWER": "ad-free"}, {"POS": "NOUN"}]

# Initialize the Matcher and add the patterns
matcher = Matcher(nlp.vocab)
matcher.add("PATTERN1", None, pattern1)
matcher.add("PATTERN2", None, pattern2)

# Iterate over the matches
for match_id, start, end in matcher(doc):
    # Print pattern string name and text of matched span
    print(doc.vocab.strings[match_id], doc[start:end].text)
```

```python
import json
from spacy.lang.en import English

with open("exercises/countries.json") as f:
    COUNTRIES = json.loads(f.read())

nlp = English()
doc = nlp("Czech Republic may help Slovakia protect its airspace")

# Import the PhraseMatcher and initialize it
from spacy.matcher import PhraseMatcher

matcher = PhraseMatcher(nlp.vocab)

# Create pattern Doc objects and add them to the matcher
# This is the faster version of: [nlp(country) for country in COUNTRIES]
patterns = list(nlp.pipe(COUNTRIES))
matcher.add("COUNTRY", None, *patterns)

# Call the matcher on the test document and print the result
matches = matcher(doc)
print([doc[start:end] for match_id, start, end in matches])
```

## Processing Pipelines

### OOB pipeline components

First, the tokenizer is applied to turn the string of text into a Doc object. Next, a series of pipeline components is applied to the Doc in order. In this case, the tagger, then the parser, then the entity recognizer. Finally, the processed Doc is returned, so you can work with it.


|Name   | Description  | Creates  |
|---|---|---|
|tagger   | Part-of-speech tagger  | Token.tag  |
|parser   | Dependency parser  | Token.dep, Token.head, Doc.sents, Doc.noun_chunks  |
|ner   | Named entity recognizer  |  Doc.ents, Token.ent_iob, Token.ent_type |
|textcat   | Text classifier  | Doc.cats  |

Because text categories are always very specific, the text classifier is not included in any of the pre-trained models by default. But you can use it to train your own system.

```python
#initialize the language, add the pipeline and load in the binary model weights
nlp = spacy.load("en_core_web_sm")
```

```python
doc = nlp("This is a sentence.")
```

```python
#list of pipeline component names
print(nlp.pipe_names)
```

{{< output >}}
```nb-output
['tagger', 'parser', 'ner']
```
{{< /output >}}

```python
#list of (name, component) tuples
print(nlp.pipeline)
```

{{< output >}}
```nb-output
[('tagger', <spacy.pipeline.pipes.Tagger object at 0x7f4d64e3ada0>), ('parser', <spacy.pipeline.pipes.DependencyParser object at 0x7f4d4ab97108>), ('ner', <spacy.pipeline.pipes.EntityRecognizer object at 0x7f4d4ab97228>)]
```
{{< /output >}}

### Custom pipeline components

Custom components are executed automatically when you call the nlp object on a text.  They're especially useful for adding your own custom metadata to documents and tokens.  You can also use them to update built-in attributes, like the named entity spans.

A custom component:

* takes a doc, modifies it and returns it
* can be added using the nlp.add_pipe method

Custom components can only modify the Doc and can’t be used to update weights of other components directly.

```python
def custom_component(doc, <last,first,before,after> ):
    # Do something to the doc here
    return doc

nlp.add_pipe(custom_component)
```

```python
#simple component

# Create the nlp object
nlp = spacy.load('en_core_web_sm')

# Define a custom component
def custom_component(doc):
    # Print the doc's length
    print('Doc length:', len(doc))
    # Return the doc object
    return doc

# Add the component first in the pipeline
nlp.add_pipe(custom_component, first=True)

# Print the pipeline component names
print('Pipeline:', nlp.pipe_names)

# Process a text
doc = nlp("Hello world!")
```

{{< output >}}
```nb-output
Pipeline: ['custom_component', 'tagger', 'parser', 'ner']
Doc length: 3
```
{{< /output >}}

```python
import spacy
from spacy.matcher import PhraseMatcher
from spacy.tokens import Span

nlp = spacy.load("en_core_web_sm")
animals = ["Golden Retriever", "cat", "turtle", "Rattus norvegicus"]
animal_patterns = list(nlp.pipe(animals))
print("animal_patterns:", animal_patterns)
matcher = PhraseMatcher(nlp.vocab)
matcher.add("ANIMAL", None, *animal_patterns)

# Define the custom component
def animal_component(doc):
    # Apply the matcher to the doc
    matches = matcher(doc)
    # Create a Span for each match and assign the label 'ANIMAL'
    spans = [Span(doc, start, end, label="ANIMAL") for match_id, start, end in matches]
    # Overwrite the doc.ents with the matched spans
    doc.ents = spans
    return doc

# Add the component to the pipeline after the 'ner' component
nlp.add_pipe(animal_component, after="ner")
print(nlp.pipe_names)

# Process the text and print the text and label for the doc.ents
doc = nlp("I have a cat and a Golden Retriever")
print([(ent.text, ent.label_) for ent in doc.ents])
```

{{< output >}}
```nb-output
animal_patterns: [Golden Retriever, cat, turtle, Rattus norvegicus]
['tagger', 'parser', 'ner', 'animal_component']
[('cat', 'ANIMAL'), ('Golden Retriever', 'ANIMAL')]
```
{{< /output >}}

### Custom span attributes

Custom attributes allow

* add custom metadata to documents, tokens and spans
* accessible via the `._ property` to distinguish from built-in attr
* registered on the global Doc, Token or Span using the set_extension method

* Attribute extensions
* Property extensions
* Method extensions

```python
doc._.title = 'My document'
token._.is_color = True
span._.has_color = False
```

```python
# Import global classes
from spacy.tokens import Doc, Token, Span

# Set extensions on the Doc, Token and Span
Doc.set_extension('title', default=None)
Token.set_extension('is_color', default=False)
Span.set_extension('has_color', default=False)
```

```python
#Attribute extension
from spacy.tokens import Token

# Set extension on the Token with default value
Token.set_extension('is_color', default=False)
doc = nlp("The sky is blue.")
# Overwrite extension attribute value
doc[3]._.is_color = True
```

```python
#Property (getter/setter) extension: Token
from spacy.tokens import Token

# Define getter function
def get_is_color(token):
    colors = ['red', 'yellow', 'blue']
    return token.text in colors

# Set extension on the Token with getter
Token.set_extension('is_color', getter=get_is_color, force=True)

doc = nlp("The sky is blue.")
print(doc[3]._.is_color, '-', doc[3].text)
```

{{< output >}}
```nb-output
True - blue
```
{{< /output >}}

```python
#Property (getter/setter) extension: Span
from spacy.tokens import Span

# Define getter function
def get_has_color(span):
    colors = ['red', 'yellow', 'blue']
    return any(token.text in colors for token in span)

# Set extension on the Span with getter
Span.set_extension('has_color', getter=get_has_color)

doc = nlp("The sky is blue.")
print(doc[1:4]._.has_color, '-', doc[1:4].text)
print(doc[0:2]._.has_color, '-', doc[0:2].text)
```

{{< output >}}
```nb-output
True - sky is blue
False - The sky
```
{{< /output >}}

```python
#Method (pass an argument) extension
from spacy.tokens import Doc

# Define method with arguments
def has_token(doc, token_text):
    in_doc = token_text in [token.text for token in doc]
    return in_doc

# Set extension on the Doc with method
Doc.set_extension('has_token', method=has_token)

doc = nlp("The sky is blue.")
print(doc._.has_token('blue'), '- blue')
print(doc._.has_token('cloud'), '- cloud')
```

{{< output >}}
```nb-output
True - blue
False - cloud
```
{{< /output >}}

### Scaling and performance

#### Streaming

* Use `nlp.pipe` method
* Processes texts as a stream, yields Doc objects
* Much faster than calling nlp on each text

```python
%timeit 
docs = [nlp(text) for text in LOTS_OF_TEXTS]
#bad
```

```python
%timeit
docs = list(nlp.pipe(LOTS_OF_TEXTS))
#good
```

```python
#this idiom is useful for associating metadata with the doc
from spacy.tokens import Doc

Doc.set_extension('id', default=None)
Doc.set_extension('page_number', default=None)

data = [
    ('This is a text', {'id': 1, 'page_number': 15}),
    ('And another text', {'id': 2, 'page_number': 16}),
]

for doc, context in nlp.pipe(data, as_tuples=True):
    doc._.id = context['id']
    doc._.page_number = context['page_number']
```

#### Pipeline configuration

Only run the models you need.

```python
#slow
doc = nlp("Hello world")

#fast - only runs tokenizer, not all models
doc = nlp.make_doc("Hello world!")
```

```python
#disable tagger and parser
#restores them after the with block
with nlp.disable_pipes('tagger', 'parser'):
    # Process the text and print the entities
    doc = nlp(text)
    print(doc.ents)
```

## Training a neural network model

List of english models, [here](https://spacy.io/models/en)

SpaCy supports updating existing models with more examples, and training new models.

* Update an existing model: a few hundred to a few thousand examples
* Train a new category: a few thousand to a million examples; spaCy's English models: 2 million words

This is essential for text classification, very useful for entity recognition and a little less critical for tagging and parsing.

### Creating training data

The entity recognizer predicts entities in context, it also needs to be trained on entities and their surrounding context.

Use `Matcher` to quickly create training data for NER models.

* Create a doc object for each text using nlp.pipe.
* Match on the doc and create a list of matched spans.
* Get (start character, end character, label) tuples of matched spans.
* Format each example as a tuple of the text and a dict, mapping 'entities' to the entity tuples.
* Append the example to TRAINING_DATA and inspect the printed data.

```python
import json
from spacy.matcher import Matcher
from spacy.lang.en import English

TEXTS = "New iPhone X release date leaked as Apple reveals pre-orders by mistake"

nlp = English()
matcher = Matcher(nlp.vocab)

# Two tokens whose lowercase forms match 'iphone' and 'x'
pattern1 = [{"LOWER": "iphone"}, {"LOWER": "x"}]

# Token whose lowercase form matches 'iphone' and an optional digit
pattern2 = [{"LOWER": "iphone"}, {"IS_DIGIT": True, "OP": "?"}]

# Add patterns to the matcher
matcher.add("GADGET", None, pattern1, pattern2)
```

```python
import json
from spacy.matcher import Matcher
from spacy.lang.en import English

with open("exercises/iphone.json") as f:
    TEXTS = json.loads(f.read())

nlp = English()
matcher = Matcher(nlp.vocab)
pattern1 = [{"LOWER": "iphone"}, {"LOWER": "x"}]
pattern2 = [{"LOWER": "iphone"}, {"IS_DIGIT": True, "OP": "?"}]
matcher.add("GADGET", None, pattern1, pattern2)

TRAINING_DATA = []

# Create a Doc object for each text in TEXTS
for doc in nlp.pipe(TEXTS):
    # Match on the doc and create a list of matched spans
    spans = [doc[start:end] for match_id, start, end in matcher(doc)]
    # Get (start character, end character, label) tuples of matches
    entities = [(span.start_char, span.end_char, "GADGET") for span in spans]
    # Format the matches as a (doc.text, entities) tuple
    training_example = (doc.text, {"entities": entities})
    # Append the example to the training data
    TRAINING_DATA.append(training_example)

print(*TRAINING_DATA, sep="\n")
```

### Training the model

* Loop for a number of times.
* Shuffle the training data.
* Divide the data into batches.
* Update the model for each batch.
* Save the updated model.

```python
import spacy
import random
import json

with open("exercises/gadgets.json") as f:
    TRAINING_DATA = json.loads(f.read())

nlp = spacy.blank("en")
ner = nlp.create_pipe("ner")
nlp.add_pipe(ner)
ner.add_label("GADGET")

# Start the training
nlp.begin_training()

# Loop for 10 iterations
for itn in range(10):
    # Shuffle the training data
    random.shuffle(TRAINING_DATA)
    losses = {}

    # Batch the examples and iterate over them
    for batch in spacy.util.minibatch(TRAINING_DATA, size=2):
        texts = [text for text, entities in batch]
        annotations = [entities for text, entities in batch]

        # Update the model
        nlp.update(texts, annotations, losses=losses)
        print(losses)
```

Problems with updating:

* if you don't provide examples of original labels, then it will 'forget' them by adjusting too much to the new data
* label scheme needs to be consistent and not too specific, for example: CLOTHING is better than ADULT_CLOTHING and CHILDRENS_CLOTHING

You can create those additional examples by running the existing model over data and extracting the entity spans you care about.  You can then mix those examples in with your existing data and update the model with annotations of all labels.

If the decision is difficult to make based on the context, the model can struggle to learn it.  The label scheme also needs to be consistent and not too specific.  You can always add a rule-based system later to go from generic to specific.

## Applications

### Working on customer environment

Serialization refers to the process of converting an object in memory to a byte stream that can be stored on disk or sent over a network.  This SpaCy guide provides the latest recommendations, [ref](https://spacy.io/usage/saving-loading).

The DocBin class lets you efficiently serialize the information from a collection of Doc objects. You can control which information is serialized by passing a list of attribute IDs, and optionally also specify whether the user data is serialized. The DocBin is faster and produces smaller data sizes than pickle, and allows you to deserialize without executing arbitrary Python code. 

#### Typical serialization

```python
# Load a larger model with vectors
nlp = spacy.load('en_core_web_lg')

# Compare two documents
doc1 = nlp("I like fast food")
doc2 = nlp("I like pizza")
print(doc1.similarity(doc2))
```


{{< output >}}
```nb-output
---------------------------------------------------------------------------
```
{{< /output >}}

{{< output >}}
```nb-output
NameError                                 Traceback (most recent call last)
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-3-a430716dafad> in <module>()
      1 # Load a larger model with vectors
----> 2 nlp = spacy.load('en_core_web_lg')
      3 
      4 # Compare two documents
      5 doc1 = nlp("I like fast food")
```
{{< /output >}}

{{< output >}}
```nb-output
NameError: name 'spacy' is not defined
```
{{< /output >}}


```python
! ls ../tmp;
```

{{< output >}}
```nb-output
spacy-pizza.bz	spacy-pizza.mdl
```
{{< /output >}}

```python
import pickle

data_dict = {'doc1':doc1,'nlp':nlp}
filename = '../tmp/spacy-pizza.mdl'
outfile = open(filename,'wb')

pickle.dump(data_dict, outfile)
outfile.close()
```


{{< output >}}
```nb-output
---------------------------------------------------------------------------
```
{{< /output >}}

{{< output >}}
```nb-output
NameError                                 Traceback (most recent call last)
```
{{< /output >}}

{{< output >}}
```nb-output
<ipython-input-2-9c7a736efa99> in <module>()
      1 import pickle
      2 
----> 3 data_dict = {'doc1':doc1,'nlp':nlp}
      4 filename = '../tmp/spacy-pizza.mdl'
      5 outfile = open(filename,'wb')
```
{{< /output >}}

{{< output >}}
```nb-output
NameError: name 'doc1' is not defined
```
{{< /output >}}


```python
infile = open(filename,'rb')
new_dict = pickle.load(infile)
infile.close()
```

```python
new_dict['doc1'].similarity(doc2)
```

{{< output >}}
```nb-output
/opt/conda/envs/beakerx/lib/python3.6/runpy.py:193: ModelsWarning: [W007] The model you're using has no word vectors loaded, so the result of the Doc.similarity method will be based on the tagger, parser and NER, which may not give useful similarity judgements. This may happen if you're using one of the small models, e.g. `en_core_web_sm`, which don't ship with word vectors and only use context-sensitive tensors. You can always add your own word vectors, or use one of the larger models instead if available.
  "__main__", mod_spec)
```
{{< /output >}}




{{< output >}}
```nb-output
0.953127971438058
```
{{< /output >}}



#### Serialization with compression

```python
import bz2
import pickle

filename = '../tmp/spacy-pizza.bz'
#sfile = bz2.BZ2File('smallerfile', 'w')
#pickle.dump(data_dict, sfile)
#outfile.close()


outfile = bz2.BZ2File(filename, 'wb')
pickle.dump(data_dict, outfile, protocol=2)
outfile.close()
```

```python
! ls ../tmp
```

{{< output >}}
```nb-output
spacy-pizza.bz	spacy-pizza.mdl
```
{{< /output >}}

```python
infile = bz2.BZ2File(filename, 'rb')
myobj = pickle.load(infile)
infile.close()
```

```python
myobj
```




{{< output >}}
```nb-output
{'doc1': This is a sentence., 'nlp': <spacy.lang.en.English at 0x7f4d606145c0>}
```
{{< /output >}}



```python
myobj['doc1'].similarity(doc2)
```

{{< output >}}
```nb-output
/opt/conda/envs/beakerx/lib/python3.6/runpy.py:193: ModelsWarning: [W007] The model you're using has no word vectors loaded, so the result of the Doc.similarity method will be based on the tagger, parser and NER, which may not give useful similarity judgements. This may happen if you're using one of the small models, e.g. `en_core_web_sm`, which don't ship with word vectors and only use context-sensitive tensors. You can always add your own word vectors, or use one of the larger models instead if available.
  "__main__", mod_spec)
```
{{< /output >}}




{{< output >}}
```nb-output
0.953127971438058
```
{{< /output >}}



#### SpaCy method for encapsulating texts

```python
#fast method
from spacy.attrs import LOWER, POS, ENT_TYPE, IS_ALPHA
doc = nlp(text)

# All strings mapped to integers, for easy export to numpy
np_array = doc.to_array([LOWER, POS, ENT_TYPE, IS_ALPHA])
np_array = doc.to_array("POS")

import pickle
serialized = pickle.dumps(np_array, protocol=0) # protocol 0 is printable ASCII
deserialized_array = pickle.loads(serialized)
```

```python
#comprehensive approach
import spacy
from spacy.tokens import DocBin

doc_bin = DocBin(attrs=["LEMMA", "ENT_IOB", "ENT_TYPE"], store_user_data=True)
texts = ["Some text", "Lots of texts...", "..."]
nlp = spacy.load("en_core_web_sm")
for doc in nlp.pipe(texts):
    doc_bin.add(doc)
bytes_data = doc_bin.to_bytes()    #.to_disk("/path")
```

```python
# Deserialize later, e.g. in a new process
nlp = spacy.blank("en")
doc_bin = DocBin().from_bytes(bytes_data)    #.from_disk("/path")
docs = list(doc_bin.get_docs(nlp.vocab))

docs = list(doc_bin.get_docs(nlp.vocab))
Doc.set_extension("my_custom_attr", default=None)
print([doc._.my_custom_attr for doc in docs])
```

#### Pickle Doc to include dependencies

When pickling spaCy’s objects like the `Doc` or the `EntityRecognizer`, keep in mind that they all require the shared `Vocab` (which includes the string to hash mappings, label schemes and optional vectors). This means that their pickled representations can become very large, especially if you have word vectors loaded, because it won’t only include the object itself, but also the entire shared vocab it depends on.

```python
doc = nlp("This is a sentence.")
assert len(nlp.vocab) > 0
```

```python
data = {"doc":doc, "nlp":nlp}
```
