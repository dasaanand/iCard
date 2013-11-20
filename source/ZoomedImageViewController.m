//
//  ZoomedImageViewController.m
// iCard

#import "ZoomedImageViewController.h"


@implementation ZoomedImageViewController

@synthesize image,scroll;
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
	NSString *img;
	sqlite3_stmt *statement;
	sqlite3_open([[self filePath] UTF8String], &db);
	if (sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"select * from vctbl where status='report';"]UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{	
		while (sqlite3_step(statement) == SQLITE_ROW) {
			img = [[NSString alloc] initWithUTF8String:(char *)(sqlite3_column_text(statement, 24))];
		}
	}
	sqlite3_close(db);	
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
	
	NSData *data =[[NSData alloc] initWithContentsOfFile:[documentsDir stringByAppendingPathComponent:img]];
	image.image = [[UIImage alloc] initWithData:data];
	
	scroll.contentSize = CGSizeMake(image.frame.size.width, image.frame.size.height);
	scroll.maximumZoomScale = 4.0;
	scroll.minimumZoomScale = 0.75;
	scroll.clipsToBounds = YES;
	scroll.delegate = self;
	[scroll addSubview:image];
	[data release];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return image;
}

- (IBAction)back {
	[self dismissModalViewControllerAnimated:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (NSString *)filePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:@"iCard.sql"];
} 


- (void)dealloc {
	[scroll release];
	[image release];
    [super dealloc];
}


@end
