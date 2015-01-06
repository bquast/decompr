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

Lets start by looking at the objects included in this data set.

{% highlight r %}
ls()
{% endhighlight %}

{% highlight r %}
[1] "countries"  "final"      "industries" "inter"      "out" 
{% endhighlight %}

Now lets examine each object in detail.

{% highlight r %}
countries
{% endhighlight %}

{% highlight r %}
[1] "Argentina" "Turkey"    "Germany"
{% endhighlight %}


{% highlight r %}
industries
{% endhighlight %}

{% highlight r %}
[1] "Agriculture"         "Textile.and.Leather" "Transport.Equipment"
{% endhighlight %}


{% highlight r %}
out
{% endhighlight %}

{% highlight r %}
[1]  77.7  58.3  19.0 112.7 124.6  43.2 156.3 127.8 217.0
{% endhighlight %}


{% highlight r %}
final
{% endhighlight %}

{% highlight r %}
      [,1] [,2] [,3]
 [1,] 21.5  6.1  8.4
 [2,] 16.2  1.9  5.1
 [3,] 11.0  0.5  0.8
 [4,]  7.5 29.5 14.2
 [5,]  8.9 24.9 16.9
 [6,]  1.2 18.5  4.9
 [7,]  9.2 17.9 51.2
 [8,]  7.9 10.1 38.5
 [9,] 25.1 35.2 68.4
{% endhighlight %}

{% highlight r %}
inter
{% endhighlight %}

{% highlight r %}
      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9]
 [1,] 16.1  5.1  1.8  3.2  4.3  0.4  3.1  2.8  4.9
 [2,]  2.4  8.0  3.2  0.1  3.2  1.6  1.2  3.9 11.5
 [3,]  0.9  0.5  4.0  0.0  0.1  0.3  0.0  0.4  0.5
 [4,]  1.1  1.9  0.2 18.0 13.2  6.1  9.0  3.1  8.9
 [5,]  0.3  2.8  0.1  6.1 28.1  6.3  2.1  2.5 25.6
 [6,]  0.0  0.1  0.3  4.1  3.2  8.9  0.2  0.0  1.8
 [7,]  1.2  4.2  0.3  4.1  1.2  0.6 29.0 19.5 17.9
 [8,]  1.3  1.1  0.0  3.2  4.8  2.6  5.1 29.1 24.1
 [9,]  2.1  1.4  3.0  4.1  3.1  3.9 11.3  8.1 51.3
{% endhighlight %}

We start by using the 'standard' Leontief decomposition.

{% highlight r %}
decomp(inter,
       final,
       countries,
       industries,
       out,
       method = "leontief")
{% endhighlight %}

{% highlight r %}
                              Argentina.Agriculture Argentina.Textile.and.Leather Argentina.Transport.Equipment Turkey.Agriculture Turkey.Textile.and.Leather Turkey.Transport.Equipment Germany.Agriculture Germany.Textile.and.Leather Germany.Transport.Equipment
Argentina.Agriculture                   28.52278143                    2.79395126                    0.35606694         1.81066955                  3.1173841                 0.35901126           1.2364172                  1.30283802                   4.1208736
Argentina.Textile.and.Leather            1.06206936                   19.12053186                    0.41813924         0.48370042                  1.8329024                 0.43058635           0.5937041                  1.15375958                   4.7490351
Argentina.Transport.Equipment            0.21043693                    0.14228369                    1.06369578         0.03329456                  0.0790545                 0.04024626           0.0231846                  0.07482343                   0.1932621
Turkey.Agriculture                       0.71952151                    1.34237213                    0.11504126        34.92704803                  6.9994970                 1.47711579           2.5543089                  1.52213499                   6.1806254
Turkey.Textile.and.Leather               0.41201175                    1.38523849                    0.11764036         2.69291816                 40.1671410                 1.31799873           1.1093993                  1.15207241                   9.5069032
Turkey.Transport.Equipment               0.03482652                    0.08553139                    0.02667530         0.81210167                  0.9075189                 3.16041392           0.1151191                  0.07448266                   0.6464733
Germany.Agriculture                      0.92530356                    2.25142713                    0.16222512         2.31122022                  2.0595825                 0.51211484          29.8763359                  5.24719728                   9.6006931
Germany.Textile.and.Leather              0.64666560                    0.72785683                    0.08244379         1.53837777                  2.5488967                 0.63316614           1.4593583                 18.95868110                   8.1583150
Germany.Transport.Equipment              0.66638333                    0.65080723                    0.25807221         1.29066963                  1.4880228                 0.56934671           1.7321726                  1.51401054                  34.7438192
{% endhighlight %}

