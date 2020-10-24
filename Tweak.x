// Thank you DGh0st and the iphonedevwiki
%hook SpringBoard- (void)frontDisplayDidChange:(id)arg {    %orig(arg);    if (arg == nil) {        // you are on homescreen
        NSLog(@"lasttime: homescreen");    } else if ([arg isKindOfClass:%c(CSCoverSheetController)]) {        // you are on lockscreen
        NSLog(@"lasttime: lockscreen");    } else if ([arg isKindOfClass:%c(SBApplication)]) {        // you are in applications
        //NSLog(@"lt: %@", arg);
        NSLog(@"lasttime: %@, opened at %@", [arg bundleIdentifier], [NSDate date]);
        NSString *displayName = [arg displayName];
        NSString *lastOpened = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
        //NSLog(@"%@", lastOpened);
        arg.displayName = [displayName stringByAppendingString:lastOpened];
        /*NSLog(@"lasttime: application");
        NSDate *last = [NSDate date];
        NSLog(@"opened, %@", last);*/    } else {        // newDisplay will be either a UIViewController or a controller that inherits from UIViewController (pretty much another special case like lockscreen)
        NSLog(@"lasttime: other");    }}%end
