//
// Copyright (c) 2016-present, Facebook, Inc.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree. An additional grant
// of patent rights can be found in the PATENTS file in the same directory.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LPSROpCode)
{
    LPSROpCodeTextFrame = 0x1,
    LPSROpCodeBinaryFrame = 0x2,
    // 3-7 reserved.
    LPSROpCodeConnectionClose = 0x8,
    LPSROpCodePing = 0x9,
    LPSROpCodePong = 0xA,
    // B-F reserved.
};

/**
 Default buffer size that is used for reading/writing to streams.
 */
extern size_t LPSRDefaultBufferSize(void);
