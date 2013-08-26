#import "Libzed_plist.h"

@implementation Libzed_plist

static Libzed_plist* InstanceofPlatform_pListWrapper= nil;

@synthesize defaults; 

- (id) init {
	static BOOL initialized = NO;
	if(NO == initialized) {
		self = [super init];
		InstanceofPlatform_pListWrapper = self;
		initialized = YES;
	}
	return self;
}

+ (id) allocWithZone:(NSZone*) zone{
	@synchronized (self){
		if(nil == InstanceofPlatform_pListWrapper){
			InstanceofPlatform_pListWrapper = [super allocWithZone:zone];
		}
	}
	return InstanceofPlatform_pListWrapper;
}

+(Libzed_plist*) sharedInstance{
	if( nil == InstanceofPlatform_pListWrapper){
		InstanceofPlatform_pListWrapper = [[Libzed_plist alloc] init];
        [InstanceofPlatform_pListWrapper create];
	}
	return InstanceofPlatform_pListWrapper;
}

-(void) create {
	NSString* ibundlePath = [[NSBundle mainBundle] bundlePath];
	NSString* pListPath = [ibundlePath stringByAppendingPathComponent:@"PackagesData.plist"];
	//NSLog(@"path %@", pListPath);
	NSDictionary* pListTimesheet = [NSDictionary dictionaryWithContentsOfFile:pListPath] ;
	
	//NSLog(@"description %@", [pListTimesheet description]);
	
	self.defaults = [NSUserDefaults standardUserDefaults];
	[self.defaults registerDefaults:pListTimesheet];
	[self.defaults synchronize];
}

-(void) destroy{
	/* FIX ME - should be implemented */
}

-(void) writeToFile:(NSString*)filename key:(NSString*)KeyID
{
	NSString* ibundlePath = [[NSBundle mainBundle] bundlePath];
	NSString* pListPath = [ibundlePath stringByAppendingPathComponent:filename];
    NSMutableDictionary* target = [[NSMutableDictionary alloc]
                                     initWithDictionary:[self.defaults objectForKey:KeyID]];
    [target writeToFile:pListPath atomically:NO];
}
/*
-(void) setStoryID:(NSString*)KeyID
           version:(NSString*)version_
     serverversion:(NSString*)serverversion_
           visible:(NSString*)visible_
{
    NSDictionary* src = [self getStoryID:(NSString*)KeyID];
    NSMutableDictionary* det=nil;
    NSMutableDictionary* pstories = [[NSMutableDictionary alloc]
                                     initWithDictionary:[self.defaults objectForKey:@"Stories"]];
    if (nil == src) {
        det = [[NSMutableDictionary alloc] init];
    } else {
        det = [src mutableCopy];
    }
    [det setValue:KeyID forKey:@"keyID"];
    [det setValue:version_ forKey:@"version"];
    [det setValue:serverversion_ forKey:@"serverversion"];
    [det setValue:visible_ forKey:@"visible"];
    [pstories setObject:det forKey:KeyID];
    //NSData *_messageData = [NSKeyedArchiver archivedDataWithRootObject:pstories];
	[self.defaults setObject:(NSDictionary*)pstories forKey:@"Stories"];
	[self.defaults synchronize];
    
#ifdef APPLICATION_RELEASE_SETTING_STORYENGINE_DEBUG
    [self writeToFile:@"stories.plist" key:@"Stories"];
#endif
}

-(void) setPageID:(NSString*)KeyID
          storyID:(NSString*)storyID
          version:(NSString*)version_
    serverversion:(NSString*)serverversion_
          visible:(NSString*)visible_
             name:(NSString*)name_
             text:(NSString*)text_
             mode:(NSString*)mode_
            point:(NSString*)point_
         sampleen:(NSString*)sampleen_
         sampleko:(NSString*)sampleko_
     passed_count:(NSString*)passed_count_
     failed_count:(NSString*)failed_count_
{
    NSDictionary* src = [self getPageID:(NSString*)KeyID];
    NSMutableDictionary* det=nil;
    NSMutableDictionary* ppages = [[NSMutableDictionary alloc]
                                     initWithDictionary:[self.defaults objectForKey:@"Pages"]];
    if (nil == src) {
        det = [[NSMutableDictionary alloc] init];
    } else {
        det = [src mutableCopy];
    }
    
    [det setValue:KeyID forKey:@"keyID"];
    [det setValue:storyID forKey:@"storyKeyID"];
    [det setValue:version_ forKey:@"version"];
    [det setValue:serverversion_ forKey:@"serverversion"];
    [det setValue:visible_ forKey:@"visible"];
    [det setValue:name_ forKey:@"name"];
    [det setValue:text_ forKey:@"text"];
    [det setValue:mode_ forKey:@"mode"];
    [det setValue:point_ forKey:@"point"];
    [det setValue:sampleen_ forKey:@"sampleen"];
    [det setValue:sampleko_ forKey:@"sampleko"];
    [det setValue:passed_count_ forKey:@"passed_count"];
    [det setValue:failed_count_ forKey:@"failed_count"];

    
    [ppages setObject:det forKey:KeyID];
	[self.defaults setObject:ppages forKey:@"Pages"];
	[self.defaults synchronize];
    
#ifdef APPLICATION_RELEASE_SETTING_STORYENGINE_DEBUG
    [self writeToFile:@"pages.plist" key:@"Pages"];
#endif
}
*/
-(void) setStringID:KeyID data:(NSString*)data_ {
    [self.defaults setObject:data_ forKey:KeyID];
	[self.defaults synchronize];
}

