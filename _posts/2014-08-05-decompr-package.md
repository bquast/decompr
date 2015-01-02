---
layout: post
title: The decompr package
comments: true
author: Bastiaan_Quast
---

We are proud to announce the beta version of the [decompr](http://qua.st/decompr/) **R package**. The package implements Export Decomposition using the Wang-Wei-Zhu (Wang, Wei, and Zhu 2013) and Kung-Fu (Mehrotra, Kung, and Grosky 1990) algorithms. It comes with a sample data set from the [WIOD project](http://www.wiod.org/), and has its own [mini site](http://qua.st/decompr).

**Update**, the decompr package in now [available on CRAN](http://cran.r-project.org/web/packages/decompr/index.html), also announced in [this post](/decompr-cran)

Inputs
------

The package uses Inter-Country Input-Output (ICIO) tables, such as World Input Outpt Database (Timmer et al. 2012).

The **x** argument is intermediate demand table, where the first row and the first column list the country names, the second row and second column list the insdustry names for each country. The matrix is presumed to be of dimensions **GxN** where **G** represents the country and **N** the industry. No extra columns should be there. Extra rows at the bottom which list adjustments such as taxes as well are disregarded, with the exception that the very last row is presumed to contain the total output.

The **y** argument is the final demand table it has dimensions **GNxGM** ( where **M** is the number of objects final demand is decomposed in, e.g. household consumption, here this is five decompositions).

Output
------

The output when using the WWZ algorithm is a matrix with dimensions **GNGx19**. Whereby **19** is the **16** objects the WWZ algorithm decomposes exports into, plus three checksums. **GNG** represents source country, using industry and using country.

Installation
------------
You can install the latest **stable** version from CRAN.

{% highlight r linenos %}
install.packages("decompr")
{% endhighlight %}

You can install the latest **development** version from GitHub using the `devtools` package.


{% highlight r linenos %}
library(devtools)
install_github("decompr", "bquast")
{% endhighlight %}

    ## Downloading github repo bquast/decompr@master
    ## Installing decompr
    ## "D:/R/R-3.1.1/bin/x64/R" --vanilla CMD INSTALL  \
    ##   "C:\Users\quast2\AppData\Local\Temp\Rtmp0oRZqc\devtools142c2c3e7a0a\bquast-decompr-1e34b57"  \
    ##   --library="D:/R/R-3.1.1/library" --install-tests

Usage
-----

{% highlight r linenos %}
# load the package
library(decompr)

# load World Input-Output Database for 2011
data(wiod)

# explore the data
dim(intermediate_demand) # (2 + GN + totals) x (2 + GN)
{% endhighlight %}

    ## [1] 255 247

{% highlight r linenos %}
dim(final_demand)        # (2 + GN + totals) x (2 + G*5)
{% endhighlight %}

    ## [1] 247  37

{% highlight r linenos %}
intermediate_demand[1:40,1:40]
{% endhighlight %}

    ##           V1  V2        V3        V4        V5        V6        V7
    ## 1                Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone
    ## 2                       c1        c2        c3        c4        c5
    ## 3  Euro-zone  c1     43597        73    154023      1693       319
    ## 4  Euro-zone  c2       534      1971       628        53        17
    ## 5  Euro-zone  c3     30075        84    119378       665      2707
    ## 6  Euro-zone  c4       458        25       498     27680      1257
    ## 7  Euro-zone  c5       106         6       152       755      6919
    ## 8  Euro-zone  c6      1393       228      2069       130        88
    ## 9  Euro-zone  c7       856       237     12260      1400       415
    ## 10 Euro-zone  c8     12133      1364      4741      1113       169
    ## 11 Euro-zone  c9     11620       851      7665      6366      1040
    ## 12 Euro-zone c10      1601       290     10389      1453      1533
    ## 13 Euro-zone c11      1582      1261      5862       360        48
    ## 14 Euro-zone c12      4146      1671     10704      1498       741
    ## 15 Euro-zone c13      5976      2397      5059      1492       300
    ## 16 Euro-zone c14       720       287      2184       540       172
    ## 17 Euro-zone c15      1275       151      1427       496       119
    ## 18 Euro-zone c16       283        63      1230       700       131
    ## 19 Euro-zone c17     11094      4708     20700      5352       682
    ## 20 Euro-zone c18      2772       891      4604      1406       248
    ## 21 Euro-zone c19      5444       590     12508      2780       992
    ## 22 Euro-zone c20     19661      1852     66156     14220      4483
    ## 23 Euro-zone c21     15447      1213     48427     10791      3591
    ## 24 Euro-zone c22       481       125      2902       957       344
    ## 25 Euro-zone c23      4911      2057     22975      4357      1750
    ## 26 Euro-zone c24       333       104       732       187        54
    ## 27 Euro-zone c25       152       147       623       211       144
    ## 28 Euro-zone c26      1388       860     11508      1534       514
    ## 29 Euro-zone c27       715       377      3379       930       175
    ## 30 Euro-zone c28      9469      1155     13752      3188       762
    ## 31 Euro-zone c29      1243       674      9049      2754       572
    ## 32 Euro-zone c30     19129      3995     65820     10566      2650
    ## 33 Euro-zone c31       779       297      2372       304        68
    ## 34 Euro-zone c32       404       104      1405       230        62
    ## 35 Euro-zone c33      2888        30      1072       126        33
    ## 36 Euro-zone c34      2016       474      6961      1430       434
    ## 37 Euro-zone c35         0         0         0         0         0
    ## 38  Other EU  c1      1511         4      7181        68        12
    ## 39  Other EU  c2        36       527       134         8         1
    ## 40  Other EU  c3       461         2      1864        10        19
    ##           V8        V9       V10       V11       V12       V13       V14
    ## 1  Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone
    ## 2         c6        c7        c8        c9       c10       c11       c12
    ## 3      11567      4392       141      1008      1780        88       348
    ## 4         45       831     30501      2819       194     10398      3791
    ## 5        173      1028       872      7727       505       324      1137
    ## 6         99       686       162      1155      1099       212       711
    ## 7         37        56        29       104        76        41       199
    ## 8      21204      2129       168       907       705      1064      2508
    ## 9        894     63990      1019      7539      2402      1690      3165
    ## 10       848      1980     61117     28321      3029      3147      8343
    ## 11      2357      8268     14459     99768     25521      4175     12476
    ## 12       662      3156      3680      8239     18864      1517      6479
    ## 13       872       465       422      3998      1143     22795      6482
    ## 14      2737      3501      5882     11787      6947      5557    300369
    ## 15       986      3110      2898      5574      3732      3249     16648
    ## 16       307      1447      2583      3695      1473       991      7540
    ## 17       166       504      1026      2002      1010       643      4147
    ## 18       445      2177       487      1181      1228       944     19971
    ## 19      2524     12368      6172     21204      7567     11992     26896
    ## 20       853      2345      3204      3693      1167      2485      6656
    ## 21      1348      3282      3766      7611      2732      2391      7741
    ## 22      6473     18782     22053     41274     14456     11378     41990
    ## 23      4528     12196     16751     28480     10139      7487     26739
    ## 24       367      1119       562      2168       836       708      2907
    ## 25      2463      8297      7647     12814      4841      7402     15825
    ## 26       115       273       942      1128       210       181      1393
    ## 27       105       562       493      1100       402       257       920
    ## 28      1014      4505      8943      6108      2466      3377      8010
    ## 29       378      3382      1164      3453       986      1030      3168
    ## 30      1529      6241      6344      9644      2837      3072     12802
    ## 31      1220      5395      3427      6388      2744      2462      9289
    ## 32      4332     34801     21813     70705     18836     15269     51803
    ## 33       364      1299       865      2665       711       724      1933
    ## 34       136       643       813      2225       508       309      1589
    ## 35        64       282       193       676       171       113       355
    ## 36       692      9233      2461      8263      1558      1461      6175
    ## 37         0         0         0         0         0         0         0
    ## 38       354       147       123        61        90         6        27
    ## 39         7        93     15127       982        40       470      3547
    ## 40         4        20        41       207        33         6        20
    ##          V15       V16       V17       V18       V19       V20       V21
    ## 1  Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone
    ## 2        c13       c14       c15       c16       c17       c18       c19
    ## 3        193       173       196       273       716      2781       206
    ## 4        297       303       160       210     10204      9799       102
    ## 5        878       907      1156       542       423      1493       952
    ## 6        499       579      1902      1782       105      1264       209
    ## 7        142       100       413       635        35       195        49
    ## 8       1263       874      2036     15287       675     24098       210
    ## 9       3156      4103      2676      3277      1681      3670      2925
    ## 10      2216      2261      3048      1618     15269     13704      2911
    ## 11      4832      7509      7458      3085      2568      8621      2225
    ## 12     11802     10988     24852      4228      1318     20166      2946
    ## 13      2445      4492      5151      1214      1377     91033       950
    ## 14    105797     51434     94206     23320      7709     89657      5427
    ## 15     82550      8909     26820      2818      5712     18497      2288
    ## 16     22954     83209     25774      1470      8277     29967      2485
    ## 17      6659      3244    187692      1129       752      2417     19054
    ## 18      2318      1711      4206      9231       581      4666       558
    ## 19      8779      8119     10105      2719    155877      7898      5179
    ## 20      3619      2975      3285      1270     14338    266598      3630
    ## 21      5545      5230      9254      2606      2502     13233      7256
    ## 22     30173     28292     43413     12809      8153     47650     12851
    ## 23     20669     20639     33693      9036      5462     35490      6424
    ## 24      2868      2292      1582       813      1075      4693      2290
    ## 25      9127      7314     11905      4405      4310     13476      7852
    ## 26       607       407      1293       167       423       581       210
    ## 27      1313      1534      1363       178       251      1053       450
    ## 28      5691      4489      7319      1653      2979      7125      6373
    ## 29      3282      3710      2440       813      4256      6615      4277
    ## 30     10093      8440      8828      3148      9894     29071      8293
    ## 31      7473      7293     10595      3037      4986     31066     14551
    ## 32     49567     58871     59095     12804     35522     96542     31973
    ## 33      1138      1730      1981       546      7914      3969       958
    ## 34      1240      2113      2389       247      1117      1717       813
    ## 35       287       336       462       160       292       844       359
    ## 36      2765      2787      4787      1434      5170      6797      3551
    ## 37         0         0         0         0         0         0         0
    ## 38        20        14        15        25        63        64         8
    ## 39       206       153       248       150      3462       495         9
    ## 40        20        17        21         8        10        25         9
    ##          V22       V23       V24       V25       V26       V27       V28
    ## 1  Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone
    ## 2        c20       c21       c22       c23       c24       c25       c26
    ## 3       3826      2772     11979       194       313        98       393
    ## 4        710       507       133       123        18        36       144
    ## 5       5209      4707     88444       386      1146       319       516
    ## 6       1473      2228      1017       196        46        59       168
    ## 7       1016       398        96        45         7         8        37
    ## 8        924       642       709       143        24        30       464
    ## 9      13174     10675      3092      1435       175       289      3567
    ## 10     16549      6970      3913     34882      4196     13488      6540
    ## 11      4795      2011      3148       850       207       340       853
    ## 12      4899      3652       989      3367        59       136      1528
    ## 13      1765       920      2185       391        55        41       450
    ## 14      6520      3803      1846      2497       250       363      2917
    ## 15      4140      2626      2170      1926       337       263      1914
    ## 16      5742      3012      1756      1573       153       310      2026
    ## 17      2869      1389       583      7062      1014      4463      2440
    ## 18      1907      1780      1670       458       192       320       663
    ## 19     11632     19415     13636      7911       504       447      5627
    ## 20      7438      8616      6472      3655       308       499     11810
    ## 21      7186      6126      5803     13079       404       573      4888
    ## 22     64519     13286     24841      9730      2039      2803      6731
    ## 23     10377      7620     21341      4933       934      1550      3202
    ## 24     11301      4784      5717      3297       438      1616     11349
    ## 25     44857     13583      5705     32416      1844      1544     40358
    ## 26      2127       271       263       388      5509       161      3450
    ## 27      2560       938       202       692       393      2381      6999
    ## 28     52315      9288      3072     51751     28410     22165     82785
    ## 29     16269     16342      5608      4013       383      1006      5465
    ## 30     38167     24638     11371     15764      1247      2060      9851
    ## 31     44051     65437     30391      7105       418       961      9498
    ## 32    124683     79553     27445     32828      5677     10833     37684
    ## 33      3268      2386      1108      1838       256       379      1450
    ## 34      2647      1814       772      1380        81       665       833
    ## 35      1232       818       833       311        46        69       262
    ## 36      9653     13257      7994      2411       341       538      4117
    ## 37         0         0         0         0         0         0         0
    ## 38       177        99       397        10        13         4        15
    ## 39        61        24        10        16         4         2        20
    ## 40        78        63      1057         9        18         7        13
    ##          V29       V30       V31       V32       V33       V34       V35
    ## 1  Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone
    ## 2        c27       c28       c29       c30       c31       c32       c33
    ## 3        101       139      1306       790      2856       690      2626
    ## 4        110       101       253       470       405        41       106
    ## 5        415       448       433      3240      3432      3094     13785
    ## 6        137        88        76       782       470        83      1442
    ## 7         35        18        11       128       123         8       109
    ## 8        196        81      1185       815       543       309       239
    ## 9       4331      8730      2352     38902      9630      5086      5167
    ## 10      2218      1853      1389     12378      6755      3153      5163
    ## 11       788       994      1008      7606      2627       723     29816
    ## 12      1088       386       560      4035      1025       204      1634
    ## 13      1002       172      2115      2259       764       347      1297
    ## 14      1461       916      1405      8025      4074      1007      2502
    ## 15      1374       725      1170      5326     10940       396      2473
    ## 16      8561      1555      1014     11811      3174       886     11775
    ## 17       630       576       403      4354      9104       204       815
    ## 18       384       638       367      3367      1394       631      1408
    ## 19      6205      6405      9339     16074     18394      9941     14745
    ## 20     10311      7125     86369     21336     26325      6828     10791
    ## 21      1530      1838      1046     10184      5418       938      4685
    ## 22      5522      4394      5042     28445      9524      3229     20204
    ## 23      3623      2402      1821     14439      7825      2497     16578
    ## 24      1448      3895      2200     16220      4355      1691      7115
    ## 25      3133      2055       945     12296      7202      4972      5522
    ## 26       130        81        56       418       355        67       214
    ## 27      1337      2372       457      5212      3060       263       607
    ## 28      4441      1747      1986     12654      2365       739       989
    ## 29     61825     21933      5284     39398     16892      2234      7057
    ## 30     10342    286397     49598     53126     19292      4889     12822
    ## 31     11981     29167     52870     58033     18998     13525     21275
    ## 32     43854    138297     50625    469468     67083     15181     50383
    ## 33      1370      2148      4161      8473     10219      2974      2511
    ## 34      1378      2182      1079     12821      4153     22191      3107
    ## 35       562       944       258      2597      2428       750     50811
    ## 36      3519      5663      8921     46621     21706      2950     12282
    ## 37         0         0       979         0         0         0         0
    ## 38         4         7        81        39       198        33       165
    ## 39         6        11        37        41        49        10        19
    ## 40         6         9         7        49       100        40       284
    ##          V36       V37      V38      V39      V40
    ## 1  Euro-zone Euro-zone Other EU Other EU Other EU
    ## 2        c34       c35       c1       c2       c3
    ## 3       1575         0     1652        4     4190
    ## 4        232         0       15      348        9
    ## 5       3380         0     1083        9     3550
    ## 6        771         0      112       17      112
    ## 7        105         0       10       10       33
    ## 8       1700         0       57       15       63
    ## 9       9534         0      157       20     1642
    ## 10      5411         0     1138      178      343
    ## 11      4377         0     3076      312     1094
    ## 12      1847         0      275      143     1410
    ## 13      1195         0       73       69      240
    ## 14      4551         0      560      841      717
    ## 15      2809         0      820      811      643
    ## 16      2626         0      131      209      170
    ## 17      1545         0      221      220      163
    ## 18      4640         0       56       23       78
    ## 19     14617         0       82       62      110
    ## 20     12132         0       19       23       26
    ## 21      4518         0        4        7        8
    ## 22     10343         0       92       51      144
    ## 23      7264         0       17        8       38
    ## 24      6397         0       32       28       58
    ## 25      5420         0       37       45      101
    ## 26       158         0        4       19       22
    ## 27      1628         0       23       47       53
    ## 28      3553         0       65       47      166
    ## 29     10611         0       24       11       48
    ## 30     16436         0       61       29       59
    ## 31     19238         0        1        1        1
    ## 32     62925         0      177      205      560
    ## 33      5220         0       10       10       22
    ## 34      1609         0        2        3        3
    ## 35      1500         0        7        1        2
    ## 36     95530         0       40       37       39
    ## 37         1         0        0        0        0
    ## 38        78         0    26805       87    49065
    ## 39        18         0      309     3956      304
    ## 40        57         0     8909      118    38313

{% highlight r linenos %}
final_demand[1:40,1:10]
{% endhighlight %}

    ##           V1  V2        V3        V4        V5        V6        V7
    ## 1                Euro-zone Euro-zone Euro-zone Euro-zone Euro-zone
    ## 2                      c37       c38       c39       c41       c42
    ## 3  Euro-zone  c1    154716        67       946      9895      9935
    ## 4  Euro-zone  c2      2942         2       175      1011       -66
    ## 5  Euro-zone  c3    476590        49      1130      2382      9494
    ## 6  Euro-zone  c4     75919         2       193      1390      -957
    ## 7  Euro-zone  c5     20491         0        29       231     -1417
    ## 8  Euro-zone  c6     10910         2        66      7027      -513
    ## 9  Euro-zone  c7    102994        61       420      3733     -4665
    ## 10 Euro-zone  c8    177458       125      2160      1995     -1966
    ## 11 Euro-zone  c9    101580       264     63557      4043      1253
    ## 12 Euro-zone c10     30400         3       390      3270     -1082
    ## 13 Euro-zone c11     19986         2       205      2882      2417
    ## 14 Euro-zone c12     42145         6       770     68714     -2936
    ## 15 Euro-zone c13     62641        67      1374    150238      2183
    ## 16 Euro-zone c14     63389        56      7284     73782      8570
    ## 17 Euro-zone c15    209707       815      3101    117952      4767
    ## 18 Euro-zone c16     80787         3      3037     21423      1159
    ## 19 Euro-zone c17    219802        98      1948     14347       354
    ## 20 Euro-zone c18     55330         6      2066   1102223      2526
    ## 21 Euro-zone c19    201421        21      3759     20583       906
    ## 22 Euro-zone c20    387691       127     21982     86532      3623
    ## 23 Euro-zone c21    343128       115     17871     67209      4526
    ## 24 Euro-zone c22    580174       225      2383      2447        88
    ## 25 Euro-zone c23    157576        25     14565     15701       587
    ## 26 Euro-zone c24     13550         1       308       799        19
    ## 27 Euro-zone c25     41466         1       621       471        20
    ## 28 Euro-zone c26     83657        85     20120      4171       161
    ## 29 Euro-zone c27    176134        14       618      4323        41
    ## 30 Euro-zone c28    409763        26       670      3643         8
    ## 31 Euro-zone c29   1123474       226     30039     87027        13
    ## 32 Euro-zone c30    104652      5431     45624    240732      1674
    ## 33 Euro-zone c31     28051       557   1045312      7702        44
    ## 34 Euro-zone c32     85037     27616    542525       682        11
    ## 35 Euro-zone c33    266492     70993    877024       854        18
    ## 36 Euro-zone c34    338344     77350     85335     16422      1235
    ## 37 Euro-zone c35     56376         0         0         0         0
    ## 38  Other EU  c1      3145         2        16        85         0
    ## 39  Other EU  c2       388         0        15        35         0
    ## 40  Other EU  c3     29359        29       107        26         0
    ##          V8       V9      V10
    ## 1  Other EU Other EU Other EU
    ## 2       c37      c38      c39
    ## 3     10301        2      169
    ## 4        16        0        1
    ## 5     55168        8       39
    ## 6     11850        5       33
    ## 7      3853        0       11
    ## 8       136        0        2
    ## 9      4551        3      117
    ## 10    11752        2      201
    ## 11    21926        7     4474
    ## 12     2489        0       41
    ## 13      518        0        6
    ## 14     1760        1       46
    ## 15     8428        6       79
    ## 16    11865       31      312
    ## 17    36358        5       55
    ## 18     9355        2       24
    ## 19      874        5       36
    ## 20      562        2       19
    ## 21      127        2        4
    ## 22     2365        4       51
    ## 23      866        2       10
    ## 24     1682        2       14
    ## 25      555        1       61
    ## 26      180        0        4
    ## 27     5819        0       12
    ## 28     1190        1      216
    ## 29      848        1        7
    ## 30      663       16        6
    ## 31       33        0        1
    ## 32     1503      355      265
    ## 33      145        7       92
    ## 34       26        8        3
    ## 35       57       10      259
    ## 36     1467      154      432
    ## 37        0        0        0
    ## 38    58605       71     2065
    ## 39     4342        6       91
    ## 40   129956       24      195

{% highlight r linenos %}
# use the direct approach
# run the WWZ decomposition
wwz <- decomp(intermediate_demand, final_demand, method='wwz')
wwz[1:5,1:5]
{% endhighlight %}

    ##                        DVA_FIN DVA_INT DVA_INTrexI1 DVA_INTrexF
    ## Euro-zone.c1.Euro-zone     0.0     0.0         0.00        0.00
    ## Euro-zone.c1.Other EU   9198.6  4491.8       301.50      550.78
    ## Euro-zone.c1.NAFTA       755.9  1479.3        68.98       60.98
    ## Euro-zone.c1.China       265.0   990.6        86.75      140.39
    ## Euro-zone.c1.East Asia   238.9   451.1        16.29       14.22
    ##                        DVA_INTrexI2
    ## Euro-zone.c1.Euro-zone        0.000
    ## Euro-zone.c1.Other EU        25.076
    ## Euro-zone.c1.NAFTA            7.204
    ## Euro-zone.c1.China           12.077
    ## Euro-zone.c1.East Asia        2.459

{% highlight r linenos %}
# run the source decomposition
source  <- decomp(intermediate_demand, final_demand, method='source')
source[1:5,1:5]
{% endhighlight %}

    ##              Euro-zone.c1 Euro-zone.c2 Euro-zone.c3 Euro-zone.c4
    ## Euro-zone.c1    23803.980      14.3808      17353.8        512.2
    ## Euro-zone.c2      133.892    6585.1837        436.5        134.1
    ## Euro-zone.c3      948.942       8.7316      51581.5        180.7
    ## Euro-zone.c4       30.694       3.1747        114.9      29069.7
    ## Euro-zone.c5        6.998       0.7309         29.5        130.2
    ##              Euro-zone.c5
    ## Euro-zone.c1       273.09
    ## Euro-zone.c2        43.27
    ## Euro-zone.c3       452.59
    ## Euro-zone.c4       277.22
    ## Euro-zone.c5     10071.56


{% highlight r linenos %}
# or use the step-by-step approach
# create intermediate object (class decompr)
decompr_object <- load_tables(intermediate_demand, final_demand)
str(decompr_object)
{% endhighlight %}

    ## List of 31
    ##  $ Exp      : num [1:245, 1:245] 43807 0 0 0 0 ...
    ##  $ Vhat     : num [1:245, 1:245] 0.486 0 0 0 0 ...
    ##  $ A        : num [1:245, 1:245] 0.09225 0.00113 0.063638 0.000969 0.000224 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ B        : num [1:245, 1:245] 1.118216 0.005181 0.083961 0.002014 0.000473 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ Ad       : num [1:245, 1:245] 0.09225 0.00113 0.063638 0.000969 0.000224 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ Am       : num [1:245, 1:245] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ Bd       : num [1:245, 1:245] 1.118216 0.005181 0.083961 0.002014 0.000473 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ Bm       : num [1:245, 1:245] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ L        : num [1:245, 1:245] 1.117975 0.004996 0.083703 0.001922 0.000458 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ Vc       : Named num [1:245] 0.486 0.59 0.258 0.348 0.338 ...
    ##   ..- attr(*, "names")= chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ X        : Named num [1:245] 472596 91193 961881 197646 57757 ...
    ##   ..- attr(*, "names")= chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ Y        : num [1:245, 1:7] 175559 4064 489645 76547 19334 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:7] "Euro-zone" "Other EU" "NAFTA" "China" ...
    ##  $ Yd       : num [1:245, 1:7] 175559 4064 489645 76547 19334 ...
    ##  $ Ym       : num [1:245, 1:7] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:7] "Euro-zone" "Other EU" "NAFTA" "China" ...
    ##  $ E        : num [1:245, 1] 43807 10880 172263 71671 26222 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "3" "4" "5" "6" ...
    ##   .. ..$ : NULL
    ##   ..- attr(*, "names")= chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ ESR      : num [1:245, 1:7] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:7] "Euro-zone" "Other EU" "NAFTA" "China" ...
    ##  $ Eint     : num [1:245, 1:7] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:7] "Euro-zone" "Other EU" "NAFTA" "China" ...
    ##  $ Efd      : num [1:245, 1:7] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##   .. ..$ : chr [1:7] "Euro-zone" "Other EU" "NAFTA" "China" ...
    ##  $ G        : int 7
    ##  $ N        : num 35
    ##  $ GN       : num 245
    ##  $ bigrownam: chr [1:1960] "Euro-zone.c1.Euro-zone" "Euro-zone.c1.Other EU" "Euro-zone.c1.NAFTA" "Euro-zone.c1.China" ...
    ##  $ regnam   : chr [1:7] "Euro-zone" "Other EU" "NAFTA" "China" ...
    ##  $ rownam   : chr [1:245] "Euro-zone.c1" "Euro-zone.c2" "Euro-zone.c3" "Euro-zone.c4" ...
    ##  $ secnam   : chr [1:35] "c1" "c2" "c3" "c4" ...
    ##  $ tot      : chr [1:245] "sub" "sub" "sub" "sub" ...
    ##  $ z        : num [1:245, 1:280] 0 0 0 0 0 0 0 0 0 0 ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr [1:245] "3" "4" "5" "6" ...
    ##   .. ..$ : chr [1:280] "V3" "V4" "V5" "V6" ...
    ##  $ z01      : chr [1:1960, 1] "Euro-zone.c1" "Euro-zone.c1" "Euro-zone.c1" "Euro-zone.c1" ...
    ##  $ z02      : chr [1:1960] "Euro-zone" "Other EU" "NAFTA" "China" ...
    ##  $ z1       : chr [1:7, 1:245] "Euro-zone.c1" "Euro-zone.c1" "Euro-zone.c1" "Euro-zone.c1" ...
    ##  $ z2       : chr [1:8] "Euro-zone" "Other EU" "NAFTA" "China" ...
    ##  - attr(*, "class")= chr "decompr"

{% highlight r linenos %}
# run the WWZ decomposition on the decompr object
wwz <- wwz(decompr_object)
wwz[1:5,1:5]
{% endhighlight %}

    ##                        DVA_FIN DVA_INT DVA_INTrexI1 DVA_INTrexF
    ## Euro-zone.c1.Euro-zone     0.0     0.0         0.00        0.00
    ## Euro-zone.c1.Other EU   9198.6  4491.8       301.50      550.78
    ## Euro-zone.c1.NAFTA       755.9  1479.3        68.98       60.98
    ## Euro-zone.c1.China       265.0   990.6        86.75      140.39
    ## Euro-zone.c1.East Asia   238.9   451.1        16.29       14.22
    ##                        DVA_INTrexI2
    ## Euro-zone.c1.Euro-zone        0.000
    ## Euro-zone.c1.Other EU        25.076
    ## Euro-zone.c1.NAFTA            7.204
    ## Euro-zone.c1.China           12.077
    ## Euro-zone.c1.East Asia        2.459


{% highlight r linenos %}
# run the source decomposition on the decompr object
source  <- kung_fu(decompr_object)
source[1:5,1:5]
{% endhighlight %}

    ##              Euro-zone.c1 Euro-zone.c2 Euro-zone.c3 Euro-zone.c4
    ## Euro-zone.c1    23803.980      14.3808      17353.8        512.2
    ## Euro-zone.c2      133.892    6585.1837        436.5        134.1
    ## Euro-zone.c3      948.942       8.7316      51581.5        180.7
    ## Euro-zone.c4       30.694       3.1747        114.9      29069.7
    ## Euro-zone.c5        6.998       0.7309         29.5        130.2
    ##              Euro-zone.c5
    ## Euro-zone.c1       273.09
    ## Euro-zone.c2        43.27
    ## Euro-zone.c3       452.59
    ## Euro-zone.c4       277.22
    ## Euro-zone.c5     10071.56

Credit
------

This package is based on R code written by Fei Wang (not to be confused with the author of the algorithm, with the same last name), which implemented this algorithm.

References
----------

Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. “The World Input-Output Database (WIOD): Contents, Sources and Methods.” *WIOD Background Document Available at Www. Wiod. Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. “Quantifying International Production Sharing at the Bilateral and Sector Levels.”
