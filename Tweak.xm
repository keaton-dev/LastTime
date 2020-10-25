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

@interface SBFluidSwitcherItemContainerHeaderItem : NSObject
@property (nonatomic,copy) NSString * titleText;
@property (nonatomic,copy) NSString * subtitleText;
@end

// view responsible for containing app icon and label
@interface SBFluidSwitcherItemContainerHeaderView : UIView {
	SBFluidSwitcherItemContainerHeaderItem* _firstItem;
	SBFluidSwitcherItemContainerHeaderItem* _secondItem;
}
-(id)initWithFrame:(CGRect)arg1 delegate:(id)arg2;
-(void)_updateIconsAndTitles;
-(void)layoutSubviews;
@end

%hook SBFluidSwitcherItemContainerHeaderView
-(id)initWithFrame:(CGRect)arg1 delegate:(id)arg2 {
    %orig;
	SBFluidSwitcherItemContainerHeaderItem *firstItem = MSHookIvar<SBFluidSwitcherItemContainerHeaderItem *>(self, "_firstItem");
    [firstItem setTitleText:[firstItem.titleText stringByAppendingString:@"timestamp1"]];
	SBFluidSwitcherItemContainerHeaderItem *secondItem = MSHookIvar<SBFluidSwitcherItemContainerHeaderItem *>(self, "_secondItem");
    [secondItem setTitleText:[secondItem.titleText stringByAppendingString:@"timestamp2"]];
    return self;
}
-(void)_createIconAndTitleSubviews {
    NSLog(@"lasttime: _createIconAndTitleSubviews");
    %orig;
	SBFluidSwitcherItemContainerHeaderItem *firstItem = MSHookIvar<SBFluidSwitcherItemContainerHeaderItem *>(self, "_firstItem");
    [firstItem setTitleText:[firstItem.titleText stringByAppendingString:@"timestamp1"]];
	SBFluidSwitcherItemContainerHeaderItem *secondItem = MSHookIvar<SBFluidSwitcherItemContainerHeaderItem *>(self, "_secondItem");
    [secondItem setTitleText:[secondItem.titleText stringByAppendingString:@"timestamp2"]];
}
%end
