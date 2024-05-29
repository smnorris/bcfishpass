# Background

Dams and linear infrastructure such as roads and railways cross streams and rivers, often using structures that can impede fish passage and fragment freshwater systems. Roads and railways built prior to the mid 20th century did not prioritize fish passage, and the original crossing structures are often still in place. Even crossings designed and installed with fish passage in mind are often degraded over time, leading to perched outlets, culverts collapsing or infilling with debris, and other issues that can impede passage of fish. 

With more than half a million mapped road-stream crossings and dams across BC, field assessment of all sites is impractical and tools are required to prioritize where fieldwork should be done. `bcfishpass` provides users a common reference point by modelling and tracking:

1. Natural barriers to fish passage (waterfalls, subsurface flow, steep gradients, other)

2. The potential range of accessible streams for various fish species, based on swimming ability (ie, identify all stream downstream of natural barriers), referred to in this document as '*potentially accessible habitat*'

3. Streams with the potential to support spawning and rearing stages of various species life cycles (based on stream slope and modelled discharge / channel width intrinsic potential (IP) models), referred to in this document as '*spawning/rearing habitat*'

4. Known anthropogenic barriers (dams, road-stream crossings field assessed as barriers, other)

5. Potential anthropogenic barriers (dams, mapped road-stream crossings)

6. Potential lateral (floodplain) habitat connected to modelled spawning/rearing habitat (DRAFT)

7. Potential lateral habitat that has been isolated by known or potential anthropogenic barriers (DRAFT)

With this information, users can:

- eliminate thousands of crossing from further consideration (for example, sites upstream of natural barriers or hydro dams without fish passage structures)

- create watershed-level or location specific connectivity status reports

- prioritize sites for field assessment by ranking indicators (eg, length of upstream spawning/rearing habitat, number of potential anthropogenic barriers downstream)

- communicate and visualize the extent of potential fish passage issues across British Columbia (per species and crossing type)

- use model outputs as inputs to other models, such as:
	+ habitat based inputs to fisheries population models
	+ landscape/regional level timber supply analysis (as riparian area buffer source)


For more background and references, see:

- [Fish Passage Technical Working Group (FPTWG)](https://www2.gov.bc.ca/gov/content/environment/plants-animals-ecosystems/fish/aquatic-habitat-management/fish-passage) and the "Strategic Approach" to barrier assessment and remediation  
- [Effects of rail infrastructure on Pacific salmon and steelhead habitat connectivity in British Columbia](https://cwf-fcf.org/en/resources/research-papers/BC_report_formatted_final.pdf), Rebellato et al (2024)