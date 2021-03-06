/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to deal in the Software        */
/* without restriction, including without           */
/* limitation the rights to use, copy, modify,      */
/* merge, publish, distribute, sublicense,          */
/* and/or sell copies of the Software, and to       */
/* permit persons to whom the Software is furnished */
/* to do so, subject to the following conditions:   */
/*                                                  */
/* The above copyright notice and this permission   */
/* notice shall be included in all copies or        */
/* substantial portions of the Software.            */
/*                                                  */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT        */
/* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        */
/* INCLUDING BUT NOT LIMITED TO THE WARRANTIES      */
/* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR     */
/* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   */
/* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR   */
/* ANY CLAIM, DAMAGES OR OTHER LIABILITY,           */
/* WHETHER IN AN ACTION OF CONTRACT, TORT OR        */
/* OTHERWISE, ARISING FROM, OUT OF OR IN            */
/* CONNECTION WITH THE SOFTWARE OR THE USE OR       */
/* OTHER DEALINGS IN THE SOFTWARE.                  */
/*                                                  */
/*--------------------------------------------------*/

#import <MobilyCore/MobilyObject.h>

/*--------------------------------------------------*/

@protocol MobilyHttpQueryDelegate;

/*--------------------------------------------------*/

typedef void (^MobilyHttpQueryBlock)();
typedef void (^MobilyHttpQueryErrorBlock)(NSError* error);

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyHttpQuery : NSObject < MobilyObject >

@property(nonatomic, readwrite, strong) NSString* certificateFilename;
@property(nonatomic, readwrite, assign) BOOL allowInvalidCertificates;

@property(nonatomic, readwrite, strong) NSURL* requestUrl;
@property(nonatomic, readwrite, strong) NSString* requestMethod;
@property(nonatomic, readwrite, strong) NSDictionary* requestHeaders;
@property(nonatomic, readwrite, strong) NSData* requestBody;
@property(nonatomic, readwrite, assign) NSTimeInterval requestTimeout;

@property(nonatomic, readonly, assign) NSInteger responseStatusCode;
@property(nonatomic, readonly, strong) NSString* responseMimeType;
@property(nonatomic, readonly, strong) NSString* responseTextEncoding;
@property(nonatomic, readonly, strong) NSDictionary* responseHeaders;
@property(nonatomic, readonly, strong) NSData* responseData;

@property(nonatomic, readonly, assign) NSString* responseString;
@property(nonatomic, readonly, strong) NSDictionary* responseJsonObject;
@property(nonatomic, readonly, strong) NSArray* responseJsonArray;
@property(nonatomic, readonly, assign) id responseJson;

@property(nonatomic, readonly, strong) NSError* error;

@property(nonatomic, readwrite, weak) id< MobilyHttpQueryDelegate > delegate;
@property(nonatomic, readwrite, copy) MobilyHttpQueryBlock startCallback;
@property(nonatomic, readwrite, copy) MobilyHttpQueryBlock cancelCallback;
@property(nonatomic, readwrite, copy) MobilyHttpQueryBlock finishCallback;
@property(nonatomic, readwrite, copy) MobilyHttpQueryErrorBlock errorCallback;

- (void)setup NS_REQUIRES_SUPER;

- (void)setRequestUrl:(NSURL*)url params:(NSDictionary*)params;
- (void)setRequestUrlParams:(NSDictionary*)params;
- (void)setRequestBodyParams:(NSDictionary*)params encodeParamKey:(BOOL)encodeParamKey encodeParamValue:(BOOL)encodeParamValue;
- (void)setRequestBodyParams:(NSDictionary*)params encodeParamKey:(BOOL)encodeParamKey encodeParamValue:(BOOL)encodeParamValue boundary:(NSString*)boundary attachments:(NSArray*)attachments;

- (void)addRequestHeader:(NSString*)header value:(NSString*)value;
- (void)addRequestHeaders:(NSDictionary*)headers;
- (void)removeRequestHeader:(NSString*)header;
- (void)removeRequestHeaders:(NSArray*)headers;

- (void)start;
- (void)cancel;

@end

/*--------------------------------------------------*/

MOBILY_REQUIRES_PROPERTY_DEFINITIONS
@interface MobilyHttpAttachment : NSObject < MobilyObject >

@property(nonatomic, readonly, strong) NSString* name;
@property(nonatomic, readwrite, assign) BOOL encodeName;
@property(nonatomic, readonly, strong) NSString* filename;
@property(nonatomic, readwrite, assign) BOOL encodeFilename;
@property(nonatomic, readonly, strong) NSString* mimeType;
@property(nonatomic, readwrite, assign) BOOL encodeMimeType;
@property(nonatomic, readonly, strong) NSData* data;

- (instancetype)initWithName:(NSString*)name filename:(NSString*)filename mimeType:(NSString*)mimeType data:(NSData*)data;

@end

/*--------------------------------------------------*/

@protocol MobilyHttpQueryDelegate < NSObject >

@optional
- (void)didStartHttpQuery:(MobilyHttpQuery*)httpQuery;
- (void)didCancelHttpQuery:(MobilyHttpQuery*)httpQuery;
- (void)didFinishHttpQuery:(MobilyHttpQuery*)httpQuery;
- (void)httpQuery:(MobilyHttpQuery*)httpQuery didError:(NSError*)error;

@end

/*--------------------------------------------------*/
