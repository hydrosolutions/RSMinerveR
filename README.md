# RSMinerveR
I/O for RSMinerve in R

RSMinerve is a hydrological modelling software freely available from [CREALP](https://www.crealp.ch/fr/accueil/outils-services/logiciels/rs-minerve/telechargement-rsm.html). RSMinerve can be scripted from within R by calling the Visual Basics interface. This package provides functions to simplify R-RSMinerve interaction.   
The Visual Basics interface is documented in the Technical Manual of RS Minerve. The Technical Manual can be viewed under "Help" from within RSMinerve or downloaded as PDF from CREALPs download site linked above. 


## Requirements 
RSMinerve runs on Windows OS only.

### Installation of RSMinerve
RSMinerve is freely available from [CREALP](https://www.crealp.ch/fr/accueil/outils-services/logiciels/rs-minerve/telechargement-rsm.html). The download site is in French but the software is available in English. On the CREALP site linked above, click on "Version actuelle" to download the latest version of RSMinerve. Follow the installation guide. RSMinerveR is written for RSMinerve 2.9.1.0. 

## Installation of R and R tools
RSMinerveR is written in R 4.1.0 in RStudio 1.4.1717. RTools40 needs to be downloaded and installed. The latest R and RTools can be downloaded for example from [https://stat.ethz.ch/CRAN/](https://stat.ethz.ch/CRAN/). The RStudio community version can be downloaded for free from  [rstudio.com](https://www.rstudio.com/products/rstudio/download/). 

### Installation of rClr
rClr is a package for low-level access from R to a Common Language Runtime (CLR). The supported CLR implementations are Microsoft '.NET' framework on Windows. Using rClr we can interact with the Visual Basics Interface implemented for RSMinerve. For this package we use the rClr implementation from [Open-Systems-Pharmacology] (https://github.com/Open-Systems-Pharmacology/rClr/releases) (v0.9.1). Download the latest release as zip to your working directory and install it with the following command. 
```{r}
install.packages("rClr_0.9.1.zip", repos = NULL, type = "source")
```

## Tutorials
Existing examples in Visual Basics provided by CREALP are being translated to R and made available as vignettes for this package. Many thanks to CREALP for providing these examples. 


## License Information

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This
work is licensed under a
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative
Commons Attribution-ShareAlike 4.0 International License</a>.
