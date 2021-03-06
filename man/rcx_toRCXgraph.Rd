% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ndex_RCXgraph.r
\name{rcx_toRCXgraph}
\alias{rcx_toRCXgraph}
\alias{RCXgraph}
\alias{rcxgraph_fromRCX}
\title{Create RCXgraph object from RCX object}
\usage{
rcx_toRCXgraph(
  rcx,
  idAsVertexName = FALSE,
  idAsEdgeName = FALSE,
  verbose = FALSE
)

rcxgraph_fromRCX(
  rcx,
  idAsVertexName = FALSE,
  idAsEdgeName = FALSE,
  verbose = FALSE
)
}
\arguments{
\item{rcx}{\code{\link{RCX}} object}

\item{idAsVertexName}{logical; whether the ndex node id ("@id") should be used as name for the igraph node (i.e. vertex). By default the "n"ame property is used}

\item{idAsEdgeName}{logical; whether the ndex edge id ("@id") should be used as name for the igraph edge. By default the "i"nteraction property is used}

\item{verbose}{logical; whether to print out extended feedback}
}
\value{
returns object of class RCXgraph if successfull, NULL otherwise
}
\description{
This function creates an RCXgraph object from a supplied \code{\link{RCX}} object.
RCX objects store the CX data as a named list of data.frames containing metaData and all aspects of the network.
The RCXgraph class inherits from igraph and contains the complete (R)CX information as graph, node and edge attributes.
All \code{\link[igraph]{igraph}} functionality is available, e.g. access nodes and edges of igraph g via V(g) and E(g) and their attributes via V(g)$attribute
}
\details{
The following rules apply to convert from \code{\link{RCX}} to RCXgraph:
\itemize{
 \item nodes receive their name from RCX$node$n. If idAsVertexName is TRUE, the "@id" value is used as name. All other information in aspects node and nodeAttributes are saved as \code{\link[igraph]{vertex_attr}}, access via V(g).
       Data goes from long format (column n containing attribute name and column v containing attribute value) to wide format (columns for each unique n with cells contianing v).
 \item edges are connected via their "s"ource and "t"arget fields. The "@id" and "i"nteraction attribute are stored as is and all edgeAttributes are saved as \code{\link[igraph]{edge_attr}}, access via E(g).
       Data goes from long format (column n containing attribute name and column v containing attribute value) to wide format (columns for each unique n with cells contianing v).
 \item all other aspect data is stored as graph attributes, access via g$<aspectName>
}
The following rules apply to convert RCXgraph back to \code{\link{RCX}}:
\itemize{
 \item Two vertex attributes "n" and "@id" have to be present in RCXgraph! Those two are mandatory \code{\link{RCX}} node properties!
 \item The igraph vertex name is ignored for the conversion! If the name is needed, adjust manually, e.g.: V(RCXgraph)$n <- V(RCXgraph)$name
 \item The edge attribute "@id" has to be present in RCXgraph! This is a mandatory \code{\link{RCX}} edge property!
}

An RCXgraph object could look like this:

\preformatted{
## Get some network...
> ndexcon = ndex_connect()
> rcx = ndex_get_network(ndexcon,"dd268e2f-fd4d-11e7-adc1-0ac135e8bacf")

> summary(rcxgraph)
IGRAPH f99ed1e DN-- 30 218 -- 
+ attr: metaData (g/x), numberVerification (g/x), ndexStatus (g/x), provenanceHistory (g/x), networkAttributes (g/x), cartesianLayout (g/x), cyVisualProperties
| (g/x), cyHiddenAttributes (g/x), status (g/x), name (v/c), @id (v/n), n (v/c), Basal (v/c), avg_PPR (v/c), LumA (v/c), LumB (v/c), ANOVA_FDR (v/c), ANOVA_p
| (v/c), Her2 (v/c), name (e/c), @id (e/n), i (e/c), NAME (e/c), strength (e/c), interaction (e/c)

## Attributes marked with "(g/x)" are graph attributes, "(v/x)" and "(e/x)" correspond to vertex and edge attributes respectively
## Accessing a graph attribute, e.g. "metaData"
rcxgraph$metaData
   consistencyGroup elementCount   lastUpdate               name properties version idCounter
1                 1            1 1.516391e+12         ndexStatus       NULL     1.0        NA
2                 1            1 1.516391e+12  provenanceHistory       NULL     1.0        NA
3                 1           30           NA              nodes       NULL     1.0       826
4                 1          218           NA              edges       NULL     1.0       827
5                 1           11           NA  networkAttributes       NULL     1.0        NA
6                 1          210           NA     nodeAttributes       NULL     1.0        NA
7                 1          654           NA     edgeAttributes       NULL     1.0        NA
8                 1           30           NA    cartesianLayout       NULL     1.0        NA
9                 1            3           NA cyVisualProperties       NULL     1.0        NA
10                1            1           NA cyHiddenAttributes       NULL     1.0        NA 


## The vertices:
> V(rcxgraph)[[]]
+ 30/30 vertices, named, from f99ed1e:
     name X.id      n            Basal          avg_PPR             LumA             LumB         ANOVA_FDR           ANOVA_p             Her2
1    ABL1  332   ABL1 2.10282304283E-4 0.00153239525422 2.40855043132E-4 0.00243281556888   0.0126090186692  5.20659657795E-4  0.0085750597325
2    JAK2  331   JAK2 0.00818834880039 0.00229451204468 0.00112294137386 5.02052428871E-4  2.16495388014E-4  5.05285465741E-6 0.00264438694116
3  NOTCH4  330 NOTCH4 0.00271376234049 0.00146318626692 9.53762145731E-4 0.00122487574678  2.16495388014E-4  4.79793511798E-6 0.00258535935846
4   KMT2C  329  KMT2C 0.00628341277798 0.00228045774193 0.00156001096343 0.00150488341005   0.0227077886547  9.78432545266E-4 9.99799190468E-4
5  NOTCH1  328 NOTCH1 0.00839759047274  0.0185377425722  0.0238783637494  0.0174878270867 5.65380895701E-13 4.06018596554E-15  0.0104288971099 
6 ...

## Display the igraph vertex names
> V(rcxgraph)$name
 [1] "ABL1"   "JAK2"   "NOTCH4" "KMT2C"  "NOTCH1" "INPPL1" "SPOP"   "AKT1"   "MYC"    "GATA3"  "MET"    "PTPRM"  "ACVR1B" "PTK2"   "PLCB1"
[16] "IBSP"   "ERBB2"  "PIK3CA" "EGFR"   "TLN1"   "MYCN"   "KRAS"   "CDH1"   "TP53"   "CCNE1"  "CCND1"  "CARD11" "STK11"  "MSH6"   "PER1"  

## The igraph vertex names equal to the ndex node names by default
> V(rcxgraph)$n
 [1] "ABL1"   "JAK2"   "NOTCH4" "KMT2C"  "NOTCH1" "INPPL1" "SPOP"   "AKT1"   "MYC"    "GATA3"  "MET"    "PTPRM"  "ACVR1B" "PTK2"   "PLCB1"
[16] "IBSP"   "ERBB2"  "PIK3CA" "EGFR"   "TLN1"   "MYCN"   "KRAS"   "CDH1"   "TP53"   "CCNE1"  "CCND1"  "CARD11" "STK11"  "MSH6"   "PER1"  

## If in \link{rcx_toRCXgraph} or \link{rcxgraph_fromRCX} \quote{idAsVertexName} is set, the igraph vertex names equal to the ndex node IDs ("@id")
## Note: "@id" is displayed in the vertex summary as "X.id", but can be accessed using "@id"
> V(rcxgraph)$'@id'
[1] 332 331 330 329 328 327 326 325 324 323 322 321 320 319 318 317 316 315 314 313 312 311 310 309 308 307 306 305 304 303


## The edges:
> E(rcxgraph)[[]] 
+ 218/218 edges from f99ed1e (vertex names):
      tail   head tid hid           name X.id              i                           NAME          strength    interaction
1     ABL1   EGFR   1  19 interacts with  550 interacts with     ABL1 (interacts with) EGFR   2.6501871987E-8 interacts with
2     ABL1  GATA3   1  10 interacts with  549 interacts with    ABL1 (interacts with) GATA3  0.00179423650681 interacts with
3     ABL1 INPPL1   1   6 interacts with  548 interacts with   ABL1 (interacts with) INPPL1  0.00531125201389 interacts with
4     ABL1   JAK2   1   2 interacts with  547 interacts with     ABL1 (interacts with) JAK2  0.00668830637406 interacts with
5     ABL1    MET   1  11 interacts with  546 interacts with      ABL1 (interacts with) MET  2.37014815511E-5 interacts with
6 ...

## Display the igraph edge names
> E(rcxgraph)$name
[1] "interacts with" "interacts with" "interacts with" "interacts with" "interacts with" "interacts with" "interacts with"
[8] ...

## The igraph edge names equal to the ndex edge "i"nteraction by default
> E(rcxgraph)$i
[1] "interacts with" "interacts with" "interacts with" "interacts with" "interacts with" "interacts with" "interacts with" 
[8] ...

## If in \link{rcx_toRCXgraph} or \link{rcxgraph_fromRCX} \quote{idAsEdgeName} is set, the igraph edge names equal to the ndex edge IDs ("@id")
## Note: "@id" is displayed in the edge summary as "X.id", but can be accessed using "@id"
> E(rcxgraph)$'@id'
 [1] 550 549 548 547 546 545 544 543 542 541 540 539 538 537 536 535 534 533 532 531 530 529 528 527 526 525 524 523 522 
[30] ...
}
}
\examples{
## Create an RCX object
rcx = rcx_new(c('@id'=1, n='Some Name', r='HGNC:Symbol'))

## Convert to RCXgraph
rcxgraph = rcxgraph_fromRCX(rcx)
## or
rcxgraph = rcx_toRCXgraph(rcx)

## Convert RCXgraph back to RCX
rcx = rcx_fromRCXgraph(rcxgraph)
## or 
rcx = rcxgraph_toRCX(rcxgraph)
}
\seealso{
\code{\link{rcxgraph_toRCX}} \code{\link{rcx_fromRCXgraph}} \code{\link{rcx_fromJSON}} \code{\link{rcx_toJSON}} \code{\link{RCX}} \code{\link[igraph]{igraph}}
}
