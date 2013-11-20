//
//  AddressViewController.m
// iCard
//


#import "AddressViewController.h"

@implementation AddressViewController

@synthesize off1add,off1city,off1state,off1country,off1pin,off2add,off2city,off2state,off2country,off2pin;

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}

- (IBAction)saveButton:(id)sender{
	[self saveAddress];
	self.switchToFlip;
}

- (IBAction)cancelButton:(id)sender{
	[self deleteAddress];
	self.switchToFlip;
}

- (void)saveAddress {
	if ([[off1add text] isEqualToString:@""]) {
		off1add.text = @"address";
	}
	if ([[off1city text] isEqualToString:@""]) {
		off1city.text = @"city";
	}
	if ([[off1state text] isEqualToString:@""]) {
		off1state.text = @"state";
	}
	if ([[off1country text] isEqualToString:@""]) {
		off1country.text = @"country";
	}
	if ([[off1pin text] isEqualToString:@""]) {
		off1pin.text = @"postal no";
	}
	if ([[off2add text] isEqualToString:@""]) {
		off2add.text = @"address";
	}
	if ([[off2city text] isEqualToString:@""]) {
		off2city.text = @"city";
	}
	if ([[off2state text] isEqualToString:@""]) {
		off2state.text = @"state";
	}
	if ([[off2country text] isEqualToString:@""]) {
		off2country.text = @"country";
	}
	if ([[off2pin text] isEqualToString:@""]) {
		off2pin.text = @"postal no";
	}
	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set off1add='%@', off1city='%@', off1state='%@', off1country='%@', off1pin='%@' where status='new';",[off1add text], [off1city text],[off1state text],[off1country text],[off1pin text]]UTF8String], NULL, NULL, NULL);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set off2add='%@', off2city='%@', off2state='%@', off2country='%@', off2pin='%@' where status='new';",[off2add text], [off2city text],[off2state text],[off2country text],[off2pin text]]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
}

- (void)deleteAddress {
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set off1add='address', off1city='city', off1state='state', off1country='country', off1pin='postal no' where status='new';"]UTF8String], NULL, NULL, NULL);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set off2add='address', off2city='city', off2state='state', off2country='country', off2pin='postal no' where status='new';"]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
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
	NSString *a[10];
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='new';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {
			int i,j;
			j=0;
			for (i=9; i<=18; i++) {
				a[j] = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, ("%i",i)))];
				j++;
			}	
			off1add.text=a[0];
			off1city.text=a[1];
			off1state.text=a[2];
			off1country.text=a[3];
			off1pin.text=a[4];
			off2add.text=a[5];
			off2city.text=a[6];
			off2state.text=a[7];
			off2country.text=a[8];
			off2pin.text=a[9];
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
    
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		midline = textFieldRect.origin.x + 0.4 * textFieldRect.size.height;
		numerator = midline - viewRect.origin.x	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;		
	}
	if (orientation == UIInterfaceOrientationLandscapeRight) {
		midline = textFieldRect.origin.x + 0.4 * textFieldRect.size.height;
		numerator = midline - viewRect.origin.x	- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	}
	
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
		animatedDistance *=0.5;
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
