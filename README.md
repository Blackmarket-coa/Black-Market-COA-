# Farmers Collective - n8n Orchestrator

This project contains the n8n workflows and Docker configuration for the Farmers Collective orchestration layer. It is designed for local development and collaboration.

## Prerequisites

* [Docker](https://www.docker.com/products/docker-desktop/) and Docker Compose
* [Git](https://git-scm.com/)
* A command-line terminal

## 🚀 Developer Setup

Follow these steps to get a fully functional local development environment. This is a one-time setup process that takes about 5-10 minutes.

### Step 1: Initial Launch

First, we'll clone the repository, create the local environment file from the template, and start the n8n and database services.
```bash
# Clone the repository
git clone https://github.com/Blackmarket-coa/Black-Market-COA-
```
```bash
# cd into newly created project
cd Black-Market-COA-
```
```bash
# Create the .env file from the template
cp ."env example" .env
```
```bash
# Start the services in the background
docker-compose up -d
```
### Step 2: Manual n8n Configuration

n8n requires the initial owner account and credentials to be created securely through its web interface.

1.  **Create Your Owner Account:**
    * Open your web browser and navigate to `http://localhost:5678`.
    * You will be prompted to create an owner account. Complete the setup form.

2.  **Create the Database Credential:**
    * In the left-hand menu, go to **Credentials** and click **"Add credential"**.
    * Search for and select **"Postgres"**.
    * Fill in the credential details. **These values must match your `.env` file exactly.**
        * **Credential Name:** `Local Postgres DB` *(This name is for your reference).*
        * **Host:** `postgres`
        * **Database:** `farmers_collective`
        * **User:** `n8n_user`
        * **Password:** `mysecretpassword`
        * **Port:** `5432`
    * Click **Save**.

3.  **Import the Workflows:**
    * In the left-hand menu, go to **Workflows**.
    * Click the **"Import"** button and choose **"Import from File"**.
    * Navigate to the `n8n_workflows` directory in your project folder.
    * Import each `.json` workflow file one by one.
    * After importing a workflow, you may need to manually link the Postgres nodes to the `Local Postgres DB` credential you just created. Open the workflow, click on each Postgres node, and select the credential from the dropdown.
    * **Save** each workflow after configuring it.

**Congratulations! Your environment is now fully configured and ready for development.**

## Daily Development

* **To start your environment:** `docker-compose up -d`
* **To stop your environment:** `docker-compose down`
* **To completely reset the instance (deletes all data):** `docker-compose down -v`. You will need to repeat the entire setup process after running this.
