# Standalone Pact Stub Server

[![Build](https://github.com/uglyog/pact-stub-server/workflows/Build/badge.svg)](https://github.com/uglyog/pact-stub-server/actions?query=workflow%3ABuild)

This project provides a server that can generate responses based on pact files. It is a single executable binary. 
It implements the [V4 Pact specification](https://github.com/pact-foundation/pact-specification/tree/version-4).

[Docker Image](https://hub.docker.com/r/pactfoundation/pact-stub-server)

[Online rust docs](https://docs.rs/crate/pact-stub-server)

The stub server works by taking all the interactions (requests and responses) from a number of pact files. 
For each interaction, it will compare any incoming request against those defined in the pact files. If there is a match 
(based on method, path and query parameters), it will return the response from the pact file.

**Note:** The stub server was designed to supporting prototyping of mobile applications by stubbing out the
backend servers. It will always try to return a response, even when there is not an extract match with the
pact files.

## Command line interface

The pact stub server is bundled as a single binary executable `pact-stub-server`. Running this without any options displays the standard help.

```console
./pact-stub-server v0.5.0
Pact Stub Server

USAGE:
    pact-stub-server [OPTIONS]

OPTIONS:
    -b, --broker-url <broker-url>
            URL of the pact broker to fetch pacts from [env: PACT_BROKER_BASE_URL=]

        --consumer-names <consumer-names>...
            Consumer names to use to filter the Pacts fetched from the Pact broker

        --cors-referer
            Set the CORS Access-Control-Allow-Origin header to the Referer

    -d, --dir <dir>
            Directory of pact files to load (can be repeated)

    -e, --extension <ext>
            File extension to use when loading from a directory (default is json)

        --empty-provider-state
            Include empty provider states when filtering with --provider-state

    -f, --file <file>
            Pact file to load (can be repeated)

    -h, --help
            Print help information

        --insecure-tls
            Disables TLS certificate validation

    -l, --loglevel <loglevel>
            Log level (defaults to info) [possible values: error, warn, info, debug, trace, none]

    -o, --cors
            Automatically respond to OPTIONS requests and return default CORS headers

    -p, --port <port>
            Port to run on (defaults to random port assigned by the OS)

        --provider-names <provider-names>...
            Provider names to use to filter the Pacts fetched from the Pact broker

        --provider-state-header-name <provider-state-header-name>
            Name of the header parameter containing the provider state to be used in case multiple
            matching interactions are found

    -s, --provider-state <provider-state>
            Provider state regular expression to filter the responses by

    -t, --token <token>
            Bearer token to use when fetching pacts from URLS or Pact Broker

    -u, --url <url>
            URL of pact file to fetch (can be repeated)

        --user <user>
            User and password to use when fetching pacts from URLS or Pact Broker in user:password
            form

    -v, --version
            Print version information
```

## Options

### Log Level

You can control the log level with the `-l, --loglevel <loglevel>` option. It defaults to info, and the options that you can specify are: error, warn, info, debug, trace, none.

### CORS pre-flight requests

If you specify the `-o, --cors` option, then any un-matched OPTION request will result in a default 200 response. By default the 
Access-Control-Allow-Origin header will be set to `*`. If you provide the `--cors-referer` flag, then it will be set to the
value of the Referer header from the request.

### Pact File Sources

You can specify the pacts to verify with the following options. They can be repeated to set multiple sources.

| Option | Type | Description |
|--------|------|-------------|
| `-f, --file <file>` | File | Loads a pact from the given file |
| `-u, --url <url>` | URL | Loads a pact from a URL resource |
| `-d, --dir <dir>` | Directory | Loads all the pacts from the given directory |
| `-b, --broker-url <url>` | URL | Loads all the latest pacts from the Pact Broker |

*Note:* For URLs and Pact Brokers that are authenticated, you can use the `--user` option to set the username and password or the
`--token` to use a bearer token.

#### Disabling TLS certificate validation

If you need to load pact files from a HTTPS URL that is using a self-signed certificate, you can use the `--insecure-tls`
flag to disable the TLS certificate validation. WARNING: this disables all certificate validations, including expired
certificates.

### Filtering interactions by provider state

You can filter the interactions by provider state by supplying the `--provider-state` option. This takes a regular
expression that is applied to all interactions before the requests are matched.

### Filtering interactions by consumer and provider name (Pact Broker)

For Pacts fetched from a Pact broker, you can filter the Pacts by the consumer and/or provider names using: 

```
 --consumer-names <consumer-names>...
            Consumer names to use to filter the Pacts fetched from the Pact broker
            
 --provider-names <provider-names>...
            Provider names to use to filter the Pacts fetched from the Pact broker
```

### Server Options

The running server can be controlled with the following options:

| Option | Description |
|--------|-------------|
| `-p, --port <port>` | The port to bind to. If not specified, a random port will be allocated by the operating system. |

## Running with docker

A docker image is published to `pactfoundation/pact-stub-server`.

Example of using it:

```
# Create a Stub API
docker pull pactfoundation/pact-stub-server
docker run -t -p 8080:8080 -v "$(pwd)/pacts/:/app/pacts" pactfoundation/pact-stub-server -p 8080 -d pacts

# Test your stub endpoints
curl -v $(docker-machine ip $(docker-machine active)):8080/bazbat
curl -v $(docker-machine ip $(docker-machine active)):8080/foobar
```
