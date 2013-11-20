//
//  CallSmsMailViewController.m
// iCard

#import "CallSmsMailViewController.h"
#import "ReportView.h"

@implementation CallSmsMailViewController
@synthesize title1,lab1,lab2,lab3;

int itemSelected;
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
	btn1.hidden = YES;
	btn2.hidden = YES;
	btn3.hidden = YES;
	itemSelected = 0;
	[btn1 setTag:1];
	[btn2 setTag:2];
	[btn3 setTag:3];
	buttonTitles = [[NSMutableArray alloc] init];
	[buttonTitles insertObject:@"" atIndex:0];
	[buttonTitles insertObject:@"" atIndex:1];
	[buttonTitles insertObject:@"" atIndex:2];

	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSString *content1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 19))];
			NSString *content2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 20))];
			NSString *content3 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 21))];
			if (![content1 isEqualToString:@"personal"]) {
				btn1.hidden = NO;
				[btn1 setTitle:content1 forState:UIControlStateNormal];
				[buttonTitles replaceObjectAtIndex:0 withObject:content1];
			}
			if (![content2 isEqualToString:@"office"]) {
				btn2.hidden = NO;
				[btn2 setTitle:content2 forState:UIControlStateNormal];
				[buttonTitles replaceObjectAtIndex:1 withObject:content2];
			}			
			if (![content3 isEqualToString:@"office"]) {
				btn3.hidden = NO;
				[btn3 setTitle:content3 forState:UIControlStateNormal];
				[buttonTitles replaceObjectAtIndex:2 withObject:content3];
			}
			[content1 release];
			[content2 release];
			[content3 release];
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

- (IBAction)back {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)toolButtons:(id)sender {
	UIBarItem *btn = (UIBarItem *)sender;
	
	btn1.hidden = YES;
	btn2.hidden = YES;
	btn3.hidden = YES;
	lab3.hidden = NO;
	lab1.text = @"Personal:";
	lab2.text = @"Office1:";
	[buttonTitles removeAllObjects];	
	[buttonTitles insertObject:@"" atIndex:0];
	[buttonTitles insertObject:@"" atIndex:1];
	[buttonTitles insertObject:@"" atIndex:2];
	
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	
	switch ([btn tag]) {
		case 0:
			title1.text = @"For call";
			if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
			{	
				while (sqlite3_step(statement) == SQLITE_ROW) {
					NSString *content1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 19))];
					NSString *content2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 20))];
					NSString *content3 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 21))];
					if (![content1 isEqualToString:@"personal"]) {
						btn1.hidden = NO;
						[btn1 setTitle:content1 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:0 withObject:content1];
					}
					if (![content2 isEqualToString:@"office"]) {
						btn2.hidden = NO;
						[btn2 setTitle:content2 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:1 withObject:content2];
					}			
					if (![content3 isEqualToString:@"office"]) {
						btn3.hidden = NO;
						[btn3 setTitle:content3 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:2 withObject:content3];
					}
					[content1 release];
					[content2 release];
					[content3 release];
				}
			}
			itemSelected = 0;
			break;

		case 2:
			title1.text = @"For mailing";
			if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
			{	
				while (sqlite3_step(statement) == SQLITE_ROW) {
					NSString *content1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 4))];
					NSString *content2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 5))];
					NSString *content3 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 6))];
					if (![content1 isEqualToString:@"xxx@yyy.com"]) {
						btn1.hidden = NO;
						[btn1 setTitle:content1 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:0 withObject:content1];
					}
					if (![content2 isEqualToString:@"xxx@yyy.com"]) {
						btn2.hidden = NO;
						[btn2 setTitle:content2 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:1 withObject:content2];
					}			
					if (![content3 isEqualToString:@"xxx@yyy.com"]) {
						btn3.hidden = NO;
						[btn3 setTitle:content3 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:2 withObject:content3];
					}
					[content1 release];
					[content2 release];
					[content3 release];
				}
			}
			itemSelected = 2;
			break;
		case 3:	
			title1.text = @"Online contact";
			lab1.text = @"Website:";
			lab2.text = @"Blog:";
			lab3.hidden = YES;
			if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
			{	
				while (sqlite3_step(statement) == SQLITE_ROW) {
					NSString *content1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 8))];
					NSString *content2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 7))];

					if (![content1 isEqualToString:@"website"]) {
						btn1.hidden = NO;
						[btn1 setTitle:content1 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:0 withObject:content1];
					}
					if (![content2 isEqualToString:@"blog"]) {
						btn2.hidden = NO;
						[btn2 setTitle:content2 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:1 withObject:content2];
					}			

					[content1 release];
					[content2 release];
				}
			}
			itemSelected = 3;
			break;
		case 4:
			title1.text = @"Google Map";
			lab1.text = @"Office1:";
			lab2.text = @"Office2:";
			lab3.hidden = YES;
			if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
			{	
				while (sqlite3_step(statement) == SQLITE_ROW) {
					NSString *content1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 10))];
					NSString *content2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 15))];
					
					if (![content1 isEqualToString:@"city"]) {
						btn1.hidden = NO;
						[btn1 setTitle:content1 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:0 withObject:content1];
					}
					if (![content2 isEqualToString:@"city"]) {
						btn2.hidden = NO;
						[btn2 setTitle:content2 forState:UIControlStateNormal];
						[buttonTitles replaceObjectAtIndex:1 withObject:content2];
					}			
					
					[content1 release];
					[content2 release];
				}
			}
			itemSelected = 4;
			break;

		default:
			break;
	}
	sqlite3_close(db);
}

