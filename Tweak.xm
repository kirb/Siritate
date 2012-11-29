UIDeviceOrientation oldorient = UIDeviceOrientationPortrait;
UIInterfaceOrientation apporient = UIInterfaceOrientationPortrait;
BOOL hasSiri = NO;

@interface UIDevice (Private)
-(void)setOrientation:(UIDeviceOrientation)orientation;
@end

%hook SBAssistantController
-(void)viewDidAppear {
	hasSiri = YES;
	%orig;
}
-(void)viewWillAppear {
	if (UIDeviceOrientationIsLandscape(oldorient = [UIDevice currentDevice].orientation)){
		[[UIDevice currentDevice]setOrientation:UIDeviceOrientationPortrait];
		apporient = [[UIApplication sharedApplication] statusBarOrientation];
		[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
	}
	%orig;
}
-(void)viewWillDisappear {
	hasSiri = NO;
	%orig;
}
-(void)viewDidDisappear {
	if (UIDeviceOrientationIsLandscape(oldorient)) {
		[[UIApplication sharedApplication] setStatusBarOrientation:apporient];
		[[UIDevice currentDevice] setOrientation:oldorient];
	}
	%orig;
}
%end
%hook SBUIController
-(BOOL)window:(id)window shouldAutorotateToInterfaceOrientation:(int)interfaceOrientation {
	return (hasSiri && UIInterfaceOrientationIsPortrait(interfaceOrientation)) ? NO : %orig;
}
%end
