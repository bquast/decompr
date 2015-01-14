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

\begin{table}[htbp] \scriptsize
    \begin{adjustwidth}{-1.15in}{-1.15in}  
  \centering
  \caption{Leontief Decomposition}
    \begin{tabular}{lccccccccc}
    \toprule
          & Argentina. & Argentina. & Argentina. & Turkey. & Turkey. & Turkey. & Germany. & Germany. & Germany.\\
          & Agriculture & Textile.and. & Transport. & Agriculture & Textile.and. & Transport. & Agriculture & Textile.and. & Transport.\\
          & & Leather & Equipment & & Leather & Equipment & & Leather & Equipment\\
    \midrule
    Argentina.Agriculture & 28.52 & 2.79  & 0.36  & 1.81  & 3.12  & 0.36  & 1.24  & 1.30  & 4.12 \\
    Argentina.Textile.and.Leather & 1.06  & 19.12 & 0.42  & 0.48  & 1.83  & 0.43  & 0.59  & 1.15  & 4.75 \\
    Argentina.Transport.Equipment & 0.21  & 0.14  & 1.06  & 0.03  & 0.08  & 0.04  & 0.02  & 0.07  & 0.19 \\
    Turkey.Agriculture & 0.72  & 1.34  & 0.12  & 34.93 & 7.00  & 1.48  & 2.55  & 1.52  & 6.18 \\
    Turkey.Textile.and.Leather & 0.41  & 1.39  & 0.12  & 2.69  & 40.17 & 1.32  & 1.11  & 1.15  & 9.51 \\
    Turkey.Transport.Equipment & 0.03  & 0.09  & 0.03  & 0.81  & 0.91  & 3.16  & 0.12  & 0.07  & 0.65 \\
    Germany.Agriculture & 0.93  & 2.25  & 0.16  & 2.31  & 2.06  & 0.51  & 29.88 & 5.25  & 9.60 \\
    Germany.Textile.and.Leather & 0.65  & 0.73  & 0.08  & 1.54  & 2.55  & 0.63  & 1.46  & 18.96 & 8.16 \\
    Germany.Transport.Equipment & 0.67  & 0.65  & 0.26  & 1.29  & 1.49  & 0.57  & 1.73  & 1.51  & 34.74 \\
    \bottomrule
    \end{tabular}
  \label{tab:leon}
      \end{adjustwidth}
\end{table}

\begin{table}[htbp]\scriptsize
    \begin{adjustwidth}{-1.15in}{-1.15in} 
  \centering
  \caption{Non-decomposed Values}
    \begin{tabular}{lccccccccc}
    \toprule
         & Argentina. & Argentina. & Argentina. & Turkey. & Turkey. & Turkey. & Germany. & Germany. & Germany.\\
          & Agriculture & Textile.and. & Transport. & Agriculture & Textile.and. & Transport. & Agriculture & Textile.and. & Transport.\\
          & & Leather & Equipment & & Leather & Equipment & & Leather & Equipment\\
    \midrule
    Argentina.Agriculture & 6.88  & 2.49  & 0.25  & 1.30  & 2.04  & 0.08  & 0.77  & 0.68  & 1.76 \\
    Argentina.Textile.and.Leather & 1.03  & 3.91  & 0.44  & 0.04  & 1.52  & 0.31  & 0.30  & 0.95  & 4.13 \\
    Argentina.Transport.Equipment & 0.38  & 0.24  & 0.55  & 0.00  & 0.05  & 0.06  & 0.00  & 0.10  & 0.18 \\
    Turkey.Agriculture & 0.47  & 0.93  & 0.03  & 7.33  & 6.27  & 1.20  & 2.23  & 0.75  & 3.19 \\
    Turkey.Textile.and.Leather & 0.13  & 1.37  & 0.01  & 2.48  & 13.35 & 1.24  & 0.52  & 0.61  & 9.19 \\
    Turkey.Transport.Equipment & 0.00  & 0.05  & 0.04  & 1.67  & 1.52  & 1.75  & 0.05  & 0.00  & 0.65 \\
    Germany.Agriculture & 0.51  & 2.05  & 0.04  & 1.67  & 0.57  & 0.12  & 7.18  & 4.73  & 6.43 \\
    Germany.Textile.and.Leather & 0.56  & 0.54  & 0.00  & 1.30  & 2.28  & 0.51  & 1.26  & 7.06  & 8.65 \\
    Germany.Transport.Equipment & 0.90  & 0.68  & 0.41  & 1.67  & 1.47  & 0.77  & 2.80  & 1.96  & 18.42 \\
    \bottomrule
    \end{tabular}
  \label{tab:noleon}
        \end{adjustwidth}
\end{table}
