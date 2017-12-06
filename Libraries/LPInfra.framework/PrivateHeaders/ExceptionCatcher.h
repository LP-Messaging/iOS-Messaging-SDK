//
//  ExceptionCatcher.h
//  LPMessagingSDK
//
//  Created by Nir Lachman on 27/09/2016.
//  Copyright © 2016 Udi Dagan. All rights reserved.
//

//
//  ExceptionCatcher.h
//

#import <Foundation/Foundation.h>

NS_INLINE NSException * _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        return exception;
    }
    return nil;
}
