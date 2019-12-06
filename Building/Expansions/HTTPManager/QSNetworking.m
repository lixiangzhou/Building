//
//  QSNetworking.m
//  AFNetworkingDemo
//
//  Created by qingsong on 16/6/14.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "QSNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
//#import "AFNetworking.h"
//#import "AFHTTPSessionManager.h"

#import <CommonCrypto/CommonDigest.h>

@interface NSString (md5)

+ (NSString *)QSnetworking_md5:(NSString *)string;

@end

@implementation NSString (md5)

+ (NSString *)QSnetworking_md5:(NSString *)string {
  if (string == nil || [string length] == 0) {
    return nil;
  }
  
  unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
  CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
  NSMutableString *ms = [NSMutableString string];
  
  for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
    [ms appendFormat:@"%02x", (int)(digest[i])];
  }
  
  return [ms copy];
}

@end

static NSString *sg_privateNetworkBaseUrl = nil;
static BOOL sg_isEnableInterfaceDebug = NO;
static BOOL sg_shouldAutoEncode = NO;
static NSDictionary *sg_httpHeaders = nil;
static QSResponseType sg_responseType = kQSResponseTypeJSON;
static QSRequestType  sg_requestType  = kQSRequestTypeJSON;
//static QSRequestType  sg_requestType  = kQSRequestTypePlainText;
static QSNetworkStatus sg_networkStatus = kQSNetworkStatusUnknown;
static NSMutableArray *sg_requestTasks;
static BOOL sg_cacheGet = YES;
static BOOL sg_cachePost = NO;
static BOOL sg_shouldCallbackOnCancelRequest = YES;
static NSTimeInterval sg_timeout = 10.0f;
static BOOL sg_shoulObtainLocalWhenUnconnected = NO;

@implementation QSNetworking

+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost {
  sg_cacheGet = isCacheGet;
  sg_cachePost = shouldCachePost;
}

+ (void)updateBaseUrl:(NSString *)baseUrl {
  sg_privateNetworkBaseUrl = baseUrl;
}

+ (NSString *)baseUrl {
  return sg_privateNetworkBaseUrl;
}

+ (void)setTimeout:(NSTimeInterval)timeout {
  sg_timeout = timeout;
}

+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain {
  sg_shoulObtainLocalWhenUnconnected = shouldObtain;
}

+ (void)enableInterfaceDebug:(BOOL)isDebug {
  sg_isEnableInterfaceDebug = isDebug;
}

+ (BOOL)isDebug {
  return sg_isEnableInterfaceDebug;
}

static inline NSString *cachePath() {
  return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/QSNetworkingCaches"];
}

+ (void)clearCaches {
  NSString *directoryPath = cachePath();
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
    
    if (error) {
      NSLog(@"QSNetworking clear caches error: %@", error);
    } else {
      NSLog(@"QSNetworking clear caches ok");
    }
  }
}

+ (unsigned long long)totalCacheSize {
  NSString *directoryPath = cachePath();
  BOOL isDir = NO;
  unsigned long long total = 0;
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDir]) {
    if (isDir) {
      NSError *error = nil;
      NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
      
      if (error == nil) {
        for (NSString *subpath in array) {
          NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
          NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path
                                                                                error:&error];
          if (!error) {
            total += [dict[NSFileSize] unsignedIntegerValue];
          }
        }
      }
    }
  }
  
  return total;
}

+ (NSMutableArray *)allTasks {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (sg_requestTasks == nil) {
      sg_requestTasks = [[NSMutableArray alloc] init];
    }
  });
  
  return sg_requestTasks;
}

+ (void)cancelAllRequest {
  @synchronized(self) {
    [[self allTasks] enumerateObjectsUsingBlock:^(QSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([task isKindOfClass:[QSURLSessionTask class]]) {
        [task cancel];
      }
    }];
    
    [[self allTasks] removeAllObjects];
  };
}

+ (void)cancelRequestWithURL:(NSString *)url {
  if (url == nil) {
    return;
  }
  
  @synchronized(self) {
    [[self allTasks] enumerateObjectsUsingBlock:^(QSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
      if ([task isKindOfClass:[QSURLSessionTask class]]
          && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
        [task cancel];
        [[self allTasks] removeObject:task];
        return;
      }
    }];
  };
}



