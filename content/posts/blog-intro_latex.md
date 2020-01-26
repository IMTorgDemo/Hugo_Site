
+++
title = "Introduction to LaTeX"
date = "2019-07-05"
author = "Jason Beach"
categories = ["Mathematics", "Logic"]
tags = ["visualization", "tag2", "tag3"]
+++


LaTeX is the document preparation and typesetting system used for scientific publications.  LaTeX is based on the idea that 'it is better to leave document design to document designers', so the user can focus on the content. It requires a greater technical understanding than typical simple note-taking systems; however, because it is incredibly descriptive and produces aesthetically-appealing output, it is becoming more popular.  This post provides a reference to configuration and syntax.

## LaTeX Beginnings

Tex is the actual low-level language created by Donald Knuth in 1978.  Leslie Lamport created an alternative, high-level, macro file called lplain (“l” for Lamport), with a set of much-easier-to-use commands.  The latex script ran the macros, first, then compiled the Tex language and outputs to a PostScript file that another program converts to a document.  This evolved into the LaTeX program.   

The [LaTeX site](https://www.latex-project.org/) provides the open source software distribution that compiles your LaTeX markup.  Getting this set-up and using it can be quite involved and most workflows don't allow for such complexities.

Also, most users don't have to worry about becoming comfortable with the LaTeX markup.  There are many templates available, including:
* [free boilerplates](http://mrzool.cc/tex-boilerplates/)
* [free templates](http://www.latextemplates.com/)
* [some commercial](https://www.overleaf.com/gallery/tagged/book).  

Large journal publications provide their own templates for document preparation, such as [IEEE](http://www.latextemplates.com/template/ieee).  However, some users may want to customize their own output.  An example document could include the following.
```
\begin{document}
  \begin{environment1}
    \begin{environment2}
    \end{environment2}
  \end{environment1}
\end{document}
```

There is an interesting [post](https://olivierpieters.be/blog/2017/02/11/designing-a-business-card-in-latex) describing how to create a business card in LaTeX.  This is ridiculous!  For more graphic-intensive work there are much better options, such Photoshop or even PowerPoint.  For more information, look into [latex tutorial](https://www.latex-tutorial.com/).

## Typical Usage

### Jupyter

More commonly, simple snippets or blocks of LaTeX are used within common markdown or HTML to display mathematical text or special symbols.  [Pandoc](https://pandoc.org/) can be used to convert simple markdown into other formats, including a PDF file with LaTeX.  

Jupyter notebook uses [MathJax](https://www.mathjax.org/) to render LaTeX inside html/markdown. Just put your LaTeX math inside `\\(`.

The inline notation `\\)c = \sqrt{a^2 + b^2}\\(` becomes: \\)c = \sqrt{a^2 + b^2}$

The display mode notation `\\[c = \\sqrt{a^2 + b^2}\\]` becomes:

\\[c = \\sqrt{a^2 + b^2}\\]

Or place it in an individual cell.

```python
from IPython.display import Math
Math(r'F(k) = \int_{-\infty}^{\infty} f(x) e^{2\pi i k} dx')
```




$\displaystyle F(k) = \int_{-\infty}^{\infty} f(x) e^{2\pi i k} dx$



You can enter latex directly with the %%latex cell magic, within a Markdown cell:
```
%%latex
\begin{aligned}
\nabla \times \vec{\mathbf{B}} -\, \frac1c\, \frac{\partial\vec{\mathbf{E}}}{\partial t} & = \frac{4\pi}{c}\vec{\mathbf{j}} \\
\nabla \cdot \vec{\mathbf{E}} & = 4 \pi \rho \\
\nabla \times \vec{\mathbf{E}}\, +\, \frac1c\, \frac{\partial\vec{\mathbf{B}}}{\partial t} & = \vec{\mathbf{0}} \\
\nabla \cdot \vec{\mathbf{B}} & = 0
\end{aligned}
```

%%latex
\begin{aligned}
\nabla \times \vec{\mathbf{B}} -\, \frac1c\, \frac{\partial\vec{\mathbf{E}}}{\partial t} & = \frac{4\pi}{c}\vec{\mathbf{j}} \\
\nabla \cdot \vec{\mathbf{E}} & = 4 \pi \rho \\
\nabla \times \vec{\mathbf{E}}\, +\, \frac1c\, \frac{\partial\vec{\mathbf{B}}}{\partial t} & = \vec{\mathbf{0}} \\
\nabla \cdot \vec{\mathbf{B}} & = 0
\end{aligned}

### MathJax

__Superscripts and Subscripts__, use ^ and _. For example

* `x_i^2`: \\(x\_i^2\\)
* `\log_2 x`: \\(\\log\_2 x\\)

__Groups, Superscripts, Subscripts, and other operations__ apply only to the next “group”. A “group” is either a single symbol, or any formula surrounded by curly braces {…}. If you do `10^10`, you will get a surprise: 1010

But `10^{10}` gives what you probably wanted: \\(10^{10}\\). Use curly braces to delimit a formula to which a superscript or subscript applies: 
* `x^5^6` is an error
* `{x^y}^z` is \\({x^y}^z\\)
* `x^{y^z}` is \\(x^{y^z}\\) 

Observe the difference between `x_i^2` \\(x\_i^2\\) and `x_{i^2}` \\(x\_{i^2}\\)

__Parentheses and Ordinary symbols__ ()[] make parentheses and brackets \\((2+3)[4+4]\\) Use `\{` and `\}` for curly braces \\(\\{\\}\\)

These do not scale with the formula in between, so if you write `(\frac{\sqrt x}{y^3})` the parentheses will be too small: \\((\\frac{\\sqrt x}{y^3})\\)

Using `\left`(…\right) will make the sizes adjust automatically to the formula they enclose: `\left(\frac{\sqrt x}{y^3}\right)` is \\(\\left(\\frac{\\sqrt x}{y^3}\\right)\\)

`\left` and `\right` apply to all the following sorts of parentheses: 
* `( )` \\((𝑥)\\)
* `[ ]` \\([𝑥]\\)
* `\{  \}` \\(\\{𝑥\\}\\)
* `|` \\(|𝑥|\\)
* `\vert` \\(\\vert x\\vert\\)
* `\Vert` \\(\\Vert x\\Vert\\)
* `\langle` and `\rangle` \\(\\langle x \\rangle\\)
* `\lceil` and `\rceil` \\(\\lceil x \\rceil\\)
* `\lfloor` and `\rfloor` \\(\\lfloor x \\rfloor\\)
* `\middle` can be used to add additional dividers

There are also invisible parentheses, denoted by `.`: `\left.\frac12\right\rbrace` is \\(\\left.\\frac12\\right\\rbrace\\)

If manual size adjustments are required: `\Biggl(\biggl(\Bigl(\bigl((x)\bigr)\Bigr)\biggr)\Biggr)` gives \\(\\Biggl(\\biggl(\\Bigl(\\bigl((x)\\bigr)\\Bigr)\\biggr)\\Biggr)\\)

__Sums and integrals__ `\sum` and `\int`; the subscript is the lower limit and the superscript is the upper limit, so for example `\sum_1^n`  \\(\\sum\_1^n\\). Don't forget `{…}` if the limits are more than a single symbol. For example, `\sum_{i=0}^\infty i^2` is \\(\\sum\_{i=0}^\\infty i^2\\). Similarly, `\prod` \\(\\prod\\), `\int` \\(\\int\\), `\bigcup` \\(\\bigcup\\), `\bigcap` \\(\\bigcap\\), `\iint` \\(\\iint\\), `\iiint` \\(\\iiint\\), `\idotsint` \\(\\idotsint\\)

__Fractions__ There are three ways to make these. `\frac ab` applies to the next two groups, and produces \\(\\frac ab\\); for more complicated numerators and denominators use `{…}`: `\frac{a+1}{b+1}` is \\(\\frac{a+1}{b+1}\\). If the numerator and denominator are complicated, you may prefer `\over`, which splits up the group that it is in: `{a+1\over b+1}` is \\({a+1\\over b+1}\\). Using `\cfrac{a}{b}` command is useful for continued fractions \\(\\cfrac{a}{b}\\), more details for which are given in this sub-article.

__Radical signs__ use `sqrt`, which adjusts to the size of its argument: `\sqrt{x^3}` \\(\\sqrt{x^3}\\); `\sqrt[3]{\frac xy}` \\(\\sqrt[3]{\\frac xy}\\). For complicated expressions, consider using `{...}^{1/2}` \\({...}^{1/2}\\) instead.

__Special functions__, such as "lim", "sin", "max", "ln", and so on are normally set in roman font instead of italic font. Use `\lim` \\(\\lim\\), `\sin` \\(\\sin\\), etc. to make these: `\sin x` \\(\\sin x\\), not `sin x` \\(sin x\\). Use subscripts to attach a notation to `\lim`: `\lim_{x\to 0}` \\(\\lim\_{x\\to 0}\\).

There are a very large number of special symbols and notations, too many to list here; see this [shorter listing](https://pic.plover.com/MISC/symbols.pdf), or this [exhaustive listing](http://mirrors.ibiblio.org/CTAN/info/symbols/comprehensive/symbols-a4.pdf). Some of the most common include: 

`\lt \gt \le \leq \leqq \leqslant` \\(\\lt \\gt \\le \\leq \\leqq \\leqslant\\) 

`\ge \geq \geqq \geqslant \neq` \\(\\ge \\geq \\geqq \\geqslant \\neq\\)
    
You can use `\not` to put a slash through almost anything: `\not\lt` \\(\\not\\lt\\), but it often looks bad.

`\times \div \pm \mp` \\(\\times \\div \\pm \\mp\\)

`\cup \cap \setminus \subset \subseteq \subsetneq \supset` \\(\\cup \\cap \\setminus \\subset \\subseteq \\subsetneq \\supset\\) 

`\in \notin \emptyset \varnothing` \\(\\in \\notin \\emptyset \\varnothing\\)

`\cdot` is a centered dot: \\(x \\cdot y\\)

`{n+1 \choose 2k}` \\({n+1 \\choose 2k}\\) or `\binom{n+1}{2k}` \\(\\binom{n+1}{2k}\\)

`\to \rightarrow \leftarrow \Rightarrow \Leftarrow \mapsto` \\(\\to \\rightarrow \\leftarrow \\Rightarrow \\Leftarrow \\mapsto\\)


`\land \lor \lnot \forall \exists \top \bot \vdash \vDash` \\(\\land \\lor \\lnot \\forall \\exists \\top \\bot \\vdash \\vDash\\)

`\star \ast \oplus \circ \bullet` \\(\\star \\ast \\oplus \\circ \\bullet\\)

`\approx \sim \simeq \cong \equiv \prec \lhd \therefore` \\(\\approx \\sim \\simeq \\cong \\equiv \\prec \\lhd \\therefore\\)

`\infty \aleph_0` \\(\\infty \\aleph\_0\\)

`\nabla \partial` \\(\\nabla \\partial\\) `\Im \Re` \\(\\Im \\Re\\)

For modular equivalence, use `\pmod` like this: `a\equiv b\pmod n` \\(a\\equiv b\\pmod n\\)

`\ldots` is the dots in \\(a1,a2,\\ldots,an\\)

`\cdots` is the dots in \\(a1+a2+\\cdots+an\\)

Some Greek letters have variant forms: `\epsilon \varepsilon` \\(\\epsilon\\) \\(\\varepsilon\\) and `\phi` `\varphi` \\(\\phi \\varphi\\) and others

Script lowercase `l` is \\(\\ell\\)

__Formula to code__ can be done with [Detexify](http://detexify.kirelabs.org/classify.html) which lets you draw a symbol on a web page and then lists the 𝑇𝐸𝑋 symbols that seem to resemble it. These are not guaranteed to work in MathJax but are a good place to start. To check that a command is supported, note that MathJax.org maintains a list of currently supported 𝐿𝐴𝑇𝐸𝑋 commands, and one can also check Dr. Carol JVF Burns's page of 𝑇𝐸𝑋

__Spaces__ MathJax usually decides for itself how to space formulas, using a complex set of rules. Putting extra literal spaces into formulas will not change the amount of space MathJax puts in: `a b` and `a    b` are both `ab`

* To add more space: use `\,` for a thin space \\(a\\,b\\); and use`\;` for a wider space \\(a\\;b\\). `\quad` and `\qquad` are large spaces: \\(a \\quad b\\) adn \\(a \\qquad b\\)
* To set plain text, use `\text{…}`: \\(\\{x\\in s\\mid x\\text{ is extra large}\\}\\).  You can nest `\\(…\\)` inside of `\text{…}`.
* Accents and diacritical marks use `\hat` for a single symbol \\(\\hat{x}\\), `\widehat` for a larger formula \\(\\hat{xy}\\).  If you make it too wide, it will look silly.  Similarly, there are `\bar` \\(\\bar{x}\\) and `\overline` \\(\\overline{xyz}\\), and `\vec` \\(\\vec{x}\\)  and `\overrightarrow` \\(\\overrightarrow{xy}\\) and `\overleftrightarrow` \\(\\overleftrightarrow{xy}\\). For dots, as in \\(\\frac d{dx}x\\dot x =  \\dot x^2 +  x\\ddot x\\), use `\dot` \\(\\dot\\) and `\ddot` \\(\\ddot\\).
* Special characters used for MathJax interpreting can be escaped using the `\` character: `\$` \\(
, `\\{` {, `\\_` \_, etc. If you want `\\` itself, you should use `\\backslash` \\)∖$, because `\\` is for a new line. 

## References

To see how any formula was written in any question or answer, including this one, right-click on the expression it and choose "Show Math As > TeX Commands".

This [small mathjax post](https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference) on stackexchange provided the best mathjax examples I've seen.  The [docs](https://docs.mathjax.org/en/latest/mathjax.html) are useful, but a bit wordy. 

The [wikipedia page](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols) provides some nice LaTeX references.

### Tables

MathJax does not implement LaTeX tables.

%%latex
\begin{array}{|c|c|}
\hline X & P(X = i) \\\hline
  1 & 1/6 \\\hline
  2 & 1/6 \\\hline
  3 & 1/6 \\\hline
  4 & 1/6 \\\hline
  5 & 1/6 \\\hline
  6 & 1/6 \\\hline
\end{array}

### Greek letters

%%latex
\begin{array}{|c|c|c|c|}
\hline
\alpha  &  \theta  &  o  & \tau          \\\hline
\beta  &  \vartheta &  \pi  &  \upsilon  \\\hline
\gamma  &  \gamma  &  \varpi  & \phi     \\\hline
\delta  &  \kappa  &  \rho  &  \varphi    \\\hline
\epsilon  &  \lambda  &   \varrho  &   \chi    \\\hline
\varepsilon  &  \mu  &  \sigma   &   \psi      \\\hline
\zeta  &  \nu  &  \varsigma  &  \omega      \\\hline
\eta   &   \xi  &  &   \\\hline                                     
\end{array}                                                                  

%%latex
\begin{array}{|c|c|c|c|}
\hline 
\Gamma        &         \Lambda       &        \Sigma       &        \Psi          \\\hline
 \Delta        &         \Xi           &        \Upsilon      &        \Omega        \\\hline
 \Theta        &         \Pi           &        \Phi    & - \\\hline
\end{array}

### Notation

%%latex
\begin{array}{|c|c|c|c|c|}
\hline 
 \hat{a}    &        \acute{a}     &     \bar{a}     &       \dot{a}     &       \breve{a}    \\\hline
 \check{a}   &        \grave{a}     &     \vec{a}     &       \ddot{a}    &       \tilde{a}    \\\hline
\end{array}

%%latex
\begin{array}{|c|c|}
\hline
\widetilde{abc}    &                 \widehat{abc}    \\\hline
 \overleftarrow{abc}   &              \overrightarrow{abc}    \\\hline
 \overline{abc}    &                  \underline{abc}    \\\hline
 \overbrace{abc}   &                  \underbrace{abc}    \\\hline
 \sqrt{abc}      &                    \sqrt[n]{abc}    \\\hline
 f'      &                          \frac{abc}{xyz}    \\\hline
 \end{array}

### Basic arrows and symbols 

%%latex
\begin{array}{|c|c|c|}
\hline
 \leftarrow    &               \longleftarrow       &        \uparrow      \\\hline
 \Leftarrow    &                \Longleftarrow      &         \Uparrow      \\\hline      
 \rightarrow   &                \longrightarrow     &         \downarrow      \\\hline    
 \Rightarrow   &                \Longrightarrow     &         \Downarrow      \\\hline    
 \leftrightarrow  &             \longleftrightarrow   &       \updownarrow      \\\hline  
 \Leftrightarrow   &            \Longleftrightarrow   &       \Updownarrow      \\\hline  
 \mapsto         &              \longmapsto         &         \nearrow       \\\hline     
 \hookleftarrow   &             \hookrightarrow      &        \searrow       \\\hline     
 \leftharpoonup    &            \rightharpoonup      &        \swarrow       \\\hline     
 \leftharpoondown    &          \rightharpoondown    &        \nwarrow       \\\hline     
 \rightleftharpoons  &          \leadsto    &                           \\\hline
\end{array}

### Logic, set, and operator symbols

%%latex
\begin{array}{|c|c|c|c|}
\hline
\forall  &  \complement  &  \therefore  &  \emptyset    \\\hline
\exists  &  \subset  &  \because  &  \empty    \\\hline
\exist  &  \supset  &  \mapsto  &  \varnothing    \\\hline
\nexists  &  \mid  &  \to  &  \implies    \\\hline
\in  &  \land  &  \gets  &  \impliedby    \\\hline
\isin  &  \lor  &  \leftrightarrow  &  \iff    \\\hline
\notin  &  \ni  &  \notni  &  \neg or \lnot    \\\hline
\end{array}

%%latex
\begin{array}{|c|c|c|c|}
\hline
\pm         &         \cap       &         \diamond           &         \oplus    \\\hline      
\mp         &        \cup        &        \bigtriangleup      &        \ominus    \\\hline     
\times      &         \uplus     &         \bigtriangledown   &         \otimes    \\\hline     
\div        &          \sqcap    &          \triangleleft     &          \oslash    \\\hline     
\ast        &         \sqcup     &         \triangleright     &         \odot       \\\hline       
\star       &         \vee       &         \lhd\\(^b\\)           &         \bigcirc    \\\hline    
\circ       &         \wedge     &         \rhd\\(^b\\)           &         \dagger    \\\hline     
\bullet     &         \setminus  &         \unlhd\\(^b\\)         &         \ddagger    \\\hline    
\cdot       &         \wr        &         \unrhd\\(^b\\)         &         \amalg     \\\hline      
+           &         -          &                              &                \\\hline
\end{array}

### Relation symbols

%%latex
\begin{array}{|c|c|c|c|}
\hline
 \leq         &        \geq         &       \equiv      &        \models    \\\hline       
 \prec        &        \succ        &       \sim        &        \perp    \\\hline         
 \preceq      &        \succeq      &       \simeq      &        \mid    \\\hline          
 \ll          &        \gg          &       \asymp      &        \parallel    \\\hline     
 \subset      &        \supset      &       \approx     &        \bowtie    \\\hline       
 \subseteq    &        \supseteq      &     \cong       &        \Join\\(^b\\)    \\\hline     
 \sqsubset\\(^b\\)    &    \sqsupset\\(^b\\)  &     \neq        &        \smile    \\\hline        
 \sqsubseteq      &    \sqsupseteq    &     \doteq      &        \frown    \\\hline        
 \in              &    \ni           &      \propto     &        =         \\\hline        
 \vdash           &    \dashv        &      <           &        >         \\\hline        
 :       &            &                &               \\\hline 
\end{array}

### Miscellaneous symbols

%%latex
\begin{array}{|c|c|c|c|}
\hline
\ldots       &         \cdots       &       \vdots       &       \ddots         \\\hline        
\ldots       &         \cdots       &       \vdots       &       \ddots         \\\hline        
 \aleph      &          \prime      &        \forall     &        \infty         \\\hline        
 \hbar       &          \emptyset   &        \exists     &        \Box\\(^b\\)         \\\hline      
 \imath      &          \nabla      &        \neg        &        \Diamond\\(^b\\)         \\\hline  
 \jmath      &          \surd       &        \flat       &        \triangle         \\\hline     
 \ell        &          \top        &        \natural    &        \clubsuit         \\\hline     
 \wp         &         \bot         &       \sharp       &       \diamondsuit         \\\hline  
 \Re         &         \|           &       \backslash   &       \heartsuit          \\\hline   
 \Im         &         \angle       &       \partial     &       \spadesuit         \\\hline    
 \mho\\(^b\\)    &         .            &       |      &                  \\\hline
 \end{array}

%%latex
\begin{array}{|c|c|c|c|c|c|c|}
\hline
\arccos   &  \cos    &   \csc   &   \exp   &   \ker    &     \limsup   &   \min   &   \sinh    \\\hline  
 \arcsin  &   \cosh   &   \deg  &    \gcd  &    \lg     &     \ln	   &   \Pr    &   \sup    \\\hline   
 \arctan  &   \cot    &   \det  &    \hom  &    \lim     &    \log	   &   \sec   &   \tan    \\\hline   
 \arg     &   \coth   &   \dim  &    \inf  &    \liminf  &    \max	   &   \sin   &   \tanh    \\\hline
  \end{array}

### Variable-sized symbols

%%latex
\begin{array}{|c|c|c|}
\hline
\sum         &        \bigcap       &      \bigodot    \\\hline       
 \prod       &         \bigcup      &       \bigotimes    \\\hline     
 \coprod     &         \bigsqcup    &       \bigoplus    \\\hline      
 \int        &         \bigvee      &       \biguplus    \\\hline      
 \oint       &         \bigwedge &   \\\hline
 \end{array}

### Delimiters

%%latex
\begin{array}{|c|c|c|c|}
\hline
(         &           )         &          \uparrow      &      \Uparrow    \\\hline       
 [        &            ]        &           \downarrow    &      \Downarrow    \\\hline     
 \{       &            \}       &           \updownarrow  &      \Updownarrow     \\\hline  
 \lfloor    &          \rfloor    &         \lceil       &       \rceil    \\\hline         
 \langle    &          \rangle    &         /            &       \backslash    \\\hline     
 |          &          \|    &           &    \\\hline 
 \end{array}

%%latex
\begin{array}{|c|c|c|c|}
\hline
\rmoustache    &    \lmoustache     &    \rgroup         &   \lgroup     \\\hline
  \arrowvert   &      \Arrowvert     &     \bracevert    &       \\\hline
\end{array}

### Matrix symbols

\\[\\begin{matrix} a & b \\\\ c & d \\end{matrix}\\]

\begin{pmatrix}
   a & b \\
   c & d
\end{pmatrix}

\\[\\begin{bmatrix} 1 & 2 & -1 \\\\ 3 & 0 & 1 \\\\ 0 & 2 & 4 \\end{bmatrix}\\]

\\[\\left( \\frac{p}{q} \\right)\\]

### Geometry symbols

%%latex
\begin{array}{|c|c|}
\hline
\angle  & \measuredangle        \\\hline
\triangle & \square         \\\hline
\cong  &  \ncong        \\\hline
\sim   &   \nsim        \\\hline
\| & \nparallel        \\\hline
\perp  &  \not \perp       \\\hline
\end{array}

### Algebraic symbols

\\[\\sum\_{n=0}^{\\infty}\\]

\\[\\prod\_{n=0}^{\\infty}\\]

### Calculus symbols

\\[\\int\_a^b\\]

\\[\\lim\_{x \\to a}\\]

\\[f'(a) = \\lim\_{x \\to a} \\frac{f(x) - f(a)}{x - a}\\]

\\[\\lim\_{x \\to a^-} f(x) = f(a) = \\lim\_{x \\to a^+} f(x)\\]

## Conclusion

Remembering these symbols' code may be difficult when only writing intermitently; however, this reference should provide any required information, quickly.

### References

* [wikipedia page of latex references](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols)
* [mathjax tutorial](https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference)
* [tex symbols](http://web.ift.uib.no/Teori/KURS/WRK/TeX/symALL.html)
* [latex wiki symbols](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols)
* [katex page](https://katex.org/docs/supported.html#html)
* [katex supported](https://github.com/KaTeX/KaTeX/blob/master/docs/supported.md)
