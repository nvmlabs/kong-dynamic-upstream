[![Build Status](https://travis-ci.org/nvmlabs/kong-dynamic-upstream.svg?branch=master)](https://travis-ci.org/nvmlabs/kong-dynamic-upstream)

# kong-dynamic-upstream
A Kong plugin that sets different upstream URLs based on API and Consumer.

The path of the user's request to the API will be appended to the end of the replacement URL.
The ```strip_request_path``` parameter will be respected.

A request to an API at /foo that is set to strip the request path, [http://kong/foo/bar](http://kong/foo/bar),
by a consumer with the ```dynamic-upstream``` plugin configured with a ```replacement_url``` of [https://snafu:4242](https://snafu:4242)
will be directed to [https://snafu:4242/bar](https://snafu:4242/bar).

The replacement URL must contain:
- a scheme, eg. _HTTPS_
- a hostname, eg. _mockbin.com_

Optionally you can include:
- a port, eg. _:8080_
- a path, eg. _/path_

Any existing path in the upstream_url configured for the API will not be replaced by the plugin. For example, an API with an upstream_url of http://www.google.com/foo and a dynamic-upstream plugin with a replacement_url of http://mockbin.com/bin/1234 will route consumers to http://mockbin.com/bin/1234/foo{request_path}.

Some usage examples of valid replacement URLs:
- [http://localhost:8081/](http://localhost:8081/)
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
This plugin can work when attached to All Consumers but really only makes sense when added to a specific Consumer to an API. You can add this plugin to an API and Consumer by making the following request to your Kong server:

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
| ```config.replacement_url``` | *required*    | The URL to replace the default upstream specified in the API |


## Usage Examples
This table details the expected behaviour of the plugin for most of the possible combinations of API and dynamic-upstream plugin configurations.

| API upstream_url         | API request_path | strip_request_path | Requested Path | dynamic-upstream replacement_url | Upstream                                    |
| ------------------------ | ---------------- | ------------------ | -------------- | -------------------------------- | ------------------------------------------- |
| http://google.com        | /foo             | true               | /foo           | https://localhost:9999           | https://localhost:9999                      |
| http://google.com        | /foo             | false              | /foo           | https://localhost:9999           | https://localhost:9999/foo                  |
| http://google.com        | /foo             | true               | /foo/bar       | https://localhost:9999           | https://localhost:9999/bar                  |
| http://google.com        | /foo             | false              | /foo/bar       | https://localhost:9999           | https://localhost:9999/foo/bar              |
| http://google.com        | /foo             | true               | /foo           | https://mockbin.com/bin/1234     | https://mockbin.com/bin/1234                |
| http://google.com        | /foo             | false              | /foo           | https://mockbin.com/bin/1234     | https://mockbin.com/bin/1234/foo            |
| http://google.com        | /foo             | true               | /foo/bar       | https://mockbin.com/bin/1234     | https://mockbin.com/bin/1234/bar            |
| http://google.com        | /foo             | false              | /foo/bar       | https://mockbin.com/bin/1234     | https://mockbin.com/bin/1234/foo/bar        |
| http://google.com/teapot | /foo             | true               | /foo           | https://localhost:9999           | https://localhost:9999/teapot               |
| http://google.com/teapot | /foo             | false              | /foo           | https://localhost:9999           | https://localhost:9999/teapot/foo           |
| http://google.com/teapot | /foo             | true               | /foo/bar       | https://localhost:9999           | https://localhost:9999/teapot/bar           |
| http://google.com/teapot | /foo             | false              | /foo/bar       | https://localhost:9999           | https://localhost:9999/teapot/foo/bar       |
| http://google.com/teapot | /foo             | true               | /foo           | https://mockbin.com/bin/1234     | https://mockbin.com/bin/1234/teapot         |
| http://google.com/teapot | /foo             | false              | /foo           | https://mockbin.com/bin/1234     | https://mockbin.com/bin/1234/teapot/foo     |
| http://google.com/teapot | /foo             | true               | /foo/bar       | https://mockbin.com/bin/1234     | https://mockbin.com/bin/1234/teapot/bar     |
| http://google.com/teapot | /foo             | false              | /foo/bar       | https://mockbin.com/bin/1234     | https://mockbin.com/bin/1234/teapot/foo/bar |
