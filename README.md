# env-echo

This is a really basic flask application I am using to watch how K8s service round robin happens.

## The app

The application is just a single `python:slim` flask app that runs in a single container.

Execution of the application is best driven from a Makefile:

```
$ make
+------------------+
| env-echo targets |
+------------------+
build        Build env-echo locally
dev          Start dev env-echo container
shell        Start a /bin/bash shell on env-echo container
up           Start immutable env-echo container
exec         Exec /bin/bash into running env-echo
watch        Start a watch commmand
login        Log into registry
publish      Build locally and publish to registry
deploy       Deploy env-echo to Kuberentes
```

You can certainly run this locally but be aware that the output is not helpful.

``` bash
$ curl localhost:5000
{
  "META": "Here is some info about this pod", 
  "NODE_NAME": null, 
  "POD_IP": null, 
  "POD_NAME": null
}
```

Deploy this an it will look much better:

