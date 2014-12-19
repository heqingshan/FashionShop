//
//  FSCache.m
//  VANCL
//
//  Created by yek on 10-12-22.
//  Copyright 2010 yek. All rights reserved.
//

#import "FSCache.h"

@interface FSCacheItem : NSObject<NSCoding>
{
	id object;
	id key;
	NSDate* expireDate;
}
@property(nonatomic,retain) id object;
@property(nonatomic,retain) id key;
@property(nonatomic,retain) NSDate* expireDate;

@end

@implementation FSCacheItem
@synthesize object;
@synthesize key;
@synthesize expireDate;

-(void) encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:key forKey:@"key"];
	[aCoder encodeObject:expireDate forKey:@"expireDate"];
	[aCoder encodeObject:object forKey:@"object"];
}
-(id) initWithCoder:(NSCoder *)aDecoder{
	if(self=[super init]){
		self.key=[aDecoder decodeObjectForKey:@"key"];
		self.expireDate=[aDecoder decodeObjectForKey:@"expireDate"];
		self.object=[aDecoder decodeObjectForKey:@"object"];
	}
	return self;
}
-(void) dealloc{
	[key release];
	[object release];
	[expireDate release];
	[super dealloc];
}

@end



@implementation FSMemoryCache

-(id) init{
	if(self=[super init]){
		//fileBasePath=[NSTemporaryDirectory() stringByAppendingPathComponent:@"FileCache"];
		dic=[[NSMutableDictionary alloc] init];
	}
	return self;
}
-(void) dealloc{
	[dic release];
	[super dealloc];
}

-(void) setObject:(id <NSCoding>)object forKey:(id)key{
	[self setObject:object forKey:key expireDate:[NSDate distantFuture]];
}

-(void) setObject:(id <NSCoding>)object forKey:(id)key expireDate:(NSDate *)expireDate{
	assert(key!=nil);
	if(object==nil){
		[self removeObjectForKey:key];
	}else{
		FSCacheItem* item=[[FSCacheItem alloc] init];
		item.key=key;
		item.object=object;
		item.expireDate=expireDate;
		@synchronized(dic){
			[dic setObject:item forKey:key];
		}
		[item autorelease];
	}
}

-(void) removeObjectForKey:(id)key{
	assert(key!=nil);
	@synchronized(dic){
		[dic removeObjectForKey:key];
	}
}

-(id) objectForKey:(id)key{
	assert(key!=nil);
	id ret=nil;
	FSCacheItem* item=[dic objectForKey:key];
	if(item!=nil){
		NSDate* nowDate=[NSDate date];
		if([nowDate compare:item.expireDate]==NSOrderedAscending){
			ret=item.object;
		}else{
			[self removeObjectForKey:key];
		}
	}
	return ret;
}

-(int) count{
	return [dic count];
}
@end


@implementation FSFileCache
NSString* const FSFileCacheFileName=@"FileCache_default2.dat";

-(void) internalInit{
	if(autoSaveInterval<=0){
		autoSaveInterval=10;
	}
	if([[NSFileManager defaultManager] fileExistsAtPath:dicFilePath]){
	  //dic=[[NSMutableDictionary dictionaryWithContentsOfFile:dicFilePath] retain];
		dic=[[NSKeyedUnarchiver unarchiveObjectWithFile:dicFilePath] retain];
	}
	
	if(nil==dic || ![dic isKindOfClass:[NSMutableDictionary class]]){
		if(dic!=nil){[dic release];}
		dic=[[NSMutableDictionary alloc] init];
	}
	assert(dic!=nil);
	needSave=NO;
	saveTimer=[NSTimer scheduledTimerWithTimeInterval:autoSaveInterval target:self selector:@selector(save:) userInfo:nil repeats:YES];
}

-(void) save{
	assert(dicFilePath!=nil);
	NSMutableDictionary* tempDic=[[NSMutableDictionary alloc] init];
	@synchronized(dic){
		[tempDic addEntriesFromDictionary:dic];
	}
	NSArray* keyArray=[tempDic allKeys];
	NSMutableArray* toRemoveKeyArray=[[NSMutableArray alloc] init];
	for(id key in keyArray){
		if([tempDic objectForKey:key]==nil){
			[toRemoveKeyArray addObject:key];
		}
	}
	[tempDic removeObjectsForKeys:toRemoveKeyArray];
	[toRemoveKeyArray release];
	
	BOOL success=[NSKeyedArchiver archiveRootObject:tempDic toFile:dicFilePath];
	[tempDic release];
	assert(success);
}

-(void) save:(NSTimer*) timer{
	NSAutoreleasePool* pool=[[NSAutoreleasePool alloc] init];
	if(needSave){
		[self save];
	}
	needSave=NO;
	[pool release];
}

-(id) init{
	if(self=[super init]){
		dicFilePath=[documentFilePath(FSFileCacheFileName) copy];
		autoSaveInterval=10;
		[self internalInit];
	}
	return self;
}

