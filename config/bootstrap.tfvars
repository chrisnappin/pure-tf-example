# special settings to be used with the "assume-role" component only, to setup cross-account access
# (not really an envrionment)

project         = "myproject"
region          = "eu-west-2"
policy_to_grant = "AdministratorAccess"

# account that holds the pipeline, build artefacts and TF remote state
# this also needs to be the default profile (set AWS_PROFILE) as it is used by the backend config which cannot use variables
build_account_id = xxx
build_profile    = "aaa"

# accounts that host environments, provisioned from the build account
# profiles need to be defined in the shared credentials file
dev_account_id  = yyy
dev_profile     = "bbb"
test_account_id = zzz
test_profile    = "ccc"
