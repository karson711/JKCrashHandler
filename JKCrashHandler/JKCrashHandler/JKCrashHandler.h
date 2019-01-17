//
//  JKCrashHandler.h
//  JKCrashHandler
//
//  Created by kunge on 2019/1/17.
//  Copyright © 2019 kunge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKCrashHandler : NSObject

// 崩溃时的回调函数
void uncaughtExceptionHandler(NSException *exception);

@end

NS_ASSUME_NONNULL_END