+ (void)configRequestType:(QSRequestType)requestType
             responseType:(QSResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest {
  sg_requestType = requestType;
  sg_responseType = responseType;
  sg_shouldAutoEncode = shouldAutoEncode;
  sg_shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

+ (BOOL)shouldEncode {
  return sg_shouldAutoEncode;
}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
  sg_httpHeaders = httpHeaders;
}
//--------------------------GET--------------------------//
+ (QSURLSessionTask *)getWithUrl:(NSString *)url
                         success:(QSResponseSuccess)success
                            fail:(QSResponseFail)fail {
    return [self getWithUrl:url
               refreshCache:NO
                     params:nil
               headerParams:@{}
                    success:success
                       fail:fail];
}
+ (QSURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                          success:(QSResponseSuccess)success
                             fail:(QSResponseFail)fail {
  return [self getWithUrl:url
             refreshCache:refreshCache
                   params:nil
             headerParams:@{}
                  success:success
                     fail:fail];
}

+ (QSURLSessionTask *)getWithUrl:(NSString *)url
                    headerParams:(NSDictionary *)headerParams
                         success:(QSResponseSuccess)success
                            fail:(QSResponseFail)fail {
    return [self getWithUrl:url
               refreshCache:YES
                     params:nil
               headerParams:headerParams
                    success:success
                       fail:fail];
}

+ (QSURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                     headerParams:(NSDictionary *)headerParams
                          success:(QSResponseSuccess)success
                             fail:(QSResponseFail)fail {
  return [self getWithUrl:url
             refreshCache:refreshCache
                   params:params
             headerParams:headerParams
                 progress:nil
                  success:success
                     fail:fail];
}

+ (QSURLSessionTask *)getWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                     headerParams:(NSDictionary *)headerParams
                         progress:(QSGetProgress)progress
                          success:(QSResponseSuccess)success
                             fail:(QSResponseFail)fail {
  return [self _requestWithUrl:url
                  refreshCache:refreshCache
                     httpMedth:1
                        params:params
                  headerParams:headerParams
                      progress:progress
                       success:success
                          fail:fail];
}

//--------------------------POST--------------------------//
+ (QSURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                          success:(QSResponseSuccess)success
                             fail:(QSResponseFail)fail {
    return [self postWithUrl:url
                refreshCache:NO
                      params:params
                headerParams:@{}
                    progress:nil
                     success:success
                        fail:fail];
}

+ (QSURLSessionTask *)postWithUrl:(NSString *)url
                           params:(NSDictionary *)params
                     headerParams:(NSDictionary *)headerParams
                          success:(QSResponseSuccess)success
                             fail:(QSResponseFail)fail {
    return [self postWithUrl:url
                refreshCache:NO
                      params:params
                headerParams:headerParams
                    progress:nil
                     success:success
                        fail:fail];
}
+ (QSURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                      headerParams:(NSDictionary *)headerParams
                           success:(QSResponseSuccess)success
                              fail:(QSResponseFail)fail {
  return [self postWithUrl:url
              refreshCache:refreshCache
                    params:params
              headerParams:headerParams
                  progress:nil
                   success:success
                      fail:fail];
}

+ (QSURLSessionTask *)postWithUrl:(NSString *)url
                      refreshCache:(BOOL)refreshCache
                            params:(NSDictionary *)params
                      headerParams:(NSDictionary *)headerParams
                          progress:(QSPostProgress)progress
                           success:(QSResponseSuccess)success
                              fail:(QSResponseFail)fail {
  return [self _requestWithUrl:url
                  refreshCache:refreshCache
                     httpMedth:2
                        params:params
                  headerParams:headerParams
                      progress:progress
                       success:success
                          fail:fail];
}

+ (QSURLSessionTask *)_requestWithUrl:(NSString *)url
                          refreshCache:(BOOL)refreshCache
                             httpMedth:(NSUInteger)httpMethod
                                params:(NSDictionary *)params
                          headerParams:(NSDictionary *)headerParams
                              progress:(QSDownloadProgress)progress
                               success:(QSResponseSuccess)success
                                  fail:(QSResponseFail)fail {
    // 获取请求头
    
//    refreshCache = YES;
//  AFHTTPSessionManager *manager = [self manager];
//    AFHTTPSessionManager *manager = [self manager:[self requestHeader:params]];
    if ([GlobalConfigClass shareMySingle].userAndTokenModel.token) {
        NSMutableDictionary *header = (NSMutableDictionary *)[headerParams mutableCopy];
        header[@"token"] = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
        headerParams = header;
    }
    
    AFHTTPSessionManager *manager = [self manager:headerParams];
    NSString *absolute = [self absoluteUrlWithPath:url];
  
  if ([self baseUrl] == nil) {
    if ([NSURL URLWithString:url] == nil) {
      DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
      return nil;
    }
  } else {
    NSURL *absouluteURL = [NSURL URLWithString:absolute];
    
    if (absouluteURL == nil) {
      DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
      return nil;
    }
  }
  
  if ([self shouldEncode]) {
    url = [self encodeUrl:url];
  }
  
  QSURLSessionTask *session = nil;
  
  if (httpMethod == 1) {//get
      if (sg_cacheGet) {
          if (sg_shoulObtainLocalWhenUnconnected) {
              if (sg_networkStatus == kQSNetworkStatusNotReachable ||  sg_networkStatus == kQSNetworkStatusUnknown ) {
                  id response = [QSNetworking cahceResponseWithURL:absolute
                                                         parameters:params];
                  if (response) {
                      if (success) {
                          [self successResponse:response callback:success];
                          
                          if ([self isDebug]) {
                              [self logWithSuccessResponse:response
                                                       url:absolute
                                                    params:params];
                          }
                      }
                      return nil;
                  }
              }
          }
          if (!refreshCache) {// 获取缓存 
              id response = [QSNetworking cahceResponseWithURL:absolute
                                                     parameters:params];
              if (response) {
                  if (success) {
                      [self successResponse:response callback:success];
                      
                      if ([self isDebug]) {
                          [self logWithSuccessResponse:response
                                                   url:absolute
                                                params:params];
                      }
                  }
                  return nil;
              }
          }
      }
    
    session = [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
      if (progress) {
        progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
      }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      [self successResponse:responseObject callback:success];
      
      if (sg_cacheGet) {
        [self cacheResponseObject:responseObject request:task.currentRequest parameters:params];
      }
      
      [[self allTasks] removeObject:task];
      
      if ([self isDebug]) {
        [self logWithSuccessResponse:responseObject
                                 url:absolute
                              params:params];
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      [[self allTasks] removeObject:task];
      
      if ([error code] < 0 && sg_cacheGet) {// 获取缓存
        id response = [QSNetworking cahceResponseWithURL:absolute
                                               parameters:params];
        if (response) {
          if (success) {
            [self successResponse:response callback:success];
            
            if ([self isDebug]) {
              [self logWithSuccessResponse:response
                                       url:absolute
                                    params:params];
            }
          }
        } else {
          [self handleCallbackWithError:error fail:fail];
          
          if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:params];
          }
        }
      } else {
        [self handleCallbackWithError:error fail:fail];
        
        if ([self isDebug]) {
          [self logWithFailError:error url:absolute params:params];
        }
      }
    }];
  } else if (httpMethod == 2) {
      if (sg_cachePost ) {// 获取缓存
          if (sg_shoulObtainLocalWhenUnconnected) {
              if (sg_networkStatus == kQSNetworkStatusNotReachable ||  sg_networkStatus == kQSNetworkStatusUnknown ) {
                  id response = [QSNetworking cahceResponseWithURL:absolute
                                                         parameters:params];
                  if (response) {
                      if (success) {
                          [self successResponse:response callback:success];
                          
                          if ([self isDebug]) {
                              [self logWithSuccessResponse:response
                                                       url:absolute
                                                    params:params];
                          }
                      }
                      return nil;
                  }
              }
          }
          if (!refreshCache) {
              id response = [QSNetworking cahceResponseWithURL:absolute
                                                     parameters:params];
              if (response) {
                  if (success) {
                      [self successResponse:response callback:success];
                      
                      if ([self isDebug]) {
                          [self logWithSuccessResponse:response
                                                   url:absolute
                                                params:params];
                      }
                  }
                  return nil;
              }
          }
      }
    
    session = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
      if (progress) {
        progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
      }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      [self successResponse:responseObject callback:success];
//        NSHTTPURLResponse  * response = (NSHTTPURLResponse *)task.response;
//        response.allHeaderFields[]
      if (sg_cachePost) {
        [self cacheResponseObject:responseObject request:task.currentRequest  parameters:params];
      }
      
      [[self allTasks] removeObject:task];
      
      if ([self isDebug]) {
        [self logWithSuccessResponse:responseObject
                                 url:absolute
                              params:params];
      }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      [[self allTasks] removeObject:task];
      
      if ([error code] < 0 && sg_cachePost) {// 获取缓存
        id response = [QSNetworking cahceResponseWithURL:absolute
                                               parameters:params];
        
        if (response) {
          if (success) {
            [self successResponse:response callback:success];
            
            if ([self isDebug]) {
              [self logWithSuccessResponse:response
                                       url:absolute
                                    params:params];
            }
          }
        } else {
          [self handleCallbackWithError:error fail:fail];
          
          if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:params];
          }
        }
      } else {
        [self handleCallbackWithError:error fail:fail];
        
        if ([self isDebug]) {
          [self logWithFailError:error url:absolute params:params];
        }
      }
    }];
  }
  
  if (session) {
    [[self allTasks] addObject:session];
  }
  
  return session;
}

