# Farmers Collective - n8n Orchestrator

This project contains the n8n workflows and Docker configuration for the Farmers Collective orchestration layer. It is designed for local development.PrerequisitesDocker and Docker ComposeGitA command-line terminal🚀 
## Quickstart: First-Time Developer Setup
Follow these steps to get a fully functional local development environment running.
1. Clone the Repositorygit clone <your-repository-url>
cd <repository-folder>
2. Create Your Environment FileCopy the provided template to create your local .env file. The default values are suitable for local development.cp .env.example .env
3. Start the ServicesThis command will download the necessary Docker images and start the n8n and PostgreSQL containers.docker-compose up -d
4. Configure n8n (One-Time Manual Setup)The first time you start the instance, you need to configure it.
  * Create Your Owner AccountOpen your web browser and navigate to http://localhost:5678.You will be prompted to create an owner account. Complete the setup form.
  * Import the Workflows
    * From the main n8n dashboard, click the "Import" button and select "Import from File". 
    * Navigate to the n8n_workflows directory in this project.
    * Import all the .json workflow files one by one.
  * Create the Database Credential
    * The workflows need to connect to the local PostgreSQL database. In the left-hand menu, go to Credentials and click "Add credential".
    * Search for and select "Postgres".
    * Fill in the credential details. These values must match your .env file and Docker Compose configuration exactly.
      * Credential Name: Local Postgres DB (or any name you prefer)
      * Host: postgresDatabase: farmers_collective
      * User: n8n_userPassword: mysecretpassword
      * Port: 5432* Click Save.
  * Configure the Main Orchestrator Workflow
    * Go back to the "Workflows" list and open the "Farmers Collective - Main Orchestrator" workflow.
    * Link the Database Credential:
      * Click on the "Log to Orchestrator DB" node.
      * In the "Credential" field, select the "Local Postgres DB" credential you just created.
      * Repeat this for the "Update Orchestrator Log" node.
    * Update the Webhook URLs:
      * The workflow needs to call other local workflows. You must update the placeholder URLs.
      * Click on the "Call AI Planning Workflow" node.
      * Change the URL to http://n8n:5678/webhook/ai-crop-planning.Repeat this for all five "Call..." HTTP Request nodes, updating each with the correct local path (e.g., /webhook/merchant-trading, /webhook/mutual-aid, etc.).
      * Save Your Changes: Click the "Save" button at the top of the canvas.
Your environment is now fully configured and ready for development!

## Everyday Development
  * To start your environment: docker-compose up -d
  * To stop your environment: docker-compose down
  * To reset everything (deletes all data): docker-compose down -v
## Testing the Main Orchestrator
  * Open the "Main Orchestrator" workflow in the n8n GUI.Click the "Main API Gateway" node and copy the 
  * Test URL.Click "Listen for Test Event".In your terminal, send a curl request to the Test URL:
        ```bash
        curl 
        -X POST \
YOUR_TEST_URL_HERE \
-H "Content-Type: application/json" \
-d '{
  "action": "ai_schedule",
  "role": "farmer",
  "userId": "user-123"
}'
```
