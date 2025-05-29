# Docker Compose Services

Internal folders mounted to containers have a parent folder of the service name. Configurations that do not work are marked with a `issues.txt` file in the respective service folder.

No containers or credentials should be shared between services. This is to ensure that the services are isolated from each other. This is to prevent any potential unwanted deletion risks. Communication between containers within the same service should be done through the service name. This is to ensure that the containers can communicate with each other without any issues... that is unless meant to be exposed on their own.

Ports will be allocated as needed with closest to default protocol port first. Duplicates will be checked by docker itself on `up` command or manually in the case of externally hosted services. Notable exceptions below and in `firewall.env` file:

- 'ssh' will be on port 22/tcp.
- 'samba' will be on ports 137/udp, 138/udp, 139/tcp and 445/tcp.

The service name will be prefixed with the project name e.g. `sonarqube_postgresql`. If there are multiples of the base service required, they will be postfixed with a number e.g. `sonarqube_postgresql_1`.

You can run the `docker_ufw_allow.sh` and `docker_ufw_prune.sh` scripts to allow and prune the firewall rules respectively. This will allow the running docker services to be accessed from the outside world without pruning the specified exceptions by rule comment, those have to be managed manually.

## DEPENDENCIES

- `duplicati` requires a wireguard connection on the host system to connect to the backup server. This is not included in the docker-compose file.
- External access to services is provided by the cloudfare proxy. This is not included in the docker-compose file. Ergo, password manager items will be referred to by the proxy address followed by the local too. This can be done in `https://one.dash.cloudflare.com/ -> Networks -> Tunnels`. [Further instructions here...](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/)

## FORMATTING

To format all `docker-compose.yml` files in the repository, install `jbockle.jbockle-format-files` in VSCode and do `Start Format Files: From Glob` command with `**/*.yml`
