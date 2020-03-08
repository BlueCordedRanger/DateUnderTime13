#import <Cephei/HBPreferences.h>

HBPreferences *_Nullable pref;

BOOL enabled;

NSString *_Nullable format1;
long fontSize1;
BOOL bold1;

NSString *_Nullable format2;
long fontSize2;
BOOL bold2;

NSString *_Nullable locale;

long alignment;

@interface _UIStatusBarStringView : UILabel
@property(nullable, nonatomic, copy) NSString *text;
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) NSInteger numberOfLines;
@property(nullable, nonatomic, copy) NSAttributedString *attributedText;
@end