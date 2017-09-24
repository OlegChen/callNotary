//
// DemoTableHeaderView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>


@interface DemoTableHeaderView : UIView {
    
  UIImageView *title;
  UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet UIImageView *title;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
