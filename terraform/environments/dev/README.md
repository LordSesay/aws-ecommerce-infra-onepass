# AWS Infrastructure for OnePass Apparel

This project documents the full integration of my clothing brand's e-commerce website (https://onepassapparel.com) with AWS cloud services. It's designed to demonstrate real-world skills in infrastructure design, cloud architecture, and DevOps best practices.

---

## **Purpose**
- Scale the OnePass platform to support future traffic and growth.
- Improve site performance, reliability, and global delivery.
- Gain hands-on AWS experience and share it with the community.

---

## **Architecture Overview**

- **DNS & Domain:** Route 53
- **Static Assets & CDN:** S3 + CloudFront
- **Web Server:** EC2 (Ubuntu), optionally Dockerized
- **Database:** RDS (MySQL)
- **Monitoring:** CloudWatch
- **Security:** IAM, Security Groups, HTTPS via ACM
- **IaC:** Terraform

---

## **Diagram**
> See `/diagrams/architecture-v1.png` for a high-level view of the infrastructure.

---

## **To Do**
- [ ] Set up Route 53 for domain
- [ ] Deploy EC2 instance and install WordPress
- [ ] Configure RDS MySQL database
- [ ] Use CloudFront and S3 for asset hosting
- [ ] Write Terraform configuration
- [ ] Monitor and log using CloudWatch
- [ ] Backup automation to S3
- [ ] Document all steps in `/notes`

---

## **Author**
Malcolm L. Sesay  
Founder of [OnePass Apparel](https://onepassapparel.com)  
AWS Cloud Engineer 
[LinkedIn](https://www.linkedin.com/in/malcolmsesay)

---

## **License**
MIT License
