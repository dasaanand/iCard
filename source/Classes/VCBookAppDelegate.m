//
//  VCBookAppDelegate.m
// iCard 
//

#import "VCBookAppDelegate.h"
#import "MainViewController.h"

@implementation VCBookAppDelegate

@synthesize window;
@synthesize mainViewController;
@synthesize nameArray;
@synthesize alertRetry,alertPassword,loginPassword;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// Override point for customization after application launch.  	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];

	NSString *pass = [defaults stringForKey:@"password"];
	if ([pass isEqualToString:@""]) {
		[self setupDefaults];
	}
	
	NSString *toogleValue = [defaults stringForKey:@"loginCheck"];	
	if ([toogleValue isEqualToString:@"check"]) {
		alertRetry = 0;
		loginPassword = [defaults stringForKey:@"password"];
		[self passwordCheck];
	}
	
	databaseName = @"iCard.sql";
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	[self checkAndCreate0];
	
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl order by fname;"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
		while (sqlite3_step(statement) == SQLITE_ROW) 
			sqlite3_exec(db, [[NSString stringWithFormat:@"delete from vctbl where status='new';"]UTF8String], NULL, NULL, NULL);

	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
		while (sqlite3_step(statement) == SQLITE_ROW) 
			sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set status='saved' where status='report';"]UTF8String], NULL, NULL, NULL);

	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where edit='yes';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
		while (sqlite3_step(statement) == SQLITE_ROW) 
			sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set edit='no' where edit='yes;"]UTF8String], NULL, NULL, NULL);
	
	sqlite3_close(db);
	
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
    // Add the main view controller's view to the window and display.
    [window addSubview:mainViewController.view];
    [window makeKeyAndVisible];
    return YES;
}

- (void)setupDefaults {	
    //use the shared defaults object
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	id text = [[NSString alloc] initWithFormat:@"dontCheck"];
	id pswd = [[NSString alloc] initWithFormat:@""];

	[defaults setObject:text forKey:@"loginCheck"];
	[defaults setObject:pswd forKey:@"password"];
    //write the changes to disk
    [defaults synchronize];
	[text release];
	[pswd release];
}


- (void)passwordCheck {
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Enter the secure key" message:@"" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil ];
	[myAlertView addTextFieldWithValue:nil label:@"password"];
	alertPassword = [myAlertView textFieldAtIndex:0];
	alertPassword.secureTextEntry = YES;
	[myAlertView setTag:0];
	[myAlertView show];
	[myAlertView release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if ([alertView tag] == 0) {
		if (![[alertPassword text] isEqualToString:loginPassword]) {
			alertRetry ++;
			if (alertRetry < 5) {
				UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Password Error" message:@"Enter the correct password" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Quit",nil ];		
				[myAlertView setTag:1];
				[myAlertView show];
				[myAlertView release];
			}
			else {
				alertRetry = 0;
				UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Too many tries" message:@"Go to your system settings and reset the password for the application" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil ];		
				[myAlertView setTag:2];
				[myAlertView show];
				[myAlertView release];
			}
		}
	}
	else {
		if ([alertView tag] == 1) {
			NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
			if (buttonIndex == [alertView cancelButtonIndex]) {
				[self passwordCheck];
			} else if ([buttonTitle isEqualToString:@"Quit"]) {
				exit(0);
			}
		}
		else {
			if ([alertView tag] == 2) {
				exit(0);
			}
		}
	}
}


-(void) checkAndCreateDatabase{
	BOOL success;
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) {
		return;
	}
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	[fileManager release];
}


- (void) checkAndCreate0 {
	BOOL success;
	NSString *card = [[NSString alloc] initWithString:@"0"];
	NSString *cardPath = [NSString alloc];
	
	// Get the path to the documents directory and append the cardName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	cardPath = [documentsDir stringByAppendingPathComponent:card];
	
	// Create a FileManager object, we will use this to check the status
	// of the card and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the card has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:cardPath];

	//if default card is not found copy it
	if(!success) {		
		// Get the path to the card in the application package
		NSString *cardPathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:card];
		
		// Copy the card from the package to the users filesystem
		[fileManager copyItemAtPath:cardPathFromApp toPath:cardPath error:nil];
		[fileManager release];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults synchronize];
	
	NSString *toogleValue = [defaults stringForKey:@"loginCheck"];	
	if ([toogleValue isEqualToString:@"check"]) {
		alertRetry = 0;
		loginPassword = [defaults stringForKey:@"password"];
		[self passwordCheck];
	}
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
}

- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
