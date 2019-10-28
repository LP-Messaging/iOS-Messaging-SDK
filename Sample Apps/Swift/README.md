# LiveEngage iOS SDK Sample App
This read.me include the quick start guide for LiveEngage In-App Messaging iOS SDK Sample Apps in Swift and Objective-C.

## Installation
LiveEngage In-App Messaging SDK for iOS supports multiple methods of installations.

**_Option 1: Using CocoaPods_**

LiveEngage iOS SDK Sample App is based on LPMessagingSDK CocoaPods.
The Podfile in the project is ready for used and already includes  LPMessagingSDK CocoaPods source.

 1. If you have CocoaPods installed skip to step #2.  Install cocoapods using the following command:
```
	$ gem install cocoapods
```
 2. Run the following command in the terminal under your project folder to init pod use:
```
 $ pod init
```
 3. Podfile should be created under your project’s folder.
 To integrate Liveperson Messaging SDK into your Xcode project using CocoaPods, specify it in your Podfile:

    ```
      platform :ios, '11.0'
      use_frameworks!
      source 'https://github.com/LivePersonInc/iOSPodSpecs.git' #LiveEngage Pod Repository

      target 'SampleApp' do
        #LPMessagingSDK Includes: LPAMS.framework, LPInfra.framework, LPMessagingSDK.framework and  LPMessagingSDKModels.bundle
        pod 'LPMessagingSDK'
      end
    ```
 4. Run the following command in the terminal under your project folder:
```
	$ pod install
```
 5. Incase you wish to upgrade to the latest SDK version and you have already ran 'pod install', Run the following command:
```
	$ pod update
```
 6. Run the project from SampleApp.xcworkspace file

**_Option 2: Using Libraries Copy to Xcode Project_**

Copy (Drag and Drop) all framework and bundle files into the project.

### Configure project settings to connect LiveEngage SDK

2. In project settings, navigate to the **General** tab, and add all Framework files to the **Embedded Binaries** section.

3. In the **General** tab, make sure that the framework files are under **Embedded Libraries**.

4. In Build settings, make sure **Always Embed Swift Standard Libraries** is set to **YES**.

5. In project settings, navigate to the Build Phases tab, and click the + button to add a New Run Script Phase. Add the script below in order to loop through the frameworks embedded in the application and remove unused architectures (used for simulator). **This step is a workaround for known iOS issue and is necessary for archiving your app before publishing it to the App Store.**

  * If frameworks installed using CocoaPods, use the following script:
```
bash "${SRCROOT}/Pods/LPMessagingSDK/LPMessagingSDK/LPInfra.framework/frameworks-strip.sh"
```

  * If frameworks installed using copy to Xcode project, use the following script:
```
bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/LPInfra.framework/frameworks-strip.sh"
```

## SDK Documentation
Integration guide, API Documentation and Configurations can be found in Livepersons Developers Portal:
https://developers.liveperson.com/consumer-experience-ios-sdk-quick-start.html
