# Pure Terraform example
A very simple example of using Terraform with AWS, using native functionality to handle multiple environments, to acheive most of the functionality of a tool like tfscaffold (or terragrunt) but just using Terraform alone.

Terraform State is stored remotely in a private s3 bucket and dynamoDB table, using the built-in s3 backend.

This codebase supports being scaled up to multiple accounts (cross-account provisioning) hosting multiple environments (internally terraform workspaces are used), consisting of multiple components, with any duplication minimised by locally defined modules.

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

## Pre-requisites
### Organization and Accounts
Use AWS Organizations to setup a hierarchy of accounts, OUs and SCPs. At it's simplest, you could have:
* Root
    * "myproject" OU - apply an SCP at this level to set project-wide mandatory guardrails (see `example_scp.json` as an example)
        * member account: `build` - hosts all code, release packages, pipelines, TF State
        * member account: `dev` - hosts the dev environments (with dev data)
        * member account: `test` - hosts the test environments (with test data)
        * etc..
    * management account - consolidated billing, security logs, etc

If desired you could have a more complex hierarchy with several isolated backends to limit admin access, by adding extra `.tfbackend` files.

### CLI Access
To run Terraform each engineer will require an IAM user with API access in the `build` account, typically granted `AdministratorAccess`. Set this as the default profile using the `AWS_PROFILE` environment variable. Always keep all access details out of your Terraform codebase and not under version control.

To setup or update the cross-account assume-role access, an IAM user with API access in required in the remaining member accounts. Because several profiles are used for this setup, the Terraform provider configuration in the `assume-role` component references profile names set in your local AWS CLI shared credentials file (`~/.aws/credentials`). These users are not used at any other time.

### TF Backend Setup
Manually create a private s3 bucket and dynamoDB table in the `build` account to store your remote state, as per the Terraform documentation. State is stored in a `.tfstate` file for each component and environment combination. Use partial backend configuration to keep the state key in your component definitions (use a name based on the component) and the rest of the details in a suitable `config/<name>.s3.tfbackend` file.

### Assume Role Setup
Cross-account Terraform provisioning requires a role setup in each member account that hosts environments. To achieve this, use the `assume-role` component with the logical "bootstrap" environment, as follows:
* Update `config/bootstrap.tfvars` as required
* To add more accounts, add further providers and IAM policies and roles
    * Because Terraform requires providers to be static, this cannot be easily parameterised
* Run `./bin/init.sh assume-role bootstrap default` 
* Then run `./bin/tf.sh assume-role bootstrap plan` (and then `apply`)

## Use
To initialise a component in an environment:

`./bin/init.sh <component> <environment> <backend>`

To run a Terraform action (e.g. `plan`, `apply`):

`./bin/tf.sh <component> <environment> <action>`

## Versions Used
* Terraform v1.4.6
* AWS provider v5.1.0
* AWS CLI v2.11.25

## Limitations
Anyone with access to Terraform provisioning has admin access to all member accounts and can see full details of all environments handled by the same backend (e.g. all TF state, outputs, etc). If this is a concern then split the account hierarchy and use multiple backends, as outlined above, and limit access at the AWS IAM user level. Splitting by environment (e.g. keeping `prod` separate) is feasible, splitting by component is not.

Using AWS Organizations alone can scale up to a single department with several technical teams working on several projects/products/services with the same ways of working. Mandatory guardrails can be set using SCPs at OU and account level, e.g. department-wide, project-wide, per-member-account, etc.

For large organisations with dedicated InfoSec operations teams, and a larger number of technical teams working in several departments using a range of approaches (so optional guardrails become necessary), look at using AWS Control Tower.