-(void) setArrayID:KeyID data:(NSArray*)data_ {
    [self.defaults setObject:data_ forKey:KeyID];
	[self.defaults synchronize];
}

-(void) setDictionaryID:KeyID data:(NSDictionary*)data_ {
    [self.defaults setObject:data_ forKey:KeyID];
	[self.defaults synchronize];
}

-(NSInteger) getexecount {
    return [self.defaults integerForKey:@"exeCount"];
}

-(void) setexecount:(NSInteger)integer {
    [self.defaults setInteger:integer forKey:@"exeCount"];
    [self.defaults synchronize];
}

-(NSDictionary*) getAllStories
{
    NSDictionary* ret = [self.defaults dictionaryForKey:@"Stories"];
    return ret;
}

-(NSDictionary*) getAllPages
{
    NSDictionary* ret = [self.defaults dictionaryForKey:@"Pages"];
    return ret;
}

-(NSDictionary*) getStoryID:(NSString*)KeyID
{
    NSDictionary* det = [self.defaults dictionaryForKey:@"Stories"];
    if (nil == det) {
        printf("Err! keyID[%s] (%s %d) ", [KeyID UTF8String], __func__, __LINE__);
        return nil;
    }
    return [det valueForKey:KeyID];
}

-(NSDictionary*) getPageID:(NSString*)KeyID
{
    NSDictionary* det = [self.defaults dictionaryForKey:@"Pages"];
    if (nil == det) {
        printf("Err! keyID[%s] (%s %d) ", [KeyID UTF8String], __func__, __LINE__);
        return nil;
    }
    return [det valueForKey:KeyID];
}

-(NSString*) getStringID:(NSString*)KeyID
{
    return [self.defaults stringForKey:KeyID];
}

-(NSArray*) getArrayID:(NSString*)KeyID
{
    return [self.defaults arrayForKey:KeyID];
}


-(NSDictionary*) getDictionaryID:(NSString*)KeyID
{
    return [self.defaults dictionaryForKey:KeyID];
}

-(void) showAll
{
    NSDictionary* stories = [self getAllStories];
    NSDictionary* story;
    for (NSString* key in stories) {
        story = [self getStoryID:key];
        NSLog(@"Story:keyID[%@]:=version[%@]",
              [story objectForKey:@"keyID"], [story objectForKey:@"version"]);
    }
    
    NSDictionary* pages = [self getAllPages];
    NSDictionary* page;
    for (NSString* key in pages) {
        page = [self getPageID:key];
        NSLog(@"Page:keyID[%@]:=version[%@/%@], name[%@] w/story[%@]",
              [page objectForKey:@"keyID"],
              [page objectForKey:@"version"],
              [page objectForKey:@"serverversion"],
              [page objectForKey:@"name"],
              [page objectForKey:@"storyKeyID"]);
    }
}

@end