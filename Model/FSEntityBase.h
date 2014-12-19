//
//  FSEntityBase.h
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonResponseHeader.h"

typedef enum{
    NoError = 0,
    NetworkError = 1,
    ServerInternal = 2,
    UnAuthorized = 3,
    Other = 4
    
}FSNetworkErrorType;

typedef enum{
    FSSourceAll = 0,
    FSSourceProduct = 1,
    FSSourcePromotion = 2,
    FSSourceComment = 3,
}FSSourceType;


typedef  enum
{
    FSNormalUser = 1,
    FSDARENUser = 2
}FSUserLevel;

typedef  enum
{
    FSProSortByDate = 1,
    FSProSortByPre = 2,
    FSProSortByDist = 3,
    FSProSortDefault,
}FSProSortType;

typedef  enum
{
    FSProdSortDefault = 1,
}FSProdSortType;

@class FSEntityRequestBase;
@interface FSEntityBase : NSObject

@property(nonatomic,strong) FSEntityRequestBase * request;
@property(nonatomic,strong) NSString * statusCode;
@property(nonatomic,strong) NSNumber * isSuccessful;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) id responseData;
@property(nonatomic,strong) Class dataClass;

@property(nonatomic,assign) BOOL isSuccess;
@property(nonatomic,strong) NSString *errorDescrip;
@property(nonatomic,assign) FSNetworkErrorType errorType;
@property(nonatomic,strong) RKObjectMapping *requestMap;



+ (void) setMappingForCommonHeader:(RKObjectMapping *)mapping;

-(void) mapRequestReponse:(RKObjectMapping*)map toManager:(RKObjectManager *)innerManager;


@end
