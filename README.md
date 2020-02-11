# hello-world-ruby-pg

This repo has a "Hello World" Ruby application that uses the [pg](https://rubygems.org/gems/pg) library to talk to [CockroachDB](https://www.cockroachlabs.com/docs/stable/).

Prerequisites: 

    $ bundle install

To run the code:

1. Start a [local, insecure CockroachDB cluster](https://www.cockroachlabs.com/docs/stable/start-a-local-cluster.html).

2. Create a `bank` database and `maxroach` user as described in [Build a Ruby app with CockroachDB](https://www.cockroachlabs.com/docs/stable/build-a-ruby-app-with-cockroachdb.html#insecure).

3. From the [SQL client](https://www.cockroachlabs.com/docs/stable/cockroach-sql.html): `GRANT ALL ON DATABASE bank TO maxroach`

4. In your terminal, from this directory:

```
$ ruby main.rb
```