Now lets use the WWZ decomposition (default method, so no need to specify).

{% highlight r %}
decomp(inter,
       final,
       countries,
       industries,
       out)
{% endhighlight %}


{% highlight r %}
                                           DVA_FIN    DVA_INT DVA_INTrexI1 DVA_INTrexF DVA_INTrexI2     RDV_INT    RDV_FIN    RDV_FIN2    OVA_FIN     MVA_FIN    OVA_INT    MVA_INT     DDC_FIN
Argentina.Agriculture.Argentina          0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
Argentina.Agriculture.Turkey             5.4744354  2.6813686   1.13634407  1.40930027  0.504931544 0.168614730 0.70568372 0.347019751 0.41126356  0.21430105 0.19588405 0.10207118 0.064864146
Argentina.Agriculture.Germany            7.5385668  5.1055954   0.41301548  2.07223830  0.184142503 0.241349852 1.40626760 0.084582830 0.29510308  0.56633015 0.19467191 0.37359342 0.087209223
sub.TOTAL                               13.0130022  7.7869640   1.54935955  3.48153856  0.689074047 0.409964582 2.11195132 0.431602581 0.70636664  0.78063119 0.39055596 0.47566461 0.152073368
Argentina.Textile.and.Leather.Argentina  0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
Argentina.Textile.and.Leather.Turkey     1.4704511  1.6059520   0.51989101  0.73959485  0.238689217 0.078969730 0.33143582 0.166207540 0.24200608  0.18754280 0.26256584 0.20347560 0.027678457
Argentina.Textile.and.Leather.Germany    3.9470004  6.4499428   0.53948810  2.81987967  0.236761536 0.317887034 1.98497120 0.107403534 0.50340436  0.64959526 0.81211670 1.04795907 0.106880311
sub.TOTAL                                5.4174515  8.0558948   1.05937911  3.55947452  0.475450753 0.396856764 2.31640701 0.273611074 0.74541044  0.83713807 1.07468254 1.25143467 0.134558769
Argentina.Transport.Equipment.Argentina  0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
Argentina.Transport.Equipment.Turkey     0.3534427  0.1488951   0.02512465  0.05166467  0.011502878 0.004631660 0.01867612 0.007976699 0.09668098  0.04987633 0.04203798 0.02168679 0.001418669
Argentina.Transport.Equipment.Germany    0.5655083  0.3167888   0.02878668  0.13002229  0.012763061 0.014519380 0.09346627 0.005810004 0.07980213  0.15468957 0.04511074 0.08744330 0.005097011
sub.TOTAL                                0.9189510  0.4656839   0.05391133  0.18168696  0.024265939 0.019151040 0.11214239 0.013786703 0.17648311  0.20456591 0.08714872 0.10913009 0.006515680
Turkey.Agriculture.Argentina             6.2797497  1.1190525   0.42428189  0.32364669  0.127683939 0.154036261 0.17353911 0.182994956 0.83991301  0.38033734 0.15006977 0.06795601 0.107000467
Turkey.Agriculture.Turkey                0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
Turkey.Agriculture.Germany              11.8896593  9.1875645   0.44406842  2.46325705  0.104348906 0.693923875 3.73948515 0.057224342 0.72010537  1.59023530 0.55070767 1.21614811 0.452925213
sub.TOTAL                               18.1694090 10.3066170   0.86835031  2.78690374  0.232032845 0.847960135 3.91302425 0.240219299 1.56001837  1.97057264 0.70077744 1.28410412 0.559925680
Turkey.Textile.and.Leather.Argentina     7.2273648  1.0471326   0.46078259  0.29530382  0.140987907 0.151185856 0.13152490 0.200948224 0.91653494  0.75610026 0.13297218 0.10969609 0.101320108
Turkey.Textile.and.Leather.Turkey        0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
Turkey.Textile.and.Leather.Germany      13.7238725 12.0058480   0.62802955  3.90680904  0.127367338 0.950059562 5.57979048 0.074151999 1.43574094  1.74038658 1.24831079 1.51318619 0.597136653
sub.TOTAL                               20.9512373 13.0529806   1.08881214  4.20211286  0.268355245 1.101245417 5.71131537 0.275100223 2.35227588  2.49648684 1.38128298 1.62288228 0.698456761
Turkey.Transport.Equipment.Argentina     0.8407805  0.1781916   0.02204374  0.02060577  0.006672856 0.008562439 0.01119518 0.009457655 0.24206509  0.11715443 0.05450683 0.02638016 0.005182273
Turkey.Transport.Equipment.Turkey        0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
Turkey.Transport.Equipment.Germany       3.4331870  0.6546040   0.03517716  0.21633307  0.007037041 0.049810123 0.31139842 0.004084652 0.47838059  0.98843243 0.09450248 0.19526151 0.031112965
sub.TOTAL                                4.2739675  0.8327955   0.05722090  0.23693884  0.013709897 0.058372562 0.32259360 0.013542308 0.72044567  1.10558686 0.14900931 0.22164167 0.036295238
Germany.Agriculture.Argentina            7.8610949  2.0199906   0.28226589  0.28018271  0.060605877 0.820750168 0.57157404 0.131707311 0.89832585  0.44057920 0.22998309 0.11279400 0.605435276
Germany.Agriculture.Turkey              15.2949565  2.0603035   0.11637081  0.47705677  0.015705424 0.736949683 0.97226390 0.029961455 0.85721388  1.74782965 0.11412326 0.23269341 0.531356894
Germany.Agriculture.Germany              0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
sub.TOTAL                               23.1560514  4.0802941   0.39863671  0.75723948  0.076311301 1.557699850 1.54383794 0.161668766 1.75553973  2.18840885 0.34410636 0.34548741 1.136792170
Germany.Textile.and.Leather.Argentina    6.5544233  0.7909465   0.11961386  0.15208027  0.027530616 0.309465907 0.25977474 0.058019038 0.70047263  0.64510407 0.08462563 0.07793643 0.224432812
Germany.Textile.and.Leather.Turkey       8.3797057  3.6874998   0.18967992  0.78711215  0.023624112 1.222414373 1.69900744 0.046204332 0.82475330  0.89554095 0.36128082 0.39228915 0.921022483
Germany.Textile.and.Leather.Germany      0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
sub.TOTAL                               14.9341290  4.4784463   0.30929378  0.93919242  0.051154728 1.531880280 1.95878218 0.104223370 1.52522593  1.54064502 0.44590645 0.47022558 1.145455295
Germany.Transport.Equipment.Argentina   16.9168288  2.3746384   0.18110921  0.25997068  0.039006620 0.436904740 0.42764724 0.084238072 5.26294538  2.92022578 0.77714301 0.43120969 0.314861124
Germany.Transport.Equipment.Turkey      23.7239990  3.2689405   0.14831124  0.60720101  0.018387426 0.907106729 1.37381855 0.035453172 4.09529671  7.38070428 0.58558374 1.05536198 0.673700534
Germany.Transport.Equipment.Germany      0.0000000  0.0000000   0.00000000  0.00000000  0.000000000 0.000000000 0.00000000 0.000000000 0.00000000  0.00000000 0.00000000 0.00000000 0.000000000
sub.TOTAL                               40.6408278  5.6435788   0.32942045  0.86717168  0.057394046 1.344011469 1.80146580 0.119691243 9.35824209 10.30093006 1.36272675 1.48657167 0.988561658
{% endhighlight %}
