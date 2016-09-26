# LPMessagingSDK-iOS
This read.me include the quick start guide for Swift project. 
Find the full documentation, including Objective-C guide in the integration guide. 


### Configure project settings to connect LiveEngage SDK
* Copy the files into the project, including the bundle file
In project settings, navigate to the General tab, and add all Framework files to the Embedded Binaries section.

* If you are using Xcode 8 with iOS 10 (or later): In project setting, navigate to Capabilities and enable Keychain Sharing. LiveEngage iOS SDK uses keychain to store sensitive settings and data. This step is a workaround for an open Apple’s bug that fails to use keychain store in Xcode 8 and iOS 10: https://openradar.appspot.com/27422249

* In project settings, navigate to the Build Phases tab, and click the + button to add a New Run Script Phase. Add the following script in order to loop through the frameworks embedded in the application and remove unused architectures (used for simulator). This step is a workaround for a known iOS issue http://www.openradar.me/radar?id=6409498411401216 and is necessary for archiving your app before publishing it to the App Store.

```
bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/LPInfra.framework/frameworks-strip.sh"

```

### Initialization
Now that you have the configuration file for your project, you're ready to begin implementing. 
To initialize the SDK, you must have a LivePerson account number. Consult your LivePerson account team to obtain the number.

* Inside AppDelegate, add:
```
import LPMessagingSDK
```

* Inside AppDelegate, under didFinishLaunchingWithOptions, add the following code:
```
do {
try LPMessagingSDK.instance.initialize()
} catch {
// SDK has an initialization error...
return
}
```
* Setup and call the conversation view
You’ll need to provide your account number and a container view controller
```
let conversationQuery = LPMessagingSDK.instance.getConversationBrandQuery(accountNumber)
LPMessagingSDK.instance.showConversation(conversationQuery, authenticationCode: accountNumber, containerViewController: self)
```
* In order to remove the conversation view when your container is deallocated, run the following code:
```
let conversationQuery = LPMessagingSDK.instance.getConversationBrandQuery(accountNumber)
LPMessagingSDK.instance.removeConversation(conversationQuery)
```

* In general tab, make sure that the framework files are under ‘Embedded Libraries’.
* In build settings make sure “Embedded content contains Swift code” is set to “Yes”

