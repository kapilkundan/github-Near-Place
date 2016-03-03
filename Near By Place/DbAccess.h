
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@interface DbAccess : NSObject<NSFileManagerDelegate> {
	
}
//@property (nonatomic, retain) *dbName; 

+ (NSString *)selectOneValueSQL:(NSString *)sql;
+ (NSMutableArray *)selectManyValuesWithSQL:(NSString *)sql;
+ (NSDictionary *)selectOneRowWithSQL:(NSString *)sql;
+ (NSArray *)selectManyRowsWithSQL:(NSString *)sql;
+ (NSNumber *)insertWithSQL:(NSString *)sql;
+ (void)updateWithSQL:(NSString *)sql;
+ (void)deleteWithSQL:(NSString *)sql;

+ (void)executeSQL:(NSString *)sql;
+ (void)setDbName;
+ (void)closeDataBase;
+(void)createDBSchema;

@end
