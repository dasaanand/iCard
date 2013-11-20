//
//  MainViewControllerImages.m
// iCard

#import "MainViewControllerImages.h"
#import "MainViewCCController.h"
#import "MainViewOrgController.h"
#import "MainViewController.h"
#import "ReportView.h"
#import "CustomMainViewController.h"
#import "MainViewEmailController.h"
#import "MainViewContactController.h"


@implementation MainViewControllerImages

@synthesize card1,card2,card3,card4,nextSet,previousSet;
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
	[card1 setTag:1];
	[card2 setTag:2];
	[card3 setTag:3];
	[card4 setTag:4];
		
	listOfNames = [[NSMutableArray alloc] init];
	idKey = [[NSMutableArray alloc] init];
	idref = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl order by id desc;"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) 
		{
			[listOfNames addObject:[[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 24))]];
			NSNumber *idk=[NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
			[idKey addObject:idk];
 		}
	}
	sqlite3_close(db);
	endCardIndex = 0;
	[self dispImage:endCardIndex];
	[self checkCount];

}

- (void) dispImage:(int) start {
	NSMutableArray *saveImage = [[NSMutableArray alloc] init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	[idref removeAllObjects];
	
	for (int i=start; i<[listOfNames count]; i++) {
		NSData *data1 =[[NSData alloc] initWithContentsOfFile:[documentsDir stringByAppendingPathComponent:[listOfNames objectAtIndex:i]]];
		[saveImage addObject:data1];
		[idref addObject:[idKey objectAtIndex:i]];
		[data1 release];
	}
	
	if ([saveImage count]/4 >0) {
		card4.hidden = NO;
		card3.hidden = NO;
		card2.hidden = NO;		
		card1.hidden = NO;
		
		[card4 setBackgroundImage:[[UIImage alloc] initWithData:[saveImage objectAtIndex:3]] forState:UIControlStateNormal];
		[card3 setBackgroundImage:[[UIImage alloc] initWithData:[saveImage objectAtIndex:2]] forState:UIControlStateNormal];
		[card2 setBackgroundImage:[[UIImage alloc] initWithData:[saveImage objectAtIndex:1]] forState:UIControlStateNormal];
		[card1 setBackgroundImage:[[UIImage alloc] initWithData:[saveImage objectAtIndex:0]] forState:UIControlStateNormal];
		endCardIndex+=4;
	}
	else {
		card4.hidden = YES;
		card3.hidden = YES;
		card2.hidden = YES;		
		card1.hidden = YES;
		
		switch ([saveImage count]) {
			case 3:
				card3.hidden = NO;
				[card3 setBackgroundImage:[[UIImage alloc] initWithData:[saveImage objectAtIndex:2]] forState:UIControlStateNormal];
				endCardIndex++;
			case 2:
				card2.hidden = NO;
				[card2 setBackgroundImage:[[UIImage alloc] initWithData:[saveImage objectAtIndex:1]] forState:UIControlStateNormal];
				endCardIndex++;
			case 1:
				card1.hidden = NO;
				[card1 setBackgroundImage:[[UIImage alloc] initWithData:[saveImage objectAtIndex:0]] forState:UIControlStateNormal];
				endCardIndex++;
				break;
			default:
				break;
		}	
	}
	[saveImage release];
}


- (IBAction)next {
	if (endCardIndex < [listOfNames count]) {
		[self dispImage:endCardIndex];
		[self checkCount];
	}
}

- (IBAction)previous {
	if (endCardIndex > 4) {
		int i=endCardIndex%4;
		if (i==0) {
			i=4;
		}
		endCardIndex=endCardIndex-i-4;
		[self dispImage:endCardIndex];
		[self checkCount];
	}
}

- (void)checkCount {
	if (([listOfNames count]-endCardIndex) > 0) {
		nextSet.style = UIBarButtonItemStyleDone;
		nextSet.enabled = YES;
	}
	else {
		nextSet.style = UIBarButtonItemStyleBordered;
		nextSet.enabled = NO;
	}
	if (endCardIndex >4) {
		previousSet.style = UIBarButtonItemStyleDone;
		previousSet.enabled = YES;
	}
	else {
		previousSet.style = UIBarButtonItemStyleBordered;
		previousSet.enabled = NO;
	}
}

- (IBAction)cardClicked:(id)sender {
	UIButton *btn = (UIButton *)sender;
	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set status='report' where id='%@';",[idref objectAtIndex:btn.tag-1]]UTF8String], NULL, NULL, NULL);	
	sqlite3_close(db);
	
	ReportView *controller = [[ReportView alloc] initWithNibName:@"ReportView" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
	
}


- (IBAction)showInfo {    	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"insert into vctbl (status) values ('new');"]UTF8String], NULL, NULL, NULL);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set fname='first name', lname='last name', orgname='organization name' where status='new';"]UTF8String], NULL, NULL, NULL);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set persemail='xxx@yyy.com', off1email='xxx@yyy.com', off2email='xxx@yyy.com' where status='new';"]UTF8String], NULL, NULL, NULL);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set blog='blog', website='website' where status='new';"]UTF8String], NULL, NULL, NULL);	
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set off1add='address', off1city='city', off1state='state', off1country='country', off1pin='postal no' where status='new';"]UTF8String], NULL, NULL, NULL);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set off2add='address', off2city='city', off2state='state', off2country='country', off2pin='postal no' where status='new';"]UTF8String], NULL, NULL, NULL);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set persno='personal', off1no='office', off2no='office', faxno='fax', grouplist='Others', edit='no' where status='new';"]UTF8String], NULL, NULL, NULL);		
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set card='0' where status='new';"]UTF8String], NULL, NULL, NULL);	
	sqlite3_close(db);
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;	
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	[controller release];	
}

- (void)changeScope {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle: @"Select the field for search" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Visting Cards" otherButtonTitles:@"City/Country",@"Email",@"Contact Number", nil];
	[menu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 1:
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
			MainViewCCController *controller = [[MainViewCCController alloc] initWithNibName:@"MainViewCCController" bundle:nil];
			controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController:controller animated:YES];
			[controller release];
			[actionSheet release];
			break;
		case 2:
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
			MainViewEmailController *controller1 = [[MainViewEmailController alloc] initWithNibName:@"MainViewEmailController" bundle:nil];
			controller1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController:controller1 animated:YES];
			[controller1 release];
			[actionSheet release];
			break;
		case 3:
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
			MainViewContactController *controller2 = [[MainViewContactController alloc] initWithNibName:@"MainViewContactController" bundle:nil];
			controller2.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController:controller2 animated:YES];
			[controller2 release];
			[actionSheet release];
			break;	
		default:
			break;
	}
	
}


- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
} 


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {    
	[self dismissModalViewControllerAnimated:YES];
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


- (void)dealloc {
    [super dealloc];
	[listOfNames release];
	[idKey release];
	[idref release];
	[card1 release];
	[card2 release];
	[card3 release];
	[card4 release];
}

@end
