
+++
title = "A Reasonable MVP Tech Stack"
date = "2021-09-01"
author = "Jason Beach"
categories = ["Best_Practice", "Architecture_and_DevOps"]
tags = ["project_management", "create_team"]
+++


This is a quick summary of products needed to get a development team started.  We can manage accounts for code repositories.  GitLab is especially good because it is open-source, and it is highly customizable.  It is one of several Team ‘infrastructure’ projects necessary for effectively building software.

This is a summary of code repository platforms with explanations:

* Atlassian (firm)– the company with a suite of different project management tools, including Trello, Jira, BitBucket, and others.  Jira, I think you said, is typically used at FDA for managing developer tasks.
* Bitbucket (SAAS product) – is owned by Atlassian.  It maintains your project code.
* Github (SAAS product) – is owned by Microsoft.  It is the most popular product for maintaining open-source project code.  FDA has an account, here: https://github.com/fda.  Private accounts cost firms >$50,000 before GitLab.
* GitLab (open source SAAS product) – is an open source copy of Github.  It can be deployed to an internal server and used freely for maintaining project code. 



Important Team infrastructure necessary for effectively developing and operating software:

* version control system (git)
* code repository management (gitlab)
* CI /CD and Test suite (gitlab, kubernetes, aws-eks)
* knowledge base / publishing: site, reporting, wiki, pdfs  (jupyter, hugo, pandoc, ??? )
* project task and schedule management (jira)
* project code-functionality accounting (scrumsaga)
* container environment system (docker)
* container deployment system (kubernetes)
* cloud infrastructure: IAAS, SAAS, FAAS (aws)
* site and infrastructure monitoring

