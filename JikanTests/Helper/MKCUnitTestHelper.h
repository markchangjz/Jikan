#import <Foundation/Foundation.h>

@interface MKCUnitTestHelper : NSObject

/**
 讀取 Local 端的 JSON 檔案

 @param fileName JSON 檔案名稱
 @return 將 JSON 轉換成 NSObject
 */
+ (id)apiResponseObjectFromJsonFileName:(NSString *)fileName;

/**
 等待

 @param interval 等待時間 (單位：秒)
 */
+ (void)waitWithInterval:(NSTimeInterval)interval;

@end
