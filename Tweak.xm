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
	NSLog(@"[Siritate] Siri's comin' to town!");
	#if DEBUG
	NSLog(@"[Siritate] I haz %@ as interface orientation",debugorient);
	#endif
	if(UIDeviceOrientationIsLandscape(oldorient=[[UIDevice currentDevice]orientation])){
		NSLog(@"[Siritate] Orientation isn't portrait. But that's all gonna change.");
		[[UIDevice currentDevice]setOrientation:UIDeviceOrientationPortrait];
		apporient=[[UIApplication sharedApplication]statusBarOrientation];
		[[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationPortrait];
		NSLog(@"[Siritate] We apologize for this brief break of screen orientation.");
	}
	%orig;
}
-(void)viewWillDisappear{
	hasSiri=NO;
	%orig;
}
-(void)viewDidDisappear{
	NSLog(@"[Siritate] Buh bye, Siri!");
	if(UIDeviceOrientationIsLandscape(oldorient)){
		NSLog(@"[Siritate] So let's turn this thing 'round again");
		[[UIApplication sharedApplication]setStatusBarOrientation:apporient];
		[[UIDevice currentDevice]setOrientation:oldorient];
		NSLog(@"[Siritate] ...there you go.");
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
