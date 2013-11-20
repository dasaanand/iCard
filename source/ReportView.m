//
//  ReportView.m
// iCard 

#import "ReportView.h"
#import "MainViewController.h"
#import "FlipsideViewController.h"
#import "ZoomedImageViewController.h"
#import "CallSmsMailViewController.h"

@implementation ReportView

@synthesize fname,lname,orgname,jobtitle,off1add,off1city,off1state,off1country,off1pinno,off1contactno,off1email,off2add,off2city,off2state,off2country,off2pinno,off2contactno,off2email,blog,website,personalno,personalemail,faxno,vcImage;


int countClicks;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)changePage:(id)sender {
	switch ([pageControl currentPage]) {
		case 0:
			[page2 removeFromSuperview];
			[page3 removeFromSuperview];
			[page4 removeFromSuperview];
			[self.view addSubview:page1];
			[scrollView1 setScrollEnabled:YES];
			[scrollView1 setContentSize:CGSizeMake(325, 375)];
			break;
		case 1:
			[page1 removeFromSuperview];
			[page3 removeFromSuperview];
			[page4 removeFromSuperview];
			[self.view addSubview:page2];
			[scrollView2 setScrollEnabled:YES];
			[scrollView2 setContentSize:CGSizeMake(325, 375)];
			break;
		case 2:
			[page1 removeFromSuperview];
			[page2 removeFromSuperview];
			[page4 removeFromSuperview];
			[self.view addSubview:page3];
			[scrollView3 setScrollEnabled:YES];
			[scrollView3 setContentSize:CGSizeMake(325, 375)];
			break;
		case 3:
			[page1 removeFromSuperview];
			[page2 removeFromSuperview];
			[page3 removeFromSuperview];
			[self.view addSubview:page4];
			[scrollView4 setScrollEnabled:YES];
			[scrollView4 setContentSize:CGSizeMake(325, 375)];
			break;
		default:
			break;
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self initlabels];
	
	pageControl.numberOfPages = 4;
	countClicks = 0;
    [super viewDidLoad];
	[scrollView1 setScrollEnabled:YES];
	[scrollView1 setContentSize:CGSizeMake(325, 375)];
	
	[page2 removeFromSuperview];
	[page3 removeFromSuperview];
	[page4 removeFromSuperview];
	[self.view addSubview:page1];
}

- (void)initlabels {
	labels = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {
			
			int i;
			for (i=1; i<=24; i++) {
				[labels addObject:[[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, ("%i",i)))]];
			}

		}
	}
	sqlite3_close(db);	
	int i=0;
	
	fname.text = [labels objectAtIndex:i++];
	lname.text = [labels objectAtIndex:i++];
	orgname.text = [labels objectAtIndex:i++];
	personalemail.text = [labels objectAtIndex:i++];
	off1email.text = [labels objectAtIndex:i++];
	off2email.text = [labels objectAtIndex:i++];
	blog.text = [labels objectAtIndex:i++];
	website.text = [labels objectAtIndex:i++];
	off1add.text = [labels objectAtIndex:i++];
	off1city.text = [labels objectAtIndex:i++];
	off1state.text = [labels objectAtIndex:i++];
	off1country.text = [labels objectAtIndex:i++];
	off1pinno.text = [labels objectAtIndex:i++];
	off2add.text = [labels objectAtIndex:i++];
	off2city.text = [labels objectAtIndex:i++];
	off2state.text = [labels objectAtIndex:i++];
	off2country.text = [labels objectAtIndex:i++];
	off2pinno.text = [labels objectAtIndex:i++];
	personalno.text = [labels objectAtIndex:i++];
	off1contactno.text = [labels objectAtIndex:i++];
	off2contactno.text = [labels objectAtIndex:i++];
	faxno.text = [labels objectAtIndex:i++];
	jobtitle.text = [labels objectAtIndex:i++];

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
	
	NSData *data =[[NSData alloc] initWithContentsOfFile:[documentsDir stringByAppendingPathComponent:[labels objectAtIndex:i]]];
	vcImage.image = [[UIImage alloc] initWithData:data];
	
	
	if ([fname.text isEqualToString:@"first name"]) {
		fname.text = @"";
	}if ([lname.text isEqualToString:@"last name"]) {
		lname.text = @"";
	}if ([orgname.text isEqualToString:@"organization name"]) {
		orgname.text = @"";
	}if ([personalemail.text isEqualToString:@"xxx@yyy.com"]) {
		personalemail.text = @"";
	}if ([off1email.text isEqualToString:@"xxx@yyy.com"]) {
		off1email.text = @"";
	}if ([off2email.text isEqualToString:@"xxx@yyy.com"]) {
		off2email.text = @"";
	}if ([blog.text isEqualToString:@"blog"]) {
		blog.text = @"";
	}if ([website.text isEqualToString:@"website"]) {
		website.text = @"";
	}if ([off1add.text isEqualToString:@"address"]) {
		off1add.text = @"";
	}if ([off1city.text isEqualToString:@"city"]) {
		off1city.text = @"";
	}if ([off1state.text isEqualToString:@"state"]) {
		off1state.text = @"";
	}if ([off1country.text isEqualToString:@"country"]) {
		off1country.text = @"";
	}if ([off1pinno.text isEqualToString:@"postal no"]) {
		off1pinno.text = @"";
	}if ([off2add.text isEqualToString:@"address"]) {
		off2add.text = @"";
	}if ([off2city.text isEqualToString:@"city"]) {
		off2city.text = @"";
	}if ([off2state.text isEqualToString:@"state"]) {
		off2state.text = @"";
	}if ([off2country.text isEqualToString:@"country"]) {
		off2country.text = @"";
	}if ([off2pinno.text isEqualToString:@"postal no"]) {
		off2pinno.text = @"";
	}if ([personalno.text isEqualToString:@"personal"]) {
		personalno.text = @"";
	}if ([off1contactno.text isEqualToString:@"office"]) {
		off1contactno.text = @"";
	}if ([off2contactno.text isEqualToString:@"office"]) {
		off2contactno.text = @"";
	}if ([faxno.text isEqualToString:@"fax"]) {
		faxno.text = @"";
	}
	[data release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return NO;
}*/

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

