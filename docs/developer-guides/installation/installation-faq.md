---
description: Frequently Asked Questions
hidden: true
---

# Installation FAQ

The following information is provided to assist a state education agency (SEA) in determining readiness for CIID’s Generate tool. Further questions can be sent to [**CIIDTA@AEMcorp.com**.](mailto:CIIDTA@AEMcorp.com.)

### Cost <a href="#toc109377198" id="toc109377198"></a>

<details>

<summary>💰 Is there a cost for Generate?</summary>

Generate is freely available to all SEAs, with no cost. SEAs may identify costs related to server space or staff time, depending on the state environment and implementation plan.

</details>

### Installation <a href="#toc109377199" id="toc109377199"></a>

<details>

<summary>🤔 Who from the SEA should be involved in the installation process?</summary>

State IT staff will need to install Generate in the state environment.

</details>

<details>

<summary>🖥️ What are the technical system requirements to install and run Generate?</summary>

The following system requirements are:

* [x] Web Server - Windows 2012 R2 (or newer) with IIS 8.5 (or newer) and 16GB of RAM.
* [x] Database Server - Windows 2012 R2 (or newer) with SQL Server 2012 or newer and 16GB of RAM.
  * [x] Web Server and Database Server may be on the same machine, if desired.
* [x] 32GB of RAM is required if on the same machine.
* [x] .NET 6.0 or newer installed on Web Server. .NET Core Windows Server Hosting bundle installed on Web Server.
* [x] Active Directory (AD) accessible from the Web Server. If no AD installation exists, AD LDS may be installed.

</details>

<details>

<summary>📂 Where will Generate be installed?</summary>

Generate is installed on a .Net server in the state. A new server may be required, which could result in a cost.

</details>

<details>

<summary>🌥️ Can Generate be installed in the cloud?</summary>

Yes, for specifics on installing Generate in the cloud please contact CIID at [CIIDTA@AEMcorp.com.](mailto:CIIDTA@AEMcorp.com.)

</details>

<details>

<summary>⌛ How long will it take for the installation of Generate?</summary>

Please plan on a 3-6 hour window for installation and troubleshooting.

</details>

<details>

<summary>🆘 Can CIID address installation questions?</summary>

Yes. Please reach out to CIID at [CIIDTA@AEMcorp.com.](mailto:CIIDTA@AEMcorp.com)

</details>

<details>

<summary>🆘 Can CIID assist an SEA with an installation?</summary>

Please reach out to CIID at [CIIDTA@AEMcorp.com](mailto:CIIDTA@AEMcorp.com) to discuss your SEA’s installation needs.

</details>

<details>

<summary>🧭 Can the SEA install on its own (without CIID assistance)?</summary>

Yes, the [Generate Installation Guide](./) provides instructions for a SEA to install the application on their own.

</details>

### Implementation <a href="#toc109377200" id="toc109377200"></a>

<details>

<summary>⏭️ Once the install is done, what’s next?</summary>

Your SEA should make a plan to successfully move data into Generate. The [**CIID Data Integration Toolkit**](https://ciidta.communities.ed.gov/#program/toolkit) can guide you through this process with the [Implementation](../migration/) section of the **Developer Guides**

</details>

<details>

<summary>⚒️ Are there additional tools to assist an SEA in setting up the ETLs for Generate?</summary>

Yes, because Generate is built on CEDS, the CEDS Align and Connect tools provide a location to map your source data systems to CEDS Elements, which will provide details about where data will be stored in Generate. Additionally, all ED_Facts_ reports in Generate have CEDS Connections. The CEDS _myConnect_ tool will show a gap analysis of your source systems against the ED_Facts_ Connection to identify any missing and/or duplicative elements. For more information, please visit [**https://ceds.ed.gov/**](https://ceds.ed.gov/).

</details>

