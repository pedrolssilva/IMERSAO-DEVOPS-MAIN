# ---- Builder Stage ----
# This stage installs build dependencies and Python packages. Using a multi-stage
# build keeps the final image small and clean by not including build tools.
# FROM python:3.13.4-alpine3.22 AS builder
FROM python:3.13.4-alpine3.22

# Install build-time dependencies required for some Python packages with C extensions.
# This is a robust practice for Alpine-based images.
# RUN apk add --no-cache build-base

# Create a virtual environment to isolate dependencies
WORKDIR /app
# RUN python -m venv /opt/venv
# ENV PATH="/opt/venv/bin:$PATH"

# Copy and install requirements. This is done in a separate layer to leverage Docker's cache.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# ---- Final Stage ----
# This stage creates the final, lean image for production.
# FROM python:3.13.4-alpine3.22

# WORKDIR /app

# Create a non-root user and group for better security
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the virtual environment and application code
# COPY --from=builder /opt/venv /opt/venv
COPY . .

# Activate the virtual environment, set ownership, and switch to the non-root user
# ENV PATH="/opt/venv/bin:$PATH"
# RUN chown -R appuser:appgroup /app
# USER appuser

# Expose the port the app runs on and define the startup command
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
