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
  name                = "twentyone"
  oslogin             = true
  activate_apis       = var.api_list
  auto_create_network = false
  owners              = []
  oslogin_admins      = []
}

resource "google_project_iam_custom_role" "fw_custom_role" {
  project     = "odin-twentyone"
  role_id     = "custom.operations.role"
  title       = "custom-role"
  description = "custom role"
  permissions = [
    "compute.firewalls.create",
    "compute.firewalls.delete",
    "compute.firewalls.update",
    "iam.serviceAccounts.setIamPolicy",
    "iam.serviceAccounts.delete"
  ]
}

module "iam" {
  source = "github.com/aniruddha-sinha/gcp-iam-module.git?ref=main"
  //source = "../../modules/iam"

  project_id                   = "odin-twentyone"
  service_account_id           = "terraform-sa"
  service_account_display_name = "Terraform Service Account"
  role_list = [
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iam.serviceAccountViewer",
    "roles/iam.serviceAccountCreator",
    "roles/iam.securityReviewer",
    "roles/container.clusterAdmin",
    "roles/compute.networkAdmin",
    google_project_iam_custom_role.fw_custom_role.id
  ]
}
