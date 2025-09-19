# Farmers Collective Platform - Architecture Overview

**Version:** 1.0 **Date:** 2025-09-18

## 1\. Executive Summary

The Farmers Collective is a community-owned, technology-driven ecosystem designed to empower independent farmers. The platform's mission is to provide small-scale agricultural producers with the logistical, analytical, and financial power of a large enterprise without sacrificing their autonomy.

This is achieved through a hybrid architecture consisting of two primary components:

1. An **On-Farm Hub ("Farm Brain"):** A low-cost, physical device running local AI and IoT controllers on the farm.
2. A **Cloud Orchestration Hub:** A central backend service that connects the individual farm hubs, facilitating peer-to-peer communication and providing shared services.

The business model is built on accessibility, with a one-time fee for the hardware and lifetime access to the network. The platform is designed to be self-sustaining, using its own microinvestment and crowdfunding tools to fund expansion and support members in need.

## 2\. Guiding Principles

The design of this platform is guided by the following core principles:

- **Resilience:** The system must be functional even with intermittent or no internet connectivity. Core farm operations should not depend on the cloud.
- **Accessibility:** The cost of entry must be low. The user interfaces must be simple and task-oriented for a non-technical user in a field environment.
- **Community Ownership:** The platform's tools should empower the collective, not a central corporation. The economic engine should directly benefit the members.
- **Modularity:** The system is composed of distinct, decoupled components (the Hub and the Spokes) to allow for independent development and future expansion.

## 3\. High-Level Architecture

The platform utilizes a three-tiered "Hub and Spoke" model.

1. **The Edge Tier (On-Farm):** A physical device (Raspberry Pi) on each farm that runs local services. This is the primary point of interaction for the farmer.
2. **The Service Tier (The Cloud Hub):** The n8n workflows and PostgreSQL database you are building. This is the central nervous system for the entire network.
3. **The Client Tier (The Spokes):** The user interfaces, primarily a simple mobile app, that farmers use to interact with the system.


+---------------------------------+  
| Client Tier (Spokes) |  
| \[Flutter Mobile App\] \[Web Admin\]|  
+-----------------|---------------+  
| (API Calls)  
+-----------------V---------------+  
| Service Tier (The Cloud Hub) |  
| \[n8n + PostgreSQL\] |  
| (API Gateway & Business Logic) |  
+-----------------|---------------+  
| (API Calls)  
+-----------------V---------------+  
| Edge Tier (On-Farm Hub) |  
| \[Raspberry Pi + Local AI + IoT\] |  
+---------------------------------+  

## 4\. Component Breakdown

### 4.1. The On-Farm Hub ("Farm Brain")

- **Technology:** Raspberry Pi (or similar single-board computer), Python, Lightweight AI/ML libraries (e.g., TensorFlow Lite), IoT sensor/actuator libraries.
- **Responsibilities:**
  - **Offline Operation:** Execute core "action models" (e.g., irrigation schedules, pest detection from a camera feed) without an internet connection.
  - **IoT Control:** Directly interface with and control on-farm hardware like sensors, water pumps, and feeders.
  - **Local Data Cache:** Store local sensor data and operational logs.
  - **Gateway to the Cloud:** Act as the single point of communication between the farm and the Cloud Hub. It sends requests (for aid, sales, etc.) and receives updates.

### 4.2. The Cloud Orchestration Hub (n8n Backend)

- **Technology:** n8n, PostgreSQL, Docker.
- **Responsibilities:**
  - **API Gateway:** Provide a single, stable set of API endpoints (/collective-main) for all On-Farm Hubs to connect to.
  - **Business Logic Execution:** Run the core, non-real-time business processes of the collective. This includes:
    - **Orchestrator Workflow:** Route all incoming traffic to the appropriate sub-system.
    - **Mutual Aid Workflow:** Act as the "switchboard" to connect a request from one farm to potential helpers at other farms.
    - **Merchant Trading & Microinvestment Workflows:** Handle all financial transactions, fee processing, and crowdfunding logic.
    - **AI Crop Planning Workflow:** Process requests for complex, data-heavy analysis that is too intensive for the local Pi.
  - **Central Data Persistence:** The PostgreSQL database serves as the shared, canonical memory for the entire collective, storing member data, transaction histories, and shared resource availability.

### 4.3. The Client Interfaces (The Spokes)

- **Technology:** Flutter for the primary mobile app. A simple web framework (e.g., Retool or a basic React site) for an admin dashboard.
- **Responsibilities:**
  - Provide a simple, task-oriented user interface for farmers.
  - The mobile app's primary function is to act as a "remote control" for the farmer's local On-Farm Hub.
  - When an action requires the collective network (e.g., requesting aid), the app will instruct the On-Farm Hub to make the necessary API call to the Cloud Hub.

## 5\. Data Flow Example: A Mutual Aid Request

1. **Maria's tractor breaks.** She opens the Flutter app and taps "Request Aid."
2. The app sends a simple command to her local **On-Farm Hub** over her local Wi-Fi.
3. The **On-Farm Hub** formats a full mutual_aid_request JSON object and makes a secure POST request to the central **Cloud Hub's** API endpoint.
4. The **n8n Orchestrator Workflow** receives the request and routes it to the **Mutual Aid Workflow**.
5. The **Mutual Aid Workflow** logs the request and then queries the PostgreSQL database to find nearby farmers with a matching resource.
6. The **Cloud Hub** then sends outbound API calls to the **On-Farm Hubs** of the potential helpers, notifying them of Maria's request.
7. A helper, John, sees the notification on his mobile app. His acceptance is sent from his On-Farm Hub back to the Cloud Hub, which then relays the confirmation to Maria's hub.

## 6\. Future Vision: Federation

This architecture is the foundation for a future federated network. Each "Cloud Hub" can be seen as the central server for an independent collective. In the future, these hubs could communicate with each other using an open protocol like ActivityPub, allowing a farmer in one collective to trade or request aid from a farmer in a completely different collective, creating a truly resilient and scalable network of communities.
