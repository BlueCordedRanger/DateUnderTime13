static UIFont *const timeFont = [UIFont boldSystemFontOfSize: 14];
static UIFont *const dateFont = [UIFont boldSystemFontOfSize: 10];

static NSDateFormatter *timeFormatter;
static NSDateFormatter *dateFormatter;

static NSMutableAttributedString *finalString;

@interface _UIStatusBarStringView : UILabel
@property(nullable, nonatomic, copy) NSString *text;
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) NSInteger numberOfLines;
@property(nullable, nonatomic, copy) NSAttributedString *attributedText;
@end

%hook _UIStatusBarStringView
- (void)applyStyleAttributes: (id)arg1
{
	if(!(self.text != nil && [self.text containsString : @":"]))
	{
		%orig(arg1);
	}
}

-(void)setText: (NSString *)text
{
	if([text containsString : @":"])
	{
		@autoreleasepool
		{
			NSDate *nowDate = [NSDate date];

			[finalString setAttributedString: [[NSAttributedString alloc] initWithString:[timeFormatter stringFromDate: nowDate] attributes: @{ NSFontAttributeName: timeFont }]];
			[finalString appendAttributedString: [[NSAttributedString alloc] initWithString: [dateFormatter stringFromDate: nowDate] attributes: @{ NSFontAttributeName: dateFont }]];

			self.textAlignment = 1; // 0 = left, 1 = center, 2 = right
			self.numberOfLines = 2;
			self.attributedText = finalString;
		}
	}
	else
	{
		%orig(text);
	}
}
%end

%ctor
{
	timeFormatter = [[NSDateFormatter alloc] init];
	timeFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
	timeFormatter.timeStyle = NSDateFormatterNoStyle;
	timeFormatter.dateFormat = @"HH:mm\n";

	dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
	dateFormatter.timeStyle = NSDateFormatterNoStyle;
	dateFormatter.dateFormat = @"E dd/MM";

	finalString = [[NSMutableAttributedString alloc] init];

	%init;
}