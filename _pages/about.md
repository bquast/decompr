---
layout: page
title: About decompr
tags: [about, decompr, GVC]
permalink: /about/
modified: 2015-01-04
image:
  feature: shipping-train.jpg
---

This page describes the R package decompr. The package enables researchers working on Global Value Chains (GVCs) to derive different GVC indicators at a bilateral and sectoral level (e.g. Vertical Specialization, i.e. foreign value added in exports).

In detail, the package applies two decomposition algorithms to Inter-Country Input-Output tables (ICIOs) such as the ones provided by WIOD (http://www.wiod.org/new_site/home.htm) or TiVA (http://oe.cd/tiva).
Firstly, the **Wang-Wei-Zhu** (Wang, Wei, and Zhu 2013) algorithm splits bilateral gross exports into 16 value added components depending on where they are finally consumed along three dimensions (source country, using industry, using country).
The algorithm is theoretically derived and explained in Wang, Wei, and Zhu (2013).
The main components are domestic value added in gross exports (DViX), foreign value added in gross exports (FVAX), and double counting terms that are misleading in official trade statistics.

Secondly, the **Leontief decomposition** algorithm derives the value added origin of an industry's exports by source country and source industry.
Therefore, it covers all four dimensions but at a lesser detail than the Wang-Wei-Zhu algorithm. It applies the basic Leontief insight to gross trade data.
A theoretical derivation can also be found in Wang, Wei, and Zhu (2013).

## CRAN
The **decompr** package is hosted on the [Comprehensive R Archive Network (CRAN)](http://cran.r-project.org/). There is a dedicated CRAN decompr page which can be accessed here:

[http://cran.r-project.org/web/packages/decompr/index.html](http://cran.r-project.org/web/packages/decompr/index.html)

# Authors
Bastiaan Quast (bastiaan.quast@graduateinstitute.ch)

Victor Kummritz (victor.kummritz@graduateinstitute.ch)

# References
Timmer, Marcel, A. A. Erumban, R. Gouma, B. Los, U. Temurshoev, G. J. de Vries, and I. Arto. 2012. "The World Input-Output Database (WIOD): Contents, Sources and Methods." *WIOD Background Document Available at www.Wiod.Org*.

Wang, Zhi, Shang-Jin Wei, and Kunfu Zhu. 2014. "Quantifying International Production Sharing at the Bilateral and Sector Levels."
