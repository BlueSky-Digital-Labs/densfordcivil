resource "aws_ssm_document" "docker-compose-up" {
  name            = "docker-compose-up-${var.project}"
  document_type   = "Command"
  document_format = "YAML"
  target_type     = "/AWS::EC2::Instance"

  content = <<DOC
---
schemaVersion: '2.2'
description: Runs `docker compose up -d` on `/app`. Timeouts at 180 seconds
mainSteps:
- action: aws:runShellScript
  name: runBash
  inputs:
    timeoutSeconds: '180'
    workingDirectory: /app
    runCommand:
      - "#!/bin/bash"
      - su -c "docker image prune -a -f" ubuntu
      - su -c "docker compose up -d" ubuntu
      - su -c "docker exec app-backend-1 bash -c \"php artisan migrate\"" ubuntu
DOC

  tags = {
    Name = "Docker Compose Up for ${var.project}"
  }
}

// TODO: until a good MVP is hit, leave `- su -c "touch $(date +%s )" ubuntu` alone. Once hit, use `- su -c "docker compose up -d" ubuntu`

# If prg-nginx does not automatically restart even though it has been observed to restart
# once prg-frontend and prg-backend have been updated, maybe add
# `- su -c "docker compose restart nginx" ubuntu` (without the tildes (`)) at the end of
# the `runCommand:` array
