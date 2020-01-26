
+++
title = "Building Math from the Ground-Up"
date = "2019-07-05"
author = "Jason Beach"
categories = ["Mathematics", "Logic"]
tags = ["nlp", "tag2", "tag3"]
+++


After completing basic high school mathematics, one might think that math stands on its own.  To understand and know that `1+1=2` is obvious.  But math can go much deeper.  In fact, we can build new concepts from math as well as build a math, itself.  This is important because it effects how we think about other subjects, and is especially useful in helping us think about language and abstract concepts, such as in programming.  This post will introduce a few of these concepts.  We will also make some references to how it is useful in natural language processing.

## Logical Beginnings

There are a few different types of logic.   These are presented, here, with increasing rigor:

* informal logic - typically that of natural language
* formal logic - the study of inference, or steps in reasoning; in addition, it is possible to analyze the form of an argument
* symbolic logic - abstractions for capturing features of inference
* mathematical logic - extension of symbolic to use in different theories, such as model, set, and proof theory

Moving from informal to formal logic is a big jump.  Showing the 'logical form' of an argument is difficult in informal logic because 'indicative sentences of ordinary language show a considerable variety of form and complexity that makes their use in inference impractical.'  

Aristotle was the first to support the use of logical form by defining variables to represent valid inferences.  An example is 'all men are mortals' has the form 'all Ps are Qs'.  This advancement leads us to symbolic logic.

Three formal systems of symbolic logic began with Greek philosophers and now provide the foundations we need to do mathematics.  These are: i) syllogism, ii) propositional (sentential), and iii) predicate (first-order) logics.  In order to discuss these we need to define a few terms.  These are formal definitions that are different from how we use every-day language, but they are not un-related.

## Important Definitions

### Arguments and inference

A premise is an assumption that something is true.  In logic, an argument requires a set of (at least) two declarative sentences known as the premises along with another declarative sentence known as the conclusion.  

The proof of a conclusion depends on both the truth of the premises and the validity of the argument.  An argument is valid if, and only if, it takes a form that makes it impossible for the premises to be true and the conclusion nevertheless to be false. 

The word inference is used quite often in logic, math, and statistics.  It comes from the latin infero which means to 'carry forward', and is usually divided between deduction and induction.

Deduction is the act of deriving (using formal proof) logical conclusions from premises using the 'laws of valid inference'.  So, there are a finite sequence of 'well-formed forumlas' each of which is an assumption (axiom), or conclusion (inferred from the others) used as an assumption, that create a theorem (proven statement).  There are a few popular rules for inference and they include such important ones as _modus ponens_, _modus tollens_, _contrapositive_, and _reductio ad absurdum_ for propositional calculus.

In the example of _modus ponens_, the form is written:
```
A -> B
A
------
B
```  
There are additional rules for predicate calculus, as well as other logics, and many of the rules are displayed, [here](https://en.wikipedia.org/wiki/List_of_rules_of_inference).

A formal system is an organization of terms used for the analysis of deduction. It consists of an alphabet, a language over the alphabet to construct sentences, and a rule for deriving sentences. 

Induction involves inference from particular premises, each with some evidence of truth, to a universal conclusion.  While a deductive argument is certain, an inductive argument can only be probable.  It is the basis for the scientific method which is the foundation of all natural sciences (study of naturally occurring phenomena).  Inductive reasoning is inherently uncertain; therefore, it is important when used for making arguments with probability.  Bayes rule is an example of a rule for inference within probability-based inductive reasoning.  

Instead of being valid or invalid, inductive arguments are either strong or weak, according to how probable it is that the conclusion is true.  An argument may be plausible, probable, reasonable, justified or strong, but never certain.

Confusingly, inductive reasoning is different from mathematical induction, which is a form of deductive reasoning which is used for strict proofs of properties on recursively defined sets.

Reaching such a deep level of analysis and relating it to the real world can become quite philosophical.  An example is the Second Axiom of Probability which states that at least one of the elementary events in the entire sample space will occur is 1, which in epistemic uncertainty uses the closed-world assumption.  So, it can be difficult to know when one has gone 'too far down the rabbit hole', to use another philosophical reference.

Oftentimes, latin terms may be used to describe rules of inference, such as _modus ponens_, and these underly their Greek philosophical underpinnings.  As an aside, the greek language is not used because the vast majority of that culture's ideas are transferred only by the latin-bearing Roman scrolls.  Interestingly, there is not much latin texts (since the destruction of the Ptolemaic Library of Alexandria), also, but more is still being uncovered through the use of xray photography that displays text erased to provide for medieval christian writings.

At the same time, some philosophy of science must be understood.  For instance, the idea of hypothesis testing, and the use of the p-value, is fundamental to classical statistics and is almost universally used across all scientific disciplines.  Less conspicuous, but equally controversial, is the assumption of _ceteris paribus_, all things held constant, in economics research, which allowed statistical theory to be bridged from controlled experimental designs, to observational data.

### First-order logic

Syntax is the collection of symbols (concepts) and rules used for creating well-formed expressions.  It is independent of symantics and interpretation.  In natural language, the rules are called grammar, and one such rule in english is that statement structure must be of the form Subject-Verb-Object.

Symantics determine the meaning behind expressions.  It is concerned with words, phrases, signs and symbols.  Oftentimes, there may be a mapping from one set of symbols to another.  In effect, a translation between known and unknown symbols.  

These necessitate a definition for expression, which is a finite combination of symbols that are well-formed according to the syntax.  The term combination can be difficult because mathematical combinations which are selections made regardless of ordering.  Here, order is important to syntax.  In programming, expressions return a new value, as opposed to a statement which does not.

Expressions are stated using terms, to represent objects, and formulas, which are predicates (relations) to true / false.  A predicate can visualized as the Unit Step (Heaviside) Function.  The domain of all terms and formulas (symbols) is the alphabet of that system.

## Syllogistic and Propositional Logic

A syllogism is a kind of logical argument that applies deductive reasoning to arrive at a conclusion based on two or more propositions that are asserted or assumed to be true.  The _modus ponens_ described above is an example.  Aristotle, of the Nyaya school, defined the three-part form where from a general statement (the major premise) and a specific statement (the minor premise), a conclusion is deduced.
```
All men are mortal.
Socrates is a man.
Therefore, Socrates is mortal. 
```


The Stoics created propositional logic.  A proposition is any sentence that can be assigned a truth value, such as “Helsinki is the capital of Finland”.

The versatility (and restriction) of propositional logic lies in the fact that we can use it with any statement whatsoever, regardless of its inner structure or logical form.
But it is also very, very simple. Elementary propositions are denoted usually by letters, such as lower case p and q. These propositions are connected to each other and manipulated using simple logical connectives, such as:
```
~ not
& and
| or
=> if, then
<=> if and only if
```
Using these symbols, we can generate combinations of the elementary propositions to claim certain logical connections between them.

We then use so-called truth tables to evaluate the truth of this complex proposition. We can also determine whether it is a tautology (logical truth). In the truth-table method we go through all combinations of p and q as to their truth and falsity and see what the truth value of the whole proposition is. Like so:

If the last column has only T in it (sometimes +/- or 1/0 are used for truth and falsity), the proposition is a tautology; if it has only F in it, it is a contradiction.

## Predicate and Mathematical Logic

While propositional logic treats whole propositions, predicate logic distinguishes between objects and their properties (called predicates).

An alphabet consists of logical and non-logical symbols.  Non-logical symbols include predicates (relations), functions, and constants.  The set of all of these are the signature.  The signature may be i) empty, ii) finite, iii) infinite, or iv) uncountable.  Logical symbols include i) quantifiers, ii) logical connectives, iii) and truth constants.

