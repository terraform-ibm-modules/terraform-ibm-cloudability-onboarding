locals {
  request_body = {
    keyAccess = var.key
    keySecret = var.secret
  }
}
data "http" "apikeylogin" {
  url    = "${var.host}/service/apikeylogin"
  method = "POST"
  # Optional request headers
  request_headers = {
    Content-Type = "application/json"
    Accept       = "application/json"
  }
  request_body = jsonencode(local.request_body)
  lifecycle {
    postcondition {
      condition     = contains([200], self.status_code) && try(self.response_headers["Apptio-Opentoken"], try(self.response_headers["apptio-opentoken"], "apptio-opentoken not found in response headers")) != null
      error_message = "Status code invalid or `apptio-opentoken` header missing."
    }
  }
}

locals {
  response_headers = data.http.apikeylogin.response_headers
  opentoken        = try(local.response_headers["Apptio-Opentoken"], local.response_headers["apptio-opentoken"])
  status_code      = data.http.apikeylogin.status_code
}
