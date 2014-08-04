decompr
=======

Bastiaan Quast, <bquast@gmail.com>
----------------------------------
An R package that implements Export Decomposition using the Wang-Wei-Zhu (Wang, Wei, and Zhu 2013) and Kung-Fu (Mehrotra, Kung, and Grosky 1990) algorithms. 

Inputs
--------------------------------------
The package uses Inter-Country Input-Output (ICIO) tables, such as World Input Outpt Database (Timmer et al. 2012).

The **x** argument is intermediate demand table, where the first row and the first column list the country names, the second row and second column list the insdustry names for each country. The matrix is presumed to be of dimensions **GxN** where **G** represents the country and **N** the industry. No extra columns should be there. Extra rows at the bottom which list adjustments such as taxes as well are disregarded, with the exception that the very last row is presumed to contain the total output.

The **y** argument is the final demand table it has dimensions **GNxGM** ( where **M** is the number of objects final demand is decomposed in, e.g. household consumption, here this is five decompositions).

Output
--------------------------------------
The output when using the WWZ algorithm is a matrix with dimensions **GNGx19**. Whereby **19** is the **16** objects the WWZ algorithm decomposes exports into, plus three checksums. **GNG** represents source country, using industry and using country.

Installation
--------------------------------------
**WARNING**, decompr is in an extremely early stage of development. The API will still change.


```r
# install.packages("devtools")
devtools::install_github("bquast/decompr")
```

```
## Installing github repo decompr/master from bquast
## Downloading master.zip from https://github.com/bquast/decompr/archive/master.zip
## Installing package from /tmp/RtmpQV7Eon/master.zip
## arguments 'minimized' and 'invisible' are for Windows only
## Installing decompr
## '/usr/lib/R/bin/R' --vanilla CMD INSTALL  \
##   '/tmp/RtmpQV7Eon/devtoolsdbc9385f39/decompr-master'  \
##   --library='/home/bquast/R/x86_64-pc-linux-gnu-library/3.1'  \
##   --install-tests
```

Usage
--------------------------------------

```r
# load the package
library(decompr)

# load World Input-Output Database for 2011
data(wiod)

# explore the data
dim(intermediate.demand) # (2 + GN + totals) x (2 + GN)
```

```
## [1] 1445 1437
```

```r
dim(final.demand)        # (2 + GN + totals) x (2 + G*5)
```

```
## [1] 1445  207
```

```r
intermediate.demand[1:40,1:40]
```

