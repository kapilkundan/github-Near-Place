
#import "DbAccess.h"
#import <sqlite3.h>

@implementation DbAccess
//@synthesize dbName;
static NSString *dbName  = PREF_DATABASE_NAME;




//static NSOperationQueue * DatabaseQueue = nil;

+ (void) setDbName {
	
}

// 
// queryValueSP is a dictionary object
// all col and value are set in this and returned
// there is one dictionary object having col name and value as objects

static int singleRowCallback(void *queryValuesVP, int columnCount, char **values, char **columnNames) {
    NSMutableDictionary *queryValues = (__bridge NSMutableDictionary *)queryValuesVP;
    int i;
    for(i=0; i<columnCount; i++) {
        queryValues[[NSString stringWithFormat:@"%s", columnNames[i]]] = values[i] ? [NSString stringWithFormat:@"%s",values[i]] : [NSNull null];
    }
    return 0;
}


//queryvaluesp is an array
// this is an array of dictionary 
// each time fn is called, a dictionary object is created and added into the original array 

static int multipleRowCallback(void *queryValuesVP, int columnCount, char **values, char **columnNames) {
    NSMutableArray *queryValues = (__bridge NSMutableArray *)queryValuesVP;
    NSMutableDictionary *individualQueryValues = [[NSMutableDictionary alloc]init];
    int i;
    for(i=0; i<columnCount; i++) {
        individualQueryValues[[NSString stringWithFormat:@"%s", columnNames[i]]] = values[i] ? [NSString stringWithFormat:@"%s",values[i]] : [NSNull null];
    }
    //[queryValues addObject:[NSDictionary dictionaryWithDictionary:individualQueryValues]];
	[queryValues addObject:individualQueryValues];
    return 0;
}

//vk 100919
// copied from dbinterface

+(NSString*)pathToDB 
{
	[self setDbName];
	
	NSString *		dataBasePath	=	nil	;
	NSFileManager	*manager		=	[NSFileManager defaultManager];
	BOOL			isDirectory		=	FALSE;
	
	NSString *path  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	//return path;
    manager.delegate =(id)self;
	//dataBasePath = [Utils getDocPath];
	//[manager setDelegate:self];
	[manager fileExistsAtPath:path isDirectory:&isDirectory];
	
	
	//--If directory doesnt exist, create it
	if(!isDirectory)
	{
		//[manager createDirectoryAtPath:dataBasePath attributes:nil];
        
        [manager createDirectoryAtPath:dataBasePath withIntermediateDirectories:NO attributes:nil error:nil];
		
	}
	//dataBasePath = [dataBasePath stringByAppendingPathComponent:dbName];
	dataBasePath = [path stringByAppendingPathComponent:dbName];
	
	return dataBasePath;
	
	
}


// vk 100919
// original fn commented
// pathtodb is copied from dbinterface above

+ (NSString *)pathToDB123 {

    NSString *originalDBPath = [[NSBundle mainBundle] pathForResource:dbName ofType:@"db"];
    NSString *path = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *appSupportDir = paths[0];
    NSString *dbNameDir = [NSString stringWithFormat:@"%@/Recipes", appSupportDir];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL dirExists = [fileManager fileExistsAtPath:dbNameDir isDirectory:&isDir];
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@.db", dbNameDir, dbName];
    if(dirExists && isDir) {
        BOOL dbExists = [fileManager fileExistsAtPath:dbPath];
        if(!dbExists) {
            NSError *error = nil;
            BOOL success = [fileManager copyItemAtPath:originalDBPath toPath:dbPath error:&error];
            if(!success) {
                NSLog(@"error = %@", error);
            } else {
                path = dbPath;
            }
        } else {
            path = dbPath;
        }
    } else if(!dirExists) {
        NSError *error = nil;
        BOOL success =[fileManager createDirectoryAtPath:dbNameDir withIntermediateDirectories:NO attributes:nil error:nil];
        
               if(!success) {
            NSLog(@"failed to create dir");
        }
        success = [fileManager copyItemAtPath:originalDBPath toPath:dbPath error:&error];
        if(!success) {
            NSLog(@"error = %@", error);
        } else {
            path = dbPath;
        }
    }
    return path;
}

