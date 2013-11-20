//
//  MainViewCCController.m
// iCard

#import "MainViewCCController.h"
#import "MainViewOrgController.h"
#import "MainViewController.h"
#import "ReportView.h"
#import "CustomMainViewController.h"
#import "MainViewEmailController.h"
#import "MainViewContactController.h"
#import "MainViewControllerImages.h"

@implementation MainViewCCController


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

- (IBAction)nameButton {
	MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}


- (IBAction)jobButton {
	CustomMainViewController *controller = [[CustomMainViewController alloc] initWithNibName:@"CustomMainViewController" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (IBAction)orgButton {
	MainViewOrgController *controller = [[MainViewOrgController alloc] initWithNibName:@"MainViewOrgController" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	listOfNames = [[NSMutableArray alloc] init];
	dataSource = [[NSMutableArray alloc] init];
	idKey = [[NSMutableArray alloc] init];
	unsortedidKey = [[NSMutableArray alloc] init];
	
	[self initName:10];
	[self initName:15];
	listOfNames = [self sort:listOfNames];
}


- (void)initName:(NSInteger)i {
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl;"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) 
		{
			NSString *name1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, i))];
			
			if (![name1 isEqualToString:@"city"]) {
				NSString *name2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, i+1))];
				NSString *name3 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 1))];
				NSString *name4 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 2))];
				
				if ([name2 isEqualToString:@"state"]) {
					name2 = @"";
				}
				if ([name4 isEqualToString:@"last name"]) {
					name4 = @"";
				}
				
				NSString *fullName = [name1 stringByAppendingFormat:@", %@: %@ %@",name2,name3,name4];
				NSNumber *idk=[NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
				
				[listOfNames addObject:fullName];
				[dataSource addObject:fullName];
				[unsortedidKey addObject:idk];
				[name2 release];
				[name3 release];
				[name4 release];
				[fullName release];
				[idk release];
			}
			[name1 release];
		}
	}
	sqlite3_close(db);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [listOfNames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}	
	// Set up the cell...
	NSString *cellValue = [listOfNames objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set status='report' where id='%@';",[idKey objectAtIndex:indexPath.row]]UTF8String], NULL, NULL, NULL);	
	sqlite3_close(db);
	
	ReportView *controller = [[ReportView alloc] initWithNibName:@"ReportView" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *header = [[NSString alloc] initWithFormat:@"City, State : Name"];
	return header;
	[header release];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar's cancel button while in edit mode
	sBar.showsCancelButton = YES;
	sBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	[listOfNames removeAllObjects];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	sBar.showsCancelButton = NO;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[listOfNames removeAllObjects];// remove all data that belongs to previous search
	if([searchText isEqualToString:@""]||searchText==nil){
		[myTableView reloadData];
		return;
	}
	NSInteger counter = 0;
	for(NSString *name in dataSource)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [name rangeOfString:searchText];
		if(r.location != NSNotFound)
		{
			if(r.location== 0)//that is we are checking only the start of the names.
			{
				[listOfNames addObject:name];
			}
		}
		counter++;
		[pool release];
	}
	[myTableView reloadData];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {    
	[self dismissModalViewControllerAnimated:YES];
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


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[theTextField resignFirstResponder];
	return YES;
}


- (void)changeScope {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle: @"Select the field for search" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"City/State" otherButtonTitles:@"E-mail",@"Contact number",@"Visting Cards", nil];
	[menu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
		case 1:
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
			MainViewEmailController *controller = [[MainViewEmailController alloc] initWithNibName:@"MainViewEmailController" bundle:nil];
			controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController:controller animated:YES];
			[controller release];
			[actionSheet release];
			break;
		case 2:
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
			MainViewContactController *controller1 = [[MainViewContactController alloc] initWithNibName:@"MainViewContactController" bundle:nil];
			controller1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController:controller1 animated:YES];
			[controller1 release];
			[actionSheet release];
			break;
		case 3:
			[actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
			MainViewControllerImages *controller2 = [[MainViewControllerImages alloc] initWithNibName:@"MainViewControllerImages" bundle:nil];
			controller2.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			[self presentModalViewController:controller2 animated:YES];
			[controller2 release];
			[actionSheet release];
			break;

		default:
			break;
	}
}

- (NSMutableArray *)sort:(NSMutableArray *)unsortedArray {
	static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch |NSWidthInsensitiveSearch | NSForcedOrderingSearch;

	if ([unsortedArray count] <= 1) {
		if ([unsortedArray count] == 1) {
			[idKey addObject:[unsortedidKey objectAtIndex:0]];
		}
		return unsortedArray;
	}
	else {
		NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
		[sortedArray addObject:[unsortedArray objectAtIndex:0]];
		[idKey addObject:[unsortedidKey objectAtIndex:0]];
		
		for (int i=1; i<[unsortedArray count]; i++) {
			int flag=0;
			for (int j=0; j<[sortedArray count]; j++) {
				
				NSComparisonResult result;
				result = [[unsortedArray objectAtIndex:i] compare:[sortedArray objectAtIndex:j] options:comparisonOptions];
				if (result == -1) {	//descending
					int k = [sortedArray count];
					[sortedArray addObject:[sortedArray objectAtIndex:k-1]];
					[idKey addObject:[idKey objectAtIndex:k-1]];
					k--;
					while (k>j) {
						[sortedArray replaceObjectAtIndex:k withObject:[sortedArray objectAtIndex:k-1]];
						[idKey replaceObjectAtIndex:k withObject:[idKey objectAtIndex:k-1]];
						k--;
					}
					[sortedArray replaceObjectAtIndex:j withObject:[unsortedArray objectAtIndex:i]];
					[idKey replaceObjectAtIndex:j withObject:[unsortedidKey objectAtIndex:i]];
					flag = 1;
					break;
				}
			}
			if (flag == 0) {
				[sortedArray addObject:[unsortedArray objectAtIndex:i]];
				[idKey addObject:[unsortedidKey objectAtIndex:i]];
			}
		}
		return sortedArray;
	}
}


- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
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

- (void)dealloc {
    [super dealloc];
	[listOfNames release];
	[dataSource release];
	[idKey release];
	[unsortedidKey release];
}


@end