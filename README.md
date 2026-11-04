# Enterprise Active Directory \& Network Infrastructure Lab

## 📌 Project Overview

This project demonstrates the end-to-end deployment and configuration of an enterprise network environment using Hyper-V, Windows Server, and Windows 10. The lab simulates a corporate IT infrastructure, featuring a fully functional Active Directory Domain Services (AD DS) forest, automated user provisioning via PowerShell, and a dual-homed network architecture utilizing DHCP and NAT routing.

### 🛠️ Technologies \& Services Used

* **Hyper-V** (Type 1 Hypervisor virtualization)
* **Windows Server 2025** (Domain Controller / Network Gateway)
* **Windows 10** (Client Machine)
* **Active Directory Domain Services (AD DS)**
* **DNS \& DHCP Services**
* **Routing and Remote Access (NAT)**
* **PowerShell** (Bulk administration \& automation)

\---

## 🏗️ Architecture \& Network Design

The environment consists of an isolated internal private network that securely routes to the internet through the Domain Controller acting as a NAT gateway.

* **Domain Name:** `Automation.Com`
* **Domain Controller (DC01):**

  * Internal Interface (Private Switch): `172.16.0.10` (Static)
  * External Interface (Public/Default Switch): DHCP from host network
* **Client Network (DHCP Scope):** `172.16.0.100` – `172.16.0.200`

\---

## 🚀 Deployment Phases

### Phase 1: Hyper-V Virtual Switch Configuration

To create a secure and isolated lab environment, the Hyper-V networking infrastructure was configured first. An Internal/Private Virtual Switch was created to host the local domain traffic (172.16.0.0/24). The Domain Controller was provisioned with two network adapters: one connected to the external network for internet access, and one connected to the internal switch to serve the client machines.

!\[Virtual Switch Configuration](images/Virtual%20switch1.png) (images/Virtual%20switch2.png)
*Hyper-V Virtual Switch Manager displaying the internal lab network configuration.*

### Phase 2: Core Infrastructure \& DHCP Configuration

Promoted the Windows Server to a Domain Controller to establish the `Automation.Com` forest. Configured the DHCP Server role to dynamically lease IP addresses to client machines on the internal virtual switch, configuring the DC as the default gateway and DNS server.

!\[DHCP Scope Configuration](images/Assigning%20Static%20IP%20to%20internal.png)
*DHCP IPv4 Scope configured for the 172.16.0.0/24 subnet.*

### Phase 3: Network Address Translation (NAT)

To allow isolated internal clients to securely access the internet, the Routing and Remote Access role was configured. A dual-homed architecture was established, explicitly defining the internal interface as Private and the external interface as the Public NAT gateway.

!\[NAT Routing Interfaces](images/Enabled%20NAT.png) (images/NAT.png)
*Routing and Remote Access console showing Active NAT interfaces.*

### Phase 4: PowerShell Automation (Bulk User Provisioning)

Instead of manually creating accounts, a custom PowerShell script was developed to parse a CSV file containing 119 employee records. The script dynamically created Organizational Units (OUs) based on department data, generated Active Directory user accounts, assigned secure passwords, and enforced a mandatory password reset policy upon first login.



\[View the Bulk User Import PowerShell Script](Powershell%20script.ps1)



!\[Active Directory Users and OUs](images/all%205%20OUs%20added.png)
*Active Directory Users and Computers displaying the dynamically generated OUs and imported user accounts.*

### Phase 5: Client Domain Join \& Security Verification

A Windows 10 virtual machine was deployed on the internal switch. It successfully pulled a `172.16.0.x` IP address from the DHCP server and joined the `Automation.Com` domain. Login was tested using one of the PowerShell-imported accounts, successfully triggering the mandated password reset policy before granting desktop access.

!\[Client Domain Verification](images/Login%20with%20User%20details.png) (images/Prove%20user%20identity.png) (images/Confirming%20Domain%20membership.png)
*Command Prompt verification showing successful domain authentication (`whoami`) and system domain membership (`systeminfo`).*

