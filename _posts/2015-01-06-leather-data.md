---
layout: post
title: "leather data set"
author: Bastiaan_Quast
modified: 2015-01-04T13:03:02.362000+01:00
comments: true
---

The current development version of decompr now includes a new 3-country  3-sector example dataset, which illustrates the value of the Wang-Wei-Zhu algorithm by revealing the value of forward- and backward-linkages.

The development version of decompr can be installed using the following commands.

{% highlight r %}
# install the devtools package (installs packages directly from github)
install.packages("devtools")

# load the devtools package
library(devtools)

# load the devtools package
install_github("bquast/decompr")
{% endhighlight %}

After which we can load the development install of decompr in the usual way.

{% highlight r %}
library(decompr)
{% endhighlight %}

{% highlight r %}
If you use decompr for data analysis,
please cite R as well as decompr,
using citation() and citation("decompr") respectively.

The API for the decomp function has changed,
it now uses load_tables_vectors instead of load_tables,
for more info see http://qua.st/decompr/decompr-v2/.
{% endhighlight %}

We can now load the new leather dataset

{% highlight r %}
data(leather)
{% endhighlight %}


