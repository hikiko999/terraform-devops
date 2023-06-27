module "user_module" {
    source = "../../terraform-modules/users"
    // configure env variables
    environment = "qa"
}