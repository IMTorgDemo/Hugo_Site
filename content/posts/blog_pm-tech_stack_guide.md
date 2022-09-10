
+++
title = "The Tech Stack Quick Start Guide"
date = "2021-12-02"
author = "Jason Beach"
categories = ["Best_Practice", "Architecture_and_DevOps"]
tags = ["project_management", "create_team"]
+++


This is a guide to the fastest and cheapest way to get your development project moving forward with typical tools and infrastructure. 


## Jira 

Jira is one of the oldest applications for applying Agile to a Team's workflow.  This is a really simple tool that comes across as overly-complicated because of all the available functionality.  Stop trying to appease your corporate masters, Atlassian!  New and simplified UIs are rolling-out to fix this.  Jira is free for teams, up to 7 people.

Despite being so mature and well-established, Jira is really showing its age.  For reasons why Jira is obsolete, and for improved alternatives, see the site [whyjirasucks](https://whyjirasucks.com/).

Jira can be confusing because of changes to both the UI and available project templates.  We will keep things simple by staying with the 'Classic' project with 'Scrum' template.  This provides the Scrum board with three columns: To Do, In Progress, Done.  There are two ways to use Jira: basic To Do list, and expected Agile Sprints.

Items to work on come in three different types: Tasks, Issues, User Stories.

### Simple

You may just want to create simple To Do lists, such as for administrative activities or personal issues.  For this simple use case, just use a Board, which is nothing more than Tasks with a specific Tag.

* Create (top ribbon, far-right) 
* add Summary
* set the Assignee
* Labels should be the board you want

You can view all Tasks with this tag by clicking on Boards, just to the left of Create.  Another way is to 
* click on 'Boards in this Project'
* Create Board 
* select Scrum or Kanban
* Board from saved Filter (JQL)

The Jira Query Language (JQL) Filter is just a search for the Label that you associate with the Board.

### Agile Sprint

Using Jira for Agile Sprints is the orthodox approach.  Once you have your project, fill-up Tasks in the BackLog.  Move prioritized Tasks into the Sprint area, above, then Create sprint to begin working on those Tasks.  The Tasks will appear on the created sprint board in the To Do column.

### API

Quite useful is the open API that allows you to query the backend of Jira.  I wouldn't invest too much infrastructure with a closed-source tool, but it is definitely good to have available.

## GitLab (GitLab CI)

GitLab is an open source alternative to Github.  Github on-prem instances would cost corporations tens of thousands of dollars.  GitLab maintains a free core, with a (paid) additional functionality for scaling to large organizations.  Its primary revenue generator is the automated CI/CD pipelines, but it has an abundance of functionality and integrations, such as with Jira, that can be useful.

### Repo organization

* [ref]()

Coming later to the game, GitLab learned from some of the deficiencies of Github.  One of the best improvements was the ability to organize repositories, call Projects.  In this respect Users still have their own Project listings page, but there are also Groups and Subgroups that allow for better organization of projects.  This is especially useful in allowing access to individuals and teams.


### Integration with Jira

* [ref: docs](https://docs.gitlab.com/ee/user/project/integrations/jira.html)

Features include:

* Mention a Jira issue ID in a commit message or MR (merge request) and
  - GitLab links to the Jira issue.
  - The Jira issue adds a comment with details and a link back to the activity in GitLab.
* Mention that a commit or MR resolves or closes a specific Jira issue and when it’s merged to the default branch:
  - The GitLab MR displays a note that it closed the Jira issue. Prior to the merge, MRs indicate which issue they close.
  - The Jira issue shows the activity and is closed or otherwise transitioned as specified in your GitLab settings.
* View a list of Jira issues directly in GitLab 


### Runners and CI/CD pipelines

* [ref: blog]( https://about.gitlab.com/blog/2019/09/26/building-a-cicd-pipeline-in-20-mins/)
* [ref: video]( https://www.youtube.com/watch?v=jUiKi6FWYrg&list=PLhW3qG5bs-L8YSnCiyQ-jD8XfHC2W1NL_&index=7)
* [ref: example config]( https://gitlab.com/gitlab-org/gitlab-foss/-/blob/master/lib/gitlab/ci/templates/Auto-DevOps.gitlab-ci.yml)

Automating testing and deployment is one of the biggest productivity boosters that a team can implement.  This is a summary of the different CI/CD terms:

CI, Continuous Integration - Build => Unit Test => Integration Test => Merge
CD, Continuous Delivery - (above) => Acceptance Test => Version Release
CD, Continuous Deployment - (above) => Auto Deploy to Production

The basis of GitLab CI/CD is the GitLab CI runner.   Runners used to run build jobs, in parallel (if necessary), and send results back to the UI.  To use it you must:

i) install locally or remote server
ii) register using CI token
iii) activate runners: project > settings > CI/CD

Ensure that you assign tags with it so that it is callable in yaml config files.

To create a CI/CD pipeline, do the following:

i) create config yaml file as: .gitlab-ci.yml
ii) commit and push config to gitlab repo
iii) create GitLab runner, as described above
iv) start the runner