-(id) initWithFileName:(NSString*) fileName{
	if(self=[super init]){
		dicFilePath=[documentFilePath(fileName) copy];
		autoSaveInterval=10;
		[self internalInit];
	}
	return self;
}
-(id) initWithFilePath:(NSString*) filePath{
	if(self=[super init]){
		dicFilePath=[filePath copy];
		autoSaveInterval=10;
		[self internalInit];
	}
	return self;
}
-(id) initWithFileName:(NSString*) fileName autoSaveInterval:(NSTimeInterval) interval{
	if(self=[super init]){
		dicFilePath=[documentFilePath(fileName) copy];
		autoSaveInterval=interval;
		[self internalInit];
	}
	return self;
}
-(id) initWithFilePath:(NSString*) filePath autoSaveInterval:(NSTimeInterval) interval{
	if(self=[super init]){
		dicFilePath=[filePath copy];
		autoSaveInterval=interval;
		[self internalInit];
	}
	return self;
}

-(void) dealloc{
	[saveTimer invalidate];
	[self save];
	[dic release];
	[dicFilePath release];
	[super dealloc];
}
/*
 return $(tempdir)/[yyyy]/[MM]/[dd]/[HH]/[mm]
 */
-(NSString*) getPath:(FSCacheItem*)item{
	NSDate* nowDate=[NSDate date];
	
	NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
	NSArray* formatterArray=[NSArray arrayWithObjects:@"yyyy",@"MM",@"dd",@"HH",@"mm",nil];
	NSString* ret=NSTemporaryDirectory();
	for(NSString* formatter in formatterArray){
		[dateFormatter setDateFormat:formatter];
		ret=[ret stringByAppendingPathComponent:[dateFormatter stringFromDate:nowDate]];
	}
	NSFileManager* fm=[NSFileManager defaultManager];
	if(![fm fileExistsAtPath:ret]){
		[fm createDirectoryAtPath:ret withIntermediateDirectories:YES attributes:nil error:nil];
	}
	ret=[ret stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.dat",[nowDate timeIntervalSince1970] ]];
	//NSLog(@"FSFileCache::getPath return %@",ret);
	[dateFormatter release];
	assert(ret!=nil);
	return ret;
}
-(void) setObject:(id <NSCoding>)object forKey:(id)key{
	[self setObject:object forKey:key expireDate:[NSDate distantFuture]];
}

-(void) setObject:(id <NSCoding>)object forKey:(id)key expireDate:(NSDate *)expireDate{
	//NSLog(@"object is %@ , key is %@ expireData is %@",[object class], [key class], [expireDate class]);
	assert(key!=nil);
	if(object==nil){
		[self removeObjectForKey:key];
	}	
	FSCacheItem* item=[dic objectForKey:key];
	if(nil==item){
		item=[[FSCacheItem alloc] init];
		item.key=key;
		item.object=[self getPath:key];
		item.expireDate=expireDate;
		@synchronized(dic){
			[dic setObject:item forKey:key];
		}
		[item release];
	}
	NSString* objectFilePath=(NSString*)item.object;
	assert(objectFilePath!=nil);
	[NSKeyedArchiver archiveRootObject:object toFile:objectFilePath];
	needSave=YES;
}

-(id) objectForKey:(id)key{
	assert(key!=nil);
	id ret=nil;
	FSCacheItem* item=[dic objectForKey:key];
	if(item!=nil){
		NSDate* nowDate=[NSDate date];
		if([nowDate compare:item.expireDate]==NSOrderedDescending){
			//过期
			[self removeObjectForKey:key];
		}else{
			NSString* objectFilePath=(NSString*)item.object;
			assert(objectFilePath!=nil);
			if([[NSFileManager defaultManager] fileExistsAtPath:objectFilePath]){
				ret=[NSKeyedUnarchiver unarchiveObjectWithFile:objectFilePath];
			}
		}
	}
	return ret;
}

-(void) removeObjectForKey:(id)key{
	assert(key!=nil);
	FSCacheItem* item=[dic objectForKey:key];
	if(item!=nil){
		NSString* objectFilePath=(NSString*)item.object;
		[[NSFileManager defaultManager] removeItemAtPath:objectFilePath error:nil];		
		@synchronized(dic){
			[dic removeObjectForKey:key];
		}
	}
	needSave=YES;
}
-(int) count{
	return [dic count];
}
+(void) test{
	FSFileCache* cache=[[FSFileCache alloc] init];
	NSString* const oriString=@"fdsafdsafdsa fdsjaf dls辅导士大夫的萨芬大师傅d";
	NSString* const key=@"oriString";
	[cache setObject:oriString forKey:key];
	[cache save];
	NSString* newString=[cache objectForKey:key];
	if([oriString compare:newString]!=NSOrderedSame){
		NSLog(@"!!!error cache 可能工作不正常");		
	}
	NSLog(@"oriString=%@\n newString=%@",oriString,newString);
	[cache release];
}


@end



NSString* documentFilePath(NSString* fileName){
	assert(fileName!=nil);
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString* ret=[documentsDirectory stringByAppendingPathComponent:fileName];
	assert(ret!=nil);
	NSLog(@"documentFilePath(%@) return %@",fileName,ret);
	return ret;
}

