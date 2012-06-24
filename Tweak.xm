#import <UIKit/UIDevice2.h>

UIDeviceOrientation oldorient=UIDeviceOrientationPortrait;
UIInterfaceOrientation apporient=UIInterfaceOrientationPortrait;
BOOL hasSiri=NO;
#if DEBUG
int debugorient=1000;
#endif

%hook SBAssistantController
-(void)viewDidAppear{
	hasSiri=YES;
	%orig;
}
-(void)viewWillAppear{
	#if DEBUG
	NSLog(@"[Siritate] I haz %@ as interface orientation",debugorient);
	#endif
	if(UIDeviceOrientationIsLandscape(oldorient=[[UIDevice currentDevice]orientation])){
		[[UIDevice currentDevice]setOrientation:UIDeviceOrientationPortrait];
		apporient=[[UIApplication sharedApplication]statusBarOrientation];
		[[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
	}
	%orig;
}
-(void)viewWillDisappear{
	hasSiri=NO;
	%orig;
}
-(void)viewDidDisappear{
	if(UIDeviceOrientationIsLandscape(oldorient)){
		[[UIApplication sharedApplication]setStatusBarOrientation:apporient];
		[[UIDevice currentDevice]setOrientation:oldorient];
	}
	%orig;
}
%end
%hook SBUIController
-(BOOL)window:(id)window shouldAutorotateToInterfaceOrientation:(int)interfaceOrientation{
	#if DEBUG
	debugorient=interfaceOrientation;
	return %orig;
	#else
	return (hasSiri&&UIInterfaceOrientationIsPortrait(interfaceOrientation))?NO:%orig;
	#endif
}
%end
