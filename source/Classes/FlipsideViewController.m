//
//  FlipsideViewController.m
// iCard 
//

#import "MainViewController.h"
#import "EmailViewController.h"
#import "WebblogViewController.h"
#import "AddressViewController.h"
#import "ContactNoViewController.h"
#import "JobTitleViewController.h"

@implementation FlipsideViewController

@synthesize delegate,vcImage;
@synthesize fname, lname, orgname;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	[scrollView setScrollEnabled:YES];
	[scrollView setContentSize:CGSizeMake(325, 410)];
	
	sqlite3_stmt *statement;
	
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {

			NSString *name1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 1))];
			NSString *name2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 2))];
			NSString *orgName = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 3))]; 
			
			fname.text = name1;
			lname.text = name2;
			orgname.text = orgName;

			NSString *cardName = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 24))]; 

			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDir = [paths objectAtIndex:0];
			
			NSData *data =[[NSData alloc] initWithContentsOfFile:[documentsDir stringByAppendingPathComponent:cardName]];
			vcImage.image = [[UIImage alloc] initWithData:data];
			
			[name1 release];
			[name2 release];
			[orgName release];
			[cardName release];
			[data release];
		}
	}
	sqlite3_close(db);
}

- (IBAction)fnameDidFinish {
	if (![[fname text] isEqualToString:@""]) {
		sqlite3_open([[self filePath] UTF8String], &db);
		sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set fname='%@' where status='new';",[fname text]]UTF8String], NULL, NULL, NULL);
		sqlite3_close(db);
	}
}

- (IBAction)lnameDidFinish {
	if (![[lname text] isEqualToString:@""]) {
		sqlite3_open([[self filePath] UTF8String], &db);
		sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set lname='%@' where status='new';",[lname text]]UTF8String], NULL, NULL, NULL);
		sqlite3_close(db);		
	}	
}

- (IBAction)orgnameDidFinish {
	if (![[orgname text] isEqualToString:@""]) {
		sqlite3_open([[self filePath] UTF8String], &db);
		sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set orgname='%@' where status='new';",[orgname text]]UTF8String], NULL, NULL, NULL);
		sqlite3_close(db);
	}	
}

- (IBAction)done {
	[self saveEntry];
}


- (IBAction)cancel {
	[self deleteEntry];
	[self switchToMain];
}


- (IBAction)choosePhoto:(id)sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	picker.allowsEditing = YES;
	picker.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	[self presentModalViewController:picker animated:YES];
	[picker release];
}


- (IBAction)takePhoto:(id)sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self presentModalViewController:picker animated:YES];
	[picker release];
}

