# Logistic Regression

----

## Table of Contents

----

## About Logistic Regression

- Popularized by David Cox in 1950s
- Although a regression technique, often used for classification
- Also called **logit**
- Still very popular due to being **easy to understand and explain**, while still giving **good results**

---

# Derivation

The logistic regression is part of the **generalized linear model (GLM)** family:

$$ \begin{align} P(Y|X=x) &= \sigma(\beta_0 + \beta_1x_1 + \dots) 
    \\\\ & = \sigma(\beta^\intercal X) \end{align} $$

in the case of logistic regression, we have $\sigma(x) = 1/(1 + e^{-x})$ to give:

$$ P(Y|X=x) = \frac{1}{1 + e^{-\beta^\intercal X}} $$

----

In the case of 1-dimensional $X$, we get

$$ P(Y|X=x) = \frac{1}{1+e^{-(\beta_0 + \beta_1 x)}}$$

which, when trained, looks like this

<img src="images/logreg_plots.png" width="40%">

----

So what happens when we change the parameters $\beta_0, \beta_1$?

----

<img src="images/shift_beta_zero.png" >

----

<img src="images/shift_beta_one_plus.png" >

----

<img src="images/shift_beta_one_minus.png" >

----

## Interpretation of weighted sum

$$ \begin{align} P(Y=1|X = x) &= \frac{1}{1 + e^{-\beta^\intercal x}}
    \\\\ P(Y=1|X = x)\left( 1 + e^{-\beta^\intercal x}\right) & = 1
    \\\\ P(Y=1|X = x) + P(Y=1|X = x)e^{-\beta^\intercal x} & = 1
    \\\\ P(Y=1|X = x)\left( 1 + e^{-\beta^\intercal x}\right) & = 1 \end{align} $$

We can write $1 - P(Y=1|X = x) = P(Y=0|X = x)$ to obtain:

$$ \begin{align}  \frac{P(Y=1|X = x)}{P(Y=0|X = x)} & = e^{\beta^\intercal x}
    \\\\ \log\left(\frac{P(Y=1|X = x)}{P(Y=0|X = x)}\right) & = \beta^\intercal x \end{align} $$

----

This last expression 

> $$ \log\left(\frac{P(Y=1|X = x)}{P(Y=0|X = x)}\right) = \beta^\intercal x $$

tells us that the weighted sum of the data can be interpreted as the **log-odds ratio**

----

# Another interpretation

> We can also view this as a sequence of mappings

- A function which maps the vector $x$ to a single real number

$$\mathbb{R}^m \rightarrow \mathbb{R}: x \mapsto \beta^\intercal x$$

- A function which normalizes this number to a probability (monotonically):

$$\mathbb{R} \rightarrow [0,1]: x \mapsto \frac{1}{1 + e^{-x}} $$


----

## Decision Boundary

One problem left, we want values in $\\{0,1\\}$, not $[0,1]$.

We can solve this by introducing a **threshold $t$**

<img src="images/prob_threshold.png">

----

## Finding decision boundary

Let's find the boundary in our parameter space $x \in \mathbb{R}^m$:

$$ \begin{align} P(Y = 1 | X = x) & = \frac{1}{1 + e^{-\beta^\intercal x}}
    \\\\ & = 1/2 \end{align} $$

We can rewrite this as

$$ \begin{align}\frac{1}{1 + e^{-\beta^\intercal x}} & = \frac{1}{2}
    \\\\ 1 + e^{-\beta^\intercal x} & = 2 
    \\\\ e^{-\beta^\intercal x} & = 1
    \\\\ \beta^\intercal x & = 0\end{align} $$

----

## Finding decision boundary

The boundary is the set of points $\\{x \in \mathbb{R}^m: \beta^\intercal x = 0\\}$

<img src="images/decision_boundary.png" width="400">

---

# Evaluating Models

So now that we've defined a model $\hat{y}_\beta$, we now have to find out how to choose the best one to fit our data.

In order to make this decision, we first need to **define what a good model is.**

> We do this with an **Loss function.**

----

## Evaluating Models

We want a function that maps $\mathcal{L}: \mathbb{R}^{m+1} \rightarrow \mathbb{R}: \beta \mapsto \mathcal{L}(\hat{y}_\beta(x), y)$

This will allow us to, given the features $x$ and labels $y$, compare two sets of parameters to see which one performs better.

Often the **log-likelihood (aka cross-entropy)** is used for this 

----

## Log-likelihood

The likelihood $\mathcal{L}$ is expressed by

$$ \mathcal{L}(\beta) = \prod\_{i=1}^nP(Y = y_i|X=x_i; \beta)$$

which is the probability of the data occuring, given the model parameter $\beta$. 

This is hard to work with, so we usually work with the log-likelihood

$$ \log \mathcal{L}(\beta) = \sum\_{i=1}^n\log P(Y = y_i|X=x_i; \beta)$$

> Note that $\mathcal{L}$ and $\log \mathcal{L}$ have the same maximum

Notes: We assume independence of variables here!

----

## Log-likekelihood

We can rewrite this to another common form using the powers of math:

$$ \begin{align} \log \mathcal{L}(\beta) & = \sum\_{i=1}^n\log P(Y = y_i|X=x\_i; \beta)
    \\\\ & = \sum\_{i=1}^n\log P(Y = 1|X=x_i; \beta)^{y_i} + \log P(Y = 0|X=x_i; \beta)^{(1 - y\_i)} 
    \\\\ & = \sum\_{i=1}^n y\_i\log (\hat{y}_\beta(x)) + (1 - y\_i)\log (1 - \hat{y}_\beta(x_i))  \end{align} $$

The form at the bottom is called the **cross-entropy**

----

## Why maximum likelihood?

- Unbiased and consistent (under certain conditions)

<img src="images/convergence.png" width="250">

- Concave function on parameter space

<img src="images/concave.png" width="250">

Notes: Super nice for optimization

---

# Optimization

## GD

## SGD

## Newton-Rhapson

## BFGS/L-BFGS