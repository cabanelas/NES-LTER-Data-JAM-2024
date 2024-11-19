This README provides an overview of how the zooplankton data were generated, including the steps and methods used to process and analyze the data.
Overview

The data represent the abundance of selected zooplankton species collected from stations along the Northeast U.S. Shelf. This dataset was created as part of an educational outreach project to explore marine ecosystems and their dynamics.
You can read more about this project: https://sites.google.com/view/nes-lter-schoolyard-datajam/home

Data Collection

* Research Cruises: Data were collected during research cruises using a Bongo net system.
* Bongo Nets: Two nets with different mesh sizes (150 µm and 335 µm) were used to capture zooplankton of various sizes.
* Samples: This dataset focuses on samples from the 335 µm net.
* Stations: Sampling occurred at 12 stations, including MVCO and L1–L11, arranged from inshore to offshore along the continental shelf.

Data Processing

    Species Filtering: Only six target zooplankton species were included in this dataset.
    Abundance Calculation: Zooplankton abundance was calculated based on the volume of water filtered during sampling.
    Station Metadata: Station information (latitude, longitude, and max. depth) was merged with the zooplankton abundance data for added context.

Code Workflow

    Data Filtering: The raw zooplankton dataset was filtered to include only the target species.
    Merging Station Information: Station metadata was joined with the filtered dataset to provide spatial context.
    Ordering Data: Stations were ordered in a predefined sequence (MVCO, L1–L11) to reflect their geographic arrangement.
    Final Output: A clean, formatted dataset was created, ready for analysis and visualization.

Requirements

    R Packages:
        dplyr (data manipulation)
        tidyr (data organization)
        ggplot2 (visualization, optional)

How to Use

    Clone or download this repository.
    Open the R script file (datajamNESzoop.R).
    Run the script to reproduce the filtered and ordered zooplankton dataset.
    Modify or extend the script to customize for your research needs.

Acknowledgments

This project is part of the Northeast U.S. Shelf Long-Term Ecological Research (NES-LTER) program. The data and methods aim to support educational and research initiatives related to marine ecosystems and climate change.
