# ETCMC-Node-Win-Firewall-Rules

## Introduction
This repo was built as a response to several questions on how to set up an ETCMC Node and how to modify the firewall rules. This Windows .bat file takes the FirewallRules.txt file and exposes the PORT either inbound or outbound into the Windows firewall. 

## Important
<strong> For the .bat file to work, you must launch the command prompt as an administrator.</strong>

## Running the Script
<ol>
  <li><strong>Step 1</strong> - Download or Clone this repository to the computer that you wish to update the firewall settings.</li>
  <li><strong>Step 2</strong> - Review (and modify if necessary) the FirewallRules.txt file to confirm the rules you wish to reply</li>
  <li><strong>Step 3</strong> - Right Click on <code>WFModify.bat</code> and Click "Run as Administrator"</li>
</ol>

## Configuration

### FirewallRules.txt notes
Each port to open should be on a separate rows with properties separated by a single whitespace. The format is as follows:

%PORT% %PROTOCOL% %ROUTING1% [%ROUTING2%] - [] denotes optional parameter

#### Outbound Only Rules example

<code>30303 TCP outbound</code>

#### Inbound Only Rules
<code>30303 UDP inbound</code>

#### Both Ways Rules

<code>30303 TCP inbound outbound</code>

It is important to note that the order for both ways MUST be "inbound outbound"
