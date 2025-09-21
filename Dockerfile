# Use the official ERPNext image as base
FROM frappe/erpnext:latest

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install additional dependencies
USER root
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Switch back to frappe user
USER frappe

# Set working directory
WORKDIR /home/frappe/frappe-bench

# Copy configuration files
COPY --chown=frappe:frappe ./sites/common_site_config.json ./sites/common_site_config.json
COPY --chown=frappe:frappe ./sites/ithm.local ./sites/ithm.local

# Create apps directory (will be populated by ERPNext installation)
RUN mkdir -p ./apps

# Copy start script
COPY --chown=frappe:frappe ./start.sh ./start.sh
RUN chmod +x ./start.sh

# Expose ports
EXPOSE 8000 9000 6787

# Start command
CMD ["bash", "./start.sh"]