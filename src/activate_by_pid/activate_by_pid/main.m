#import <Cocoa/Cocoa.h>
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

@interface ApplicationDelegate : NSObject <NSApplicationDelegate>
@end

@implementation ApplicationDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    if ([args count] < 2) {
        NSLog(@"usage: activate_by_pid <pid>");
        [NSApp terminate:self];
        return;
    }
    long pid = [[args objectAtIndex:1] integerValue];
    NSRunningApplication *app = [NSRunningApplication
                                 runningApplicationWithProcessIdentifier:(pid_t)pid];
    if (app != nil) {
        [app activateWithOptions:0];
    } else {
        NSLog(@"pid:%ld not found", pid);
        [NSApp terminate:self];
    }
}

- (void)applicationDidResignActive:(NSNotification *)aNotification {
    [NSApp terminate:0];
}
@end

int main() {
    @autoreleasepool {
        [NSApplication sharedApplication];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        
        id menuBar = [NSMenu new];
        [NSApp setMainMenu:menuBar];
        
        id menuItem = [NSMenuItem new];
        [menuBar addItem:menuItem];
        id subMenu = [NSMenu new];
        [[menuBar itemAtIndex:0] setSubmenu:subMenu];
        id quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"Quit"
                                                     action:@selector(terminate:) keyEquivalent:@"q"];
        [[[menuBar itemAtIndex:0] submenu] addItem:quitMenuItem];
        
        id delegate = [ApplicationDelegate new];
        [NSApp setDelegate:delegate];
        [NSApp activateIgnoringOtherApps:YES];
        
        [NSApp run];
    }
    return 0;
}

// vim: ft=objc:

