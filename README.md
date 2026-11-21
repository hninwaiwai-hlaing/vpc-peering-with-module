#### Infrastructure Diagram
https://link.excalidraw.com/l/AyLwrHVr1Ik/7yeDinu28ws

#### SSH Command
```
ssh -i customer_profile_key_pair.pem \
  -o WarnWeakCrypto=no-pq-kex \
  -o "ProxyCommand=ssh -i jump-host-keypair.pem -o WarnWeakCrypto=no-pq-kex -W %h:%p ec2-user@<public-ip>" \
  ec2-user@<private-ip>

ssh -i account_key_pair.pem \
  -o WarnWeakCrypto=no-pq-kex \
  -o "ProxyCommand=ssh -i jump-host-keypair.pem -o WarnWeakCrypto=no-pq-kex -W %h:%p ec2-user@<public-ip>" \
  ec2-user@<private-ip>


ssh -i statement_key_pair.pem \
  -o WarnWeakCrypto=no-pq-kex \
  -o "ProxyCommand=ssh -i jump-host-keypair.pem -o WarnWeakCrypto=no-pq-kex -W %h:%p ec2-user@<public-ip>" \
  ec2-user@<private-ip>
```