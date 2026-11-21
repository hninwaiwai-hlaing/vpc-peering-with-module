ssh -i customer_profile_key_pair.pem \
  -o WarnWeakCrypto=no-pq-kex \
  -o "ProxyCommand=ssh -i jump-host-keypair.pem -o WarnWeakCrypto=no-pq-kex -W %h:%p ec2-user@3.112.123.162" \
  ec2-user@10.0.201.191

scp -i customer_profile_key_pair.pem \
  -o WarnWeakCrypto=no-pq-kex \
  -o "ProxyCommand=ssh -i jump-host-keypair.pem -W %h:%p ec2-user@52.197.141.244" \
  ../scripts/fake-service.zip ec2-user@10.0.201.195:~


scp -i ./keypairs/customer_profile_key_pair.pem \
        -o StrictHostKeyChecking=no \
        -o WarnWeakCrypto=no-pq-kex \
        -o "ProxyCommand=ssh -i ./keypairs/jump-host-keypair.pem ec2-user@${module.jump_host_instance.public_ip}" \
        ./scripts/fake-service.zip ec2-user@${module.customer_profile_instance_1.private_ip}:~

scp -i customer_profile_key_pair.pem \
  -o WarnWeakCrypto=no-pq-kex \
  -o "ProxyCommand=ssh -i jump-host-keypair.pem -W %h:%p ec2-user@13.231.207.38" \
  ../scripts/fake-service.zip ec2-user@$(terraform output -raw customer_profile_private_ip):~



  scp -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null \
          -i "./keypairs/jump-host-keypair.pem" \
          "./scripts/fake-service.zip" \
          ec2-user@${module.jump_host_instance.public_ip}:~

      scp -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null \
          -i "./keypairs/jump-host-keypair.pem" \
          "./keypairs/customer_profile_key_pair.pem" \
          ec2-user@${module.jump_host_instance.public_ip}:~
      
      ssh -i ./keypairs/jump-host-keypair.pem ec2-user@${module.jump_host_instance.public_ip}

      sleep 10s
      scp -o StrictHostKeyChecking=no \
          -o UserKnownHostsFile=/dev/null \
          -i "./customer_profile_key_pair.pem" \
          "./fake-service.zip" \
          ec2-user@${module.customer_profile_instance_1.private_ip}:~

