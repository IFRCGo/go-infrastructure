[![Waffle.io - Columns and their card count](https://badge.waffle.io/IFRCGo/go-infrastructure.svg?columns=all)](https://waffle.io/IFRCGo/go-infrastructure)

# Go Infrastructure

## Logging in

```(bash)
source .env
source bin/login
```

### Notes

- Currently there's no way to deploy a serverfarm/VM with a reserved IP address. Setting `reserved: true` on these resources will cause the deployment to fail. `reserved: false` is the default.