+ (QSURLSessionTask *)uploadFileWithUrl:(NSString *)url
                           uploadingFile:(NSString *)uploadingFile
                                progress:(QSUploadProgress)progress
                                 success:(QSResponseSuccess)success
                                    fail:(QSResponseFail)fail {
  if ([NSURL URLWithString:uploadingFile] == nil) {
    DLog(@"uploadingFile无效，无法生成URL。请检查待上传文件是否存在");
    return nil;
  }
  
  NSURL *uploadURL = nil;
  if ([self baseUrl] == nil) {
    uploadURL = [NSURL URLWithString:url];
  } else {
    uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]];
  }
  
  if (uploadURL == nil) {
    DLog(@"URLString无效，无法生成URL。可能是URL中有中文或特殊字符，请尝试Encode URL");
    return nil;
  }
  
  AFHTTPSessionManager *manager = [self manager];
  NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
  QSURLSessionTask *session = nil;
  
  [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
    if (progress) {
      progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    }
  } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
    [[self allTasks] removeObject:session];
    
    [self successResponse:responseObject callback:success];
    
    if (error) {
      [self handleCallbackWithError:error fail:fail];
      
      if ([self isDebug]) {
        [self logWithFailError:error url:response.URL.absoluteString params:nil];
      }
    } else {
      if ([self isDebug]) {
        [self logWithSuccessResponse:responseObject
                                 url:response.URL.absoluteString
                              params:nil];
      }
    }
  }];
  
  if (session) {
    [[self allTasks] addObject:session];
  }
  
  return session;
}