```
##     V1  V2   V3    V4    V5  V6  V7   V8   V9   V10  V11  V12  V13   V14
## 1           AUS   AUS   AUS AUS AUS  AUS  AUS   AUS  AUS  AUS  AUS   AUS
## 2            c1    c2    c3  c4  c5   c6   c7    c8   c9  c10  c11   c12
## 3  AUS  c1 8732    93 21337 755 217 1309  397     0  303  133    0    11
## 4  AUS  c2   88 24512   719  52  15   61  252 11177  848  102 3125 16913
## 5  AUS  c3 1472   149  6559  70  20   15   55    17  843   59   18    64
## 6  AUS  c4   54    64   110 379 109   19   55     6   49   48   13    70
## 7  AUS  c5   14    16    28  98  28    5   14     2   13   12    3    18
## 8  AUS  c6   56    76    34   8   2  994   33     6   21   21   15   137
## 9  AUS  c7  163   232  1214  52  15   89 2860    12  365  143   93   176
## 10 AUS  c8  685  1582   155   9   3   35   81   311  253   43   83   293
## 11 AUS  c9 1615   669   261  65  19  149  476   166 2183  974  160   361
## 12 AUS c10  117   295   733  35  10   37  321    20  363  275   28   121
## 13 AUS c11   55   160   256   5   2   40   31     4  106   39 1538   370
## 14 AUS c12  389  2803  1039  59  17  409  257    25  492  287  413 15931
## 15 AUS c13  234   925   119  10   3   22   48    18   52   29   28   141
## 16 AUS c14  139   550    71   6   2   13   29    11   31   17   17    83
## 17 AUS c15  135   457    66   8   2    8   22     8   26   12   19    56
## 18 AUS c16   74   300   128  26   7  110   37     9   65   30   17   170
## 19 AUS c17 1071  2988   964  96  28  158  407    83  401  212  314  2076
## 20 AUS c18 1038  7637   437  35  10  126  184   655  199  111   63   422
## 21 AUS c19 1791  3715  1126 180  52  257  844    61  449  266  207   478
## 22 AUS c20 2220  2299  4460 476 137  317 1199   422 1543  640  385  1911
## 23 AUS c21 2282  2442  3852 417 120  332 1075   439 1530  640  382  2022
## 24 AUS c22  194   322   534  27   8   23  169    58  166   33   46   186
## 25 AUS c23  780  5936  2293 147  42  261  645   127  638  392  828  1589
## 26 AUS c24   17   341    38   6   2    5   21    11   17    7   10    62
## 27 AUS c25   16    51    18   3   1    3   19     2   11    3    3    18
## 28 AUS c26  512  1415  1428  57  16  393  797    73  772   89  156   850
## 29 AUS c27  319   666   354  36  10   75  337    71  146   74  121   279
## 30 AUS c28 2025  7431  1039  66  19  121  498    64  325  135  151   507
## 31 AUS c29  837  3009   844  36  10  320  602   124  108   56   44  2837
## 32 AUS c30 2054 10299  3687 461 133  683 3557   961 3304 1738 1094  3254
## 33 AUS c31   55   449   152   3   1   16  205    20  184   19   18   110
## 34 AUS c32   23   195   148  34  10   13   59    32   61   23   32    93
## 35 AUS c33   82     3    86  17   5   13   52     1  139    1    1     3
## 36 AUS c34   72   220   197   6   2   24  145     8   96   23   18    29
## 37 AUS c35    0     0     0   0   0    0    0     0    0    0    0     0
## 38 AUT  c1    0     0     0   0   0    0    0     0    0    0    0     0
## 39 AUT  c2    0     0     0   0   0    0    0     0    0    0    0     0
## 40 AUT  c3    0     0     1   0   0    0    0     0    0    0    0     0
##     V15  V16  V17  V18  V19   V20  V21   V22  V23  V24  V25 V26  V27  V28
## 1   AUS  AUS  AUS  AUS  AUS   AUS  AUS   AUS  AUS  AUS  AUS AUS  AUS  AUS
## 2   c13  c14  c15  c16  c17   c18  c19   c20  c21  c22  c23 c24  c25  c26
## 3     5    2    0   85    6   203   13  1806  100 1573   44   0    0   32
## 4  1094  507  981  722 8233  4601   88   409 4757  540   85   4    7   73
## 5    29   13   69   27   33   325  119  4721  186 6323   46   2   20   34
## 6    24   11   57  104   13   299   92   121   59  130   44   1   12   22
## 7     6    3   15   27    3    77   24    31   15   34   11   0    3    6
## 8    21   10  116 1257   23  6280   26   325  127   26   63   1    5  115
## 9   108   50  110   86   63  1272  171  2996 1032  640  148   6   39   87
## 10   33   15   59   20  292  1409  369   428  317  254  910  20 1863  283
## 11  140   65  299  202  266  2325  257   222  194  195   79   2   25   71
## 12  154   71  322  226  105  1908  158   212  208  185  285   2   55  102
## 13   90   42  271  105  179 10984  259    98  156   70   35   0    7   13
## 14 2933 1361 2991 1875  476 17234  874   702  453  317  912  31   63  244
## 15  374  174  375   25  135  1359 1240   101  111  138  103   2   23   40
## 16  222  103  223   15   80   807  736    60   66   82   61   1   13   24
## 17   92   43 4173   92   17   676 4034   461  197   70 2278  58  793  398
## 18   45   21   97  174   27  1457  149   187  109  126   61   1   11   35
## 19  266  123  332   90 3836  2571 1164  1129  474 1199 1025  23   39 1147
## 20  130   60  239   45 2378 82047  955  1276 1657 1611 1855   8   62  955
## 21  171   80  370  269  865  4418  508  5012 2092  535 5717 243  261 1881
## 22  867  402 2084  588  447  5914 3014  4461 1406 2496 1143  14  475  478
## 23  863  400 2028  564  495  6190 3036  2361 1171 1931 1241  17  747  516
## 24   58   27  110   41   78   197  106   429  394   85  155   3   37  209
## 25  377  175  610  231  217  3108  802   868 2668  476 4120   9  123 1148
## 26   11    5   12    7   16    25   13    28   73   10    8 330    2  102
## 27   10    4   10    3   12    46    8    76  107   18   11   0  128   33
## 28   80   37  349   73   49  3349  332   872 7066  408  623 785  768 3919
## 29  223  104  166  112  312  2676 1072  3570 1898  773  825  16   99 1228
## 30  212   99  333  133 1831 15563 2050  4123 2783 1400 1098  79  187  957
## 31  129   60 1406   63  470 11586 2298  5652 6722 2397 2373   7  511 3050
## 32 2032  942 2834  804 2717 26715 5800 20769 8478 4235 4581 231  938 7616
## 33   20    9   98   12   51  1051  229   364  148   47  728   2    4  690
## 34   52   24   59   10  134   107  197    95   32  102   84   3   18  228
## 35    2    1   41    1    4     9   43    31   15   13    6   1    0  101
## 36   30   14  172   34   85   835   90  1598  259 1309  101  11   29   64
## 37    0    0    0    0    0     0    0     0    0    0    0   0    0    0
## 38    0    0    0    0    0     0    0     0    0    0    0   0    0    0
## 39    0    0    0    0    0     0    0     0    0    0    0   0    0    0
## 40    0    0    0    0    0     0    0     0    0    1    0   0    0    0
##     V29   V30   V31   V32   V33  V34  V35  V36 V37  V38 V39  V40
## 1   AUS   AUS   AUS   AUS   AUS  AUS  AUS  AUS AUS  AUT AUT  AUT
## 2   c27   c28   c29   c30   c31  c32  c33  c34 c35   c1  c2   c3
## 3     6     8    70   325   119    9   36 1103   0    0   0    1
## 4   228    15   393   380   288  127  317  339   0    0   0    0
## 5    94    54    65   448   213  192  262  646   0    0   0    0
## 6    49     4    24   108   122   51  196  132   0    0   0    0
## 7    13     1     6    28    31   13   51   34   0    0   0    0
## 8    61     1   157    31   123  186   24  102   0    0   0    0
## 9   885   176   318  2948  1342 1504  403 1126   0    0   0    0
## 10  270     7    83   779   254   21  221  237   0    0   0    0
## 11   85    58   197   690   201  100  910  863   0    0   0    0
## 12  459     6   106   160   417   85  124  170   0    0   0    0
## 13   28     5   180    64    90   29   99  133   0    0   0    0
## 14  637    17   723   486  1157  425  269  798   0    0   0    0
## 15  249     7    58   355   199  101   87  194   0    0   0    0
## 16  148     4    34   211   118   60   52  115   0    0   0    0
## 17  243     5    41   161  1288   76   45  122   0    0   0    0
## 18   77     4    64   139   177  211   77  125   0    0   0    0
## 19  690   224  1430  4359   808 1373  711  976   0    0   0    0
## 20 2089   312  4690  2153  5959  122  293  385   0    0   0    0
## 21 2413  1512  4702  5175   900  680  994 1413   0    0   0    0
## 22 1215   191   593  2346  1194 1025 1757 1668   0    0   0    0
## 23 1227   132   451  2543  1239 1078 1776 1628   0    0   0    0
## 24  327   279    28  2682   470  202  113  483   0    0   0    1
## 25 1206   154   313  2056   977  640  713  842   0    1   2    9
## 26   52    17    38   128    53   10   22   34   0    0   0    0
## 27   48    37    57   355   114   33   14   57   0    0   0    2
## 28  474   113   787  4109  2172  298  229  312   0    0   0    1
## 29  957  2098  1191  5301  2374 1174 1238 2632   0    0   0    0
## 30  999 43990 11131  8844  5126 1514 2132 2451   0    0   0    0
## 31 3365  2279 29244 14160  1056  485  768 3669   0    0   0    0
## 32 2195 11577 16172 60649 10686 2320 5530 9917   0    0   0    1
## 33  348   200   147  1976  3227  460  236  247   0    0   0    0
## 34   46   626   214  2187   377  947  160  469   0    0   0    0
## 35   81    34    14    82   164   74  682  144   0    0   0    0
## 36  149   335  1218  6152   502  550 1414 6188   0    0   0    0
## 37    0     0     0     0     0    0    0    0   0    0   0    0
## 38    0     0     0     0     0    0    0    0   0 2885   1 3538
## 39    0     0     0     0     0    0    0    0   0   13  59   27
## 40    0     0     0     0     0    0    0    0   0  493   3 2342
```

