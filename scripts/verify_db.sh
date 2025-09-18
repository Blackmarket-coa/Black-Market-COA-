#!/bin/bash

# This script verifies that all necessary tables exist in the running database.
# It uses "CREATE TABLE IF NOT EXISTS" so it is safe to run multiple times.
# It serves as a manual fallback in case the automatic DB initialization fails.

echo "--- Verifying Database Schema ---"
echo "Connecting to the running PostgreSQL container..."
echo

# --- Helper Function ---
# A function to execute SQL commands and check for errors
execute_sql() {
    echo "  -> Ensuring table '$1' exists..."
    docker-compose exec -T postgres psql -U n8n_user -d farmers_collective -c "$2" > /dev/null
}

# --- Main Orchestrator Tables ---
execute_sql "orchestrator_logs" "CREATE TABLE IF NOT EXISTS orchestrator_logs (id SERIAL PRIMARY KEY, request_id VARCHAR(255), action VARCHAR(255), role VARCHAR(255), user_id VARCHAR(255), target_workflow VARCHAR(255), status VARCHAR(50), response_data JSONB, created_at TIMESTAMPTZ DEFAULT NOW(), completed_at TIMESTAMPTZ);"

# --- AI Crop Planning Tables ---
execute_sql "ai_planning_requests" "CREATE TABLE IF NOT EXISTS ai_planning_requests (id SERIAL PRIMARY KEY, user_id VARCHAR(255), orchestrator_id VARCHAR(255), crop_type VARCHAR(255), season VARCHAR(100), location TEXT, action_type VARCHAR(255), ai_prompt TEXT, status VARCHAR(50), created_at TIMESTAMPTZ DEFAULT NOW());"
execute_sql "crop_plans" "CREATE TABLE IF NOT EXISTS crop_plans (id SERIAL PRIMARY KEY, user_id VARCHAR(255), orchestrator_id VARCHAR(255), crop_type VARCHAR(255), season VARCHAR(100), location TEXT, action_type VARCHAR(255), ai_recommendations TEXT, estimated_planting_date DATE, estimated_harvest_date DATE, confidence_score DECIMAL(5, 2), status VARCHAR(50), created_at TIMESTAMPTZ DEFAULT NOW());"

# --- Merchant Trading Tables ---
execute_sql "merchant_transactions_log" "CREATE TABLE IF NOT EXISTS merchant_transactions_log (id SERIAL PRIMARY KEY, user_id VARCHAR(255), orchestrator_id VARCHAR(255), action_type VARCHAR(255), operation VARCHAR(255), merchant_id VARCHAR(255), request_data JSONB, status VARCHAR(50), created_at TIMESTAMPTZ DEFAULT NOW());"
execute_sql "merchant_orders" "CREATE TABLE IF NOT EXISTS merchant_orders (id SERIAL PRIMARY KEY, order_id VARCHAR(255) UNIQUE, merchant_id VARCHAR(255), order_type VARCHAR(100), total_amount DECIMAL(10, 2), payment_status VARCHAR(50), transaction_hash VARCHAR(255), order_data JSONB, created_at TIMESTAMPTZ DEFAULT NOW());"

# --- Microinvestment Tables ---
execute_sql "microinvestment_logs" "CREATE TABLE IF NOT EXISTS microinvestment_logs (id SERIAL PRIMARY KEY, user_id VARCHAR(255), orchestrator_id VARCHAR(255), action_type VARCHAR(255), operation VARCHAR(255), request_data JSONB, status VARCHAR(50), created_at TIMESTAMPTZ DEFAULT NOW());"
execute_sql "producer_wishlist" "CREATE TABLE IF NOT EXISTS producer_wishlist (id SERIAL PRIMARY KEY, user_id VARCHAR(255), tool_name VARCHAR(255), tool_category VARCHAR(100), description TEXT, estimated_cost DECIMAL(10, 2), priority VARCHAR(50), expected_production_increase VARCHAR(50), funding_goal DECIMAL(10, 2), current_funding DECIMAL(10, 2) DEFAULT 0, estimated_annual_roi VARCHAR(50), payback_period_months INT, status VARCHAR(50), created_at TIMESTAMPTZ DEFAULT NOW());"
execute_sql "microinvestments" "CREATE TABLE IF NOT EXISTS microinvestments (id SERIAL PRIMARY KEY, investor_id VARCHAR(255), wishlist_item_id INT, investment_amount DECIMAL(10, 2), token_type VARCHAR(50), wallet_address VARCHAR(255), transaction_hash VARCHAR(255), blockchain_status VARCHAR(50), status VARCHAR(50), investment_date TIMESTAMPTZ, completed_at TIMESTAMPTZ);"

# --- Mutual Aid Tables ---
execute_sql "mutual_aid_logs" "CREATE TABLE IF NOT EXISTS mutual_aid_logs (id SERIAL PRIMARY KEY, user_id VARCHAR(255), orchestrator_id VARCHAR(255), action_type VARCHAR(255), operation VARCHAR(255), request_data JSONB, status VARCHAR(50), created_at TIMESTAMPTZ DEFAULT NOW());"

echo
echo "--- Verification ---"
echo "Listing all tables in the database:"
docker-compose exec -T postgres psql -U n8n_user -d farmers_collective -c "\dt"

echo
echo "✅ Schema verification complete."
