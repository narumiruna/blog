---
title: "Cross Entropy"
date: null
draft: false
tags: ["math", "machine-learning", "deep-learning"]
ShowToc: true
---

# Cross Entropy

## Binary Cross Entropy

Given a dataset $D = \{ (x_1, y_1), \cdots, (x_n, y_n) \}$ where $x_i \in \mathbb{R}^d$ and  $y_i \in \{1,0\}$. Let $h: \mathbb{R}^d \rightarrow [0,1]$ be the function in hypothesis set and $\hat{y_i} = h(x_i)$ for all $i=1,\cdots, n$.

Since we have
$$ p(y_i=1|x_i) = \left\\{\begin{array}{cc} 
h(x)  & \text{ if } y_i = 1 \\\\
1-h(x) & \text{ if } y_i = 0
\end{array} \right.
$$
the 


$$
\begin{align}
\text{likelihood}(h) = & p(x_1) p(y_1 \mid x_1) \times p(x_2) p(y_2 \mid x_2) \times \cdots \times p(x_n) p(y_n \mid x_n) \\\\
= &  \Pi_{y_i=1} h(x_i) \Pi_{y_i=0} [1-h(x_i)] \\\\
= &   \Pi_{y_i=1} \hat{y_i}  \Pi_{y_i=0} (1-\hat{y_i}) 
\end{align}
$$

Then
$$
\begin{align}
\max_{h} \text{likelihood}(h)  \Leftrightarrow & \max_{h} \log{ \Pi_{y_i=1} \hat{y_i}  \Pi_{y_i=0} (1-\hat{y_i}) } \\\\
\Leftrightarrow & \max_{h} \sum_{y_i=1} \log \hat{y_i} + \sum_{y_i=0} \log (1-\hat{y_i}) \\\\
\Leftrightarrow & \max_{h} \sum_{y_i=1} y_i \log \hat{y_i} + \sum_{y_i=0} (1-y_i)  \log (1-\hat{y_i}) \\\\
\Leftrightarrow & \max_{h} \sum_{i=1}^n y_i \log \hat{y_i} + \sum_{i=1}^n (1-y_i)  \log (1-\hat{y_i}) \\\\
\Leftrightarrow & \max_{h} \sum_{i=1}^n \left[ y_i \log \hat{y_i} + (1-y_i)  \log (1-\hat{y_i}) \right] \\\\
\Leftrightarrow & \min_{h} - \sum_{i=1}^n \left[ y_i \log \hat{y_i} + (1-y_i)  \log (1-\hat{y_i}) \right]
\end{align}
$$

where $\text{BCE} (y, \hat{y}) := - \frac{1}{n} \sum_{i=1}^n \left[ y_i \log \hat{y_i} + (1-y_i)  \log (1-\hat{y_i}) \right]​$ is the binary cross entropy.

Moreover, we let $Y_i = (y_i, 1-y_i)$, $\widehat{Y_i} = (\hat{y_i}, 1-\hat{y_i})$ and $m$ be the number of categories (here $m=2$ in binary case). Therefore, we have 
$$
\begin{align}
\text{BCE} (y, \hat{y}) = &  - \frac{1}{n} \sum_{i=1}^n \left[ y_i \log \hat{y_i} + (1-y_i)  \log (1-\hat{y_i}) \right] \\\\
= & - \frac{1}{n} \sum_{i=1}^n \left[ Y_{i1} \log \widehat{Y_{i1}} + (1-Y_{i1})  \log (1-\widehat{Y_{i1}}) \right] \\\\
=  & - \frac{1}{n} \sum_{i=1}^n \left[ Y_{i1} \log \widehat{Y_{i1}} + Y_{i2} \log \widehat{Y_{i2}} \right] \\\\
= & - \frac{1}{n} \sum_{i=1}^n \sum_{j=1}^{m=2}  Y_{ij} \log \widehat{Y_{ij}} \\\\
= & -\frac{1}{n}  \sum_{i=1}^n \left< Y_i, \log \widehat{Y_i} \right>
\end{align}
$$
from this form we can extend the binary cross entropy to categorical cross entropy. Note that $\sum_{j=1}^{m=2} Y_{ij} = 1​$ and $\sum_{j=1}^{m=2} \widehat{Y_{ij}} = 1​$.

## Categorical Cross Entropy

$$
\begin{align}
\text{CE}(Y, \widehat{Y}) = &  - \frac{1}{n} \sum_{i=1}^n \sum_{j=1}^{m}  Y_{ij} \log \widehat{Y_{ij}} \\\\
= & -\frac{1}{n}  \sum_{i=1}^n \left< Y_i, \log \widehat{Y_i} \right>
\end{align}
$$

where $\sum_{j=1}^{m} Y_{ij} = 1$ and $\sum_{j=1}^{m} \widehat{Y_{ij}} = 1$.


## Focal Loss

$$
\begin{align}
\text{CFL}(Y, \widehat{Y}) = & -\frac{1}{n}  \sum_{i=1}^n \left< Y_i,(1 - \widehat{Y_i})^{\gamma} \cdot \log \widehat{Y_i} \right> \\\\
= & -\frac{1}{n}  \sum_{i=1}^n \left< Y_i, \text{FL}(\widehat{Y_i}) \right>
\end{align}
$$

where $\text{FL}(x) = (1-x)^\gamma \log x$.

## Implementation of Binary Cross Entropy

https://github.com/tensorflow/tensorflow/blob/r1.13/tensorflow/python/ops/nn_impl.py#L108
https://github.com/pytorch/pytorch/blob/65b00aa5972e23b2a70aa60dec5125671a3d7153/aten/src/ATen/native/Loss.cpp#L90
