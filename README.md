# Pure Terraform example
A very simple example of using Terraform with AWS, using native functionality to handle multiple environments, to acheive most of the functionality of a tool like tfscaffold (or terragrunt) but just using Terraform alone.

Terraform State is stored remotely in a private s3 bucket and dynamoDB table, using the built-in s3 backend.

This codebase supports being scaled up to multiple environments, consisting of multiple components, with any duplication minimised by locally defined modules.

Typically a project's infrastructure would be logically grouped into a small set of components such as:
* *base* - has no depenedencies, contains resources such as DNS, network, and any other "core" infrastructure
* *data* - depends upon the *core* component, contains resources such as databases, NoSQL datastores, caches, storage, etc
* *application* - depends upon the *data* component, contains resources such as servers/containers/functions, code deployments, api gateways/web front end access, etc

The component grouping helps to separate frequently changing resources from rarely changing ones, and to minimise the circumstance where Terraform needs to destroy resources because it has decided a dependent resource needs recreating. Any dependencies between components should be handled using output variables.

## Code Structure
* *bin* - Very simple wrapper scripts to help reduce manual error
* *components* - Put your components here
* *config* - The environment-specific settings to use, one file per environment. Also the backend settings, either one or several.
* *modules* - Put your local modules here

## Use
Setup your local AWS CLI access, e.g. `AWS_PROFILE`, and keep all access details out of your Terraform codebase and not under version control.

Manually create a private s3 bucket and dynamoDB table to store your remote state, as per the Terraform documentation. State is stored in a `.tfstate` file for each component and environment combination. Use partial backend configuration to keep the state key in your component definitions (use a name based on the component) and the rest of the details in a suitable `config/<name>.s3.tfbackend` file. Should you genuinely need complete environment isolation, use several `.tfbackend` files.

To initialise a component in an environment:

`./bin/init.sh <component> <environment> <backend>`

To run a TF plan:

`./bin/tf.sh <component> <environment> plan`

## Versions Used
* Terraform v1.4.6
* AWS provider v5.1.0
* AWS CLI v2.11.25

## Limitations
For simplicity this example will run in a single AWS account, using only free tier resources. If you only use a single backend, then anyone with access can see full details for every environment. If that is not desired, use several backends and limit access at the AWS level.

For a non-trivial project, look at using AWS Organisations, a hierarchy of separate accounts (e.g. to control dev, test and prod data access) each containing one or more environments, and some suitable service control policies to set some mandatory guard rails about what may or may not be used, and where. Hold the IaC and code artefacts and pipelines in a dedicated account that has permissions and access to provision environments in all other accounts, ideally from scratch.

This can scale up to a single department with several technical teams working on several projects/products/services with the same ways of working.

For large organisations with dedicated InfoSec operations teams, and a large number of technical teams working in several business departments using a range of approaches (so optional guardrails become necessary), look at using AWS Control Tower.