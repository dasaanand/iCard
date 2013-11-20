//
//  JobTitleViewController.m
// iCard 

#import "JobTitleViewController.h"


@implementation JobTitleViewController

@synthesize mlabel,newGroup;


- (IBAction)saveButton:(id)sender{
	[self saveGroup];
	self.switchToFlip;
}

- (IBAction)cancelButton:(id)sender{
	self.switchToFlip;
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
	[scrollView setScrollEnabled:YES];
	[scrollView setContentSize:CGSizeMake(325, 375)];
	arrayNo = [[NSMutableArray alloc] init];
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from grouptbl order by grouplist;"]UTF8String], -1, &statement, NULL) == SQLITE_OK) {		
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString *message = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 1))];
			[arrayNo addObject:message];
			[message release];
		}
	}
	
	NSString *message1;
	
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement, NULL) == SQLITE_OK) {		
		while (sqlite3_step(statement) == SQLITE_ROW) {
			message1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 23))];
		}
	}
		
	int i=0;
	for (i=0; i<[arrayNo count]; i++) {
		if ([message1 isEqualToString:[arrayNo objectAtIndex:i]]) {
			break;
		}
	}
	
	if (i == [arrayNo count]) {
		i=0;
	}
	
	sqlite3_close(db);
    [pickerView selectRow:i inComponent:0 animated:NO];
    mlabel.text= [arrayNo objectAtIndex:[pickerView selectedRowInComponent:0]];
	[message1 release];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    mlabel.text= [arrayNo objectAtIndex:row];
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [arrayNo count];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [arrayNo objectAtIndex:row];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
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


- (IBAction) addGroup{
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"insert into grouptbl (grouplist) values('%@');",[newGroup text]]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
	[arrayNo addObject:[newGroup text]];
	[pickerView reloadAllComponents];
}

- (void)saveGroup {	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set grouplist='%@' where status='new';",[mlabel text]]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
}



- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
} 


- (void)dealloc {
    [super dealloc];
	[arrayNo release];
}


@end
