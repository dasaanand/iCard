//
//  FlipsideViewController.h
// iCard 
//
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@protocol FlipsideViewControllerDelegate;
@interface FlipsideViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIApplicationDelegate>{
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UITextField *fname;
	IBOutlet UITextField *lname;
	IBOutlet UITextField *orgname;
	sqlite3 *db;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIImageView *vcImage;
	CGFloat animatedDistance;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField *fname;
@property (nonatomic, retain) IBOutlet UITextField *lname;
@property (nonatomic, retain) IBOutlet UITextField *orgname;
@property (nonatomic, retain) IBOutlet UIImageView *vcImage;

- (IBAction)fnameDidFinish;
- (IBAction)lnameDidFinish;
- (IBAction)orgnameDidFinish;
- (IBAction)done;
- (IBAction)cancel;
- (IBAction)emailButton:(id)sender;
- (IBAction)webblogButton:(id)sender;
- (IBAction)addressButton:(id)sender;
- (IBAction)contactnoButton:(id)sender;
- (IBAction)jobButton:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;

- (void)switchToMain;
- (NSString *)filePath;
- (void)saveEntry;
- (void)deleteEntry;
- (BOOL)nameExists;
- (void)saveCard;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