```r
final.demand[1:40,1:10]
```

```
##     V1  V2     V3  V4    V5     V6    V7   V8  V9 V10
## 1             AUS AUS   AUS    AUS   AUS  AUT AUT AUT
## 2             c37 c38   c39    c41   c42  c37 c38 c39
## 3  AUS  c1  16969   0   428   5053  1616    1   0   0
## 4  AUS  c2   6658   0   397   9594  -516    0   0   0
## 5  AUS  c3  40589   0    85    569   432    7   0   0
## 6  AUS  c4   2712   0    15    575   -77    5   0   0
## 7  AUS  c5    699   0     4    148   -20    1   0   0
## 8  AUS  c6    444   0    10    223  -174    0   0   0
## 9  AUS  c7   9017   0    36   1797   459    0   0   0
## 10 AUS  c8   7093   0    32    332   673    0   0   0
## 11 AUS  c9   5555   0  1335    719   623    1   0   0
## 12 AUS c10   2304   0    30   1039   113    0   0   0
## 13 AUS c11   1827   0     9    183 -1115    0   0   0
## 14 AUS c12   5095   0    59   4324  -185    0   0   0
## 15 AUS c13   3236   0    21   3859   840    1   0   0
## 16 AUS c14   1921   0    13   2291   499    1   0   0
## 17 AUS c15  10400   0    16   4833   350    1   0   0
## 18 AUS c16   5604   0    30   3554  -211    1   0   0
## 19 AUS c17  20545   0  1415   2949     5    0   0   0
## 20 AUS c18   4070   0  3216 217502    26    0   0   0
## 21 AUS c19  25130   0    79   1378    54    0   0   0
## 22 AUS c20  61731   0  1002  18143   722    1   0   0
## 23 AUS c21  38985   0  1057  18292   962    1   0   0
## 24 AUS c22  44093   0    24    334    13   11   0   0
## 25 AUS c23  16530   0  1845   4510   172   25   0   3
## 26 AUS c24    537   0    15     88     3    2   0   0
## 27 AUS c25   6793   0    78    149     3   32   0   0
## 28 AUS c26   3431   0  7647    285     2    7   0   0
## 29 AUS c27  17704   0   115   2311     0    0   0   0
## 30 AUS c28  66098   0   101   1181     1    3   0   0
## 31 AUS c29 116122   0   235  22384     0    2   0   0
## 32 AUS c30   9228   0  8241  27955     0    1   0   1
## 33 AUS c31   1858   0 87507   1283     0    0   0   0
## 34 AUS c32  25016   0 40203    217     0    0   0   0
## 35 AUS c33  41106   0 80901     63     0    0   0   0
## 36 AUS c34  48400   0 18470    997     0    1   0   0
## 37 AUS c35      0   0     0      0     0    0   0   0
## 38 AUT  c1      3   0     0      0     0 3372   0 140
## 39 AUT  c2      0   0     0      0     0  210   0   8
## 40 AUT  c3     59   0     0      0     0 8338   0  24
```

