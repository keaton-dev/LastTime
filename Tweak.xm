@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * bundleIdentifier;
@property (nonatomic,readonly) NSString * displayName;
@end

// Thank you DGh0st and the iphonedevwiki
%hook SpringBoard
- (void)frontDisplayDidChange:(id)arg {
    %orig(arg);

    if (arg == nil) {
        // you are on homescreen
        NSLog(@"lasttime: homescreen");
    } else if ([arg isKindOfClass:%c(CSCoverSheetController)]) {
        // you are on lockscreen
        NSLog(@"lasttime: lockscreen");
    } else if ([arg isKindOfClass:%c(SBApplication)]) {
        __kindof SBApplication *app = arg;
        // you are in applications
        //NSLog(@"lt: %@", app);
        NSLog(@"lasttime: %@, opened at %@", [app bundleIdentifier], [NSDate date]);
        NSString *displayName = [app displayName];
        NSString *lastOpened = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
        //NSLog(@"%@", lastOpened);
        //app.displayName = [displayName stringByAppendingString:lastOpened];
        /*NSLog(@"lasttime: application");
        NSDate *last = [NSDate date];
        NSLog(@"opened, %@", last);*/
    } else {
        // newDisplay will be either a UIViewController or a controller that inherits from UIViewController (pretty much another special case like lockscreen)
        NSLog(@"lasttime: other");
    }
}
%end

@interface SBFluidSwitcherIconImageContainerView : UIView
@end

// view responsible for containing app icon and label
@interface SBFluidSwitcherItemContainerHeaderView : UIView {
	SBFluidSwitcherIconImageContainerView* _firstIconImageView;
	UILabel* _firstIconTitle;
	SBFluidSwitcherIconImageContainerView* _secondIconImageView;
	UILabel* _secondIconTitle;
}
@end

%hook SBFluidSwitcherItemContainerHeaderView
-(void)_createIconAndTitleSubviews {
	UILabel *secondIconTitle = MSHookIvar<UILabel *>(self, "_secondIconTitle");
    secondIconTitle.text = [secondIconTitle.text stringByAppendingString:@"timestamp"];
}
%end
