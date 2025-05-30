name: Terraform CI/CD

on:
  push:
    branches:
      - main # Or your default branch
  pull_request:
    branches:
      - main

env:
  TF_WORKING_DIR: ./terraform # Adjust if your .tf files are in a subdirectory

jobs:
  terraform_plan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.11.1 # Specify  Terraform version
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Terraform fmt
        id: fmt
        run: terraform fmt -check
        continue-on-error: true

      - name: Terraform Init
        id: init
        run: terraform init -backend-config="bucket=${{ secrets.TF_STATE_BUCKET }}" -backend-config="key=${{ env.TF_WORKING_DIR }}/terraform.tfstate" -backend-config="region=${{ secrets.AWS_REGION }}"
        working-directory: ${{ env.TF_WORKING_DIR }}

      - name: Terraform Validate
        id: validate
        run: terraform validate
        working-directory: ${{ env.TF_WORKING_DIR }}

      - name: Terraform Plan
        id: plan
        run: terraform plan -no-color -input=false
        working-directory: ${{ env.TF_WORKING_DIR }}
       
      - name: Store Plan Artifact
        uses: actions/upload-artifact@v4
        with:
          name: terraform-plan
          path: ${{ env.TF_WORKING_DIR }}/tfplan.binary # Store the binary plan

      - name: Add Plan to PR Comment
        uses: actions/github-script@v7
        if: github.event_name == 'pull_request'
        with:
          script: |
            const fs = require('fs');
            const planOutput = fs.readFileSync('${{ env.TF_WORKING_DIR }}/tfplan.binary', 'utf8'); // or 'plan.txt' if you saved text
            const output = `
            ## Terraform Plan Results:
            \`\`\`hcl
            ${planOutput}
            \`\`\`
            `;
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: output
            })

  terraform_apply:
    needs: terraform_plan # This job only runs if plan is successful
    if: github.event_name == 'push' && github.ref == 'refs/heads/main' # Only apply on push to main branch
    runs-on: ubuntu-latest
    environment: production # Link to a GitHub Environment
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.11.1 # Specify  Terraform version
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Download Plan Artifact
        uses: actions/download-artifact@v4
        with:
          name: terraform-plan
          path: ${{ env.TF_WORKING_DIR }} # Download to the working directory

      - name: Terraform Init (for apply)
        run: terraform init -backend-config="bucket=${{ secrets.TF_STATE_BUCKET }}" -backend-config="key=${{ env.TF_WORKING_DIR }}/terraform.tfstate" -backend-config="region=${{ secrets.AWS_REGION }}"
        working-directory: ${{ env.TF_WORKING_DIR }}

      - name: Terraform Apply
        run: terraform apply -auto-approve tfplan.binary # Apply the stored binary plan
        working-directory: ${{ env.TF_WORKING_DIR }}
