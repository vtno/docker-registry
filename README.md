# Docker Registry

A dead simple private Docker registry you can self-hosted with a single command. The setup uses Caddy server which automatically generates and renews SSL certificates and
provide basic authentication for the registry.

## Usage

### Configurations

Copy the .env.example to .env and modify the variables to your liking.

```bash
cp .env.example .env

# Content
# export DOMAIN="registry.yourwebsite.com"
# export USERNAME="your-basic-auth-username"
# export PLAIN_PASSWORD="your-basic-auth-password"
# export PASSWORD='bcrypted-your-basic-auth-password'
```

The PASSWORD variable is the bcrypt hash of your PLAIN_PASSWORD. You can generate it using the following command:

```bash
./crypto.sh hash your-basic-auth-password
```

This requires `htpasswd` to be installed on your system. You can install it using the following command:

```bash
sudo apt-get install -y apache2-utils
```

### Version Control Your .env

The `crypto.sh` uses [zypher](https://github.com/vtno/zypher) for file encryption which allows you to version control your `.env` as `.env.enc` without leaking your secrets.

You can install it using the following command (optional):
```bash
go install github.com/vtno/zypher/cmd/zypher@0.2.0
```

Then you'll be able to encrypt / decrypt your `.env` file using the following commands:

```bash
./crypto.sh enc # output: .env.enc
./crypto.sh dec # output: .env
```

The `.env.enc` is safe to be version controlled.

### Deploy the registry

Ensure `git` and `docker` (with `compose`) are installed on your target system. Then run the following command:

```bash
./up.sh user@your-server-ip registry.yourdomain.com
```

This will setup a registry on your server with the domain `registry.yourdomain.com` and run a small healthcheck. You can access your registry at `https://registry.yourdomain.com`.