```r
# use the direct approach
# run the WWZ decomposition
wwz <- decomp(intermediate.demand, final.demand, method='wwz')
wwz[1:5,1:5]
```

```
##              DVA_FIN    DVA_INT DVA_INTrexI1 DVA_INTrexF DVA_INTrexI2
## AUS.c1.AUS 0.0000000  0.0000000    0.0000000   0.0000000   0.00000000
## AUS.c1.AUT 0.9111762  0.4625102    0.0688806   0.3571779   0.01550494
## AUS.c1.BEL 7.2894098 28.9449226   18.6913782  67.9672390   5.61451475
## AUS.c1.BGR 0.0000000  0.0000000    0.0000000   0.0000000   0.00000000
## AUS.c1.BRA 0.0000000  1.3342108    0.2012988   0.2497688   0.03264660
```

```r
# run the Kung Fu decomposition
kf  <- decomp(intermediate.demand, final.demand, method='kung.fu')
kf[1:5,1:5]
```

```
##             AUS.c1       AUS.c2     AUS.c3     AUS.c4     AUS.c5
## AUS.c1 9008.838928 2.073470e+02 3403.21235 106.006923  28.764122
## AUS.c2  176.309989 1.167310e+05  378.83615  23.238096   6.361119
## AUS.c3  113.768875 1.156293e+02 6157.58321   8.113164   2.197657
## AUS.c4    7.173890 3.905584e+01   17.93670 596.007379   8.606622
## AUS.c5    1.562337 8.343463e+00    3.85944   6.893088 117.474862
```

