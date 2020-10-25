# Sample Dockerized Service

This repo serves as a very simple containerized service, complete with health
check.

This service has no persistent storage requirements or external dependencies.

## Endpoints

* The default endpoint, `/`, displays a randomly generated ascii-art maze. You
  can adjust the `width` and/or `height` of the maze via GET parameters.
* The healthcheck endpoint `/healthcheck` simply returns the word "Healthy"
  with a 200 status code.

## Building

```
docker build -t sample-service .
```

## Running

```
docker run -p 5000:5000 -it sample-service
```

You can then go to http://localhost:5000 in your browser to view the service.
