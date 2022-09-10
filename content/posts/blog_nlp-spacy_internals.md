
+++
title = "SpaCy Internals"
date = "2021-12-07"
author = "Jason Beach"
categories = ["Introduction_Tutorial", "Data_Science"]
tags = ["nlp", "linguistics"]
+++


I think there is some confusion about the different components - I'll try to clarify:

The tokenizer does not produce vectors. It's just a component that segments texts into tokens. In spaCy, it's rule-based and not trainable, and doesn't have anything to do with vectors. It looks at whitespace and punctuation to determine which are the unique tokens in a sentence.

An nlp model in spaCy can have predefined (static) word vectors that are accessible on the Token level. Every token with the same Lexeme gets the same vector. Some tokens/lexemes may indeed be OOV, like misspellings. If you want to redefine/extend all vectors used in a model, you can use something like init-model.

The tok2vec layer is a machine learning component that learns how to produce suitable (dynamic) vectors for tokens. It does this by looking at lexical attributes of the token, but may also include the static vectors of the token (cf item 2). This component is generally not used by itself, but is part of another component, such as an NER. It will be the first layer of the NER model, and it can be trained as part of training the NER, to produce vectors that are suitable for your NER task.

In spaCy v2, you can first train a tok2vec component with `pretrain`, and then use this component for a subsequent `train` command. Note that all settings need to be the same across both commands, for the layers to be compatible.

To answer your questions:

> Isn't the tok2vec the part that generates the vectors?

If you mean the static vectors, then no. The tok2vec component produces new vectors (possibly with a different dimension) on top of the static vectors, but it won't change the static ones.

> What does it mean loading pretrained vectors and then train a component to predict these vectors? What's the purpose of doing this?

The purpose is to get a tok2vec component that is already pretrained from external vectors data. The external vectors data already embeds some "meaning" or "similarity" of the tokens, and this is -so to say- transferred into the tok2vec component, which learns to produce the same similarities. The point is that this new tok2vec component can then be used & further fine-tuned in the subsequent train command (cf item 3)

> Is there a way to still make use of this for OOV words?

It really depends on what your "use" is. As https://stackoverflow.com/a/57665799/7961860 mentions, you can set the vectors yourself, or you can implement a user hook which will decide on how to define token.vector.

I hope this helps. I can't really recommend the best approach for you to follow, without understanding why you want the OOV vectors / what your use-case is. Happy to discuss further in the comments!

> Is the tok2vec layer already trained for pretrained downloaded models, e.g. Spanish?

Yes, the full model is trained, and the tok2vec layer is a part of it.

> If I replace the NER component of a pretrained model, does it keep the tok2vec layer untouched i.e. with the learned weights?

No, not in the current spaCy v2. The tok2vec layer is part of the model, if you remove the model, you also remove the tok2vec layer. In the upcoming v3, you'll be able to separate these so you can in fact keep the tok2vec model separately, and share it between components.

> Is the tok2vec layer also trained when I train a NER model?

Yes - see above

> Would the pretrain command help the tok2vec layer learn some domain-specific words that may be OOV?

If you simply want your plug-vector instead of the SpaCy default all-zeros vector, you could just add an extra step where you replace any all-zeros vectors with yours. For example:
```
words = ['words', 'may', 'by', 'fehlt']
my_oov_vec = ...  # whatever you like
spacy_vecs = [nlp(word) for word in words]
fixed_vecs = [vec if vec.any() else my_oov_vec 
              for vec in spacy_vecs]
```
I'm not sure why you'd want to do this. Lots of work with word-vectors simply elides out-of-vocabulary words; using any plug value, including SpaCy's zero-vector, may just be adding unhelpful noise.

And if better handling of OOV words is important, note that some other word-vector models, like FastText, can synthesize better-than-nothing guess-vectors for OOV words, by using vectors learned for subword fragments during training. That's similar to how people can often work out the gist of a word from familiar word-roots.

```
python -m spacy info         #spacy version
python -m spacy validate     #models version
```


Adding pipeline components:
https://stackoverflow.com/questions/54855780/how-to-create-ner-pipeline-with-multiple-models-in-spacy

Dangerous, but an important concept!!!
