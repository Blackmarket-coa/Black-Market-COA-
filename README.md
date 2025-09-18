# Farmers Collective - n8n Orchestrator

This project contains the n8n workflows and Docker configuration for the Farmers Collective orchestration layer. It is designed for local development.

## Prerequisites

-   [Docker](https://www.docker.com/products/docker-desktop/) and Docker Compose
-   [Git](https://git-scm.com/)
-   A command-line terminal

---

## 🚀 Developer Setup

Follow these steps to get a fully functional local development environment. This process involves a brief, one-time manual configuration, followed by an automated script that provisions everything for you.

### Step 1: Initial Launch

First, we'll clone the repository, create the local environment file, and start the n8n and database services.
```bash
# Clone the repository
git clone <your-repository-url>
cd <repository-folder>
```
```bash
# Create the .env file from the template
cp .env.example .env
```

# Start the services in the background
```bash
docker-compose up -d
```

### Step 2: Manual GUI Configuration (One-Time Only)

n8n requires the initial owner account and credentials to be created securely through its web interface. This process takes about 2-3 minutes.

1.  **Create Your Owner Account:**
    * Open your web browser and navigate to `http://localhost:5678`.
    * You will be prompted to create an owner account. Complete the setup form.

2.  **Create the Database Credential:**
    * In the left-hand menu, go to **Credentials** and click **"Add credential"**.
    * Search for and select **"Postgres"**.
    * Fill in the credential details. **These values must match your `.env` file exactly.**
        * **Credential Name:** `Local Postgres DB`  *(This name is critical for the script to find it!)*
        * **Host:** `postgres`
        * **Database:** `farmers_collective`
        * **User:** `n8n_user`
        * **Password:** `mysecretpassword`
        * **Port:** `5432`
    * Click **Save**.

3.  **Create an API Key:**
    * In the left-hand menu, navigate to **Settings > My Profile > n8n API**.
    * Click **Create an API key**. Give it a label like "dev-script" and click **Create**.
    * **Immediately copy the API key to your clipboard.** You will only see it once.

### Step 3: Automated Workflow Provisioning

Now, run the provisioning script. It will use the API key you just created to automatically import and configure all the project workflows.

# Make the script executable
```bash
chmod +x ./scripts/provision.sh
```

# Run the script
```bash
./scripts/provision.sh
```
The script will prompt you to paste the API key. Once you do, it will handle the rest.

**Congratulations! Your environment is now fully configured and ready for development.**

---

## Daily Development

-   **To start your environment:** `docker-compose up -d`
-   **To stop your environment:** `docker-compose down`
-   **To completely reset the instance (deletes all data):** `docker-compose down -v`. You will need to repeat the setup process after running this.