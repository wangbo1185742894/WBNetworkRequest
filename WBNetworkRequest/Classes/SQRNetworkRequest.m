//
//  SQRNetworkRequest.m
//  SQRCommonToolsProject
//
//  Created by Azir on 2018/5/30.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "SQRNetworkRequest.h"
#import "YYCache.h"
#import "HMFJSONResponseSerializerWithData.h"
#import "NSString+Custom.h"
#import "HUDIndicatorTools.h"

//无网络返回错误状态
#define NOT_NETWORK_ERROR [NSError errorWithDomain:@"com.shequren.SQRNetworking.ErrorDomain" code:-999 userInfo:@{NSLocalizedDescriptionKey:@"无网络"}]

//请求成功处理数据并返回
#define REQUEST_SUCCEED_OPERATION_BLCOK(success)\
\
NSDictionary *dictObj;\
if ([responseObject isKindOfClass:[NSDictionary class]]) {\
if (success)success(responseObject);\
NSLog(@"成功返回 --- URL ： %@ \n %@",urlString,responseObject);\
}else{\
NSString *responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];\
dictObj = [responseJson JsonToDictionary];\
if (success)success(dictObj);\
NSLog(@"成功返回 --- URL ： %@ \n %@",urlString,dictObj);\
}\
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];\
[HUDIndicatorTools HideHUD];


//请求成功判断缓存方式并缓存
#define SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(cacheWay,myCache,cacheKey)\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{\
if (cacheWay != IgnoringLocalCacheData) {\
if ([responseObject isKindOfClass:[NSDictionary class]]) {\
[myCache setObject:responseObject forKey:cacheKey];\
}else{\
[myCache setObject:dictObj forKey:cacheKey];\
}\
}\
});

//请求失败打印错误原因并返回
#define REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task)\
if (fail)fail(error,task);\
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];\
[HUDIndicatorTools HideHUD];\
NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;\
NSLog(@"失败返回 --- URL ： %@ \n ---错误码 = %ld  \n ---详细信息 : %@",urlString,responses.statusCode,error);


static AFNetworkReachabilityStatus  networkStatus;

@interface SQRNetworkRequest ()

//记录401的接口，用作刷新token之后比对，按需刷新
@property(nonatomic,strong) NSString *refreshAgainUrl;

@end

@implementation SQRNetworkRequest

+ (SQRNetworkRequest *)sharedInstance {
    static SQRNetworkRequest *netRequest = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netRequest = [[self alloc] init];
    });
    [self checkNetworkStatus];
    return netRequest;
}

- (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                  @"text/html",
                                                                                  @"text/json",
                                                                                  @"text/plain",
                                                                                  @"text/javascript",
                                                                                  @"text/xml",
                                                                                  @"image/*",
                                                                                  @"application/octet-stream",
                                                                                  @"application/zip"]];
        manager.requestSerializer.timeoutInterval = 10;
    });
    self.showHud = YES;
    return manager;
}



#pragma mark --- 检查网络
+ (void)checkNetworkStatus {
    networkStatus = AFNetworkReachabilityStatusUnknown;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                // 未知网络
                networkStatus = AFNetworkReachabilityStatusUnknown;
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                // 没有网络
                networkStatus = AFNetworkReachabilityStatusNotReachable;
                [HUDIndicatorTools ShowToastText:@"没有网络"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                // 手机自带网络,移动流量
                networkStatus = AFNetworkReachabilityStatusReachableViaWWAN;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                // WIFI
                networkStatus = AFNetworkReachabilityStatusReachableViaWiFi;
            }
        }
    }];
    
}





- (void)getWithUrl:(NSString *)urlString
        parameters:(id)parameters
           success:(NetRequestSuccessBlock)success
              fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:GET cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}


- (void)postWithUrl:(NSString *)urlString
         parameters:(id)parameters
            success:(NetRequestSuccessBlock)success
               fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:POST cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}

