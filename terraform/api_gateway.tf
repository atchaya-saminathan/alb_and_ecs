resource "aws_api_gateway_rest_api" "example" {
  name = "zoominfo"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "example" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_rest_api.example.root_resource_id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "example" {
  http_method = aws_api_gateway_method.example.http_method
  resource_id = aws_api_gateway_rest_api.example.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.example.id
  type                    = "HTTP_PROXY"
  uri                     = format("http://%s",module.alb.lb_dns_name)
  integration_http_method = "GET"  
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  depends_on = [aws_api_gateway_method.example]
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "initial"
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_rest_api.example.root_resource_id
  http_method = aws_api_gateway_method.example.http_method
  status_code = "200"
}

output "invoke_url" {
  value = aws_api_gateway_stage.example.invoke_url
}

