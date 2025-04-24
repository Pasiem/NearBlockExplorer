# NearBlockExplorer:

  NearBlockExplorer is a simulated block explorer using a mock API for the Near blockchain.

## Set Up:

- install [redis](https://redis.io/docs/latest/operate/oss_and_stack/install/archive/install-redis/)
- run `bundle install`
- create .env file at the root of the repository and define `NEAR_API_KEY='SECRET_API_KEY'`

## Run Locally:

- run `redis-server` to start the redis server
- run `bundle exec sidekiq` to start sidekiq server
- run `bin/rails server` to start the app
- go to http://localhost:3000/index in your browser and you should see:
  <img width="1275" alt="Transfers List" src="https://github.com/user-attachments/assets/66b92a7d-2206-47b7-b282-dd4b8624d3c9" />


## Assumptions:

- Every transaction has only 1 action, but in future there could be more.

- The deposit value for a transfer is determined by the deposit attribute of a transaction's 
  singular action of type Transfer.

- The transactions returned by the API may or may not be in chronological order.

- Display only successful Transfer transactions.

- The only API endpoint available for NEAR blockchain data is the one provided. Ex. There is no
endpoint for fetching a transaction by it's hash or id.

## Decisions Made:

- Store aggregate data (contains_transfer and transfer_deposit) on BlockTransactions to remove the need to query Actions.

- Enforce uniqueness constraint on trans_hash for BlockTransactions. This ensures Transactions aren't duplicated
when fetching from the API.

- Create and store Actions. Although we store the aggregate data on BlockTransactions, storing 
Actions allows us to maintain historical records for all Actions in the event we want to surface types other
than 'Transfer' or attributes other than 'deposit'. This also allows Actions to scale independantly.

- Storing transfer_deposit as a string on BlockTransactions. One reason for this decision was the size limit of integer in SQLite,
the second is that the value is returned by the API as a string, suggesting this is standard convention. The trade off to this being
losing the ability to sort and filter numerically at the database level.

- Storing additional data in both BlockTransactions and Actions and effectively creating a copy of the Near blockchain. Since the only 
API endpoint provided returns 'changing' data this copy allows for the possibility to create different features and reference historical transactions.
Ex, if we want to add the ability filter, group or search by block_hash or height.

- Storing Actions.data as a json column. This provides flexibity in the schema to save different Action types with varying data structures.

- Run UpdateTransactions worker on application start up. This ensures that the database will be populated when running the app locally.

- Run UpdateTransactions as a recurring cron job every 10 minutes. see config/schedule.yml
