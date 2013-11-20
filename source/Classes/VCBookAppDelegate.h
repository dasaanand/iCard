//
//  VCBookAppDelegate.h
// iCard 
//

@class MainViewController;

@interface VCBookAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	sqlite3 *db;
	NSString *databaseName;
	NSString *databasePath;
	NSInteger *pkey;	
	NSMutableArray *nameArray;
	NSInteger alertRetry;
	UITextField *alertPassword;
	NSString *loginPassword;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) NSMutableArray *nameArray;
@property (nonatomic, retain) UITextField *alertPassword;
@property NSInteger alertRetry;
@property (nonatomic,retain) NSString *loginPassword;

- (void) checkAndCreateDatabase;
- (void) checkAndCreate0;
- (NSString *)filePath;
- (void)setupDefaults;
- (void)passwordCheck;
   
@end

