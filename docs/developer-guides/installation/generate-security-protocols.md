---
description: Guidelines for Secure Deployment and Configuration
icon: face-smile
---

# Generate Security Protocols

> As the product owners of Generate, we are committed to providing you with a secure and robust software solution. This document outlines our security practices and highlights important configuration items to consider when implementing Generate in your environment. 

## <mark style="background-color:$info;">Security Requirements</mark>

### Authentication and Authorization 

Our software supports LDAP or OAuth integration to connect with your state’s active directory, ensuring centralized and secure user management. Regular auditing and updating of user access controls are crucial to maintaining the security of your system. 

### Data Encryption&#x20;

Data encryption is critical for protecting sensitive information. We encourage users to enable end-to-end encryption for data in transit using TLS 1.2 or higher and use SQL Server encryption for data at rest.  

### Input Validation

To prevent common attacks such as SQL injection and XSS, we utilize input validation libraries to sanitize user inputs. Implementing regular security testing is ab essential step in our SDLC to ensure only valid data is processed by the application. 

### Session Management

Secure session handling with strict timeouts and proper session termination mechanisms are managed through .NET and IIS session management components.  

### Error Handling

Our secure error handling practices ensure that error messages do not expose sensitive information. Errors are logged securely, and users are directed to a general error page to avoid information leaks. 

***

## <mark style="background-color:$info;">Development Lifecycle Security Practices</mark>&#x20;

### Security Training

We mandate annual security awareness training for our developers and staff to stay updated on the latest security threats and best practices. Specialized training focuses on secure coding practices to mitigate common vulnerabilities. 

### Code Reviews&#x20;

Regular code reviews are conducted with a focus on identifying security vulnerabilities. Automated code review tools are employed to catch security issues early in the development process. 

### Static Code Analysis

We utilize SonarQube for continuous static code analysis to identify and address security vulnerabilities, code smells, and security hotspots. SonarQube checks are integrated into our CI/CD pipeline to ensure coding standards are maintained. 

### Dependency Management

Keeping third-party libraries and frameworks updated to their latest versions is a priority to mitigate known vulnerabilities.  

***

## <mark style="background-color:$info;">Deployment Security</mark>&#x20;

### Secure Configuration Management

We use GitHub and SourceTree for Configuration Management of Generate releases. Software changes are continuously deployed and monitored on the build server. Security scans are run on modified software to detect and fix security vulnerabilities.

### .NET Updates

Our software relies on the .NET framework, and we prioritize keeping it updated to the latest stable versions. This ensures our application benefits from Microsoft’s latest security patches and performance improvements. 

### Angular Code Updates

We consistently update our front-end Angular code to align with the latest security practices and OWASP recommendations. Implementing security features such as Content Security Policy (CSP) helps protect against client-side vulnerabilities like XSS. 

### Network Segmentation

We recommend deploying Generate behind your state’s firewall for an additional layer of protection. Network segmentation helps isolate critical systems and limit the impact of potential security breaches. 

### Logging

Comprehensive logging includes user login activity, access attempts, and error events. Using centralized logging solutions allows for effective analysis and incident response. Regularly reviewing logs for unusual activity helps in promptly addressing security incidents. 

***

## <mark style="background-color:$info;">Incident Response Plan</mark>

### ISO/IEC 27001 Compliance

Our ISO/IEC 27001 certification demonstrates our commitment to information security management best practices. We regularly review and update our incident response plan to address emerging threats and vulnerabilities, and conduct regular drills and training to ensure we are prepared for security incidents. &#x20;

Implementing these security practices and configuration recommendations will help you maintain a secure environment for deploying and running the Generate application. If you have any questions or need further assistance, please do not hesitate to contact us. &#x20;
