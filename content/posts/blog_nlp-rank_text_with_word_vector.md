
+++
title = "Ranking Text With Word Embeddings"
date = "2020-02-20"
author = "Jason Beach"
categories = ["MachineLearning", "DataScience", "Mathematics"]
tags = ["nlp", "classification"]
+++


I recently implemented search functionality for my Hugo site, which can be seen at: https://imtorgdemo.github.io/pages/search/.  The search uses lunr.js, an implementation of Solr.   While it works, sufficiently, the metadata used for ranking queries could be improved.  It would also be nice to visually locate the results by where resulting posts fit into the three data science fundamental disciplines: mathematics, computer science, and business.  This narrative provides a quick solution for ranking posts by each discipline, then reducing the dimensions to 3 axes in the xy-plane.

## Environment 

Lets setup the environment for the basic scientific and NLP work.

```python
import numpy as np
import nltk
import spacy

nlp = spacy.load("en_core_web_lg")
doc = nlp("This is a sentence.")
```

```python
len(doc.vector)
```




{{< output >}}
```nb-output
300
```
{{< /output >}}



```python
import os
import sys

os.chdir('./Data/markdown')
os.listdir()
```




{{< output >}}
```nb-output
['blog_test-my_first_post.md', 'blog-logic_for_math.md']
```
{{< /output >}}



```python
os.chdir('/home/jovyan/PERSONAL/')
```

This is the basic metadata for each post.

```python
! head Data/markdown/blog-logic_for_math.md
```

{{< output >}}
```nb-output

+++
title = "Building Math from the Ground-Up"
date = "2019-07-05"
author = "Jason Beach"
categories = ["Mathematics", "Logic"]
tags = ["nlp", "tag2", "tag3"]
+++


```
{{< /output >}}

## PreProcessing

We will use a post that focuses primarily on mathematics.  So, we expect the ranking results to align with mathematics more than the other two fields.

```python
file_path = "/home/jovyan/PERSONAL/Data/markdown/blog-logic_for_math.md"

with open(file_path, 'r') as file:
    lines = file.readlines()
```

```python
metadata = lines[1:9]
```

```python
content = '  '.join(data[9:])
content = content.replace("\n","")
```

```python
import re, string

pattern = re.compile(r'([^\s\w]|_)+')
content = pattern.sub('', content)
```

```python
content = ' '.join(content.split())
```

Get word assocations from website.  This is performed manually.  In the future, scrape the site and get many more assocations.

#TODO:scrape the website
import requests

url = 'https://wordassociations.net/en/words-associated-with/TARGET?button=Search'
url = url.replace('TARGET','computer')
resp = requests.get(url)

noun_loc = resp.text.find('Noun')
resp.text.find('Adjective')

```python
#search: business
word_assoc_biz = 'MbaEntrepreneurshipRetailEntrepreneurConsultancyStartupAccountingSectorMarketingBankingCateringGroceryInvestingWhartonEnterpriseLendingStakeholderCustomerEconomicFinanceConsumerCommerceConglomerateEconomicsBakeryInvestmentInsuranceManagementSupplierMarketplaceInvestorVentureFirmTelecomTradesmanPayrollManufacturingBrokerTransactionLumberRetailerProfitFinancingContractingSustainabilityPartnerInnovationHospitalityNetworkingAccountantExecutiveIncentivePartnershipProcurementShareholderEmployeeAssetUndergraduateIndustrialPhilanthropyEquityLiabilitySmallAdvertisingInformaticsSalesTourismRecessionLeisurePurchasingConsultantOwnerHaasAccreditationMercantileWholesaleProfitableLucrativeUnfinishedRetailThrivingRiskyConsultingCorporateMultinationalBoomingNonprofitGraduateAccreditedPhilanthropicFinancialSustainableAutomotiveBankruptUrgentDiversifyDivestInvestProsperRestructure'
tmp = re.findall('[A-Z][^A-Z]*', word_assoc_biz)
words_biz = ' '.join(tmp)
```

```python
#search: software, programming
word_assoc_cs = 'SimulcastOptimizationDualityIntegerSynthesizerApiSynthNewscastKeyboardCwProgrammerCompilerPythonBasicKeywordAiringAffiliateSyndicationDecompositionAlgorithmJavaUhfUnixSemanticsParadigmInterfaceRecourseConstraintArrangerAutomatonFccPascalSyntaxBroadcastingBroadcastCbcNickelodeonApproximationNetworkAffiliationPbsSemanticRelaxationInstrumentationLineupHdBrandingLanguagePercussionEmmyLogicFmIdeAbcChannelTelecastDrumCableForthBbQuadraticStochasticNonlinearWeekdayFractionalOrientedLinearConvexJavaOptimalDynamicSequentialDaytimeScriptedConcurrentConstrainedPrimalConcaveImperativeGraphicalRetroProceduralAiredObjectiveFuzzyAnalogPolynomialSyndicateAirNetworkProgrammeBroadcastGeneralizeStructureRelaunchMixnuHardwareLinuxCadPackageDeveloperMacintoshVendorWorkstationUnixAutomationProgrammerAmigaEncryptionFunctionalityServerVisualizationBrowserIbmAdobeCompatibilityComputerOsComputingAtariPcApiGuiInterfaceUserGraphicsNetworkingLicenseSimulationRepositoryModelingXpMidiModemUpdateVerificationRouterCompilerToolProcessorEditingSimulatorMultimediaApplicationProviderLaptopUpgradeCpuNokia3dMetadataMicroprocessorApacheStartupPiracyAppIntelValidationSuiteOptimizationCiscoKernelModellingDocumentationGraphicHackerImplementationConsultancyVulnerabilityTcpEmailGps'
tmp = re.findall('[A-Z][^A-Z]*', word_assoc_cs)
words_cs = ' '.join(tmp)
```

