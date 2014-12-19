//
//  FSEntityRequestBase.h
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "FSModelBase.h"
@class FSEntityRequestBase;

typedef void (^FSRequestLoadComplete) (FSEntityBase *);

typedef void(^DataSourceProviderRequestBlock)(FSEntityRequestBase *);
typedef void(^DataSourceProviderRequest2Block)(FSEntityRequestBase *,dispatch_block_t);

@interface FSEntityRequestBase : NSObject<RKObjectLoaderDelegate>

@property(nonatomic,strong) NSString *routeResourcePath;
@property(nonatomic,assign) RKRequestMethod requestMethod;
@property(nonatomic,assign) BOOL isCollection;
@property(nonatomic,strong) NSString *rootKeyPath;

-(NSString *) appendCommonRequestQueryPara:(RKObjectManager *)manager;

-(void) send:(Class)responseClass withRequest:(FSEntityRequestBase *)request completeCallBack:(FSRequestLoadComplete)completeCallback;

-(void) setMappingRequestAttribute:(RKObjectMapping *)map;

//type==1:REST_API_URL
//type==2:REST_API_URL_OUT
-(void)setBaseURL:(int)type;



@end
