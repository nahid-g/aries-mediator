### Run it !!!

1. Copy the file `.env.sample` to `.env` in the root of the project. The default values are fine, edit as you see fit. This file will be used by `docker-compose` to add or override any environment variables.
```console
cp .env.sample .env
```
2. Provide ```NGROK_AUTHTOKEN``` in .env file.
3. Run ```docker-compose up``` to start mediator. It will provide "mediator invitation url" for wallet.

Note:
- you need to have docker-compose installed in your pc