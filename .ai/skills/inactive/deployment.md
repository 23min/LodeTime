# Skill: deployment

**Maturity:** STUB - Project-specific implementation required

**Purpose:** Deploy application to target environments.

**Required Documentation:** 
Create `docs/development/deployment.md` in your project covering:
- Target environments (dev, staging, production)
- Deployment methods (CI/CD pipelines, manual scripts, cloud platforms)
- Prerequisites and access requirements
- Configuration management (environment variables, secrets)
- Rollback procedures
- Health check and verification steps

**Generic Checklist (adapt to your project):**
1. Confirm build is green and tests pass
2. Verify target environment and credentials
3. Review deployment configuration
4. Execute deployment (CI/CD trigger, script, or manual)
5. Monitor deployment progress
6. Verify health checks pass
7. Smoke test critical functionality
8. Monitor for errors/alerts
9. Document deployment in release notes or log

**Use when:** 
- Deploying to any environment (dev, staging, production)
- Updating infrastructure or configuration

**Outputs:** 
- Application deployed to target environment
- Deployment logged and verified
- Team notified of deployment status

**Common Failure Modes:**
1. Missing environment variables → Check configuration management docs
2. Failed health checks → Review logs, rollback if needed
3. Deployment timeout → Check infrastructure capacity, retry or escalate

---

**Version:** 1.0.0  
**Last Updated:** 2026-01-28