+ (QSURLSessionTask *)uploadWithImage:(UIImage *)image
                                   url:(NSString *)url
                              filename:(NSString *)filename
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType
                            parameters:(NSDictionary *)parameters
                          headerParams:(NSDictionary *)headerParams
                              progress:(QSUploadProgress)progress
                               success:(QSResponseSuccess)success
                                  fail:(QSResponseFail)fail {
  if ([self baseUrl] == nil) {
    if ([NSURL URLWithString:url] == nil) {
      DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
      return nil;
    }
  } else {
    if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
      DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
      return nil;
    }
  }
  
  if ([self shouldEncode]) {
    url = [self encodeUrl:url];
  }
  
  NSString *absolute = [self absoluteUrlWithPath:url];
  
//  AFHTTPSessionManager *manager = [self manager];
//    AFHTTPSessionManager *manager = [self manager:[self requestHeader:parameters]];
    if ([GlobalConfigClass shareMySingle].userAndTokenModel.token) {
        NSMutableDictionary *header = (NSMutableDictionary *)[headerParams mutableCopy];
        header = header ?: [NSMutableDictionary new];
        header[@"token"] = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
        headerParams = header;
    }
    AFHTTPSessionManager *manager = [self manager:headerParams];

  QSURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    NSString *imageFileName = filename;
    if (filename == nil || ![filename isKindOfClass:[NSString class]] || filename.length == 0) {
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = @"yyyyMMddHHmmss";
      NSString *str = [formatter stringFromDate:[NSDate date]];
      imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
    }
    
    // 上传图片，以文件流的格式
    [formData appendPartWithFileData:imageData name:name fileName:imageFileName mimeType:mimeType];
  } progress:^(NSProgress * _Nonnull uploadProgress) {
    if (progress) {
      progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
    }
  } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    [[self allTasks] removeObject:task];
    [self successResponse:responseObject callback:success];
    
    if ([self isDebug]) {
      [self logWithSuccessResponse:responseObject
                               url:absolute
                            params:parameters];
    }
  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    [[self allTasks] removeObject:task];
    
    [self handleCallbackWithError:error fail:fail];
    
    if ([self isDebug]) {
      [self logWithFailError:error url:absolute params:nil];
    }
  }];
  
  [session resume];
  if (session) {
    [[self allTasks] addObject:session];
  }
  
  return session;
}

