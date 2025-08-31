# to call the main.tf file which is inside environments folder. The following is a mandatory step when using multi envs

module "root" {
  source = "../terraform-code/environments"
}
