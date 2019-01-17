# JKCrashHandler
崩溃日志收集工具

1、iOS  SDK提供了一个现成的函数NSSetUncaughtExceptionHandler用来做异常处理。当程序异常退出的时候，可以先进行处理然后存储崩溃日志到沙盒，再一次进入App时发送日志文件到后台服务器。


---------------------------封装工具类----------------------------------------------------------------------
@interface JKCrashHandler : NSObject

// 崩溃时的回调函数
void uncaughtExceptionHandler(NSException *exception);

@end

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


-------------------------AppDelegate中注册消息方法----------------------------------------------
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
// Override point for customization after application launch.

//第一步在Appdelegate中注册消息方法
//注册消息处理函数的处理方法
NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

//第二步:崩溃日志发动到服务器（在下一次打开程序时将异常文件发送到自己的服务器）
// 发送崩溃日志
NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

NSString *dataPath = [path stringByAppendingPathComponent:@"Exception.txt"];

NSData *data = [NSData dataWithContentsOfFile:dataPath];

if (data != nil) {
[self sendExceptionLogWithData:data path:dataPath];
}

return YES;
}


-------------------------发送崩溃日志------------------------------------------------ 
- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {

AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
manager.requestSerializer.timeoutInterval = 5.0f;

//告诉AFN，支持接受 text/xml 的数据
[AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

NSString *urlString = @"后台地址";

[manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
[formData appendPartWithFileData:data name:@"file" fileName:@"Exception.txt" mimeType:@"txt"];
} progress:^(NSProgress * _Nonnull uploadProgress) {

} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
// 删除文件
NSFileManager *fileManger = [NSFileManager defaultManager];
[fileManger removeItemAtPath:path error:nil];

} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

}];

}




