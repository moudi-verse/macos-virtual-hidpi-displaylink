#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <dispatch/dispatch.h>

@interface CGVirtualDisplayMode : NSObject
- (id)initWithWidth:(unsigned int)width
             height:(unsigned int)height
        refreshRate:(double)refreshRate;
@end

@interface CGVirtualDisplaySettings : NSObject
@property(retain, nonatomic) NSArray *modes;
@property(nonatomic) unsigned int hiDPI;
@end

@interface CGVirtualDisplayDescriptor : NSObject
@property(copy, nonatomic) NSString *name;
@property(nonatomic) unsigned int vendorID;
@property(nonatomic) unsigned int productID;
@property(nonatomic) unsigned int serialNum;
@property(nonatomic) CGSize sizeInMillimeters;
@property(nonatomic) unsigned int maxPixelsWide;
@property(nonatomic) unsigned int maxPixelsHigh;
@property(nonatomic) CGPoint redPrimary;
@property(nonatomic) CGPoint greenPrimary;
@property(nonatomic) CGPoint bluePrimary;
@property(nonatomic) CGPoint whitePoint;
@property(retain, nonatomic) dispatch_queue_t queue;
@end

@interface CGVirtualDisplay : NSObject
@property(readonly, nonatomic) unsigned int displayID;
- (id)initWithDescriptor:(id)descriptor;
- (BOOL)applySettings:(id)settings;
@end

static CGVirtualDisplay *gDisplay = nil;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        unsigned int backingWidth = 4096;
        unsigned int backingHeight = 2304;
        unsigned int ppi = 218;
        NSString *name = @"Virtual Retina 27";

        CGVirtualDisplayDescriptor *descriptor = [CGVirtualDisplayDescriptor new];
        descriptor.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        descriptor.name = name;

        descriptor.whitePoint = CGPointMake(0.3125, 0.3291);
        descriptor.redPrimary = CGPointMake(0.6797, 0.3203);
        descriptor.greenPrimary = CGPointMake(0.2559, 0.6983);
        descriptor.bluePrimary = CGPointMake(0.1494, 0.0557);

        descriptor.maxPixelsWide = backingWidth;
        descriptor.maxPixelsHigh = backingHeight;

        descriptor.sizeInMillimeters = CGSizeMake(25.4 * backingWidth / ppi,
                                                  25.4 * backingHeight / ppi);

        descriptor.vendorID = 505;
        descriptor.productID = 1;
        descriptor.serialNum = 1;

        gDisplay = [[CGVirtualDisplay alloc] initWithDescriptor:descriptor];
        if (!gDisplay) {
            fprintf(stderr, "Failed to create CGVirtualDisplay\n");
            return 2;
        }

        CGVirtualDisplaySettings *settings = [CGVirtualDisplaySettings new];
        settings.hiDPI = 1;

        CGVirtualDisplayMode *mode =
            [[CGVirtualDisplayMode alloc] initWithWidth:2048
                                                 height:1152
                                            refreshRate:60.0];

        settings.modes = @[ mode ];

        if (![gDisplay applySettings:settings]) {
            fprintf(stderr, "Failed to apply settings\n");
            return 3;
        }

        printf("Created virtual display. displayID=%u\n", gDisplay.displayID);
        printf("Logical HiDPI mode: %ux%u\n", backingWidth / 2, backingHeight / 2);
        printf("Backing resolution: %ux%u\n", backingWidth, backingHeight);
        printf("Keep this process running.\n");

        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