+ (QSURLSessionTask *)uploadWithImages:(NSArray *)images
                                  url:(NSString *)url
                           parameters:(NSDictionary *)parameters
                          headerParams:(NSDictionary *)headerParams
                             progress:(QSUploadProgress)progress
                              success:(QSResponseSuccess)success
                                 fail:(QSResponseFail)fail {
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
            DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self encodeUrl:url];
    }
    
    NSString *absolute = [self absoluteUrlWithPath:url];
    
//    AFHTTPSessionManager *manager = [self manager];
//    AFHTTPSessionManager *manager = [self manager:[self requestHeader:parameters]];
    if ([GlobalConfigClass shareMySingle].userAndTokenModel.token) {
        NSMutableDictionary *header = (NSMutableDictionary *)[headerParams mutableCopy];
        header[@"token"] = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
        headerParams = header;
    }
    AFHTTPSessionManager *manager = [self manager:headerParams];
    
    QSURLSessionTask *session = [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *imgName;
        for (NSData *data in images) {
            static int i = 0;
            imgName = [NSString stringWithFormat:@"%@%d", str,i];
            [formData appendPartWithFileData:data name:imgName fileName:[imgName stringByAppendingString:@".png"] mimeType:@"image/png"];
            i ++;
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allTasks] removeObject:task];
        [self successResponse:responseObject callback:success];
        
        if ([self isDebug]) {
            [self logWithSuccessResponse:responseObject
                                     url:absolute
                                  params:parameters];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allTasks] removeObject:task];
        
        [self handleCallbackWithError:error fail:fail];
        
        if ([self isDebug]) {
            [self logWithFailError:error url:absolute params:nil];
        }
    }];
    
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    
    return session;
}

+ (QSURLSessionTask *)downloadWithUrl:(NSString *)url
                            saveToPath:(NSString *)saveToPath
                              progress:(QSDownloadProgress)progressBlock
                               success:(QSResponseSuccess)success
                               failure:(QSResponseFail)failure {
  if ([self baseUrl] == nil) {
    if ([NSURL URLWithString:url] == nil) {
      DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
      return nil;
    }
  } else {
    if ([NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [self baseUrl], url]] == nil) {
      DLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
      return nil;
    }
  }
  
  NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPSessionManager *manager = [self manager];
  
  QSURLSessionTask *session = nil;
  
  session = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
    if (progressBlock) {
      progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
    }
  } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    return [NSURL URLWithString:saveToPath];
  } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
    [[self allTasks] removeObject:session];
    
    if (error == nil) {
      if (success) {
        success(filePath.absoluteString);
      }
      
      if ([self isDebug]) {
        DLog(@"Download success for url %@",
                  [self absoluteUrlWithPath:url]);
      }
    } else {
      [self handleCallbackWithError:error fail:failure];
      
      if ([self isDebug]) {
        DLog(@"Download fail for url %@, reason : %@",
                  [self absoluteUrlWithPath:url],
                  [error description]);
      }
    }
  }];
  
  [session resume];
  if (session) {
    [[self allTasks] addObject:session];
  }
  
  return session;
}

