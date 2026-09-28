Here's the full runbook, from a cold start to presenting, 

**1. Start Docker.** Open **Docker Desktop** from Applications and wait until the whale icon in the menu bar stops animating.

**2. Open your project and activate Python:**
```bash
cd ~/insurance_dbt
source .venv/bin/activate
```

**3. Make sure Cube isn't holding the database:**
```bash
docker compose -f cube/docker-compose.yml stop
```

**4. Build and test the data:**
```bash
dbt build
```
The last line should read `PASS=50 WARN=2 ERROR=0`.

**5. Run the hand-written SQL checks:**
```bash
dbt show --select active_policies
dbt show --select avg_days_to_settlement
dbt show --select loss_ratio_by_policy_type
dbt show --select loss_ratio_fanout
```
You should get 7, then 41.6, then Auto 21.58 / Home 1.85 / Life 1.39. The last one shows the intentionally wrong fan-out numbers.

**6. Start the semantic layer:**
```bash
docker compose -f cube/docker-compose.yml up -d
```

**7. Open the Playground** at `http://localhost:4000`.

## During the demo: queries to run in the Playground

| Business question | Measures to select | Dimensions to select | Expected result |
|---|---|---|---|
| How many active policies? | `dim_policy.active_policy_count` | none | 7 |
| Average time to settle? | `fact_claims.avg_days_to_settlement` | none | 41.6 |
| Loss ratio by policy type? | `fact_claims.loss_ratio` | `dim_policy.policy_type` | 21.58 / 1.85 / 1.39 |
| Showcase of joins without double-counting | `dim_customer.customer_count`, `dim_customer.avg_age`, `fact_premium_transaction.total_premium_collected` | `dim_customer.customer_segment`, `dim_policy.policy_type` | Customers aren't inflated by their transactions |

For each query, also click the **Generated SQL** tab. That shows the reviewers that Cube writes the SQL for analysts, and it gives you a chance to point out how the loss ratio aggregates premium by policy key before dividing.

For the fan-out story, run `dbt show --select loss_ratio_fanout` in Terminal: Auto premium comes out at 43,104 instead of the correct 25,076. Then show the Cube loss ratio returning the correct value.

## Useful commands if something goes wrong mid-demo

```bash
docker ps                                          # is Cube running? look for cube-cube-1
docker compose -f cube/docker-compose.yml logs cube --since 2m    # recent Cube errors
docker compose -f cube/docker-compose.yml up -d --force-recreate  # full Cube restart
```

## stop the cube once done

```bash
docker compose -f cube/docker-compose.yml stop
deactivate
```
Then quit Docker Desktop if you like.

## First-time setup on a new machine (for the README)

This is the sequence your fresh-clone test proved works:

```bash
git clone https://github.com/jeeeet25/insurance-semantic-layer.git
cd insurance-semantic-layer
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
dbt build
docker compose -f cube/docker-compose.yml up -d
```
Then open `http://localhost:4000`. The prerequisites are Python 3.9 or newer, Docker Desktop, and Git.

Two rules to remember, and to state in the README:
- **Always stop Cube before running `dbt build`.** DuckDB allows only one writer, so the build fails while Cube has the file open.
- **Always run commands from the project folder.** Running `docker compose` from anywhere else can pick up a different compose file, which is how the Airflow containers got stopped earlier.
