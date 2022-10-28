module "google_cloud_project" {
  source                    = "terraform-google-modules/project-factory/google//modules/fabric-project"
  parent                    = "n/a"
  billing_account           = var.billing_account_id
  prefix                    = "odin"
  name                      = "sixteen"
  oslogin                   = true
  activate_apis             = var.api_list
  auto_create_network       = false
  owners                    = []
  oslogin_admins            = []
}