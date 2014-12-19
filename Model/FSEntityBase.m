//
//  FSEntityBase.m
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityBase.h"
#import "FSEntityRequestBase.h"
#import "FSModelBase.h"

@interface FSEntityBase(){
  
}
@end

@implementation FSEntityBase

@synthesize request;

@synthesize statusCode,isSuccessful,message;
@synthesize responseData,dataClass;
@synthesize isSuccess,errorDescrip;
@synthesize errorType;
@synthesize requestMap = _requestMap;

+ (void) setMappingForCommonHeader:(RKObjectMapping *)mapping{
    
    [mapping mapKeyPathsToAttributes:@"statusCode",@"statusCode",@"isSuccessful",@"isSuccessful",@"message",@"message",nil];
       
}

-(void) mapRequestReponse:(RKObjectMapping *)map toManager:(RKObjectManager *)innerManager
{
    //0:register common header
    [FSEntityBase setMappingForCommonHeader:map];
    //1:register request
    RKObjectMapping *rMap = [RKObjectMapping mappingForClass:self.class];
    [request setMappingRequestAttribute:rMap];    
   // [innerManager.mappingProvider setSerializationMapping:[requestMap inverseMapping] forClass:self.class];
    _requestMap = [rMap inverseMapping];

    //2:register response
    if (![dataClass conformsToProtocol:@protocol(FSModelMappable)] &&
        ![dataClass conformsToProtocol:@protocol(FSManagedModelMappable)])
    {
        NSLog(@"class not inherits from FSModelBase");
        return;
    }
    NSString *relationKeyPath = request.rootKeyPath;
    
    RKObjectMapping *dataRelationMap = nil;
    if ([dataClass conformsToProtocol:@protocol(FSManagedModelMappable) ])
        dataRelationMap= [dataClass getRelationDataMap:dataClass withParentMap:nil];
    else
        dataRelationMap=[dataClass getRelationDataMap];
    
    if (dataRelationMap)
        [map mapKeyPath:relationKeyPath toRelationship:@"responseData" withMapping:dataRelationMap];
    [innerManager.mappingProvider setMapping:map forKeyPath:@""];
    
}



@end
