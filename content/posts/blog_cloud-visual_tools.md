
+++
title = "Managing Cloud Infrastructure with Visual Tools"
date = "2021-12-03"
author = "Jason Beach"
categories = ["Best_Practice", "Architecture_and_DevOps"]
tags = ["diagrams", "aws"]
+++


I'm a big fan of using cloud environments, especially for getting a product started.  But for early prototyping with a small team, remembering everything that needs to be created / configured, as well as everything that is already performed, can be daunting.  To improve this process, I've started using visual tools to help document my work.  This is a reasonable approach because most aspects of the infrastructure should have a corresponding physical implementation.  In addition, a really mature tool should do alot of this automatically.  We will review some of these tool options for AWS in this post.

## Documenting Achitectures (Stacks)

* [ref: template listing](https://aws.amazon.com/architecture/)
* [docs: AWS templates](https://aws.amazon.com/cloudformation/resources/templates/)
* [repo: generate templates from your stack](https://github.com/iann0036/former2)

The Cloud Formation Template is the blueprint for an AWS deployment.  It is a single file (.yaml or .json) that AWS can use to create a new infrastructure.  Along with the hardware, essential attributes, such as security access configs, are included.  Tags can also be included for customized tracking.  

AWS even maintains a listing of popular architectures, with several thousand available.  Popular categories include:

* Analytics & big data
* Compute & HPC
* Databases
* Machine learning

In addition to this listing, you can export a template from an existing deployment, called a 'stack', using the Cloud Former service.  Unfortunately, this is only useful for a very [small subset of AWS services](https://stackoverflow.com/questions/62943396/which-aws-services-does-aws-cloudformer-support).  A third-party tool, [Former2](https://github.com/iann0036/former2) interacts with the Javascript API to generate your template.  It is open-source and appears to still be maintained.

The [AWS Well-Architected Tool](https://aws.amazon.com/well-architected-tool/?achp_wa2&whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc) can be used to review your deployment against workloads and determine how you can meet your org's specific goals.


## Effectively Using Templates

* [repo: open source Cloud Mapper](https://github.com/duo-labs/cloudmapper)
* [docs: AWS cloud formation designer](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/working-with-templates-cfn-designer.html)
* [tool: visualize template in draw.io](https://infviz.io/)

While having a template is great, the files are quite large.  Working with one should be more intuitive than searching through .json.  Specifically, we should manually work with a visual representation of a template, and update the template once changes are made.

This is exactly why Cloud Formation Designer and Cloud Mapper (open source) were created.  They both work really well and the open-source version seems to be actively maintained.  For more aesthetics, you can use Infviz.io, but you will not be able to update the template.
