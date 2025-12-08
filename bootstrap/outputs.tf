output "dev_account_number" {
    value = aws_organizations_account.dev_account.id 
}

output "prod_account_number" {
    value = aws_organizations_account.prod_account.id 
}