```python
#search: mathematics
word_assoc_math = 'PhysicAlgebraMathematicCalculusMathematicianPhysicsGeometryOlympiadAstronomyHilbertTopologyGraderPolynomialManifoldProficiencyInformaticsBscTheoremAxiomEulerMathMechanicPhdGeneralizationIntegralAptitudeProfessorshipGenealogyBsChemistryTextbookStatisticEmeritusComputationSpringerLogicDescartesDoctorateScienceMechanicsCurriculumMultiplicationBachelorProfessorUndergraduateSubgroupIntegerConjectureNeumannGraduateComputingLecturerSummaBiologySubsetAstrologyFourierExamPedagogyCantorTensorPhilosophyCalculatorPermutationMatriceAlgebraicMathematicalTopologicalProjectiveProficientEuclideanArithmeticAppliedDifferentialManifoldDiscreteOrthogonalComputationalAnalyticPolynomialInvariantNumericalGeometricFiniteQuadraticStochasticGradeGeometricalStudiedSymmetricBabylonianTheoreticalDegreeAbstractTextbookEmeritusGraduate'
tmp = re.findall('[A-Z][^A-Z]*', word_assoc_math)
words_math = ' '.join(tmp)
```

```python
path = './Data/markdown/'
file = path + 'word_assocation_ref.json'
words = {"math": words_math, "cs": words_cs, "biz": words_biz}

import json
with open(file, 'w') as fp:
    json.dump(words, fp)
```

```python
with open(file, 'r') as fp:
    new_words = json.load(fp)
```

```python
math = nlp(words_math)
cs = nlp(words_cs)
biz = nlp(words_biz)
```

## Similarity

These results use the cosine similarity between the fields and all the word-embeddings of terms in the document.  They are not what we expect to see because math is ranked lowest, despite the document using math as the primary subject.  

We can probably do better by removing unneccessary stop words and taking the most 'important' words in the document.  The most important terms can be defined using the TF-IDF formula that is typical in 'bag-of-words' NLP approaches.

We will use the `sklearn` library for the simple calculations.

```python
# Compare two documents
doc1 = nlp(content)
print(doc1.similarity(biz))
print(doc1.similarity(cs))
print(doc1.similarity(math))
```

{{< output >}}
```nb-output
0.5729121134078637
0.6058354478834562
0.48928262314068244
```
{{< /output >}}

```python
from sklearn.feature_extraction.text import TfidfVectorizer

tfidf = TfidfVectorizer(min_df=3, analyzer='word', stop_words = 'english', sublinear_tf=True)
tfidf.fit(content.split(' '))
feature_names = tfidf.get_feature_names()

def get_ifidf_for_words(text):
    tfidf_matrix= tfidf.transform([text]).todense()
    feature_index = tfidf_matrix[0,:].nonzero()[1]
    tfidf_scores = zip([feature_names[i] for i in feature_index], [tfidf_matrix[0, x] for x in feature_index])
    return dict(tfidf_scores)

scores = get_ifidf_for_words(content)
sorted_scores = {k: v for k, v in sorted(scores.items(), key=lambda item: item[1], reverse=True)}
```

```python
from itertools import islice

def take(n, iterable):
    "Return first n items of the iterable as a list"
    return list(islice(iterable, n))
```

The results of the choosing important words by TF-IDF look much more promising.  These are words you would expect to be associated with formal mathematics.

```python
take(10, sorted_scores.items())
```




{{< output >}}
```nb-output
[('logic', 0.14527847977675443),
 ('logical', 0.140443796477262),
 ('form', 0.13793934097017202),
 ('predicate', 0.13687559493415327),
 ('use', 0.1342685066335781),
 ('language', 0.13265636975548645),
 ('symbols', 0.13265636975548645),
 ('truth', 0.13265636975548645),
 ('argument', 0.13077412529085744),
 ('inference', 0.13077412529085744)]
```
{{< /output >}}



There are 82 words that are most important in describing the document.

```python
len(list(sorted_scores.keys()))
```




{{< output >}}
```nb-output
82
```
{{< /output >}}



