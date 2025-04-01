# fusionpbx-docker
- FusionPBX debian Docker

#### Steps:

1. make a copy of .env.sample and rename to .env
2. git clone https://github.com/fusionpbx/fusionpbx.git && cd fusionpbx && git checkout 5.2 && cd ..
3. docker compose --env-file=./.env build
4. docker compose --env-file=./.env up


