Knot key generation:
```
(KEY="acme"; keymgr -t "$KEY" hmac-sha256 > "knot-${KEY}.yaml"; sops --input-type binary --output-type binary --in-place --encrypt "knot-${KEY}.yaml")
```
