
+++
title = "Difficulties in Working with Contractor Teams on Data Science Projects"
date = "2021-11-01"
author = "Jason Beach"
categories = ["Best_Practice", "Architecture_and_DevOps"]
tags = ["project_management", "create_team"]
+++


Working with contractors can be very helpful in some situations.  There is an understanding of support without long-term commitment.  However, giving too much control to contractors can be very dangerous because their incentives are often quite different from yours.  

This is especially true in Data Science projects because of the long-term investments that must be made.  There are several areas of caution which should be addressed to ensure the project is kept under control.

1)	Maintain whatever the contractor builds: They have a wide-range of skills because they are often staffers.  These staffers can be capable in a wide range of areas.  But, if their skills are not focused, then the result will be an unmaintainable mess of code.  For instance, a typical data engineer will say that Scala is the best programming language for building data pipelines.  I agree with this for several reasons.  However, if you maintain this system, then you must limit the number of languages used and, also, to languages that are popular enough to find people with the skills to use them.  In such case, Scala is not a good language because it is very specialized to data engineering and has a steep learning curve that is hard to hire. Without proper control, code will be produced, but will be unmaintainable.
  
2)	Must constrain staffers properly, or they will just build things and cause the system to be out of control: Combining the contractor and in-house team can lead to more than 20 people.  That is a HUGE team for developing software.  Typical teams don’t get larger than 6 because what you are building is very intangible, and so, is very difficult to control.  Without proper control, code will be produced, but it will never be integrated and used with the system.  

3)	Must use the contractor depth appropriately.  For instance, if some contractors are very experienced deep mathematical analysis.  This is really terrific to employ on hard problems, but hard problems do not come quickly.  We will have to find hard problems in order to not waste those skills.  Without proper control, highly skilled data scientists will be bored and their talents wasted.

4)	The in-house and contractor teams are data science heavy: The teams are not balanced with other specialists, such as web dev or dev ops.  These skills are necessary to help the team deliver in a productive manner.  In addition, these skills are needed in different amounts throughout the project.  Without proper control, bottlenecks will occur and the project will grind to a stand-still waiting on a few key developers.
