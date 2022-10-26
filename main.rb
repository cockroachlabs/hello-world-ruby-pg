#!ruby

require 'pg'

def set_app_name(conn)
  conn.transaction do |txn|
    txn.exec('SET application_name = docs_simplecrud_pg')
  end
end

def create_accounts(conn)
  conn.transaction do |txn|
    txn.exec('CREATE TABLE IF NOT EXISTS accounts (id INT PRIMARY KEY, balance INT)')
    txn.exec('INSERT INTO accounts (id, balance) VALUES (1, 1000), (2, 250)')
  end
end

def print_balances(conn)
  puts '------------------------------------------------'
  printf "print_balances(): Balances as of '%s':\n", Time.now
  conn.transaction do |txn|
    txn.exec('SELECT id, balance FROM accounts') do |res|
      res.each do |val|
        puts val
      end
    end
  end
end

def delete_accounts(conn)
  conn.transaction do |txn|
    txn.exec('DELETE from accounts where ID > 0')
  end
end

def transfer_funds(conn, from, to, amount)
  puts '------------------------------------------------'
  puts "transfer_funds(): Trying to transfer #{amount} from account #{from} to account #{to}"
  conn.transaction do |txn|
    txn.exec_params('SELECT balance FROM accounts WHERE id = $1', [from]) do |res|
      res.each do |row|
        raise 'insufficient funds' if Integer(row['balance']) < amount
      end
    end
    txn.exec_params('UPDATE accounts SET balance = balance - $1 WHERE id = $2', [amount, from])
    txn.exec_params('UPDATE accounts SET balance = balance + $1 WHERE id = $2', [amount, to])
  end
end

def test_retry_loop(conn)
  conn.transaction do |txn|
    txn.exec('SELECT now()')
    txn.exec("SELECT crdb_internal.force_retry('1s'::INTERVAL)")
  end
end

# Wrapper for a transaction.
# This automatically re-calls "op" with the open transaction as an argument
# as long as the database server asks for the transaction to be retried.
def run_transaction(conn, op)
  retries = 0
  max_retries = 3
  while true
    retries += 1
    if retries == max_retries
      err = "Transaction did not succeed after #{retries} retries"
      raise err
    end

    begin
      op.call(conn)

        # If we reach this point, we were able to commit, so we break
        # from the retry loop.
        break

    rescue PG::TRSerializationFailure
      # This is a retry error, so we roll back the current
      # transaction and sleep for a bit before retrying. The
      # sleep time increases for each failed transaction.
      # conn.rollback
      puts "EXECUTE SERIALIZATION_FAILURE BRANCH"
      sleep_secs = (2**retries).floor
      puts "Sleeping for #{sleep_secs} seconds"
      sleep(sleep_secs)
      next
    end
  end
end

def main()
  # BEGIN connect
  conn = PG.connect(ENV['DATABASE_URL'])
  # END connect

  # Set to true to test the retry loop logic in `run_transaction'.
  $force_retry = false

  if $force_retry
    # The function below is used to test the transaction retry logic.  It
    # can be deleted from production code.
    run_transaction(conn,
                    lambda { |conn|
                      test_retry_loop(conn)
                    })
  else
    amt = 100
    from_id = 1
    to_id = 2
    
    set_app_name(conn)
    create_accounts(conn)
    print_balances(conn)

    run_transaction(conn,
                    lambda { |conn|
                      transfer_funds(conn, from_id, to_id, amt)
                    })

    print_balances(conn)
    delete_accounts(conn)
  end

  conn.close()
end

main()
