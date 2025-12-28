# OpenTOSCA Template for WinVMJ Framework

## Description

This template enables automated deployment of Java applications built with the WinVMJ Framework to cloud infrastructure using the OpenTOSCA orchestration method and Variability4TOSCA specifications. Currently, the template supports monolithic architecture where all application components are deployed on one Virtual Machine.

## Architecture

### Monolithic
![Monolithic Diagram](<Architecture Diagram.png>)

## How To Use

### System Requirement

To use the OpenTOSCA Template for WinVMJ Framework, you will need to have these apps/plugins installed in your device:
- Eclipse Modeling Tools (2023-12)
- WinVMJ Composer - An Eclipse Plugin consisting the implementation of WinVMJ as a FeatureIDE Composer

> Further explanation on how to install the Eclipse and WinVMJ Composer can be found in this [Wiki Page](https://github.com/rse-group/winvmj-composer/wiki/Preparation)

### Deployment Artifacts
The following files are required before starting the deployment process:
- A zipped React frontend production build
  - The correct structure of the zip:
      ```
      frontend.zip
      ├── index.html
      ├── asset-manifest.json
      ├── favicon.ico
      ├── manifest.json
      ├── robots.txt
      ├── static/
      │   ├── css/
      │   ├── js/
      │   └── media/
      ```
  - The wrong structure of the zip:
      ```
      frontend.zip
      ├── build/
      |  ├── index.html
      |  ├── asset-manifest.json
      |  ├── favicon.ico
      |  ├── manifest.json
      |  ├── robots.txt
      |  ├── static/
      |  │   ├── css/
      |  │   ├── js/
      |  │   └── media/
      ```

### Using This Template

Remember to clone this repository before starting the deployment process!

1. Prepare The Feature Model and Mapping Files
   - Open or create the `interfaces` folder in your project
   - Add a new feature model file that represents non-functional requirements. It should define deployment-related options such as cloud provider, instance type, and region
   - Below is an example of an NFR feature model (NFR.uvl)
   ```
   namespace NFR

   features
      NFR {extended__ true}
         mandatory
            Provider {abstract true}
               alternative
                  GCP
                  AWS
         optional
            "Instance Type" {abstract true}
               alternative
                  "Low Cost"
                  "High Performance"
                  "Balance Price and Performance"
         mandatory
            "Num of Transactions" {abstract true}
               alternative
                  "1000"
                  "2000"
                  "4000"
                  "8000"
                  "16000"
            "Transaction Per Second (TPS)" {abstract true}
               alternative
                  "10"
                  "100"
         optional
            Region {abstract true}
               alternative
                  "North America"
                  "South America"
                  Europe
                  "Asia Pacific"
                  "Middle East"
   ```
   - Create an `nfr_to_model.json` file in the root directory of the feature project. This file is used to map features defined in the NFR feature model to their corresponding Java object representations. Currently, there are five representations, which are Provider, Instance, Transaction, TPS, and Region
   - Below is an example of the nfr_to_model.json
   ```
   {
      "Provider": "Provider",
      "Instance Type": "Instance",
      "Num of Transactions": "Transaction",
      "Transaction Per Second (TPS)": "TPS",
      "Region": "Region"
   }
   ```
   - Create region.json and instance_type.json files to define the available cloud provider regions and instance types based on the selected instance type category.
   - Below is an example of the region.json
   ```
   {
      "AWS": {
         "North America": [
            "us-east-1",
            "us-east-2",
            "us-west-1",
            "us-west-2"
         ],
         "South America": [
            "sa-east-1"
         ],
         "Europe": [
            "eu-west-1",
            "eu-west-2",
            "eu-west-3",
            "eu-central-1",
            "eu-central-2",
            "eu-north-1",
            "eu-south-1"
         ],
         "Asia Pacific": [
            "ap-south-1",
            "ap-south-2",
            "ap-southeast-1",
            "ap-southeast-2",
            "ap-southeast-3",
            "ap-northeast-1",
            "ap-northeast-2",
            "ap-northeast-3"
         ],
         "Middle East": [
            "me-central-1",
            "me-south-1"
         ]
      },
      "GCP": {
         "North America": [
            "us-central1",
            "us-east1",
            "us-east4",
            "us-west1",
            "us-west2",
            "us-west3",
            "us-west4"
         ],
         "South America": [
            "southamerica-east1"
         ],
         "Europe": [
            "europe-west1",
            "europe-west2",
            "europe-west3",
            "europe-west4",
            "europe-west6",
            "europe-north1"
         ],
         "Asia Pacific": [
            "asia-east1",
            "asia-east2",
            "asia-northeast1",
            "asia-northeast2",
            "asia-northeast3",
            "asia-south1",
            "asia-south2",
            "asia-southeast1",
            "asia-southeast2"
         ],
         "Middle East": [
            "me-west1",
            "me-central2"
         ]
      }
   }
   ```
   - Below is an example of the instance_type.json
   ```
   {
      "AWS": {
         "Low Cost": ["t2.micro", "t2.small", "t3.micro", "t3.small"],
         "High Performance": ["c5.xlarge", "c5.2xlarge", "c6i.xlarge", "c6i.2xlarge"],
         "Balance Price and Performance": ["t3.medium", "t3.large", "m5.large", "m5.xlarge"]
      },
      "GCP": {
         "Low Cost": ["e2-micro", "e2-small", "e2-medium"],
         "High Performance": ["c2-standard-4", "c2-standard-8", "c3-standard-4"],
         "Balance Price and Performance": ["n2-standard-2", "n2-standard-4", "n1-standard-2"]
      }
   }
   ```

2. Compose The Product
   - Perform feature selection using the main feature model that has already been integrated with the NFR feature model
   - The selection can be done using Multi Level Configuration Wizard from WinVMJ Composer or manually by creating an empty configuration file
   - Set the configuration as the current configuration

3. Open the Deployment Via TOSCA Wizard
   - Right click on the `src` folder
   - Select WinVMJ > Deployment via OpenTOSCA
   - Wait until the product is compiled and zipped
   - The Deployment via OpenTOSCA Wizard will appear and fill in all the required fields
     - When filling in the OpenTOSCA Template Path, make sure the path is written in Linux-style format, not Windows format.
     - The template path must point to the location of the `variable-service-template.yaml` file
       - For example, if the variable-service-template.yaml is located in `/path/to/variable-service-template.yaml`, then fill the template path with `path/to`

## Version History
| Version | Description                                                                                                        |
|---------|--------------------------------------------------------------------------------------------------------------------|
|   1.1   | Added support for React-based front-end deployment and updated the README with usage instructions for the template |
|   1.0   | Initial version of OpenTOSCA Template for WinVMJ Framework. Tested for AWS and GCP Deployment                      |