Now, make changes in the project, commit and push, to activate the pipeline and associated runners.  Display progress with: Project > CI/CD > Pipelines, Jobs

### AutoDevOps

AutoDevOps is an automated configuration of CI/CD pipelines using Kubernetes.  It performs the build using docker from within docker, which can be time-consuming.  Then the testing occurs within Kubernetes cluster.  Functionality includes:

* Detect the language of the code
* Automatically build, test, and measure code quality
* Scan for potential vulnerabilities, security flaws, and licensing issues
* Monitor in real-time
* Deploy the application

While it may work well for some simple projects, using one of the preferred languages, their solution may be too simple for practical use. 

## Optional

### Airflow 

### MLflow

* [ref](https://mlflow.org/docs/latest/quickstart.html)

If you haven’t configured a tracking server, projects log their Tracking API data in the local `./mlruns` directory so you can see these runs using mlflow ui.  By default mlflow run installs all dependencies using conda. 

Launch a tracking server on a remote machine using:
```
mlflow server \
    --backend-store-uri /mnt/persistent-disk \
    --default-artifact-root s3://my-mlflow-bucket/ \
    --host 0.0.0.0
```

Then set your tracking to it with:
```
import mlflow
mlflow.set_tracking_uri("http://YOUR-SERVER:4040")
mlflow.set_experiment("my-experiment")
```

Four main areas of concern:

* MLflow Tracking - log information about each training run, hyperparameters alpha and l1_ratio, used to train the model and metrics, and root mean square error, used to evaluate the model

```
import mlflow
import mlflow.sklearn

import logging

logging.basicConfig(level=logging.WARN)
logger = logging.getLogger(__name__)
...
with mlflow.start_run():
		...
        mlflow.log_param("alpha", alpha)
        mlflow.log_param("l1_ratio", l1_ratio)
        mlflow.log_metric("rmse", rmse)
        tracking_url_type_store = urlparse(mlflow.get_tracking_uri()).scheme
        mlflow.sklearn.log_model(lr, "model", registered_model_name="ElasticnetWineModel")

```

`mlflow ui` and view it at http://localhost:5000.

* MLflow Project - specify the dependencies, such as alpha and l1_ratio, and entry points to your code, located in a Conda environment file called conda.yaml.  `mlflow run examples/sklearn_elasticnet_wine -P alpha=0.42`, which uns your training code in a new Conda environment with the dependencies specified in conda.yaml. 
* MLflow Models - package machine learning models that can be used in a variety of downstream tools.  For example, real-time serving through a REST API or batch inference on Apache Spark.  `mlflow.sklearn.log_model(lr, "model")`.  `MLmodel`, is a metadata file that tells MLflow how to load the model. The second file, `model.pkl`, is a serialized version of the linear regression model that you trained.  `mlflow models serve -m /Users/mlflow/mlflow-prototype/mlruns/0/7c1a0d5c42844dcdb8f5191146925174/artifacts/model -p 1234` deploy a local REST server that can serve predictions.  Predictions obtained with: 

```
# On Linux and macOS
curl -X POST -H "Content-Type:application/json; format=pandas-split" --data '{"columns":["alcohol", "chlorides", "citric acid", "density", "fixed acidity", "free sulfur dioxide", "pH", "residual sugar", "sulphates", "total sulfur dioxide", "volatile acidity"],"data":[[12.8, 0.029, 0.48, 0.98, 6.2, 29, 3.33, 1.2, 0.39, 75, 0.66]]}' http://127.0.0.1:1234/invocations
```
* 



### NLP Use Cases

### Scrumsaga

## AWS-Elastic Kubernetes Service



Too be continued...
