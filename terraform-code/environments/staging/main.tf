# to call the main.tf file which is inside environments folder. The following is a mandatory step when using multi environments.

module "stack" {
  source = "../../stack"
  cfg    = var.cfg
}