When we compare the document's most important words against the fields' associations we find a much more compelling story.  Now, Math is ranked the highest.  Computer science is not far behind, but Business is rightfully quite different.

```python
# Compare documents
words = ' '.join(list(sorted_scores.keys()))
doc1 = nlp(words)
print(doc1.similarity(biz))
print(doc1.similarity(cs))
print(doc1.similarity(math))
```

{{< output >}}
```nb-output
0.5238546677925497
0.6606328549347019
0.6888387753219556
```
{{< /output >}}

## Visual Location

We want to visually locate the document within a svg image that can be seen, below.  This is quite unintuitive because the there are three axes within a 2D-plane.  We must reduce the three dimensions to two.

<img src="images/img-datascience_plain.svg" alt="datascience" width="400"/>

There is no correct answer to this.  In fact, there are approaches we could have taken, earlier, that would have completed this for us.  A supervised clustering approach could have ensured the three groups.

But, we are keeping this simple and fast - no modeling.  Instead of justifying a best solution, let us find the simplest method to reduce dimensions which is NOT incorrect.  We can make the following assumptions:

* While the `similarity()` method returns cosine similarity with a range of 0-no similarity and 1-perfect similarity, the similarity in writing style leads us to expect an actual range of .50-.70
* x-dimension: Computer Science and Mathematics are antagonistic to each other (in a technical field perspective), but on a continuous scale between the two, so the two should be subtracted
* y-dimension: Business is discrete in it is addressed in the text, or not

We can use the [generalized logistic function](https://en.wikipedia.org/wiki/Generalised_logistic_function) with subtracting Computer Science from Math, and say 0 is completely a CS paper, while 1 is completely a Math paper.  We use an arbitrary B=25 to ensure a steep difference between the two.

```python
#formula: Y = A + (K-A)/(C+Q*np.exp(-B*t))^1/v
# set A and B, with all other parameters set to 1

def general_logistic(Beta, cs, math):
    t = math - cs
    return (1/(1+np.exp(-B*t)))

xPt = general_logistic(25, .660, .688)
print( xPt )
```

{{< output >}}
```nb-output
0.6681877721681656
```
{{< /output >}}

Because the actual range is closer to .50-.70, we can expect .60 to be decisive line with value greater than meaning applicability.  So, the y-axis will be 0-top and 1-bottom, with the top of the Business set at .60.  A similarity value lower than this number means the paper is not in this set.  

```python
yPt = doc1.similarity(biz)
print( yPt )
```

{{< output >}}
```nb-output
0.5238546677925497
```
{{< /output >}}

<img src="images/img-datascience_drawing.png" alt="datascience" width="400"/>

## Prototype

Lets complete the prototype with some frontend work using D3js.

```python
BizPt = doc1.similarity(biz)
CsPt = doc1.similarity(cs)
MathPt = doc1.similarity(math)

xPt = general_logistic(25, CsPt, MathPt)
yPt = BizPt
```

```python
metadata.insert(4, f"location = [{xPt}, {yPt}]\n")
```

```python
metadata
```




{{< output >}}
```nb-output
['+++\n',
 'title = "Building Math from the Ground-Up"\n',
 'date = "2019-07-05"\n',
 'author = "Jason Beach"\n',
 'location = [0.6693281622812353, 0.5238546677925497]',
 'categories = ["Mathematics", "Logic"]\n',
 'tags = ["nlp", "tag2", "tag3"]\n',
 '+++\n',
 '\n']
```
{{< /output >}}



```python
combined = ''.join(metadata) + content

file_path = "/home/jovyan/PERSONAL/Data/markdown/result.md"
with open(file_path, 'w') as file:
    file.write(combined)
```

Once the transformed data exported to markdown files, it can be indexed by lunrJs.  The results of the search query can load both the post information, and the location can be used with the svg.

```python
beakerx.point = {"xPt":xPt, "yPt":yPt}
```

```python
from beakerx.object import beakerx
```

```javascript
%%javascript
require.config({
  paths: {
      d3: '//cdnjs.cloudflare.com/ajax/libs/d3/4.9.1/d3.min'
  }});
```


{{< output >}}
```nb-output
<IPython.core.display.Javascript object>
```
{{< /output >}}


```javascript
%%javascript

beakerx.displayHTML(this, '<div id="fdg"></div>');

var point = beakerx.point



var d3 = require(['d3'], function (d3) {
    
    var width = 300,
        height = 200;

    var svg = d3.select("#fdg")
                .append("svg")
                .attr("width", width)
                .attr("height", height)
                .attr("transform", "translate("+[100, 0]+")")

    var node = svg
          .append("circle")
          .attr("class", "dot")
          .attr("r", 10)
          .attr("cx", 150)
          .attr("cy", 100) 
          .style("fill", "Blue"); 
    
});   
```


{{< output >}}
```nb-output
<IPython.core.display.Javascript object>
```
{{< /output >}}


## Conclusion

The final result of the script and D3 can be at: https://imtorgdemo.github.io/pages/search/.
