[![Build Status](https://travis-ci.org/nvmlabs/kong-dynamic-upstream.svg?branch=master)](https://travis-ci.org/nvmlabs/kong-dynamic-upstream)

# kong-dynamic-upstream
A Kong plugin that sets different upstream URLs based on API and Consumer.

The path of the user's request to the API will be appended to the end of the replacement URL.
The ```strip_request_path``` parameter will be respected.

A request to an API at /foo, http://kong/foo/bar,
by a consumer with the ```dynamic-upstream``` plugin configured with a ```replacement_url``` of https://snafu:4242
will be directed to https://snafu:4242/bar.

The replacement URL must contain:
- a new scheme, eg. _HTTPS_
- a new hostname, eg. _mockbin.com_

Optionally you can include:
- a new port, eg. _:8080_
- a new path, eg. _/path_

Some example replacement URLs are:
- http://localhost:8081/
- https://mockbin.org/bin/e5d28230-7462-46cb-8c90-58784104bc1d

---

## Installation
Clone the repository, navigate to the root folder and run:
```
make install
```

Edit your ```kong.yaml``` to include the plugin like so:
```yaml
custom_plugins:
  - dynamic-upstream
```

Restart Kong.

## Development
For a detailed guide on Kong plugin development, check out the official documentation
at https://getkong.org/docs/0.8.x/plugin-development/.

This plugin requires Lua 5.1 and the associated version of luarocks. Once you have these installed,
to get the development dependencies run the following command:

```
make dev
```

## Configuration
This plugin can work when attached to All Consumers but really only makes sense when added to a specific Consumer to an API. You can add this plugin to a Consumer by making the following request to your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=dynamic-upstream" \
    --data "consumer_id=6e62b030-c931-4c72-a012-6be18df81d49" \
    --data "config.replacement_url=http://newupstream:4353/path"
```

```api:``` The ```id``` or ```name``` of the API that this plugin configuration will target

| Form Parameter | Required    | Description |
| --------------:| ----------- | ----------- |
| ```name``` | *required*  | The name of the plugin to use, in this case: ```dynamic-upstream``` |
| ```consumer_id``` | *optional*    | The id of the Consumer to redirect |
| ```config.replacement_url``` | *required*    | The url to replace the default upstream specified in the API |