#pragma mark - Private
// by qingsong
+ (AFHTTPSessionManager *)manager:(NSDictionary *)httpHeaderDict {
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = nil;;
    if ([self baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    } else {
        manager = [AFHTTPSessionManager manager];
    }
    
    switch (sg_requestType) {
        case kQSRequestTypeJSON: {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case kQSRequestTypePlainText: {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    
    switch (sg_responseType) {
        case kQSResponseTypeJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case kQSResponseTypeXML: {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case kQSResponseTypeData: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    
    // hidden by qingsong
    for (NSString *key in httpHeaderDict.allKeys) {
        if (httpHeaderDict[key] != nil) {
            [manager.requestSerializer setValue:httpHeaderDict[key] forHTTPHeaderField:key];
        }
    }
    


    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    manager.requestSerializer.timeoutInterval = sg_timeout;
    
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    if (sg_shoulObtainLocalWhenUnconnected && (sg_cacheGet || sg_cachePost ) ) {
        [self detectNetwork];
    }
    return manager;
}
+ (AFHTTPSessionManager *)manager {
  // 开启转圈圈
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  
  AFHTTPSessionManager *manager = nil;;
  if ([self baseUrl] != nil) {
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
  } else {
    manager = [AFHTTPSessionManager manager];
  }
  
  switch (sg_requestType) {
    case kQSRequestTypeJSON: {
      manager.requestSerializer = [AFJSONRequestSerializer serializer];
      break;
    }
    case kQSRequestTypePlainText: {
      manager.requestSerializer = [AFHTTPRequestSerializer serializer];
      break;
    }
    default: {
      break;
    }
  }
  
  switch (sg_responseType) {
    case kQSResponseTypeJSON: {
      manager.responseSerializer = [AFJSONResponseSerializer serializer];
      break;
    }
    case kQSResponseTypeXML: {
      manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
      break;
    }
    case kQSResponseTypeData: {
      manager.responseSerializer = [AFHTTPResponseSerializer serializer];
      break;
    }
    default: {
      break;
    }
  }
  
  manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
  
  // hidden by qingsong
  for (NSString *key in sg_httpHeaders.allKeys) {
    if (sg_httpHeaders[key] != nil) {
      [manager.requestSerializer setValue:sg_httpHeaders[key] forHTTPHeaderField:key];
    }
  }
    
  manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                            @"text/html",
                                                                            @"text/json",
                                                                            @"text/plain",
                                                                            @"text/javascript",
                                                                            @"text/xml",
                                                                            @"image/*"]];
  
  manager.requestSerializer.timeoutInterval = sg_timeout;
  
  // 设置允许同时最大并发数量，过大容易出问题
  manager.operationQueue.maxConcurrentOperationCount = 3;

  if (sg_shoulObtainLocalWhenUnconnected && (sg_cacheGet || sg_cachePost ) ) {
      [self detectNetwork];
  }
  return manager;
}

+ (void)detectNetwork{
  AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
  [reachabilityManager startMonitoring];
  [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      if (status == AFNetworkReachabilityStatusNotReachable){
          sg_networkStatus = kQSNetworkStatusNotReachable;
      }else if (status == AFNetworkReachabilityStatusUnknown){
          sg_networkStatus = kQSNetworkStatusUnknown;
      }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
          sg_networkStatus = kQSNetworkStatusReachableViaWWAN;
      }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
          sg_networkStatus = kQSNetworkStatusReachableViaWiFi;
      }
  }];
}

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
  DLog(@"\n");
  DLog(@"\nRequest success, URL: %@\n params:%@\n response:%@\n\n",
            [self generateGETAbsoluteURL:url params:params],
            params,
            [self tryToParseData:response]);
}

+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
  NSString *format = @" params: ";
  if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
    format = @"";
    params = @"";
  }
  
  DLog(@"\n");
  if ([error code] == NSURLErrorCancelled) {
    DLog(@"\nRequest was canceled mannully, URL: %@ %@%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params);
  } else {
    DLog(@"\nRequest error, URL: %@ %@%@\n errorInfos:%@\n\n",
              [self generateGETAbsoluteURL:url params:params],
              format,
              params,
              [error localizedDescription]);
  }
}

// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
  if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
    return url;
  }
  
  NSString *queries = @"";
  for (NSString *key in params) {
    id value = [params objectForKey:key];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
      continue;
    } else if ([value isKindOfClass:[NSArray class]]) {
      continue;
    } else if ([value isKindOfClass:[NSSet class]]) {
      continue;
    } else {
      queries = [NSString stringWithFormat:@"%@%@=%@&",
                 (queries.length == 0 ? @"&" : queries),
                 key,
                 value];
    }
  }
  
  if (queries.length > 1) {
    queries = [queries substringToIndex:queries.length - 1];
  }
  
  if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
    if ([url rangeOfString:@"?"].location != NSNotFound
        || [url rangeOfString:@"#"].location != NSNotFound) {
      url = [NSString stringWithFormat:@"%@%@", url, queries];
    } else {
      queries = [queries substringFromIndex:1];
      url = [NSString stringWithFormat:@"%@?%@", url, queries];
    }
  }
  
  return url.length == 0 ? queries : url;
}


+ (NSString *)encodeUrl:(NSString *)url {
  return [self QS_URLEncode:url];
}

+ (id)tryToParseData:(id)responseData {
  if ([responseData isKindOfClass:[NSData class]]) {
    // 尝试解析成JSON
    if (responseData == nil) {
      return responseData;
    } else {
      NSError *error = nil;
      NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
      
      if (error != nil) {
        return responseData;
      } else {
        return response;
      }
    }
  } else {
    return responseData;
  }
}

+ (void)successResponse:(id)responseData callback:(QSResponseSuccess)success {
  if (success) {
      id response = [self tryToParseData:responseData];
      
      if ([response[@"code"] integerValue] == 1040) {
          [GlobalConfigClass shareMySingle].userAndTokenModel = nil;
          UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
          UINavigationController *navVC = (UINavigationController *)tabBarVC.selectedViewController;
          
          LoginViewController * loginVC = [[LoginViewController alloc] init];
          [loginVC setHidesBottomBarWhenPushed:YES];
          [navVC pushViewController:loginVC animated:YES];
      }
    success(response);
  }
}

+ (NSString *)QS_URLEncode:(NSString *)url {
  NSString *newString =
  CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                            (CFStringRef)url,
                                                            NULL,
                                                            CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
  if (newString) {
    return newString;
  }
  
  return url;
}

+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
  id cacheData = nil;
  
  if (url) {
    // Try to get datas from disk
    NSString *directoryPath = cachePath();
    NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
    NSString *key = [NSString QSnetworking_md5:absoluteURL];
    NSString *path = [directoryPath stringByAppendingPathComponent:key];
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    if (data) {
      cacheData = data;
      DLog(@"Read data from cache for url: %@\n", url);
    }
  }
  
  return cacheData;
}

+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
  if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
    NSString *directoryPath = cachePath();
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
      [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:&error];
      if (error) {
        DLog(@"create cache dir error: %@\n", error);
        return;
      }
    }
    
    NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
    NSString *key = [NSString QSnetworking_md5:absoluteURL];
    NSString *path = [directoryPath stringByAppendingPathComponent:key];
    NSDictionary *dict = (NSDictionary *)responseObject;
    
    NSData *data = nil;
    if ([dict isKindOfClass:[NSData class]]) {
      data = responseObject;
    } else {
      data = [NSJSONSerialization dataWithJSONObject:dict
                                             options:NSJSONWritingPrettyPrinted
                                               error:&error];
    }
    
    if (data && error == nil) {
      BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
      if (isOk) {
        DLog(@"cache file ok for request: %@\n", absoluteURL);
      } else {
        DLog(@"cache file error for request: %@\n", absoluteURL);
      }
    }
  }
}

+ (NSString *)absoluteUrlWithPath:(NSString *)path {
  if (path == nil || path.length == 0) {
    return @"";
  }
  
  if ([self baseUrl] == nil || [[self baseUrl] length] == 0) {
    return path;
  }
  
  NSString *absoluteUrl = path;
  
  if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
      if ([[self baseUrl] hasSuffix:@"/"]) {
          if ([path hasPrefix:@"/"]) {
              NSMutableString * mutablePath = [NSMutableString stringWithString:path];
              [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
              absoluteUrl = [NSString stringWithFormat:@"%@%@",
                             [self baseUrl], mutablePath];
          }else {
              absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
          }
      }else {
          if ([path hasPrefix:@"/"]) {
              absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl], path];
          }else {
              absoluteUrl = [NSString stringWithFormat:@"%@/%@",
                             [self baseUrl], path];
          }
      }
  }
  
  return absoluteUrl;
}

