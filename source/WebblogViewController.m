//
//  WebblogViewController.m
// iCard
//


#import "WebblogViewController.h"

@implementation WebblogViewController

@synthesize website,blog;

- (IBAction)cancelButton:(id)sender{
	[self switchToFlip];
}

- (IBAction)saveButton:(id)sender{
	[self saveWebblog];
	[self switchToFlip];
}

- (void)saveWebblog {
	if ([[blog text] isEqualToString:@""]) {
		blog.text = @"blog";
	}	
	if ([[website text] isEqualToString:@""]) {
		website.text = @"website";
	}
	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set blog='%@', website='%@' where status='new';",[blog text], [website text]]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
}


- (void)deleteWebblog {
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set blog='blog', website='website' where status='new';"]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	sqlite3_stmt *statement;
	
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString *blogname = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 7))];
			NSString *web = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 8))];
			blog.text = blogname;
			website.text = web;
			
			[blogname release];
			[web release];
		}
	}
	sqlite3_close(db);	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)switchToFlip{
	[self dismissModalViewControllerAnimated:YES];	
}

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
} 

- (void)dealloc {
    [super dealloc];
}


@end
