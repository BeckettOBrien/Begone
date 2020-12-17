#import <Foundation/Foundation.h>

@interface SBSApplicationShortcutSystemIcon: NSObject
-(instancetype)initWithSystemImageName:(NSString*)name;
@end

@interface SBSApplicationShortcutItem : NSObject
@property (nonatomic,copy) NSString* type;
@property (nonatomic,copy) NSString* localizedTitle;
-(void)setIcon:(SBSApplicationShortcutSystemIcon*)icon;
@end

@interface SBApplicationIcon: NSObject
@end

@interface SBApplication: NSObject
-(void)setBadgeValue:(NSNumber*)val;
@end

@interface SBIconView : NSObject
@property (nonatomic) SBApplicationIcon* icon;
-(NSString*)applicationBundleIdentifier;
-(NSString*)applicationBundleIdentifierForShortcuts;
+(void)activateShortcut:(SBSApplicationShortcutItem*)item withBundleIdentifier:(id)bundleId forIconView:(SBIconView*)iconView;
@end

%hook SBIconView
-(NSArray*)applicationShortcutItems {
	NSArray* orig = %orig;
	SBSApplicationShortcutItem* item = [[%c(SBSApplicationShortcutItem) alloc] init];
	item.localizedTitle = @"Clear Notifications";
	item.type = @"com.beckettobrien.begone.item";
	[item setIcon:[[%c(SBSApplicationShortcutSystemIcon) alloc] initWithSystemImageName:@"clear"]];
	return [orig arrayByAddingObject:item];
}
+(void)activateShortcut:(SBSApplicationShortcutItem*)item withBundleIdentifier:(id)bundleId forIconView:(SBIconView*)iconView {
	if ([[item type] isEqualToString:@"com.beckettobrien.begone.item"]) {
		[(SBApplication*)[[iconView icon] valueForKey:@"_application"] setBadgeValue:@0];
	} else {
		%orig;
	}
}
%end