```r
# or use the step-by-step approach
# create intermediate object (class decompr)
decompr.object <- load.tables(intermediate.demand, final.demand)
str(decompr.object)
```

```
## List of 31
##  $ Exp      : num [1:1435, 1:1435] 13898 0 0 0 0 ...
##  $ Vhat     : num [1:1435, 1:1435] 0.57 0 0 0 0 ...
##  $ A        : num [1:1435, 1:1435] 0.113648 0.001145 0.019158 0.000703 0.000182 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ B        : num [1:1435, 1:1435] 1.138132 0.02047 0.027332 0.001277 0.000331 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ Ad       : num [1:1435, 1:1435] 0.113648 0.001145 0.019158 0.000703 0.000182 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ Am       : num [1:1435, 1:1435] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ Bd       : num [1:1435, 1:1435] 1.138132 0.02047 0.027332 0.001277 0.000331 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ Bm       : num [1:1435, 1:1435] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ L        : num [1:1435, 1:1435] 1.1381 0.01976 0.02731 0.00128 0.00033 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ Vc       : Named num [1:1435] 0.57 0.62 0.299 0.404 0.34 ...
##   ..- attr(*, "names")= chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ X        : Named num [1:1435] 76834 266955 83717 7320 1888 ...
##   ..- attr(*, "names")= chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ Y        : num [1:1435, 1:41] 24066 16133 41675 3225 831 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:41] "AUS" "AUT" "BEL" "BGR" ...
##  $ Yd       : num [1:1435, 1:41] 24066 16133 41675 3225 831 ...
##  $ Ym       : num [1:1435, 1:41] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:41] "AUS" "AUT" "BEL" "BGR" ...
##  $ E        : num [1:1435, 1] 13898 168721 18736 1396 340 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "3" "4" "5" "6" ...
##   .. ..$ : NULL
##   ..- attr(*, "names")= chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ ESR      : num [1:1435, 1:41] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:41] "AUS" "AUT" "BEL" "BGR" ...
##  $ Eint     : num [1:1435, 1:41] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:41] "AUS" "AUT" "BEL" "BGR" ...
##  $ Efd      : num [1:1435, 1:41] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##   .. ..$ : chr [1:41] "AUS" "AUT" "BEL" "BGR" ...
##  $ G        : int 41
##  $ N        : num 35
##  $ GN       : num 1435
##  $ bigrownam: chr [1:60270] "AUS.c1.AUS" "AUS.c1.AUT" "AUS.c1.BEL" "AUS.c1.BGR" ...
##  $ regnam   : chr [1:41] "AUS" "AUT" "BEL" "BGR" ...
##  $ rownam   : chr [1:1435] "AUS.c1" "AUS.c2" "AUS.c3" "AUS.c4" ...
##  $ secnam   : chr [1:35] "c1" "c2" "c3" "c4" ...
##  $ tot      : chr [1:1435] "sub" "sub" "sub" "sub" ...
##  $ z        : num [1:1435, 1:1640] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:1435] "3" "4" "5" "6" ...
##   .. ..$ : chr [1:1640] "V3" "V4" "V5" "V6" ...
##  $ z01      : chr [1:60270, 1] "AUS.c1" "AUS.c1" "AUS.c1" "AUS.c1" ...
##  $ z02      : chr [1:60270] "AUS" "AUT" "BEL" "BGR" ...
##  $ z1       : chr [1:41, 1:1435] "AUS.c1" "AUS.c1" "AUS.c1" "AUS.c1" ...
##  $ z2       : chr [1:42] "AUS" "AUT" "BEL" "BGR" ...
##  - attr(*, "class")= chr "decompr"
```

