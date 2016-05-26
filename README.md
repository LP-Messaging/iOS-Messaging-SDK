# LPMessagingSDK-iOS
This read.me include the quick start guide for Swift project. 
Find the full documentation, including Objective-C guide in the integration guide. 


### Configure project settings to connect LiveEngage SDK
* Copy the files into the project, including the bundle file
In project settings, navigate to the General tab, and add all Framework files to the Embedded Binaries section.


* In project settings, navigate to the Build Phases tab, and add with the ‘+’ button “New      Run Script Phase”. Add the following script in order to  loop through the frameworks embedded in the application and remove unused architectures.

```
APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

# This script loops through the frameworks embedded in the application and
# removes unused architectures.
find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
do
    FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
    FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
    echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

    EXTRACTED_ARCHS=()

    for ARCH in $ARCHS
    do
        echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
        lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
        EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
    done

    echo "Merging extracted architectures: ${ARCHS}"
    lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
    rm "${EXTRACTED_ARCHS[@]}"

    echo "Replacing original executable with thinned version"
    rm "$FRAMEWORK_EXECUTABLE_PATH"
    mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

done
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