- (IBAction)contactButton:(id)sender {
	UIButton *btn = (UIButton *)sender;
	
	NSString *tel = [[NSString alloc] initWithString:@"tel:"];
	NSString *website = [[NSString alloc] initWithString:@"http://"];	
	NSString *map = [[NSString alloc] initWithString:@"http://maps.google.com/maps?q="];
	NSString *linkContact = [[NSString alloc] init];
	int flag=0;
	switch (itemSelected) {
		case 0://call
			linkContact = [tel stringByAppendingString:[buttonTitles objectAtIndex:[btn tag]-1]];
			break;
		case 2://mail
			flag = 1;
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			controller.mailComposeDelegate = self;
			
			if ([MFMailComposeViewController canSendMail]) {
				NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
				[defaults synchronize];
				NSString *cc = [defaults stringForKey:@"email"];
				if (cc==NULL)
					cc = @"";

				NSString *sub1 = [[NSString alloc] initWithString:@"Sent from iCard application"];
				NSArray *mailto = [NSArray arrayWithObject:[buttonTitles objectAtIndex:[btn tag]-1]];
				
				[controller setToRecipients:mailto];
				[controller setCcRecipients:[NSArray arrayWithObject:cc]];
				[controller setMessageBody:sub1 isHTML:NO];
				
				controller.navigationBar.barStyle = UIBarStyleBlackOpaque;
				controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
				[self presentModalViewController:controller animated:YES];
				[sub1 release];
			}
			[controller release];
			break;
		case 3://web or blog
			linkContact = [website stringByAppendingString:[buttonTitles objectAtIndex:[btn tag]-1]];
			break;
		case 4://map
			linkContact = [map stringByAppendingString:[buttonTitles objectAtIndex:[btn tag]-1]];			
			break;
		default:
			break;
	}
	
	if (flag != 1) {
		NSURL *url = [[NSURL alloc] initWithString:linkContact];
		[[UIApplication sharedApplication] openURL:url];
	}

	[tel release];
	[website release];
	[map release];
	[linkContact release];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message sending failed" message:nil delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
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

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
} 

- (void)dealloc {
    [super dealloc];
	[buttonTitles release];
}


@end