- (void)putWithUrl:(NSString *)urlString
        parameters:(id)parameters
           success:(NetRequestSuccessBlock)success
              fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:PUT cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}


- (void)deleteWithUrl:(NSString *)urlString
           parameters:(id)parameters
              success:(NetRequestSuccessBlock)success
                 fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:DELETE cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}

- (void)patchWithUrl:(NSString *)urlString
          parameters:(id)parameters
             success:(NetRequestSuccessBlock)success
                fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:PATCH cachePolicy:IgnoringLocalCacheData success:success cache:nil failure:fail];
}


- (void)getWithUrl:(NSString *)urlString
        parameters:(id)parameters
       cachePolicy:(RequestCachePolicy)policy
           success:(NetRequestCacheSuccessBlock)success
              fail:(NetRequestFailedBlock)fail
{
    [self requestWithUrl:urlString parameters:parameters type:GET cachePolicy:policy success:^(id responseObject) {
        !success ?: success(responseObject, NO);
    } cache:^(id responseObject) {
        !success ?: success(responseObject, YES);
    } failure:fail];
}


- (void)postWithUrl:(NSString *)urlString
         parameters:(id)parameters
        cachePolicy:(RequestCachePolicy)policy
            success:(NetRequestCacheSuccessBlock)success
               fail:(NetRequestFailedBlock)fail
{
    NSLog(@"请求参数：---%@",parameters);
    [self requestWithUrl:urlString parameters:parameters type:POST cachePolicy:policy success:^(id responseObject) {
        !success ?: success(responseObject, NO);
    } cache:^(id responseObject) {
        !success ?: success(responseObject, YES);
    } failure:fail];
}


