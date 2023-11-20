# ETCMC-Node-Win-Firewall-Rules

## Introduction
This repo was built as a response to a number of questions on how to set up an ETCMC Node and how to modify the firewall rules. This windows .bat file takes the FirewallRules.txt file and exposes the PORT either inbound or outbound into the windows firewall. 

## Important

In order for the .bat file to work, you must launch the command prompt as an administrator.

## FirewallRules.txt notes
Each port to open should be on a separate rows with properties separated by a single whitespace. The format is as follows:

%PORT% %PROTOCOL% %ROUTING1% [%ROUTING2%] - [] denotes optional parameter

### Outbound Only Rules example

<code>30303 TCP outbound</code>

### Inbound Only Rules
<code>30303 UDP inbound</code>

### Both Ways Rules

<code>30303 TCP inbound outbound</code>

It is important to note that the order for both ways MUST be "inbound outbound"
