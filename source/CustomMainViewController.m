//
//  CustomMainViewController.m
// iCard

#import "CustomMainViewController.h"
#import "MainViewController.h"
#import "MainViewOrgController.h"
#import "ReportView.h"
#import "MainViewCCController.h"

@implementation CustomMainViewController


- (IBAction)nameButton {
	MainViewController *controller = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
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

- (IBAction)scopeButton {
	MainViewCCController *controller = [[MainViewCCController alloc] initWithNibName:@"MainViewCCController" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
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
	[self.view addSubview:Contents];
	
	listOfNames = [[NSMutableArray alloc] init];
	contentsArray = [[NSMutableArray alloc] init];
	sections = [[NSMutableArray alloc] init];
	idKey = [[NSMutableArray alloc] init];
	idKeyTemp = [[NSMutableArray alloc] init];
	unsortedidKey = [[NSMutableArray alloc] init];
	
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl order by fname;"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) 
		{
			NSNumber *idk=[NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
			NSString *name1 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 1))];
			NSString *name2 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 2))];
			NSString *name3 = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 3))];
			if ([name1 isEqualToString:@"first name"]) {
				name1=@"Unknown";
			}			
			if ([name2 isEqualToString:@"last name"]) {
				name2=@"";
			}		
			if ([name3 isEqualToString:@"organization name"]) {
				name3=@"Unknown";
			}
			NSString *fullName = [name1 stringByAppendingFormat:@" %@",name2];
			fullName = [fullName stringByAppendingFormat:@" : %@",name3];
			
			[sections addObject:[[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 23))]];
			[idKeyTemp addObject:idk];
			[listOfNames addObject:fullName];
			[name1 release];
			[name2 release];
			[name3 release];
			[fullName release];
		}
	}
	sqlite3_close(db);	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	if ([listOfNames count]==0) {
		return 0;
	}
	
	int i,j,count,flag;
	count = 1;
	uniqueSections = [[NSMutableArray alloc] init];
	[uniqueSections addObject:[sections objectAtIndex:0]];
	[contentsArray addObject:[[NSMutableArray alloc] init]];
	[idKey addObject:[[NSMutableArray alloc] init]];
	[unsortedidKey addObject:[[NSMutableArray alloc] init]];
	
	for (i=1; i<[sections count]; i++) {
		flag = 0;
		for (j=0; j<[uniqueSections count]; j++) {
			
			if ([[uniqueSections objectAtIndex:j] isEqualToString:[sections objectAtIndex:i]]) {
				flag = 0;
				break;
			}
			else {
				flag = 1;
			}
		}
		if (flag == 1) {
			[uniqueSections addObject:[sections objectAtIndex:i]];
			[contentsArray addObject:[[NSMutableArray alloc] init]];
			[unsortedidKey addObject:[[NSMutableArray alloc] init]];
			[idKey addObject:[[NSMutableArray alloc] init]];
			count++;
		}
	}
	//adding contents
	for (i=0; i<[listOfNames count]; i++) {
		j=0;
		while (![[sections objectAtIndex:i] isEqualToString:[uniqueSections objectAtIndex:j]]) {
			j++;
		}
		[[contentsArray objectAtIndex:j] addObject:[listOfNames objectAtIndex:i]];
		[[unsortedidKey objectAtIndex:j] addObject:[idKeyTemp objectAtIndex:i]];
	}

	for (int row=0; row<[contentsArray count]; row++) {
		NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:[contentsArray objectAtIndex:row]];
		temp = [self sort:temp:row];
		[[contentsArray objectAtIndex:row] removeAllObjects];
		[[contentsArray objectAtIndex:row] addObjectsFromArray:temp];
		[temp release];
	}
	return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int i,j;
	j=0;
	for (i=0; i<[sections count]; i++) {
		 if ([[sections objectAtIndex:i] isEqualToString:[uniqueSections objectAtIndex:section]]) {
			 j++; 
		 }
	}
	return j;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}	
	// Set up the cell...
	NSString *cellValue = [[contentsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [uniqueSections objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	sqlite3_open([[self filePath] UTF8String], &db);
	sqlite3_exec(db, [[NSString stringWithFormat:@"update vctbl set status='report' where id='%@';",[[idKey objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]]UTF8String], NULL, NULL, NULL);
	sqlite3_close(db);
	
	ReportView *controller = [[ReportView alloc] initWithNibName:@"ReportView" bundle:nil];
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	[controller release];
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

- (NSMutableArray *)sort:(NSMutableArray *)unsortedArray:(int)row{
	static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch |NSWidthInsensitiveSearch | NSForcedOrderingSearch;
	
	if ([unsortedArray count] <= 1) {
		if ([unsortedArray count] == 1) {
			[[idKey objectAtIndex:row] addObjectsFromArray:[unsortedidKey objectAtIndex:row]];
		}
		return unsortedArray;
	}
	else {
		NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
		[sortedArray addObject:[unsortedArray objectAtIndex:0]];
		[[idKey objectAtIndex:row] addObject:[[unsortedidKey objectAtIndex:row] objectAtIndex:0]];
		
		for (int i=1; i<[unsortedArray count]; i++) {
			int flag=0;
			for (int j=0; j<[sortedArray count]; j++) {
				
				NSComparisonResult result;
				result = [[unsortedArray objectAtIndex:i] compare:[sortedArray objectAtIndex:j] options:comparisonOptions];
				if (result == -1) {	//descending
					int k = [sortedArray count];
					[sortedArray addObject:[sortedArray objectAtIndex:k-1]];
					[[idKey objectAtIndex:row] addObject:[[idKey objectAtIndex:row] objectAtIndex:k-1]];
					k--;
					while (k>j) {
						[sortedArray replaceObjectAtIndex:k withObject:[sortedArray objectAtIndex:k-1]];
						[[idKey objectAtIndex:row] replaceObjectAtIndex:k withObject:[[idKey objectAtIndex:row] objectAtIndex:k-1]];
						k--;
					}
					[sortedArray replaceObjectAtIndex:j withObject:[unsortedArray objectAtIndex:i]];
					[[idKey objectAtIndex:row] replaceObjectAtIndex:j withObject:[[unsortedidKey objectAtIndex:row] objectAtIndex:i]];
					flag = 1;
					break;
				}
			}
			if (flag == 0) {
				[sortedArray addObject:[unsortedArray objectAtIndex:i]];
				[[idKey objectAtIndex:row] addObject:[[unsortedidKey objectAtIndex:row] objectAtIndex:i]];
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
	[contentsArray release];
	[sections release];
	[uniqueSections release];
	[idKey release];
	[idKeyTemp release];
	[uniqueSections release];
}


@end