+ (NSNumber *)executeSQL:(NSString *)sql withCallback:(void *)callbackFunction context:(id)contextObject {
    NSString *path = [self pathToDB];
    sqlite3 *db = NULL;
    int rc = SQLITE_OK;
    NSInteger lastRowId = 0;
    rc = sqlite3_open([path UTF8String], &db);
    if(SQLITE_OK != rc) {
        NSLog(@"Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return nil;
    } else {
        char *zErrMsg = NULL;
        rc = sqlite3_exec(db, [sql UTF8String], callbackFunction, (__bridge void*)contextObject, &zErrMsg);
         
        if(SQLITE_OK != rc) {
            NSLog(@"Can't run query '%@' error message: %s\n", sql, sqlite3_errmsg(db));
            sqlite3_free(zErrMsg);
        }
        lastRowId = sqlite3_last_insert_rowid(db);
        sqlite3_close(db);
    }
    NSNumber *lastInsertRowId = nil;
    if(0 != lastRowId) {
        lastInsertRowId = @(lastRowId);
    }
    return lastInsertRowId;
}

+ (NSString *)selectOneValueSQL:(NSString *)sql {
    NSMutableDictionary *queryValues = [NSMutableDictionary dictionary];
    [self executeSQL:sql withCallback:singleRowCallback context:queryValues];
    NSString *value = nil;
    if([queryValues count] == 1) {
        value = [[queryValues objectEnumerator] nextObject];
    }
    return value;
}

+ (NSArray *)selectManyValuesWithSQL:(NSString *)sql {
    NSMutableArray *queryValues = [NSMutableArray array];
    [self executeSQL:sql withCallback:multipleRowCallback context:queryValues];
    NSMutableArray *values = [NSMutableArray array];
    for(NSDictionary *dict in queryValues) {
        [values addObject:[[dict objectEnumerator] nextObject]];
    }
    return values;
}




+ (NSDictionary *)selectOneRowWithSQL:(NSString *)sql {
    NSMutableDictionary *queryValues = [NSMutableDictionary dictionary];
    [self executeSQL:sql withCallback:singleRowCallback context:queryValues];
    return [NSDictionary dictionaryWithDictionary:queryValues];    
}

+ (NSArray *)selectManyRowsWithSQL:(NSString *)sql {
		NSMutableArray *queryValues = [NSMutableArray array];
    [self executeSQL:sql withCallback:multipleRowCallback context:queryValues];
    return [NSArray arrayWithArray:queryValues];
}

+ (NSNumber *)insertWithSQL:(NSString *)sql {
    sql = [NSString stringWithFormat:@"BEGIN TRANSACTION; %@; COMMIT TRANSACTION;", sql];
    return [self executeSQL:sql withCallback:NULL context:NULL];
}

+ (void)executeSQL:(NSString *)sql{
	[self executeSQL:sql withCallback:NULL context:nil];
}


+ (void)updateWithSQL:(NSString *)sql {
    sql = [NSString stringWithFormat:@"BEGIN TRANSACTION; %@; COMMIT TRANSACTION;", sql];
    [self executeSQL:sql withCallback:NULL context:nil];
}

+ (void)deleteWithSQL:(NSString *)sql {
    sql = [NSString stringWithFormat:@"BEGIN TRANSACTION; %@; COMMIT TRANSACTION;", sql];
    [self executeSQL:sql withCallback:NULL context:nil];
}



+(BOOL)DatabaseActionForInsertUpdateDelete:(NSArray *)arrayOfQueries
{
	
	////NSLog(@"Entering Into DatabaseActionForInsertUpdateDelete");
	BOOL runAllCommands = NO;
	int resultTransaction = 201;
	int transcComplete = 1;
	//if(m_pDataBase == nil)
//	{
//		[self openDataBase];
//	}
	NSString *path = [self pathToDB];
    sqlite3 *db = NULL;
    int rc = SQLITE_OK;
    rc = sqlite3_open([path UTF8String], &db);
    //if(SQLITE_OK != rc) {
//        NSLog(@"Can't open database: %s\n", sqlite3_errmsg(db));
//        sqlite3_close(db);
//        return nil;
//    } else {
//        char *zErrMsg = NULL;
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//        rc = sqlite3_exec(db, [sql UTF8String], callbackFunction, (void*)contextObject, &zErrMsg);
//        if(SQLITE_OK != rc) {
//            NSLog(@"Can't run query '%@' error message: %s\n", sql, sqlite3_errmsg(db));
//            sqlite3_free(zErrMsg);
//        }
//        lastRowId = sqlite3_last_insert_rowid(db);
//        sqlite3_close(db);
//        [pool release];
//    }
	////NSLog(@"Total Number of Queries -%d",[arrayOfQueries count]);
	//	int totalRecordToChange = [dataGet count];
	sqlite3_exec(db, "BEGIN TRANSACTION",0, 0,0) ;
	char* error = NULL;
	
	for	(NSString * query in arrayOfQueries)
	{
		
		
		NSString * sqlQuery = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		//////NSLog(@"%@",sqlQuery);
		if([sqlQuery isEqualToString:@""] == NO)
		{
			//////NSLog(@"Starts Reading the Query :---%@",sqlQuery);
			transcComplete = sqlite3_exec(db, [sqlQuery UTF8String], NULL, NULL,&error);
			sqlite3_free(error);
			if(transcComplete == 0 || transcComplete == 19  || transcComplete == 1)
			{
				//////NSLog(@"Query Run Successfully :---%@",sqlQuery);
				
				resultTransaction = 200;
			}
		}
		
		else
		{
			////NSLog(@"Query Run Successfully :NULL");
			break;
		}
		
		if (transcComplete == 20)
		{
			//////NSLog(@" Query Contians Error :---%@",sqlQuery);
			sqlite3_exec(db, "ROLLBACK TRANSACTION", 0, 0,0);
			resultTransaction = 201;
			transcComplete = 201;
			sqlite3_exec(db, "END TRANSACTION", NULL, NULL,&error);
			sqlite3_free(error);
			runAllCommands = NO;
			break;
			
		}
		
	}
	
	if(resultTransaction == 200)
	{
		sqlite3_exec(db,"COMMIT TRANSACTION",0,0,&error);
		sqlite3_exec(db, "END TRANSACTION", NULL, NULL,&error);
		sqlite3_free(error);
		transcComplete =201 ;
		resultTransaction = 201;
		runAllCommands = YES;
	}
	
	////NSLog(@"Exiting Into DatabaseActionForInsertUpdatseDelete");
	//[self closeDataBase];
	sqlite3_close(db);
	return runAllCommands;
	
	
	
}



+ (void)closeDataBase

{
//sqlite3 *db = NULL;
//    if(sqlite3 != nil)
//	{
//		sqlite3_close(m_pDataBase);
//		m_pDataBase = nil;
//	}
//


}


+(void)createDBSchema
{
    
    NSString *		dataBasePath	=	nil	;
    NSString*		pDatafile		=	PREF_DATABASE_NAME;
    NSFileManager	*manager		=	[NSFileManager defaultManager];
    BOOL			isDirectory		=	FALSE;
    
    
    
    dataBasePath = [self getDocPath];
    //NSLog(dataBasePath);
    
    manager.delegate =(id)self;
    
    [manager fileExistsAtPath:dataBasePath isDirectory:&isDirectory];
    
    NSLog(@"Database Locatoin :- %@",dataBasePath);
    
    //--If directory doesnt exist, create it
    if(!isDirectory)
    {
        //[manager createDirectoryAtPath:dataBasePath attributes:nil];
        [manager createDirectoryAtPath:dataBasePath withIntermediateDirectories:NO
                            attributes:nil error:nil];
        
        
    }
    dataBasePath = [dataBasePath stringByAppendingPathComponent:pDatafile];
    
    if([manager fileExistsAtPath:dataBasePath])
    {
        //sqlite3_open([dataBasePath UTF8String], &m_pDataBase);
    }
    else
    {
        NSString * resourcePath = [[NSBundle mainBundle] pathForResource:pDatafile ofType:nil];
        NSError* error= nil;
        if([manager copyItemAtPath:resourcePath toPath:dataBasePath error:&error])
        {//	sqlite3_open([dataBasePath UTF8String], &m_pDataBase);
            NSLog(@"Database Created");
            
        }else
        {
            NSLog(@"Database Creation failed");
        }
    }
    
}



+(NSString*)getDocPath
{
    NSString *path  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return path;
}




@end
