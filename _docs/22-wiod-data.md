---
layout: single
title: Wiod Data
modified: 2016-09-22
permalink: /docs/wiod-data/
image:
  feature: shipping-train.jpg
---

You can install the `wiod` package using:

{% highlight r %}
install.packages("wiod")
{% endhighlight %}

After which you can load the package using:

{% highlight r %}
library(wiod)
{% endhighlight %}

Once the package is loaded, dataset can be loaded by year using e.g.

{% highlight r %}
data(wiod95)
{% endhighlight %}
