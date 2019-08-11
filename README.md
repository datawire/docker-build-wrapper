# Example wrapper around `docker build`

## Introduction

At one point, I had thought it would be a good idea to build a wrapper
around `docker build`, that supported *mostly* the same set of flags,
with a few overrides.  I ended up deciding that this was the wrong
approach, but I don't want to lose track of the knowledge I built up
trying to do it, so this repo is a slightly cleaned-up version of that
before I scrapped it.

My first thought was to parse the `docker build --help` output to get
a list of flags.  This approach has [worked well for me before with
other programs][emacsutils].  However, this isn't a great approach
with Docker, because there are several "hidden" flags that don't
appear in `--help` that we would nevertheless like to support.

My next thought was "I can just copy/paste the list of flags from the
Docker source code".  That turns out to not be great, because there's
a bit too much metaprogramming going on.

My next thought was to just import the package from the Docker source
code that defines all the flags.  This ended up working well, but
requires a few tricks to get the right UX.  It is my intent that this
repository serves as a "how-to" for doing that.


[emacsutils]: https://git.lukeshu.com/emacsutils/

## dockerd feature-flags

`docker build` has several options that are behind `dockerd`-side
feature-flags; `docker build --help` talks to the `dockerd` to decide
which flags to show you.  I decided that talking to `dockerd` was too
much complexity for a wrapper, and that I would just allow all flags
to appear in the `--help`, and let `docker build` show you its usual
error message if you used one that `dockerd` has disabled:

```patch
$ diff -u <(docker build --help) <(./docker-build-wrapper --help)
--- /dev/fd/63  2019-08-28 12:50:16.621810000 -0400
+++ /dev/fd/62  2019-08-28 12:50:16.621810000 -0400
@@ -1,9 +1,21 @@
 
-Usage: docker build [OPTIONS] PATH | URL | -
+Usage: docker-build-wrapper [OPTIONS] PATH | URL | -
 
-Build an image from a Dockerfile
+A wrapper around `docker build`
 
-Options:
+Options for "docker":
+      --config string      Location of client config files (default "/home/lukeshu/.docker")
+      --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with "docker context use")
+  -D, --debug              Enable debug mode
+  -H, --host list          Daemon socket(s) to connect to
+  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
+      --tls                Use TLS; implied by --tlsverify
+      --tlscacert string   Trust certs signed only by this CA (default "/home/lukeshu/.docker/ca.pem")
+      --tlscert string     Path to TLS certificate file (default "/home/lukeshu/.docker/cert.pem")
+      --tlskey string      Path to TLS key file (default "/home/lukeshu/.docker/key.pem")
+      --tlsverify          Use TLS and verify the remote
+
+Options for "docker build":
       --add-host list           Add a custom host-to-IP mapping (host:ip)
       --build-arg list          Set build-time variables
       --cache-from strings      Images to consider as cache sources
@@ -24,11 +36,18 @@
       --memory-swap bytes       Swap limit equal to memory plus swap: '-1' to enable unlimited swap
       --network string          Set the networking mode for the RUN instructions during build (default "default")
       --no-cache                Do not use cache when building the image
+  -o, --output stringArray      Output destination (format: type=local,dest=path)
+      --platform string         Set platform if server is multi-platform capable
+      --progress string         Set type of progress output (auto, plain, tty). Use plain to show container output (default "auto")
       --pull                    Always attempt to pull a newer version of the image
   -q, --quiet                   Suppress the build output and print image ID on success
       --rm                      Remove intermediate containers after a successful build (default true)
+      --secret stringArray      Secret file to expose to the build (only if BuildKit enabled): id=mysecret,src=/local/secret
       --security-opt strings    Security options
       --shm-size bytes          Size of /dev/shm
+      --squash                  Squash newly built layers into a single new layer
+      --ssh stringArray         SSH agent socket or keys to expose to the build (only if BuildKit enabled) (format: default|<id>[=<socket>|<key>[,<key>]])
+      --stream                  Stream attaches to server to negotiate build context
   -t, --tag list                Name and optionally a tag in the 'name:tag' format
       --target string           Set the target build stage to build.
       --ulimit ulimit           Ulimit options (default [])
```

We see that `docker build --help` is hiding the `--output`,
`--platform`, `--progress`, `--secret`, `--squash`, `--ssh`, and
`--stream` flags from me, but that `docker-build-wrapper --help`
isn't.  If I try one of them with either tool, I get the same error
message, though:


```console
$ docker build --squash .
"--squash" is only supported on a Docker daemon with experimental features enabled

$ ./docker-build-wrapper --squash .
"--squash" is only supported on a Docker daemon with experimental features enabled
```

## Where to go from here

See `main.go` for getting the code right, and `go.sum` for getting the
dependency versions right.
