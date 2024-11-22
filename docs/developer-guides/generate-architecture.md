---
icon: sitemap
---

# Generate Architecture

The [Common Education Data Standards](https://ceds.ed.gov/Default.aspx) (CEDS) is an education data management initiative developed by education stakeholders through funding by the National Center for Education Statistics (NCES). CEDS allows different entities to speak the same language by having a common terminology or common dictionary. CEDS also includes a toolset - _Align_ and _Connect_.

### Using CEDS to Prepare for a Generate Implementation <a href="#toc108711241" id="toc108711241"></a>

There are several steps you will need to take to prepare for the Generate implementation, several of which include the use of the CEDS tools as described below. This information is an initial orientation to the CEDS tools. For more detailed steps on how to prepare for a Generate implementation, see the [CIID Data Integration Toolkit](https://ciidta.communities.ed.gov/#program/toolkit).

One of the first steps in a Generate implementation is to map your source data elements to CEDS using the Align tool. Align provides a bridge between different datasets. By aligning your datasets to CEDS and then using CEDS as the bridge, you can see how those two datasets intersect. Align also includes a location for database and table names allowing for the alignment between the datasets to be viewed at a more technical level. Datasets that have been aligned to CEDS are called maps.

The Connect tool has many uses, one of which is to define and analyze data used for reporting to the federal government, such as ED_Facts_ reports. Every ED_Facts_ report in Generate has a corresponding CEDS Connection built for it. The Connection identifies the data elements required for the report and offers a crosswalk between the CEDS element and the ED_Facts_ permitted value. When an Align map is created, the data elements from the map can then be compared to the data elements within the Connection using a gap analysis process called _myConnect_. _myConnect_ informs the technical team of the location of data elements which then informs the ETL process.

Once the Align maps have been created, _myConnect_ can be run with the Generate Connections to identify the location of the data elements in the source, as well as to identify any gaps.

For support with aligning to CEDS, review the [tutorials](https://ceds.ed.gov/learnCedsAlignment.aspx) available on the CEDS website or contact CIID at [ciidta@aemcorp.com](mailto:ciidta@aemcorp.com) or CEDS @ [https://ceds.ed.gov/contactUs.aspx](https://ceds.ed.gov/contactUs.aspx) for assistance.

### CEDS Data Warehouse <a href="#toc108711242" id="toc108711242"></a>

The Generate application is built foundationally on the Common Education Data Standards (CEDS) which provides a standard understanding of elements and their meaning. CEDS is comprised of over 1,700 elements that range from Early Childhood through Workforce. States using Generate may find additional uses for the CEDS Data Warehouse which will contain a standard longitudinal look at their students. The ability to add additional details for research or other local reporting requirements would facilitate the need for these additional CEDS elements. This Implementation Guide provides details on best practices for loading the Staging environment to ensure a successful implementation of Generate.
