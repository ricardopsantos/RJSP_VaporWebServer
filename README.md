# RJSP_HerokuApp1

--

# Heroku: 

## Server

[https://dashboard.heroku.com/apps/pacific-hollows-25711/activity](https://dashboard.heroku.com/apps/pacific-hollows-25711/activity)

## Server management

__Heroku: Deploy__ Dont work with test target enabled)

Prepare

```bash
heroku plugins:install heroku-builds
heroku builds:cancel -a pacific-hollows-25711
heroku restart
heroku builds
```

Option 1


```bash
git add .
git commit -m 'changes'
git push heroku master
```

Option 2

```bash
git add .
git commit -m 'changes'
vapor heroku push
```

--

__Fixing Error: Your account has reached its concurrent build limit__ [__(Source)__](https://stackoverflow.com/questions/47028871/heroku-your-account-has-reached-its-concurrent-build-limit)

```bash
heroku restart
heroku plugins:install heroku-builds
heroku builds:cancel -a pacific-hollows-25711
```

--

__See logs__

https://coralogix.com/log-analytics-blog/heroku-logs-the-complete-guide/

```bash
heroku logs --tail
heroku logs -tp router
heroku logs --tail --source app
heroku logs --tail --source app --dyno api
heroku logs --tail --source heroku
```

--

__Generic informations__

```bash
heroku config
heroku apps:info
```

__Kill (local) apps on port 5678__

```
kill $(lsof -t -i:5678)
```

## Test Cases


https://pacific-hollows-25711.herokuapp.com

http://127.0.0.1:8080

https://pacific-hollows-25711.herokuapp.com/hello/maria

https://pacific-hollows-25711.herokuapp.com/version

```
curl http://localhost:5678
It
```

```
curl http://localhost:5678
curl https://pacific-hollows-25711.herokuapp.com

curl http://localhost:5678/version
curl https://pacific-hollows-25711.herokuapp.com/version

curl http://localhost:5678/configuration
curl https://pacific-hollows-25711.herokuapp.com/configuration
```

## Tutorials

* [Vapor and Job Queues: Getting Started](https://www.raywenderlich.com/18510630-vapor-and-job-queues-getting-started)
* [Vapor : Deply to Heroku](https://docs.vapor.codes/4.0/deploy/heroku)
* [Vapor : Query](https://docs.vapor.codes/4.0/fluent/query)
