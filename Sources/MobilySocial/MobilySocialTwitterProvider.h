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

#import <MobilySocial/MobilySocialProvider.h>

/*--------------------------------------------------*/

@class MobilySocialTwitterSession;

/*--------------------------------------------------*/

@interface MobilySocialTwitterProvider : MobilySocialProvider

@property(nonatomic, readwrite, strong) NSString* consumerKey;
@property(nonatomic, readwrite, strong) NSString* consumerSecret;

@property(nonatomic, readwrite, strong) MobilySocialTwitterSession* session;

- (instancetype)initWithConsumerKey:(NSString*)consumerKey consumerSecret:(NSString*)consumerSecret;

- (void)signinSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure;
- (void)requestEmailSuccess:(MobilySocialProviderSuccessBlock)success failure:(MobilySocialProviderFailureBlock)failure;

@end

/*--------------------------------------------------*/

@interface MobilySocialTwitterSession : MobilySocialSession

@property(nonatomic, readonly, strong) NSString* authToken;
@property(nonatomic, readonly, strong) NSString* authTokenSecret;
@property(nonatomic, readonly, strong) NSString* userId;
@property(nonatomic, readonly, strong) NSString* userName;
@property(nonatomic, readonly, strong) NSString* email;

@end

/*--------------------------------------------------*/
