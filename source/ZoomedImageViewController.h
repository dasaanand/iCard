//
//  ZoomedImageViewController.h
// iCard


@interface ZoomedImageViewController : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIImageView *image;
	IBOutlet UIScrollView *scroll;
	sqlite3 *db;

}

@property (nonatomic,retain) IBOutlet UIImageView *image;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

- (IBAction)back;
- (NSString *)filePath;
@end
