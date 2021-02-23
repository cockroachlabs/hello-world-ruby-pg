# hello-world-ruby-pg

This repo has a "Hello World" Ruby application that uses the [pg](https://rubygems.org/gems/pg) library to talk to [CockroachCloud](CockroachCloud).

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
- A [running CockroachCloud cluster](https://www.cockroachlabs.com/docs/cockroachcloud/create-a-free-cluster.html).

To run the code:

1. [Connect to the CockroachCloud cluster](https://www.cockroachlabs.com/docs/cockroachcloud/connect-to-a-free-cluster.html).

1. Create a `bank` database using the SQL console.
```sql
CREATE DATABASE bank;
```

1. In your terminal, from the `hello-world-ruby-pg` directory, run the application:

```shell
ruby main.rb
```
