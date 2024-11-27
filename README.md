# vulnerable-by-design
Group of Terraform projects to deploy vulnerable infrastructure to use with cloud security tools

## Development Environment

This project includes devcontainer configurations for consistent development environments:

### Prerequisites
- [VS Code](https://code.visualstudio.com/)
- [Docker](https://www.docker.com/)
- [VS Code Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Available Devcontainers
- `terraform`: Includes Terraform, AWS CLI, and common infrastructure tools
- `kubernetes`: Includes kubectl, helm, and k8s development tools

To use the devcontainers:
1. Open the project in VS Code
2. Press F1 and select "Remote-Containers: Reopen in Container"
3. Choose the desired development container
