#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static UIWindow *SCWindow;

@interface SCController : NSObject
@property(nonatomic, strong) UIButton *button;
@end

@implementation SCController
- (void)toggle:(UIButton *)sender {
  sender.selected = !sender.selected;
  sender.backgroundColor = sender.selected ? [UIColor systemGreenColor] : [UIColor systemBlueColor];
  // Deliberately visible and user-triggered. Screen capture/OCR is not performed silently.
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SCUserCaptureToggled" object:@(sender.selected)];
}
@end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
  %orig;
  dispatch_async(dispatch_get_main_queue(), ^{
    SCWindow = [[UIWindow alloc] initWithFrame:CGRectMake(24, 120, 58, 58)];
    SCWindow.windowLevel = UIWindowLevelAlert + 1;
    SCWindow.backgroundColor = UIColor.clearColor;
    SCWindow.hidden = NO;
    SCController *controller = [SCController new];
    controller.button = [UIButton buttonWithType:UIButtonTypeSystem];
    controller.button.frame = SCWindow.bounds;
    controller.button.layer.cornerRadius = 29;
    controller.button.backgroundColor = UIColor.systemBlueColor;
    [controller.button setTitle:@"OCR" forState:UIControlStateNormal];
    [controller.button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [controller.button addTarget:controller action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [SCWindow addSubview:controller.button];
    objc_setAssociatedObject(SCWindow, @selector(applicationDidFinishLaunching:), controller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  });
}
%end
