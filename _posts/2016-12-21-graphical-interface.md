---
layout: single
title: "Graphical Interface to decompr in RStudio"
permalink: graphical-interface
author_profile: true
---

The latest development release of decompr includes a graphical user interface, as shown in the video below.

<iframe width="560" height="315" src="https://www.youtube.com/embed/b-bM1msVuZk" frameborder="0" allowfullscreen></iframe>

You can test the development version by installing it from GitHub, using the code below.

{% highlight r %}
if (!require('devtools')) install.packages('devtools')
devtools::install_github("bquast/decompr")
{% endhighlight %}

After which the package can be loaded as normal.

{% highlight r %}
library(decompr)
{% endhighlight %}

{% highlight r %}
If you use decompr for data analysis,
please cite R as well as decompr,
using citation() and citation("decompr") respectively.
{% endhighlight %}

This graphical user interface builds on the [online demo version of decompr](http://qua.st/decompr/demo/).
