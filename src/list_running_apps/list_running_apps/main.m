#import <Cocoa/Cocoa.h>
#import "CopyLaunchedApplicationsInFrontToBackOrder.h"

#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

int main() {
    @autoreleasepool {
        NSArray *stats = (NSArray*)CFBridgingRelease(CopyLaunchedApplicationsInFrontToBackOrder());
        for (int i = 0; i < [stats count]; i++) {
            NSDictionary* d = [stats objectAtIndex:i];
            NSLog(@"%d,%@,%@,%@,%@", i,
                  [d valueForKey:@"CFBundleName"], [d valueForKey:@"CFBundleIdentifier"],
                  [d valueForKey:@"pid"], [d valueForKey:@"BundlePath"]);
        }
    }
    return 0;
}

// vim: ft=objc:
