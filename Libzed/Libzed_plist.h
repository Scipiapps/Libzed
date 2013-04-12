
@interface Libzed_plist : NSObject {
	NSUserDefaults* defaults;
}

@property (nonatomic, retain) NSUserDefaults* defaults;

+(Libzed_plist*) sharedInstance;

-(void) writeToFile:(NSString*)filename key:(NSString*)KeyID;

/** Get / Set */
/*
-(void) setStoryID:(NSString*)KeyID
         version:(NSString*)version_
   serverversion:(NSString*)serverversion_
         visible:(NSString*)visible_;

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
     failed_count:(NSString*)failed_count_;
*/
-(void) setStringID:KeyID data:(NSString*)data_;
-(void) setArrayID:KeyID data:(NSArray*)data_;
-(void) setDictionaryID:KeyID data:(NSDictionary*)data_;

-(NSDictionary*) getAllStories;
-(NSDictionary*) getAllPages;
-(NSDictionary*) getStoryID:(NSString*)KeyID;
-(NSDictionary*) getPageID:(NSString*)KeyID;
-(NSString*) getStringID:(NSString*)KeyID;
-(NSArray*) getArrayID:(NSString*)KeyID;
-(NSDictionary*) getDictionaryID:(NSString*)KeyID;

-(NSInteger) getexecount;
-(void) setexecount:(NSInteger)integer;

/** Debug */
-(void) showAll;

@end
