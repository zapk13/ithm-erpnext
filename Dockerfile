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
COPY --chown=frappe:frappe ./apps/education ./apps/education
COPY --chown=frappe:frappe ./sites/common_site_config.json ./sites/common_site_config.json
COPY --chown=frappe:frappe ./sites/ithm.local ./sites/ithm.local

# Expose ports
EXPOSE 8000 9000 6787

# Start command
CMD ["bash", "/home/frappe/frappe-bench/start.sh"]