Predicate logic is essentially a system where the elementary propositions of propositional logic can be further analysed using predicates/properties that are assigned to subjects. For example, above “Helsinki is the capital of Finland” can be further analysed by denoting Helsinki with the lower-case letter h and the predicate the capital of Finland with a upper-case letter, say C. We get: “h is C”.

Predicate logic has standardly employed so-called quantifiers, which express the scope of the predicate over the subject-term. In the above case Helsinki is an individual object, so a quantifier makes little sense – so take the tapir example: now the subject-term is the general concept of tapir – denote it with T, and cuddly with C. Since the statement in effect claims that all tapirs are cuddly, we write: “All T are C”. This is the traditional Aristotelian way of expressing the matter. But the quantifier itself in modern predicate logic is expressed by one of the two symbols:

* Universal quantifier , meaning all, every 
* Existential quantifier , meaning some, there exists

Thus we see that unlike propositional logic, predicate logic is capable of dealing
with sets of entities – making it very useful e.g. in mathematics.

Unfortunately, this property also makes it impossible to employ truth tables in predicate logic: one would have to iterate over a potential infinity of individuals. Instead, in determining the validity of inferences in predicate logic, simple logical rules are established and iterated. For example, we can apply the rule that negating the universal quantifier gives us the existential quantifier with the negation of the proposition:

x(Px) x( Px)

Since in addition we can also use all the logical rules established in propositional logic to the propositions themselves, we have a very powerful and versatile form of logic.

## Use in Natural Language Processing

What does it take to move from a natural language to a logical form?

First, ignoring those grammatical features irrelevant to logic (such as gender and declension, if the argument is in Latin), replacing conjunctions irrelevant to logic (such as "but") with logical conjunctions like "and" and replacing ambiguous, or alternative logical expressions ("any", "every", etc.) with expressions of a standard type (such as "all", or the universal quantifier ∀).

Second, certain parts of the sentence must be replaced with schematic letters. Thus, for example, the expression "all Ps are Qs" shows the logical form common to the sentences "all men are mortals", "all cats are carnivores", "all Greeks are philosophers", and so on. The schema can further be condensed into the formula A(P,Q), where the letter A indicates the judgement 'all – are –'. 

The english language uses the Subject-Verb-Object statement structure.  From this, a Noun Phrase is created from the subject and object, while the verb and object define the predicate.  The subject and predict, together, create a clause.  The clause may be independent, or dependent.  The entire SVO statement in a meaningful context is a sentence.

Making use of all of these rules and building models around form structure can be highly supportive for both understanding natural language and creating it.

## Conclusion

Logic is one of the worlds oldest subjects of study and it is initmately related with mathematics, especially at the level of analysis.  While this may seem impractical for practicioners, learning and applying it provides a mucher richer understanding of why and how some things are done in math.  It also provides a strong precendence in studying math related disciplines, such as Natural Language Processing.
