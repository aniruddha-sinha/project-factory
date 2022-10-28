data "google_secret_manager_secret_version" "billing_account_id_secret" {
  provider = google-beta
  project  = "odin-shared-master"
  secret   = "billing-account-id-secret"
}
module "google_cloud_project" {
  source              = "terraform-google-modules/project-factory/google//modules/fabric-project"
  parent              = "n/a"
  billing_account     = data.google_secret_manager_secret_version.billing_account_id_secret.secret_data
  prefix              = "odin"
  name                = "sixteen"
  oslogin             = true
  activate_apis       = var.api_list
  auto_create_network = false
  owners              = []
  oslogin_admins      = []
}