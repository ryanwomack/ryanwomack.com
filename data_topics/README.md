## **Data Publication 2**

This workshop first reviews repositories for data publication such as Dataverse, ICPSR, OSF, Zenodo, and more. Then we turn to a detailed discussion of building R packages.

### Why Data Publication?

Sharing data is a way to maximize the impact and usefulness of your research, and is increasingly mandated by research funders.

### General Principles

Data should be shared in a manner that is [FAIR](https://www.go-fair.org/fair-principles/), enabling the data to be:

- Findable, 
- Accessible,
- Interoperable, and
- Reusable

We should also [CARE](https://www.gida-global.org/care) for our data, respecting indigenous data governance, and managing our data according to the following principles:

- Collective Benefit
- Authority to Control
- Responsibility
- Ethics

The NIH is the most recent major US funding agency to promulgate data sharing guidelines and requirements, so their materials are as good a place as any to get more information...

[NIH on Sharing Scientific Data](https://sharing.nih.gov/data-management-and-sharing-policy/sharing-scientific-data/repositories-for-sharing-scientific-data)

### Data Repositories

NIH lists several
[Generalist Repositories](https://sharing.nih.gov/data-management-and-sharing-policy/sharing-scientific-data/generalist-repositories)
which are all good places to deposit data when more specialized repositories are not available.

- [_Dataverse_](https://dataverse.org/)
- [Dryad](https://datadryad.org/)
- [Figshare](https://figshare.com/)
- [IEEE Dataport](https://ieee-dataport.org/)
- [Mendeley Data](https://data.mendeley.com/)
- [_OpenICPSR_](https://openicpsr.org) - social science emphasis, free to use for Rutgers due to our institutional membership in ICPSR
- [_Open Science Framework_](https://osf.io/)
- [Synapse](https://www.synapse.org/)
- [Vivli](https://vivli.org/)
- [_Zenodo_](https://zenodo.org/)

A [comparison](https://doi.org/10.5281/zenodo.3946719) of many of these repositories is available.

_italic_ entries are recommended for their ease of use and suitability for a wide range of data.

Specialized repositories, if available, are the best place to deposit data with special characteristics.  These repositories are built to handle and showcase certain kinds of data.

To discover specialized repositories, such as the [Protein Data Bank](https://www.rcsb.org), use

[Re3data - the Registry of Research Data Repositories](https://www.re3data.org/)

And for more information, use 

[FAIRsharing.org](https://fairsharing.org/)

### R package creation

R Packages are an excellent way to distribute collections of data and code.  Following on the release of the 2nd edition of Hadley Wickham's [_R Packages_ book](https://r-pkgs.org), this workshop reviews the package creation process, covering prerequisites, the steps involved in creating a complete package, and following up on documentation and testing.

You have a choice of how you'd like to follow along with this material.  To run code yourself, you can use the [R_Packages.R](https://ryanwomack.com/data_topics/R_Packages.R), [R_Packages.qmd](https://ryanwomack.com/data_topics/R_Packages.qmd) (Quarto), or [R_Packages.Rmd](https://ryanwomack.com/data_topics/R_Packages.Rmd) (Rmarkdown) files.  Alternatively, you can read along using:

- [R_Packages.html](https://ryanwomack.com/data_topics/R_Packages.html) (web - light theme)
- [R_Packages_dark.html](https://ryanwomack.com/data_topics/R_Packages_dark.html) (web - dark theme)
- [R_Packages.pdf](https://ryanwomack.com/data_topics/R_Packages.pdf) (PDF)
- [R_Packages.docx](https://ryanwomack.com/data_topics/R_Packages.docx) (Word)
