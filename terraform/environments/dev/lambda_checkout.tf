module "lambda_checkout" {
  source      = "../../modules/lambda_checkout"
  environment = var.environment
}
