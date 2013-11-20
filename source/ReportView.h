//
//  ReportView.h
// iCard 


@interface ReportView : UIViewController{
//page1
	IBOutlet UILabel *fname;
	IBOutlet UILabel *lname;
	IBOutlet UILabel *orgname;
	IBOutlet UILabel *jobtitle;
	IBOutlet UIImageView *vcImage;
//page2	
	IBOutlet UITextField *off1add;
	IBOutlet UILabel *off1city;
	IBOutlet UILabel *off1state;
	IBOutlet UILabel *off1country;
	IBOutlet UILabel *off1pinno;
	IBOutlet UILabel *off1contactno;
	IBOutlet UILabel *off1email;

//page3
	IBOutlet UITextField *off2add;
	IBOutlet UILabel *off2city;
	IBOutlet UILabel *off2state;
	IBOutlet UILabel *off2country;
	IBOutlet UILabel *off2pinno;
	IBOutlet UILabel *off2contactno;
	IBOutlet UILabel *off2email;
	
//page4	
	IBOutlet UILabel *blog;
	IBOutlet UILabel *website;
	IBOutlet UILabel *personalno;
	IBOutlet UILabel *personalemail;
	IBOutlet UILabel *faxno;
	
	NSMutableArray *labels;
	IBOutlet UIView *page1;
	IBOutlet UIView *page2;
	IBOutlet UIView *page3;
	IBOutlet UIView *page4;
	IBOutlet UIPageControl *pageControl;
	sqlite3 *db;
	
	IBOutlet UIScrollView *scrollView1;
	IBOutlet UIScrollView *scrollView2;
	IBOutlet UIScrollView *scrollView3;
	IBOutlet UIScrollView *scrollView4;
}

//page1
@property(nonatomic,retain) IBOutlet UILabel *fname;
@property(nonatomic,retain) IBOutlet UILabel *lname;
@property(nonatomic,retain) IBOutlet UILabel *orgname;
@property(nonatomic,retain) IBOutlet UILabel *jobtitle;
@property(nonatomic,retain) IBOutlet UIImageView *vcImage; 
//page2	
@property(nonatomic,retain) IBOutlet UITextField *off1add;
@property(nonatomic,retain) IBOutlet UILabel *off1city;
@property(nonatomic,retain) IBOutlet UILabel *off1state;
@property(nonatomic,retain) IBOutlet UILabel *off1country;
@property(nonatomic,retain) IBOutlet UILabel *off1pinno;
@property(nonatomic,retain) IBOutlet UILabel *off1contactno;
@property(nonatomic,retain) IBOutlet UILabel *off1email;

//page3
@property(nonatomic,retain) IBOutlet UITextField *off2add;
@property(nonatomic,retain) IBOutlet UILabel *off2city;
@property(nonatomic,retain) IBOutlet UILabel *off2state;
@property(nonatomic,retain) IBOutlet UILabel *off2country;
@property(nonatomic,retain) IBOutlet UILabel *off2pinno;
@property(nonatomic,retain) IBOutlet UILabel *off2contactno;
@property(nonatomic,retain) IBOutlet UILabel *off2email;

//page4	
@property(nonatomic,retain) IBOutlet UILabel *blog;
@property(nonatomic,retain) IBOutlet UILabel *website;
@property(nonatomic,retain) IBOutlet UILabel *personalno;
@property(nonatomic,retain) IBOutlet UILabel *personalemail;
@property(nonatomic,retain) IBOutlet UILabel *faxno;


- (IBAction)exitButton:(id)sender;
- (IBAction)editButton:(id)sender;
- (IBAction)deleteButton:(id)sender;
- (IBAction)zoomImage;
- (IBAction)contact;

- (void)switchToFlip;
- (NSString *)filePath;
- (void)changePage:(id)sender;
- (void)initlabels;
@end