+ (void)handleCallbackWithError:(NSError *)error fail:(QSResponseFail)fail {
  if ([error code] == NSURLErrorCancelled) {
    if (sg_shouldCallbackOnCancelRequest) {
      if (fail) {
        fail(error);
      }
    }
  } else {
      
      if (error) {
          
          if (error.code == 400) {
              error = [NSError errorWithDomain:@"服务器连接失败" code:error.code userInfo:@{NSLocalizedDescriptionKey : @"服务器连接失败！"}];
              
          } else if (error.code == -1004 || error.code == -1003 || error.code == -1009 ) {
              
              error = [NSError errorWithDomain:@"似乎已断开与互联网的连接！" code:error.code userInfo:@{NSLocalizedDescriptionKey : @"似乎已断开与互联网的连接！"}];
              
          } else if (error.code == -1005) {
              // 网络连接丢失
              error = [NSError errorWithDomain:@"网络连接丢失！" code:error.code userInfo:@{NSLocalizedDescriptionKey : @"网络连接丢失！"}];
              
          } else if(error.code == -1001 || error.code == -2000) {
              
              // NSURLErrorTimedOut 网络连接超时
              error = [NSError errorWithDomain:@"网络连接超时！" code:error.code userInfo:@{NSLocalizedDescriptionKey : @"网络连接超时！"}];
              
          }  else if(error.code == -999) {
              
              // NSURLErrorTimedOut 网络连接超时
              error = [NSError errorWithDomain:@"网络连接超时！" code:error.code userInfo:@{NSLocalizedDescriptionKey : @"网络连接超时！"}];
          }
      } else {
          
          error = [NSError errorWithDomain:@"未知错误" code:400 userInfo:@{NSLocalizedDescriptionKey : @"未知错误！"}];
      }
      if (fail) {
          fail(error);
      }

      if (fail) {
          fail(error);
      }
  }
}

//// 请求头
//+ (NSDictionary *)requestHeader:(NSDictionary *)parameterDict {
//
//    NSString *postHeaderString = @"";
//    if (parameterDict) {
//        NSError *error = nil;
//        NSString *str = @"";
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDict
//                                                           options:NSJSONWritingPrettyPrinted
//                                                             error:&error];
//        if ([jsonData length] > 0 && error == nil){
//            str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        }else{
//            str = [[NSString alloc] initWithData:[NSData data] encoding:NSUTF8StringEncoding];
//        }
//
//        NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//        NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@" " withString:@""];
//        NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"'\'" withString:@""];
//
//        postHeaderString = [self postBodyForHeader:str4];
//
//        return @{@"android-datas" : postHeaderString};
//    }
//    return nil;
//}

////签名校验
//+ (NSString *)postBodyForHeader:(NSString *)signString {
//
//    GlobalConfigClass *configClass = [GlobalConfigClass shareMySingle];
//    NSString * puid = [NSString stringWithFormat:@"%ld",(long)configClass.uid];
//    NSString *nonce =[self uuid];
//    NSString *sign= [NSString stringWithFormat:@"%@%@",nonce,signString];
//    sign = [NSString QSnetworking_md5:sign];
//    NSString* mobile_model = [[UIDevice currentDevice] model];//手机型号
//    NSString *strSysName = [[UIDevice currentDevice] systemName];//系统名称
//    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];//手机系统版本号
//    NSString *mobile_system = [NSString stringWithFormat:@"%@ %@",strSysName,strSysVersion];
//    //app应用相关信息的获取
//    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_version = [dicInfo objectForKey:@"CFBundleShortVersionString"];//App应用版本
//    NSString *allInfo = [NSString stringWithFormat:@"uid=%@,access_token="",nonce=%@,sign=%@,mobile_model=%@,mobile_system=%@,app_version=%@",puid,nonce,sign,mobile_model,mobile_system,app_version];
//
//    return allInfo;
//}

//+ (NSString*) uuid {
//
//    CFUUIDRef puuid = CFUUIDCreate( nil );
//    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
//    CFRelease(puuid);
//    CFRelease(uuidString);
//    NSArray * array = [result componentsSeparatedByString:@"-"];
//    NSString *string = [NSString stringWithFormat:@"%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4]];
//    return string ;
//}

@end
