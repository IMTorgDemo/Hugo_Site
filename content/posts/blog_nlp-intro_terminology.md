
+++
title = "Terminology Useful for NLP"
date = "2021-12-11"
author = "Jason Beach"
categories = ["Introduction_Tutorial", "Data_Science"]
tags = ["nlp", "linguistics"]
+++


NLP allows for both theoretical and practical study of language.  Below are a few of aspects of study, as well as terminology, that is frequently used within the field.  Because of the interdisciplinary nature of computational linguistics, the terms come from linguistics, computer science, and mathematics.

* Semiotics -  a philosophical theory covering the relationship between signs and the things they reference.
* Phonetic and Phonological Knowledge - Phonetics is the study of language at the level of sounds while phonology is the study of the combination of sounds into organized units of speech.
* Morphological Knowledge - study of word formation and variations of words and is also concerned with combinations of sounds into minimal distinctive units of meaning called morphemes.
* Syntactic Knowledge - formally this is grammar and mechanics, but informally may include how language is actually used.  This includes how words combine to form phrases, phrases combine to form clauses and clauses join to form sentences.
  - Part-Of-Speech Tagging - identifying the different parts of speech within a specific text is it a verb, noun, adjective, etc.
* Semantic knowledge - concerned with meaning of words and sentences.
  - Named Entity Recognition (Entity Extraction) - recognize concepts by identifying in text a unitary information such as a date, a financial amount, a percentage, a telephone number, an e-mail address, etc.
* Sentiment analysis - identifying whether a statement (a sentence, a tweet, a piece of feedback…) is positive, neutral or negative according to a certain prism.
* Pragmatic Knowledge - extension of semantics that involves contextual aspects of particular situation.
* Discourse Knowledge - chunks of language in connected sentences.  concerns inter-sentential links that is how the immediately preceding sentences affect the interpretation of the next sentence.
  - Terminological Extraction (Chunking) - identifying groups of words that form useful expressions.
* Word knowledge - general information shared amongst speakers which include users' beliefs and goals.
    
       
* Lexicon / Vocabulary - collection of words, terms, and phrases associated with a knowledge domain.
  - Lemma - is a base word that may form many other words using inflection, tenses and other means (play is the root for played, playing).
  - Stem - similar to lemma but does not take the meaning into account.  Stemming typically involves chopping off suffixes to get to the root form of a word, whereas a lemma takes into account the meaning of a word. For example, the words "better" and "worst" have the same stem (bet), but they have different lemmas (good and bad, respectively).
  - Lexical Types - multi-word expressions that have spaces in them and might not even be contiguous, for example, phrasal verbs. 
  - Lexical Analysis (Tokenization) - the task of separating symbols in the text into “words”, thus creating the lexicon of a given corpus.
  - Normalization - series of related tasks meant to put all text on a level playing field: converting all text to the same case (upper or lower), removing punctuation, expanding contractions, converting numbers to their word equivalents, and so on. Normalization puts all words on equal footing, and allows processing to proceed uniformly.
  - Stop Words - words which are filtered out before further processing of text, since these words contribute little to overall meaning.
* Glossary - a lexicon with single glosses (definitions) added per knowledge domain.
* Taxonomy - a lexicon ordered by relationships within a hierarchical tree.  This relationship is by hypernymy, also called the "is-a" relationship (i.e. motorcycle is-a vehicle, vehicle is a hypernym of motorcycle, motorcycle is a hyponym of vehicle)
* Folksonomy - similar to taxonomy but not as deeply structured because it is created organically by a crowd-sourced metadata about a knowledge domain, such as hashtags or word counts.  A word cloud is an example.
* Ontology - may have hypernymy relationships from multiple overlapping taxonomies.  May use xRY hypernymy relationship (motorcycle is-a vehicle), or predicate form (is a vehicle, motocycle).  Other binary relations commonly used in ontology are: Part-whole, property, and value.  
  - Semantic Triple - each x,y of these relationships
  - Triple Store - database (often graph-based) specifically used for these 'triples'
* Knowledge base - technology used to store structured / unstructured fact-based information for expert systems that tries to emulate ways of reasoning about facts.
  - Knowledge graph - Kb with graph structure used for interlinked descriptions of entities and concepts, while also encoding the semantics underlying the used terminology.  formally represents semantics by describing entities and their relationships.  Knowledge graphs may make use of ontologies as a schema layer. By doing this, they allow logical inference for retrieving implicit knowledge rather than only allowing queries requesting explicit knowledge.  In order to allow the use of knowledge graphs in various machine learning tasks, several methods for deriving latent feature representations of entities and relations have been devised. These knowledge graph embeddings allow them to be connected to machine learning methods that require feature vectors like word embeddings.

* Term Frequency - occurrence of a word in a document.
* TF-IDF - term frequency–inverse document frequency, is a numerical statistic that is intended to reflect how important a word is to a document in a collection or corpus. 
* N-grams - dividing the corpus into n-words chunks.  In modeling, this may refer to a moving window of terms.
* Word embeddings - vectors used to describe a specific term numerically.
