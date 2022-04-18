# hello-world-ruby-pg

This repo has a "Hello World" Ruby application that uses the [pg](https://rubygems.org/gems/pg) library to talk to [CockroachDB](https://www.cockroachlabs.com/docs/stable/).

Prerequisites:

- Install `libpq`. For example, on OS X using Homebrew:
    ```shell
    brew install libpq
    ```
- Configure `bundle` to use `libpq`.
    ```shell
    bundle config --local build.pg --with-opt-dir="/usr/local/opt/libpq"
    ```
    Set `--with-opt-dir` to the location of `libpq` for your OS.
- Install the bundle:
    ```shell
    bundle install
    ```
- A local [CockroachDB demo cluster](https://www.cockroachlabs.com/docs/stable/cockroach-demo)

For instructions on running the code in this repo, see [Build a Ruby app with CockroachDB](https://www.cockroachlabs.com/docs/stable/build-a-ruby-app-with-cockroachdb.html).