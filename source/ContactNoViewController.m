//
//  ContactNoViewController.m
// iCard
//


#import "ContactNoViewController.h"

@implementation ContactNoViewController

@synthesize personalno, office1no, office2no, faxno;

- (IBAction)saveButton:(id)sender{
	[self saveNo];
	self.switchToFlip;
}

- (IBAction)cancelButton:(id)sender{
	self.switchToFlip;
}


- (void)saveNo {
	if ([[personalno text] isEqualToString:@""]) {
		personalno.text = @"personal";
	}
	if ([[office1no text] isEqualToString:@""]) {
		office1no.text = @"office";
	}
	if ([[office2no text] isEqualToString:@""]) {
		office2no.text = @"office";
	}
	if ([[faxno text] isEqualToString:@""]) {
		faxno.text = @"fax";
	}
	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set persno='%@', off1no='%@', off2no='%@', faxno='%@' where status='new';",[personalno text], [office1no text],[office2no text],[faxno text]]UTF8String], NULL, NULL, NULL);
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
	[scrollView setScrollEnabled:YES];
	[scrollView setContentSize:CGSizeMake(325, 375)];
	sqlite3_stmt *statement;
	
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString *pers = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 19))];
			NSString *off1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 20))];
			NSString *off2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 21))];
			NSString *fax = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 22))];
			personalno.text = pers;
			office1no.text = off1;
			office2no.text = off2;
			faxno.text = fax;
			
			[pers release];
			[off1 release];
			[off2 release];
			[fax release];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
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
		animatedDistance *= 0.7;
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
