# OWASP Top 10:2021 Coverage

Use this reference when the user asks for OWASP Top 10 review coverage or when mapping confirmed findings to a common framework.

## Categories

- `A01 Broken Access Control`: Missing or inconsistent authorization, IDOR, privilege escalation, tenant isolation failures, forced browsing, or server-side trust of client-controlled access decisions.
- `A02 Cryptographic Failures`: Weak or missing encryption, plaintext secrets, insecure key handling, missing TLS protections, or sensitive data stored or transmitted without proper cryptographic controls.
- `A03 Injection`: SQL, command, LDAP, template, header, path, or similar injection where attacker-controlled input reaches an unsafe sink.
- `A04 Insecure Design`: Missing abuse controls, unsafe workflows, broken trust assumptions, or architectural choices that cannot enforce least privilege or safe defaults.
- `A05 Security Misconfiguration`: Overly broad CORS, debug features exposed in production, unsafe default settings, permissive cloud or proxy settings, verbose errors, or disabled platform protections.
- `A06 Vulnerable and Outdated Components`: Clearly risky or unsupported dependencies, packages, base images, or libraries when repository evidence shows meaningful exposure.
- `A07 Identification and Authentication Failures`: Broken session handling, weak credential flows, missing MFA on sensitive paths, token mistakes, password reset flaws, or logout and re-authentication gaps.
- `A08 Software and Data Integrity Failures`: Unsafe deserialization, unsigned updates, untrusted CI/CD inputs, plugin or package trust failures, or execution of unverified data or artifacts.
- `A09 Security Logging and Monitoring Failures`: Missing audit trails, weak alerting, tamper-prone logs, or missing visibility for sensitive actions that materially impairs detection or response.
- `A10 Server-Side Request Forgery (SSRF)`: Attacker-controlled destinations, callbacks, or URLs that can reach internal services, metadata endpoints, or restricted networks.

## Usage Notes

- Map a finding to the closest OWASP category only after confirming the abuse path and impact.
- Do not force every finding into OWASP wording when a simpler explanation is clearer.
- One finding can align to more than one category, but prefer the primary root-cause category.