- (void)requestWithUrl:(NSString *)urlString
            parameters:(id)parameters
                  type:(NetworkMethod)type
           cachePolicy:(RequestCachePolicy)policy
               success:(NetRequestSuccessBlock)success
                 cache:(NetResponseCache)cache
               failure:(NetRequestFailedBlock)fail
{
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (_showHud)[HUDIndicatorTools ShowHUDText:@""];
    if (!_showHud) {
        _showHud = true;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [HUDIndicatorTools HideHUD];
    });
    
    AFHTTPSessionManager *manager = [self sharedManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [HMFJSONResponseSerializerWithData serializer];
    
    [manager.requestSerializer setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"appVersion"];
    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"system"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"app"];
    if ([DataStorageTools objectForKey:kUserToken]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer%@",[DataStorageTools objectForKey:kUserToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    NSLog(@"发起请求 --- URL ： %@",urlString);
    
    //缓存，用url拼接参数作为key
    YYCache *myCache = [YYCache cacheWithName:@"SQRCache"];
    NSString *parString = parameters ? [self dictionaryToJson:parameters] : @"";
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@", urlString, parString];
    
    if (cache) {
        //获取缓存
        id object = [myCache objectForKey:cacheKey];
        switch (policy) {
                
                //先返回缓存，同时请求
            case CacheDataThenLoad: {
                if (object)cache(object);
                break;
            }
                
                //忽略本地缓存直接请求
            case IgnoringLocalCacheData: {
                break;
            }
                
                //有缓存就返回缓存，没有就请求
            case CacheDataElseLoad: {
                if (object) {
                    cache(object);
                    return ;
                }
                break;
            }
                
                //有缓存就返回缓存,从不请求（用于没有网络）
            case CacheDataDontLoad: {
                if (object)cache(object);
                return ;
            }
            default: {
                break;
            }
        }
    }
    
    
    switch (type) {
        case GET: {
            
            [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(policy,myCache,cacheKey);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        case POST: {
            
            [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                SAVECACHEWITH_CACHEWAY_MYCHAHE_KEY(policy,myCache,cacheKey);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        case PUT: {
            [manager PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        case DELETE: {
            [manager DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        case PATCH: {
            [manager PATCH:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                REQUEST_SUCCEED_OPERATION_BLCOK(success);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self requestDisposeUrl:urlString parameters:parameters type:type cachePolicy:policy success:success cache:cache failure:fail error:error task:task];
                
            }];
        }
            break;
            
        default:
            break;
    }
}


//错误处理
- (void)requestDisposeUrl:(NSString *)url
               parameters:(id)parameters
                     type:(NetworkMethod)type
              cachePolicy:(RequestCachePolicy)policy
                  success:(NetRequestSuccessBlock)success
                    cache:(NetResponseCache)cache
                  failure:(NetRequestFailedBlock)fail
                    error:(NSError * _Nonnull)error
                     task:(NSURLSessionDataTask * _Nullable)task {
    
    if (fail)fail(error,task);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [HUDIndicatorTools HideHUD];
    
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    NSLog(@"失败返回 --- URL ： %@ \n ---错误码 = %ld  \n ---详细信息 : %@",url,responses.statusCode,error);
    
    //针对Java接口token失效401的处理，刷新token重新请求
    if (responses.statusCode == 401) {
        
        NSString *token = [DataStorageTools objectForKey:kUserToken];
        
        if (token.length > 0) {
            
            NSString *refreshToken = [DataStorageTools objectForKey:kUserRefreshToken];
            if (self.tokenRefreshUrl.length > 0 && refreshToken.length > 0) {
                
                [self postWithUrl:self.tokenRefreshUrl
                       parameters:@{@"refresh_token":refreshToken}
                          success:^(id responseObject) {
                              
                              NSDictionary *dictObj;
                              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                  dictObj = responseObject;
                              }else{
                                  NSString *responseJson = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  dictObj = [responseJson JsonToDictionary];
                              }
                              
                              if ([dictObj.allKeys containsObject:@"access_token"]) {
                                  NSString *access_token = dictObj[@"access_token"];
                                  if (access_token.length > 0) {
                                      [DataStorageTools setObject:access_token forKey:kUserToken];
                                      
                                      if(self.refreshAgainUrl != url) {
                                          self.refreshAgainUrl = url;
                                          [self requestWithUrl:url parameters:parameters type:type cachePolicy:policy success:success cache:cache failure:fail];
                                      }else{
                                          NSLog(@"--- token已刷新，接口：%@再次请求结果还是401",url);
                                      }
                                  }else{
                                      [[LoginLoseEfficacyView sharedInstance] show];
                                  }
                                  
                              }else{
                                  if ([dictObj.allKeys containsObject:@"msg"]) {
                                      if ([dictObj[@"msg"] isEqualToString:@"error=invalid_grant"]) {
                                          [[LoginLoseEfficacyView sharedInstance] show];
                                      }
                                  }
                              }
                              
                              if ([dictObj.allKeys containsObject:@"refresh_token"]) {
                                  NSString *refresh_token = dictObj[@"refresh_token"];
                                  if (refresh_token.length > 0) {
                                      [DataStorageTools setObject:dictObj[@"refresh_token"] forKey:kUserRefreshToken];
                                  }else{
                                      [[LoginLoseEfficacyView sharedInstance] show];
                                  }
                              }
                          }
                             fail:^(NSError *error, NSURLSessionDataTask *task) {
                                 
                             }];
            }else{
                [[LoginLoseEfficacyView sharedInstance] show];
            }
            
        }else{
            //未登录状态去登陆
            [[LoginLoseEfficacyView sharedInstance] show];
        }
        return;
    }else if (responses.statusCode == 500) {
        [HUDIndicatorTools ShowToastText:@"服务器访问出错，请稍后再试"];
    }else if (responses.statusCode == 404) {
//        [HUDIndicatorTools ShowToastText:@"暂无资源"];
    }else{
        NSDictionary *dic = [error.userInfo[@"body"] JsonToDictionary];
        [HUDIndicatorTools ShowToastText:dic[@"message"]];
    }
}

- (void)postUploadMultiImageWithUrl:(NSString *)urlString
                         imageArray:(NSArray *)imageArray
                          imageName:(NSString *)imageName
                         parameters:(id)parameters
                           progress:(NetRequestProgressBlock)progress
                            success:(NetRequestSuccessBlock)success
                               fail:(NetRequestFailedBlock)fail
{
    
    AFHTTPSessionManager *manager = [self sharedManager];
    
    if ([DataStorageTools objectForKey:kUserToken]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer%@",[DataStorageTools objectForKey:kUserToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (imageArray.count == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:[NSData data] name:@"imgs" fileName:fileName mimeType:@"image/jpg"];
        }else{
            // 上传多张图片
            for(int i=0; i<imageArray.count; i++) {
                UIImage *image = imageArray[i];
                NSData *imageData = UIImageJPEGRepresentation(image,1);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",[NSString stringWithFormat:@"%@.jpg", str],i];
                [formData appendPartWithFileData:imageData name:imageName?imageName:@"uploadIcon" fileName:fileName mimeType:@"image/jpg"];
            }
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        REQUEST_SUCCEED_OPERATION_BLCOK(success);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task);
        
    }];
}

- (void)postUploadMultiImageWithUrl:(NSString *)urlString
                         imageArray:(NSArray *)imageArray
                         parameters:(id)parameters
                           progress:(NetRequestProgressBlock)progress
                            success:(NetRequestSuccessBlock)success
                               fail:(NetRequestFailedBlock)fail{
    [self postUploadMultiImageWithUrl:urlString imageArray:imageArray imageName:nil parameters:parameters progress:progress success:success fail:fail];
}



- (void)postUploadImageWithUrl:(NSString *)urlString
                         image:(UIImage *)image
                         imageName:(NSString *)imageName
                    parameters:(id)parameters
                      progress:(NetRequestProgressBlock)progress
                       success:(NetRequestSuccessBlock)success
                          fail:(NetRequestFailedBlock)fail
{
    AFHTTPSessionManager *manager = [self sharedManager];
    
    if ([DataStorageTools objectForKey:kUserToken]) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"bearer%@",[DataStorageTools objectForKey:kUserToken]] forHTTPHeaderField:@"Authorization"];
    }
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:imageData name:imageName?imageName:@"uploadIcon" fileName:fileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress)progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        REQUEST_SUCCEED_OPERATION_BLCOK(success);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        REQUEST_FAILURE_BLCOK_ERROR_TASK(fail,error,task);
        
    }];
}