/*- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	vcImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];	
}*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	[picker dismissModalViewControllerAnimated:YES];
	vcImage.image = image;
	[self saveCard];
}

- (IBAction)emailButton:(id)sender {
	EmailViewController *controller = [[EmailViewController alloc] initWithNibName:@"EmailViewController" bundle:[NSBundle mainBundle]];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller release]; 
}

- (IBAction)webblogButton:(id)sender{
	WebblogViewController *controller = [[WebblogViewController alloc] initWithNibName:@"WebblogViewController" bundle:[NSBundle mainBundle]];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller release]; 
}



- (IBAction)addressButton:(id)sender {
	ContactNoViewController *controller = [[AddressViewController alloc] initWithNibName:@"AddressViewController" bundle:[NSBundle mainBundle]];
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (IBAction)contactnoButton:(id)sender {
	ContactNoViewController *controller = [[ContactNoViewController alloc] initWithNibName:@"ContactNoViewController" bundle:nil];	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (IBAction)jobButton:(id)sender {	
	JobTitleViewController *controller = [[JobTitleViewController alloc] initWithNibName:@"JobTitleViewController" bundle:nil];	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);	
	return YES;
}


- (void)switchToMain{
	MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];	
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)saveEntry {
	if ((![[fname text] isEqualToString:@"first name"]) && (![[orgname text] isEqualToString:@"organization name"])) {
		sqlite3_open([[self filePath] UTF8String], &db);
		sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set fname='%@' where status='new';",[fname text]]UTF8String], NULL, NULL, NULL);
		sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set lname='%@' where status='new';",[lname text]]UTF8String], NULL, NULL, NULL);
		sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set orgname='%@' where status='new';",[orgname text]]UTF8String], NULL, NULL, NULL);
		sqlite3_close(db);
		[self saveCard];
		
		if ([self nameExists]) {
			UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Name exists already" message:@"The name you entered exists already with same organization and job" delegate:self cancelButtonTitle:@"Delete this!" otherButtonTitles:@"Cancel",nil ];
			[myAlertView setTag:0];
			[myAlertView show];
			[myAlertView release];
		}
		else {
			sqlite3_open([[self filePath] UTF8String], &db);
			sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set status='saved' where status='new';"]UTF8String], NULL, NULL, NULL);
			sqlite3_close(db);
			[self switchToMain];
		}
	}
	else {
		if ([[fname text] isEqualToString:@"first name"]) {
			UIAlertView *myAlertView1 = [[UIAlertView alloc] initWithTitle:@"Enter the first name" message:nil delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil ];
			[myAlertView1 setTag:1];
			[myAlertView1 show];
			[myAlertView1 release];
		}
		else {
			UIAlertView *myAlertView2 = [[UIAlertView alloc] initWithTitle:@"Enter the organization name" message:nil delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil ];
			[myAlertView2 setTag:2];
			[myAlertView2 show];
			[myAlertView2 release];
		}
	}
}


- (void) saveCard {
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSNumber *no = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
			NSString *cardName = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 24))];
			NSString *cardFile = [[NSString alloc] initWithFormat:@"%@",no];

			NSData *data = UIImagePNGRepresentation([vcImage image]);			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			// the path to write file
			NSString *appFile = [documentsDirectory stringByAppendingPathComponent:cardFile];
			[data writeToFile:appFile atomically:YES];
			
			sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set card='%@' where status='new';",cardFile]UTF8String], NULL, NULL, NULL);
			[cardFile release];
			[cardName release];
		}
	}
	sqlite3_close(db);
}


- (BOOL)nameExists {
	BOOL flag = 0;
	sqlite3_stmt *statement1;
	sqlite3_open([[self filePath] UTF8String], &db);
	NSString *fourth1;
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement1, NULL) == SQLITE_OK) {		
		while (sqlite3_step(statement1) == SQLITE_ROW) {
			fourth1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement1, 4))];
		}
	}
	
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='saved';"]UTF8String], -1, &statement1, NULL) == SQLITE_OK) {		
		while (sqlite3_step(statement1) == SQLITE_ROW) {
			NSString *first = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement1, 1))];
			NSString *second = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement1, 2))];			
			NSString *third = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement1, 3))];
			NSString *fourth = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement1, 4))];
			if (([[fname text] isEqualToString:first] && [[lname text] isEqualToString:second] && [[orgname text] isEqualToString:third] && [fourth isEqualToString:fourth1])) {
				flag = 1;
			}
			[first release];
			[second release];
			[third release];
			[fourth release];
		}
	}
	sqlite3_close(db);
	[fourth1 release];
	return flag;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [alertView cancelButtonIndex] && ([alertView tag] == 0)) {
		sqlite3_open([[self filePath] UTF8String], &db);
		sqlite3_exec(db, [[NSString stringWithFormat:@"delete from vctbl where status='new';"]UTF8String], NULL, NULL, NULL);
		sqlite3_close(db);
		[self switchToMain];
	}
}


- (void)deleteEntry {
	NSString *card = [[NSString alloc] init];
	sqlite3_stmt *statement;
	sqlite3_stmt *statement1;
	BOOL flag=0;
	
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement, NULL) == SQLITE_OK) {		
		while (sqlite3_step(statement) == SQLITE_ROW) {
			if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where edit='yes';"]UTF8String], -1, &statement1, NULL) == SQLITE_OK) {		
				while (sqlite3_step(statement1) == SQLITE_ROW) {
					sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set status='saved',edit='no' where edit='yes';"]UTF8String], NULL, NULL, NULL);
					flag = 1;
				}
			}
			card = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 24))];
		}
	}
	if (flag == 0) {
		if (![card isEqualToString:@"0"]) {
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *appFile = [documentsDirectory stringByAppendingPathComponent:card];
			
			NSFileManager *fileManager = [NSFileManager defaultManager];
			[fileManager removeItemAtPath:appFile error:NULL];
		}
		
		sqlite3_exec(db, [[NSString stringWithFormat:@"delete from vctbl where status='new';"]UTF8String], NULL, NULL, NULL);
		sqlite3_close(db);
		[card release];
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;

	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
		numerator = midline - viewRect.origin.y	+ MINIMUM_SCROLL_FRACTION * viewRect.size.height;	
	
    CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
	
	CGRect viewFrame;
    if (orientation == UIInterfaceOrientationPortrait) {
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
		viewFrame = self.view.frame;
		animatedDistance *=0.5;
		viewFrame.origin.y -= animatedDistance;
	}
	else if (orientation == UIInterfaceOrientationPortraitUpsideDown){
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
		viewFrame = self.view.frame;
		viewFrame.origin.y += animatedDistance;
	}
    else if (orientation == UIInterfaceOrientationLandscapeLeft){
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
		viewFrame = self.view.frame;
		viewFrame.origin.x -= animatedDistance;
	}
	else {
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
		viewFrame = self.view.frame;
		viewFrame.origin.x += animatedDistance;
	}

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
    if (orientation == UIInterfaceOrientationPortrait)
		viewFrame.origin.y += animatedDistance;
	else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		viewFrame.origin.y -= animatedDistance;
    else if (orientation == UIInterfaceOrientationLandscapeLeft)
		viewFrame.origin.x += animatedDistance;
	else 
		viewFrame.origin.x -= animatedDistance;

	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
} 

- (void)dealloc {
    [super dealloc];
	[vcImage release];
}


@end
