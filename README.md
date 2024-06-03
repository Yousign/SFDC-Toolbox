# Yousign Salesforce Integration Toolbox

You have discovered Yousign API and want to integrate it fast and without issues in Salesforce? We have good news, you are in the right place!

## Introduction

This repository contains code examples to integrate the Yousign API into Salesforce. We will connect through named credentials with an API Key.
The code samples, the initialization package and the documentation provided here complete but does not substitute the [Yousign API documentation](https://developers.yousign.com/docs/introduction-new) where you will find a [dedicated Salesforce section](https://developers.yousign.com/docs/integration-salesforce-yousign)&nbsp;🚀

## License

Check the License tab :point_up:

## Installation

### Prerequisites

1. Having an Yousign account with API. If you do not have an API key yet, please create a free [Yousign trial account](https://yousign.app/welcome?lang=en&product=api&signup_source=api_doc)!
2. A Salesforce Developer, Enterprise (or above) Edition.
3. Visual Studio Code. Your Visual Studio Code should be set up with the necessary [Salesforce development tools](https://trailhead.salesforce.com/content/learn/projects/set-up-your-lightning-web-components-developer-tools/install-development-tools) including the [Salesforce CLI](https://developer.salesforce.com/tools/salesforcecli).

### Installation steps
1. In Salesforce go to `Setup > Process Automation > Process Automation Settings` set an admin (generic account if possible) as `Default Workflow User`. Click `Save`.
2. Authorize your Salesforce Developer Account within Visual Studio Code. To do this press `command + shift + P` (on a Mac) or `Ctrl + Shift + P` (on Windows) to open the Command Palette. Then type `SFDX:Authorize an Org` and press `Enter`. In the browser window that opens, log into your Salesforce Organization, then on the next screen, click `Allow to grant access`.
3. Download or clone the SFDC-Toolbox repository.
4. Deploy the code to Salesforce.
   1. **On a sandbox/developer organization** Navigate to the `force-app/main/default/manifest/` folder in the menu on the left and right-click the `package.xml` file, then select SFDX: Deploy Source to Org. Now when you sign into your Salesforce Developer Edition (account) you will find the clases and Lightning Web Components defined in this project.
   2. **On a production organization** Select the `Terminal` menu then click on `New Terminal`. Type `sfdx project deploy start -x manifest/package.xml -l RunSpecifiedTests -t YS_INVOCABLE_GetSignedDocument_Test YS_INVOCABLE_UploadDocument_Test YS_Service_Test YS_MultipartUtil_Test YS_Utils_Test YS_WebhookListener_Test YS_WebhookDispatcher_Test YS_INVOCABLE_VisualForceToPDF_Test --verbose` then press `Enter`.

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

### Error Management

> Anything that can go wrong will go wrong.
> *Murphy's Law*

Although it should not happen (and we hope it will not), we have to face it: errors can happen. As most of the webhook management's work is done asynchronously for permfomance and security reasons, we need to log those errors to be aware of them.

We do not want to overcharge your organization by adding a `Log__c` SObject you might already have. As such we do not include our own `Log__c` SObject here. However some functionalities are ready to trigger a log creation if an error happens.

Hence, feel free to plug the following methods to your own logging object or create a new `Log__c` one for the occasion. The methods `toErrorLog`, `insertExceptionsAsLogs` and `insertLogsFuture` can all be found in the `YS_Utils` Apex Class and can be rapidly customized.

> [!Tip]
> E.g. We created the fields `Type__c`, `Source__c`, `ErrorMessage__c` and `ErrorDetails__c` on our `Log__c` SObject.

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
