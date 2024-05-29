# Yousign Salesforce Integration Toolbox

You have discovered Yousign API and want to integrate it fast and without issues in Salesforce ? We have good news, you are in the right place !

## Introduction

This repository contains code examples to integrate the Yousign API into Salesforce. We will connect through named credentials with an API Key.
The code samples, the initialization package and the documentation provided here complete but does not substitute the [Yousign API documentation](https://developers.yousign.com/docs/introduction-new) where you will find a [dedicated Salesforce section](https://developers.yousign.com/docs/integration-salesforce-yousign) :rocket:

## License

Check the License tab :point_up:

## Installation

### Prerequisites

1. Having an Yousign account with API. If you do not have an API key yet, please create a free [Yousign trial account](https://yousign.app/welcome?lang=en&product=api&signup_source=api_doc) !
2. A Salesforce Developer, Enterprise (or above) Edition. If you do not have a Enterprise (or above) Edition you will need some extra development.
3. Visual Studio Code. Your Visual Studio Code should be set up with the necessary [Salesforce development tools](https://trailhead.salesforce.com/content/learn/projects/set-up-your-lightning-web-components-developer-tools/install-development-tools) including the [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli).

### Installation steps

1. Authorize your Salesforce Developer Account within Visual Studio Code. To do this press `command + shift + P` (on a Mac) or `Ctrl + Shift + P` (on Windows) to open the Command Palette. Then type `SFDX:Authorize an Org` and press `Enter`. In the browser window that opens, log into your Salesforce Organization, then on the next screen, click `Allow to grant access`.
2. Download or clone the SFDC-Toolbox repository.
3. Deploy the code to Salesforce. To do this, navigate to the `force-app/main/default/manifest/` folder in the menu on the left and right-click default, then select SFDX: Deploy Source to Org. Now when you sign into your Salesforce Developer Edition (account) you will find the clases and Lightning Web Components defined in this project.

## Technical Documentation

### Access Management

We gives access to Users through `Named Credentials` with `Permission Sets`. This allows to keep the API keys secrets and to fine tune user accesses to match business needs.
![Schema explaining how users get accesses to use Yousign API](/images/YS_SF_AccessManagement.jpg)

### Sending information to Yousign from Salesforce

We integrated the Yousign API OpenAPI Specification (OAS) into Salesforce as an External Service. This way, all data structures used by the Yousign API are already created in your organization.
You can used them to send requests to Yousign API from Salesforce easily through multiple means: Low code (flows), Code (Apex methods).

The schema below describe how the request are constructed in Salesforce to fill automatically the base path of the endpoint and the credentials. It also contains how Yousign replies.
![Schema explaining how requests to Yousign from Salesforce are made](/images/SF_YS_SendInformation.jpg)

> [!NOTE]
> Some type of data or format (ex: files, base64 or multipart-forms) are not supported natively by Salesforce, as such you will need to use Apex. Some classes where developed to ease this particular use cases: `YS_MultipartUtil`, `YS_INVOCABLE_UploadDocument` and `YS_INVOCABLE_GetSignedDocument`. Feel free to customize them to best suit your needs.

### Receiving updates from Yousign in Salesforce

To have the latest information in Salesforce, Yousign send webhooks to notified Salesforce. We then treat those webhooks with Platform Events.
![Schema explaining how requests to Webhook sent by Yousign are received and treated by Salesforce](/images/YS_SF_WebhookManagement.jpg)

> [!IMPORTANT]
> As shown above, the webhooks management is developed for Signature Requests and Signers but not for Contacts, Approvers or Electronic Seals. You can add your own logic to the elements mentioned to add those features if needed.

### Data model

We create some fields and object in Salesforce that match the Yousign object structure. This is a model based on the functionalities provided with this toolbox and do not support all of the features available in Yousign API.
![Schema detailing the Yousign Custom Objects and Custom Fields contained in this package](/images/SF_YS_DataModel.jpg)

### Code Samples

By exploring the code repository you will be able to find reusable and customizable examples. Here is a non-exhaustive list of where to find some examples you might want to work with.

| Use Case | Resource type | Resource Name |
| --- | --- | --- |
| Send Signature Request | Flow | \[YS\] Send Signature Request |
| Callout to the API (flow) | Flow | \[YS\] Send Manual Reminder |
| Callout to the API (Apex) | Apex Class | YS_INVOCABLE_GetSignedDocument |
| Smart Anchor | Visualforce Page | YS_FakeDocumentEn |
| Visualforce to PDF file | Invocable Apex | YS_INVOCABLE_VisualForceToPDF |
| Reporting | Report | \[YS\] Time to Sign by Auth Mode |
| Multipart form | Apex | YS_MultipartUtil |
