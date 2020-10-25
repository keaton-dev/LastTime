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

@interface BSUIEmojiLabelView : UIView
@property (nonatomic,copy) NSString * text; 
@end

// view responsible for containing app icon and label
@interface SBFluidSwitcherItemContainerHeaderView : UIView {
	SBFluidSwitcherItemContainerHeaderItem* _firstItem;
	SBFluidSwitcherItemContainerHeaderItem* _secondItem;
    UILabel* _firstTitleLabel;
	BSUIEmojiLabelView* _firstSubtitleLabelView;
    UILabel* _secondTitleLabel;
	BSUIEmojiLabelView* _secondSubtitleLabelView;
}
@property (nonatomic,copy) NSArray * headerItems;
-(id)initWithFrame:(CGRect)arg1;
-(void)layoutSubviews;
@end

%hook SBFluidSwitcherItemContainerHeaderView
-(id)initWithFrame:(CGRect)arg1 {
    %orig;
    NSLog(@"lasttime: initWithFrame");

	SBFluidSwitcherItemContainerHeaderItem *firstItem = MSHookIvar<SBFluidSwitcherItemContainerHeaderItem *>(self, "_firstItem");
    [firstItem setTitleText:[firstItem.titleText stringByAppendingString:@"timestamp1"]];
	SBFluidSwitcherItemContainerHeaderItem *secondItem = MSHookIvar<SBFluidSwitcherItemContainerHeaderItem *>(self, "_secondItem");
    [secondItem setTitleText:[secondItem.titleText stringByAppendingString:@"timestamp2"]];

    [self setValue:firstItem forKey:@"_firstItem"];
    [self setValue:secondItem forKey:@"_secondItem"];

	UILabel *firstTitleLabel = MSHookIvar<UILabel *>(self, "_firstTitleLabel");
    firstTitleLabel.text = [firstTitleLabel.text stringByAppendingString:@"timestamp3"];
	UILabel *secondTitleLabel = MSHookIvar<UILabel *>(self, "_secondTitleLabel");
    secondTitleLabel.text = [secondTitleLabel.text stringByAppendingString:@"timestamp4"];

    [self setValue:firstTitleLabel forKey:@"_firstTitleLabel"];
    [self setValue:secondTitleLabel forKey:@"_secondTitleLabel"];

	BSUIEmojiLabelView *firstSubtitleLabelView = MSHookIvar<BSUIEmojiLabelView *>(self, "_firstSubtitleLabelView");
    [firstSubtitleLabelView setText:[firstSubtitleLabelView stringByAppendingString:@"timestamp5"]];
	BSUIEmojiLabelView *secondSubtitleLabelView = MSHookIvar<BSUIEmojiLabelView *>(self, "_secondSubtitleLabelView");
    [secondSubtitleLabelView setText:[secondSubtitleLabelView stringByAppendingString:@"timestamp6"]];

    [self setValue:firstSubtitleLabelView forKey:@"_firstSubtitleLabelView"];
    [self setValue:secondSubtitleLabelView forKey:@"_secondSubtitleLabelView"];

    return self;
}
%end
