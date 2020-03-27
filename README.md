# whatflix

# Prerequisites

```
NODE
NPM
POSTGRES
```

# How to Run

* `npm i` to install dependencies
* create .env file similar to sample-env file
* run `./dev/db/init.sh` to initialize DB
* run `./dev/db/refresh.sh` to refresh DB and insert intial data
* Run `npm start` or `node server.js` to run server

# APIs

* `/movies/user/100/search?text=Tom Hanks`
* `/movies/users`