- (IBAction)exitButton :(id)sender {	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set status='saved' where status='report';"]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)editButton :(id)sender {
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set edit='yes', status='new' where status='report';"]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);	
	[self switchToFlip];
}

- (IBAction)deleteButton :(id)sender {
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Delete this visting card" message:@"Click 'Delete!' to delete the card else click 'Cancel'" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete!",nil ];
	[myAlertView setTag:4];
	[myAlertView show];
	[myAlertView release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([alertView tag] == 4) {
		NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
		if (buttonIndex == [alertView cancelButtonIndex]) {
		} else if ([buttonTitle isEqualToString:@"Delete!"]) {
			sqlite3_stmt *statement1;
			NSString *card = [[NSString alloc] init];
			sqlite3_open([[self filePath] UTF8String], &db);
			
			if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement1, NULL) == SQLITE_OK) {		
				while (sqlite3_step(statement1) == SQLITE_ROW) {
					card = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement1, 24))];
				}
			}
			
			if (![card isEqualToString:@"0"]) {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				NSString *appFile = [documentsDirectory stringByAppendingPathComponent:card];
				
				NSFileManager *fileManager = [NSFileManager defaultManager];
				[fileManager removeItemAtPath:appFile error:NULL];
			}
			
			sqlite3_exec(db, [[NSString stringWithFormat:@"delete from vctbl where status='report';"]UTF8String], NULL, NULL, NULL);
			sqlite3_close(db);	
			
			MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];	
			controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController:controller animated:YES];
			[controller release];	
			[card release];
		}
	}
	if ([alertView tag] == 0) {
		if (buttonIndex == [alertView cancelButtonIndex]) {
			[self exitButton:self];
		}
	}
}


- (IBAction)zoomImage {
	ZoomedImageViewController *controller = [[ZoomedImageViewController alloc] initWithNibName:@"ZoomedImageViewController" bundle:nil];	
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (IBAction)contact {
	CallSmsMailViewController *controller = [[CallSmsMailViewController alloc] initWithNibName:@"CallSmsMailViewController" bundle:nil];	
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}


- (void)webView:(UIWebView *)NBC didFailLoadWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"You have a connection failure. You have to get on a wi-fi or a cell network to get a internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
	[alert setTag:0];
    [alert release];

}

- (void)switchToFlip{	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];	
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}


- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
} 


- (void)dealloc {
    [super dealloc];
	[labels release];
}


@end