- (void)postUploadImageWithUrl:(NSString *)urlString
                         image:(UIImage *)image
                    parameters:(id)parameters
                      progress:(NetRequestProgressBlock)progress
                       success:(NetRequestSuccessBlock)success
                          fail:(NetRequestFailedBlock)fail{
    [self postUploadImageWithUrl:urlString image:image imageName:nil parameters:parameters progress:progress success:success fail:fail];
}





- (AFURLSessionManager *)sharedDownloadManager {
    static AFURLSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"DownloadPatch"];
        manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    return manager;
}


- (void)downloadFileWithUrl:(NSString *)urlString
                   filePath:(NSURL *)filePath
                    success:(NetRequestSuccessBlock)success
                       fail:(NetRequestFailedBlock)fail
{
    AFURLSessionManager *manager = [self sharedDownloadManager];
    
    if (networkStatus == AFNetworkReachabilityStatusNotReachable) {
        if (fail)fail(NOT_NETWORK_ERROR,nil);
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"补丁下载%.1f%%", downloadProgress.fractionCompleted*100);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return filePath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (success) {
            success(filePath);
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [downloadTask resume];
}




//字典转json
- (NSString *)dictionaryToJson:(id)object {
    NSString *jsonString = [[NSString alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    return mutStr;
}



- (void)removeCacheForUrl:(NSString *)url params:(id)params{
    //缓存，用url拼接参数作为key
    YYCache *myCache = [YYCache cacheWithName:@"SQRCache"];
    NSString *parString = params ? [self dictionaryToJson:params] : @"";
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@", url, parString];
    [myCache removeObjectForKey:cacheKey];
}


@end

