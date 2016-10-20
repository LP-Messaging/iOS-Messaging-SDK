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




LIVEPERSON DEVELOPER LICENSE FOR SDK

By installing, accessing, downloading, or otherwise using the LP Messaging software development kit (“SDK”) and any related software code provided by LivePerson on Github’s website, you and your company, in consideration of the mutual agreements contained herein and intending to be legally bound hereby accept the terms of this developer license agreement (“License Agreement”) and agree to be bound the License Agreement.

License. 
LivePerson grants you and your company a limited, revocable, non-exclusive, non-transferable, non-sublicensable license to access and use the SDK solely for testing, development and non-production use only.  You may not sell, sublicense, rent, loan or lease any portion of the SDK to any third party and you may not reverse engineer, decompile or disassemble any portion of the SDK. Prior to your and your company’s use of the SDK for commercial purposes, including in a production environment, you and your company must notify LivePerson and mutually agree in writing on the applicable pricing and license terms for such usage. 

Term. 
This License Agreement is effective until terminated. LivePerson has the right to terminate this agreement immediately if you fail to comply with any term herein. Upon any such termination, you and your company must remove all full and partial copies of the SDK from your computer, network, and servers and discontinue use of the SDK. 

Proprietary Rights. 
LivePerson retains all proprietary rights in and to the SDK, including know how, technologies, and trade secrets, and all derivative works, and enhancements and modifications to the foregoing. Except as stated in the above license, this License Agreement does not grant you and/or your company any rights to patents, copyrights, trade secrets, trademarks, or other rights with respect to the SDK. 

Disclaimer of Warranty. 
With respect to your and your company’s testing, development, and non-production use of the SDK, LivePerson provides the SDK “as is.”  To the maximum extent permissible under applicable law, LivePerson expressly disclaims all representations and warranties, whether express or implied warranties, concerning or related to the SDK, including but not limited to the implied warranties of non-infringement and/or fitness for a particular purpose.  LivePerson does not warrant, guarantee, or make any representations regarding the use, the results of the use or the benefits, of the SDK. Your commercial and production use of the SDK will be governed the mutually agreed upon commercial agreement in writing with LivePerson. 







