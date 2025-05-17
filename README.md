# ONEPASS SERVERLESS E-COMMERCE INFRASTRUCTURE 🚀  
> Secure, Scalable, and Modular E-Commerce Platform on AWS Powered by Terraform

![AWS](https://img.shields.io/badge/Built%20With-AWS-orange?style=for-the-badge&logo=amazonaws)
![Architecture](https://img.shields.io/badge/Architecture-Serverless-blueviolet?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-In%20Progress-success?style=for-the-badge)

---

## 📌 What Problem Are We Solving?

Traditional e-commerce platforms face challenges such as:

- **Scaling bottlenecks** during high traffic
- **Manual backend deployments** with poor maintainability
- **High infrastructure costs** from idle compute
- **Security risks** with loosely managed APIs and forms

**OnePass Serverless Infrastructure** solves these problems by leveraging AWS Lambda, API Gateway, DynamoDB, and S3 to build a secure, scalable, and cost-efficient e-commerce backend—deployed entirely via Terraform.

---

## 🎯 Project Goals

- Deliver a modular, serverless backend infrastructure
- Enable secure customer interactions (checkout, contact, feedback)
- Integrate JWT-based authentication for protected admin routes
- Automate infrastructure provisioning via Terraform modules
- Host a responsive static frontend via S3 and CloudFront
- Support real-time email notifications via AWS SES

---

## ⚙️ Tech Stack

| Service               | Role                                                      |
|------------------------|-----------------------------------------------------------|
| **AWS Lambda**         | Stateless backend logic (checkout, contact, admin, etc.)  |
| **API Gateway**        | Secure HTTP interface to Lambda functions                 |
| **Amazon DynamoDB**    | NoSQL data store for orders and feedback                  |
| **Amazon S3 + CloudFront** | Host and distribute static frontend globally         |
| **AWS SES**            | Email notifications for orders and feedback               |
| **Route 53 + ACM**     | DNS management and SSL certification                      |
| **Terraform**          | Infrastructure as Code (modular, reusable components)     |
| **JWT (PyJWT)**        | Secure token-based authorization                          |

---

## 🔁 How It Works

1. **Static frontend** is hosted on S3 with a custom domain via CloudFront
2. **Users submit forms** (checkout, contact, feedback) via API Gateway endpoints
3. **Lambda functions** process data and send confirmation emails via SES
4. **Orders and feedback** are securely stored in DynamoDB
5. **Admin dashboard** fetches protected data using JWT-authenticated Lambda APIs
6. **All infrastructure** is provisioned and version-controlled via Terraform

---

## 🧩 Architecture Diagram

*(Diagram goes here — saved in /assets/onepass-ecommerce-architecture.png)*

---

## 🛠 Folder Structure

```
aws-ecommerce-infra-onepass/
├── modules/
│ ├── lambda_checkout/
│ ├── lambda_contact/
│ ├── lambda_feedback/
│ ├── lambda_get_order/
│ ├── lambda_gateway/
│ ├── dynamodb_orders/
│ ├── s3_static_site/
│ ├── acm_cert/
│ ├── route53/
│ └── cloudfront/
├── frontend/
│ ├── index.html
│ ├── checkout.html
│ ├── admin-dashboard.html
│ └── js/
├── assets/
│ └── onepass-ecommerce-architecture.png
├── main.tf
├── README.md
└── .gitignore
```
---

## 💼 Business Use Case

OnePass Apparel is a rising streetwear brand that needed a cost-effective, secure, and scalable online store.  
By leveraging AWS serverless services, this project powers a professional-grade e-commerce experience with zero idle compute, secure admin access, and real-time operations.

---

## 📈 Business Value

- **Zero-Server Overhead**: All compute is event-driven with AWS Lambda
- **Global Performance**: S3 + CloudFront delivers content rapidly worldwide
- **Scalability**: Handles sudden traffic spikes with no manual scaling
- **Security**: JWT for protected admin routes, HTTPS everywhere, IAM-controlled resources
- **Ease of Maintenance**: Modular infrastructure easily extended or modified via Terraform

---

## 🔮 Future Enhancements

- [ ] Add Stripe payment integration to `checkout`
- [ ] Implement admin analytics dashboard with metrics
- [ ] Export order and feedback data to CSV
- [ ] Integrate CI/CD pipeline for automatic frontend and Lambda deployments
- [ ] Add product search via DynamoDB + API Gateway

---

## 🤝 Connect

Built and managed by **[Malcolm Sesay](https://www.linkedin.com/in/malcolmsesay/)** — turning cloud infrastructure into business value.

---

## 🏷️ Tags

`#AWS` `#Serverless` `#Ecommerce` `#Terraform` `#Lambda` `#CI/CD` `#CloudEngineering` `#InfrastructureAsCode` `#JWT` `#DynamoDB`



