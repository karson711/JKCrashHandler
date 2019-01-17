//
//  JKCrashHandler.m
//  JKCrashHandler
//
//  Created by kunge on 2019/1/17.
//  Copyright © 2019 kunge. All rights reserved.
//

#import "JKCrashHandler.h"

@implementation JKCrashHandler

void uncaughtExceptionHandler(NSException *exception){
    
    NSArray *stackArry= [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception name:%@\nException reatoin:%@\nException stack :%@",name,reason,stackArry];
    NSLog(@"%@",exceptionInfo);
    
    //保存到本地沙盒中
    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/eror.log",NSHomeDirectory()] atomically:YES encoding:NSUTF8StringEncoding error:nil];    
}

@end
