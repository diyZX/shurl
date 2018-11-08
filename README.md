# Shurl

Shurl is URL shortener implemented with Elixir and Maru framework ([test project](TASK.md)).

## Installation

The application requires Elixir 1.5 and OTP 20.
To run application or tests locally without Docker add appropriate config to `config/local` for your database.

* Install dependencies with `mix deps.get`
* Setup database with `mix ecto.setup`
* Run tests with `mix test`
* Start application with `mix run --no-halt`

Now you can use the application at `localhost:8888`.

Or alternatively to run application install Docker Compose which supports Compose file format 3.x. 

* Build containers with `docker-compose build`
* Run containers with `docker-compose up`

And now you can use the application at `localhost:4000`.

## Usage

Available routes:

HTTP method | Route                  | Description
----------- | ---------------------- | -------------------------
POST        | /link                  | Create short code for URL
GET         | /link/:short_code      | Show URL by short code
GET         | /:short_code           | Go to URL by short code
GET         | /analytics/:short_code | Show short code analytics

#### Examples

##### Request

```
curl -X POST -H "Content-Type: application/json" -d '{"url":"http://example.com/about/index.html?uid=<%token%>"}' 'http://127.0.0.1:4000/link'
```

##### Response
```
200 OK
{"status":"success","response":"/yfmFczV3"}
```

##### Request

```
curl -X GET 'http://127.0.0.1:4000/link/yfmFczV3'
```

##### Response
```
200 OK
{"status":"success","response":"http://example.com/about/index.html?uid=<%token%>"}
```

##### Request

```
curl -X GET 'http://127.0.0.1:4000/yfmFczV3/?token=test'
```

##### Response
```
302 Found
location: http://example.com/about/index.html?uid=test
```

##### Request

```
curl -X GET 'http://127.0.0.1:4000/analytics/yfmFczV3'
```

##### Response
```
200 OK
{"status":"success","response":{"total":1,"statistics":{"{\"accept\":\"*/*\",\"host\":\"127.0.0.1:4000\",\"user-agent\":\"curl/7.47.0\"}":1}}}
```
