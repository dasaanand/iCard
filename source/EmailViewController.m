//
//  EmailViewController.m
// iCard
//


#import "EmailViewController.h"

@implementation EmailViewController

@synthesize pers;
@synthesize office1;
@synthesize office2;

- (IBAction)saveButton:(id)sender{
	[self saveEmail];
	self.switchToFlip;
}

- (IBAction)cancelButton:(id)sender{
	[self deleteEmail];
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
	sqlite3_stmt *statement;
	
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			NSString *persemail = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 4))];
			NSString *off1email = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 5))];
			NSString *off2email = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 6))]; 
			pers.text = persemail;
			office1.text = off1email;
			office2.text = off2email;
			
			[persemail release];
			[off1email release];
			[off2email release];
		}
	}
	sqlite3_close(db);	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
   // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)switchToFlip{
	[self dismissModalViewControllerAnimated:YES];
}


- (void)saveEmail {	
	if ([[pers text] isEqualToString:@""]) {
		pers.text = @"xxx@yyy.com";
	}
	if ([[office1 text] isEqualToString:@""]) {
		office1.text = @"xxx@yyy.com";
	}	if ([[office2 text] isEqualToString:@""]) {
		office2.text = @"xxx@yyy.com";
	}
	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set persemail='%@', off1email='%@', off2email='%@' where status='new';",[pers text], [office1 text], [office2 text]]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
}


- (void)deleteEmail {
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set persemail='xxx@yyy.com', off1email='xxx@yyy.com', off2email='xxx@yyy.com' where status='new';"]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
		
	if (orientation == UIInterfaceOrientationLandscapeLeft)
		numerator = midline - viewRect.origin.x	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	if (orientation == UIInterfaceOrientationLandscapeRight)
		numerator = midline + viewRect.origin.x	- MINIMUM_SCROLL_FRACTION * viewRect.size.height * 1.8;
	
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
		viewFrame.origin.y -= animatedDistance;
	}
	else if (orientation == UIInterfaceOrientationPortraitUpsideDown){
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
		viewFrame = self.view.frame;
		animatedDistance *=0.2;
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
}


@end