```r
# run the WWZ decomposition on the decompr object
wwz <- wwz(decompr.object)
wwz[1:5,1:5]
```

```
##              DVA_FIN    DVA_INT DVA_INTrexI1 DVA_INTrexF DVA_INTrexI2
## AUS.c1.AUS 0.0000000  0.0000000    0.0000000   0.0000000   0.00000000
## AUS.c1.AUT 0.9111762  0.4625102    0.0688806   0.3571779   0.01550494
## AUS.c1.BEL 7.2894098 28.9449226   18.6913782  67.9672390   5.61451475
## AUS.c1.BGR 0.0000000  0.0000000    0.0000000   0.0000000   0.00000000
## AUS.c1.BRA 0.0000000  1.3342108    0.2012988   0.2497688   0.03264660
```

```r
# run the Kung Fu decomposition on the decompr object
kf  <- kung.fu(decompr.object)
kf[1:5,1:5]
```

```
##             AUS.c1       AUS.c2     AUS.c3     AUS.c4     AUS.c5
## AUS.c1 9008.838928 2.073470e+02 3403.21235 106.006923  28.764122
## AUS.c2  176.309989 1.167310e+05  378.83615  23.238096   6.361119
## AUS.c3  113.768875 1.156293e+02 6157.58321   8.113164   2.197657
## AUS.c4    7.173890 3.905584e+01   17.93670 596.007379   8.606622
## AUS.c5    1.562337 8.343463e+00    3.85944   6.893088 117.474862
```

TODO
--------------------------------------
The most import TODO items (in order of importance) are:

- [x] Remove use of windows-only **clipboard** function
- [x] Remove use of multi-year functionality (this should be user implemented)
- [x] Remove hard-coded dimensions
- [x] change inputs and outputs to R objects in stead of files
- [x] implement as a function for reading the matrices and a function for decomposing
- [x] minimalise inputs by computing final demand (and others?)
- [x] provide documentation and examples
- [ ] add checks on data (intermediate demand sums)
- [ ] implement S4 class objects
- [x] replace use of **attach()**
- [ ] review linear algebra for efficiency

Credit
--------------------------------------
This package is based on R code written by Fei Wang (not to be confused with the author of the algorithm, with the same last name), which implemented this algorithm.


References
--------------------------------------
Mehrotra, Rajiv, Fu K. Kung, and William I. Grosky. 1990. "Industrial Part Recognition Using a Component-Index." *Image and Vision Computing* 8 (3): 225-232.

Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. "The World Input-Output Database (WIOD): Contents, Sources and Methods." *WIOD Background Document Available at Www. Wiod. Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2013. "Quantifying International Production Sharing at the Bilateral and Sector Levels."