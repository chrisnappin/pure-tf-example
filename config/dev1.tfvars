# Define variable values to be fed into components in the components directory that will each form a part of the environment...

project            = "myexample"
aws_account_id     = "928564404697"
region             = "eu-west-2"
availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
cidr_block         = "10.0.0.0/16"

# subnet network blocks for each AZ
# each is a /24 block within the overall /16 range above
frontend_network_blocks = [1, 2, 3]
backend_network_blocks  = [4, 5, 6]
