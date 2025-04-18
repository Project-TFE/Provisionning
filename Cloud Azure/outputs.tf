output "PrivateKeyJenk" {
    value = tls_private_key.ssh_1.private_key_pem
    sensitive = true
}

output "PrivateKeySonar" {
    value = tls_private_key.ssh_2.private_key_pem
    sensitive = true
}

# output "PrivateKeyControl" {
#     value = tls_private_key.ssh_3.private_key_pem
#     sensitive = true
# }