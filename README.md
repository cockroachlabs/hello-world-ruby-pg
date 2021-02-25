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

To run the code:

1. Start an empty [demo CockroachDB cluster](https://www.cockroachlabs.com/docs/stable/cockroach-demo).

    ~~~shell
    cockroach demo --empty
    ~~~

1. Create a `bank` database and `maxroach` user as described in [Build a Ruby app with CockroachDB](https://www.cockroachlabs.com/docs/stable/build-a-ruby-app-with-cockroachdb-activerecord.html).

1. From the [SQL client](https://www.cockroachlabs.com/docs/stable/cockroach-sql.html): `GRANT ALL ON DATABASE bank TO maxroach`

1. Modify the connection parameters in `main.rb` to set the username, password, and port.

    ```ruby
    user: '{username}',
    password: '{password}',
    dbname: 'bank',
    host: 'localhost',
    port: {port},
    sslmode: 'verify'
    ```

1. In your terminal, run the code from the `hello-world-ruby-pg` directory:

    ```shell
    ruby main.rb
    ```
