---
layout: post
title: "Interpreting the output of the Leontief Decomposition"
author: Victor_Kummritz
excerpt: "A short description on how to read the results of the Leontief decomposition and its advanatges."
comments: true
---

Let's take a look at the output that the Leontief decomposition of the package creates. To this end, we look at the results of the Leontief decomposition for our example data set (Table 1). The output consists of a GNxGN matrix that gives for each country and industry the value added origins of its exports by country and industry. In the first column we find the source countries and industries while the first row contains the using countries and industries. The first element, 28.52, thus gives the amount of value added that the Argentinian Agriculture industry has contributed to the exports of the Argentinian Agriculture industry. Similarly, the last element of this row, 4.12, gives the amount of value added that the Argentinian Agriculture industry has contributed to the exports of the German Transport Equipment industry. \\

A key advantage of the decomposition becomes clear when we compare the decomposed values with the intermediate trade values of the non-decomposed IO table when multiplied with the exports over output ratio to create comparability (Table 2). We see for instance that Argentina's Agriculture industry contributes significantly more value added to the German Transport Equipment industry than suggested by the non-decomposed IO table. The reason is that Argentina Agriculture industry is an important supplier to Turkey's Textile and Leather industry which is in turn an important supplier for the German Transport Equipment industry. The decomposition thus allows us to see how the value added flows along this Global Value Chain.\\
We can also take look at specific industries. For instance, we find that the non-decomposed values of the Transport Equipment are for many elements larger than the value added elements while the opposite holds for Agriculture. This emphasises the fact that Transport Equipment is a downstream industry that produces mostly final goods. Agriculture on the other hand qualifies as an upstream industry that produces also many intermediate goods so that its value added in other industries is typically large.\\

Finally let's consider the countries of our specific example. We see that Germany has more instances in which the non-decomposed values are above the value added flows than Argentina and Turkey combined. Along the lines of the industry analysis, this shows that Germany focuses within this GVC on downstream tasks producing mostly final goods that contain value added from countries located more upstream. In our example these are Turkey and Argentina.

We call the following command.

{% highlight r %}
decomp(inter,
       final,
       countries,
       industries,
       out,
       method = "leontief")
{% endhighlight %}

Which give us this output.

{% highlight r %}
.                             Argentina.Agriculture Argentina.Textile.and.Leather Argentina.Transport.Equipment Turkey.Agriculture Turkey.Textile.and.Leather Turkey.Transport.Equipment Germany.Agriculture Germany.Textile.and.Leather Germany.Transport.Equipment
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

{% highlight r %}
.          Argentina..Agriculture Argentina..Textile.and.Leather Argentina..Transport.Equipment Turkey..Agriculture Turkey..Textile.and.Leather Turkey..Transport.Equipment Germany..Agriculture Germany..Textile.and.Leather
.          Argentina.Agriculture  Argentina.Textile.and.Leather  Argentina.Transport.Equipment  Turkey.Agriculture  Turkey.Textile.and.Leather  Turkey.Transport.Equipment  Germany.Agriculture  Germany.Textile.and.Leather
Argentina.Agriculture       6.87927927927928               2.49313893653516              0.246315789473684    1.30328305235138             2.0430176565008          0.0787037037037037    0.767562380038388            0.679186228482003
Argentina.Textile.and.Leather       1.02548262548263               3.91080617495712              0.437894736842105  0.0407275953859805            1.52038523274478           0.314814814814815    0.297120921305182            0.946009389671361
Argentina.Transport.Equipment      0.384555984555985               0.24442538593482              0.547368421052632                   0          0.0475120385232745          0.0590277777777778                    0           0.0970266040688576
Turkey.Agriculture       0.47001287001287              0.928816466552316             0.0273684210526316    7.33096716947649            6.27158908507223            1.20023148148148     2.22840690978887            0.751956181533646
Turkey.Textile.and.Leather      0.128185328185328               1.36878216123499             0.0136842105263158    2.48438331854481            13.3508828250401            1.23958333333333    0.519961612284069             0.60641627543036
Turkey.Transport.Equipment                      0              0.048885077186964             0.0410526315789474     1.6698314108252            1.52038523274478            1.75115740740741   0.0495201535508637                            0
Germany.Agriculture      0.512741312741313               2.05317324185249             0.0410526315789474     1.6698314108252           0.570144462279293           0.118055555555556     7.18042226487524             4.73004694835681
Germany.Textile.and.Leather      0.555469755469756              0.537735849056604                              0    1.30328305235138            2.28057784911717           0.511574074074074     1.26276391554702             7.05868544600939
Germany.Transport.Equipment      0.897297297297297              0.684391080617496              0.410526315789474     1.6698314108252            1.47287319422151           0.767361111111111      2.7978886756238             1.96478873239437
{% endhighlight %}
