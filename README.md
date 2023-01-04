this is an extension for [`logging`](https://pub.dev/packages/logging) package provided by [`dart.dev`](https://pub.dev/publishers/dart.dev/packages)

built to make logging using web sockets easier

this package can be extended to use `http request` instead of socket connection
but as its a logging solution i will not recommend to use `http requests`

## server cli

> for debugging purposes only
type in cmd/terminal:

```bash
dart pub global activate socket_logging
```

then this will activate `log_server` command that can be used to serve
a websocket server on your machine

todo:

- [ ] handel web socket instances internally
