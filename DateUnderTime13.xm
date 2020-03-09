#import "DateUnderTime13.h"

static UIFont *font1;
static UIFont *font2;

static NSDateFormatter *formatter1;
static NSDateFormatter *formatter2;

static NSMutableAttributedString *finalString;

%hook _UIStatusBarStringView

- (void)applyStyleAttributes: (id)arg1
{
	if(!(self.text != nil && [self.text containsString: @":"])) %orig;
}

-(void)setText: (NSString*)text
{
	if([text containsString: @":"])
	{
		@autoreleasepool
		{
			NSDate *nowDate = [NSDate date];

			[finalString setAttributedString: [[NSAttributedString alloc] initWithString: [formatter1 stringFromDate: nowDate] attributes: @{ NSFontAttributeName: font1 }]];
			[finalString appendAttributedString: [[NSAttributedString alloc] initWithString: [formatter2 stringFromDate: nowDate] attributes: @{ NSFontAttributeName: font2 }]];

			self.textAlignment = alignment;
			self.numberOfLines = 2;
			self.attributedText = finalString;
		}
	}
	else %orig(text);
}

%end

%group locationIndicatorGroup

	%hook _UIStatusBarIndicatorLocationItem

	- (id)applyUpdate: (id)arg1 toDisplayItem: (id)arg2
	{
		return nil;
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.dateundertime13prefs"];

		[pref registerBool: &enabled default: YES forKey: @"enabled"];

		if(enabled)
		{
			[pref registerObject: &format1 default: @"HH:mm" forKey: @"format1"];
			[pref registerInteger: &fontSize1 default: 14 forKey: @"fontSize1"];
			[pref registerBool: &bold1 default: YES forKey: @"bold1"];

			[pref registerObject: &format2 default: @"E dd/MM" forKey: @"format2"];
			[pref registerInteger: &fontSize2 default: 10 forKey: @"fontSize2"];
			[pref registerBool: &bold2 default: YES forKey: @"bold2"];

			[pref registerObject: &locale default: @"en_US" forKey: @"locale"];

			[pref registerInteger: &alignment default: 1 forKey: @"alignment"];

			[pref registerBool: &locationIndicator default: YES forKey: @"locationIndicator"];

			formatter1 = [[NSDateFormatter alloc] init];
			formatter1.locale = [[NSLocale alloc] initWithLocaleIdentifier: locale];
			formatter1.timeStyle = NSDateFormatterNoStyle;
			formatter1.dateFormat = [NSString stringWithFormat:@"%@\n", format1];

			if(bold1) font1 = [UIFont boldSystemFontOfSize: fontSize1];
			else font1 = [UIFont systemFontOfSize: fontSize1];

			formatter2 = [[NSDateFormatter alloc] init];
			formatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier: locale];
			formatter2.timeStyle = NSDateFormatterNoStyle;
			formatter2.dateFormat = format2;

			if(bold2) font2 = [UIFont boldSystemFontOfSize: fontSize2];
			else font2 = [UIFont systemFontOfSize: fontSize2];

			finalString = [[NSMutableAttributedString alloc] init];

			%init;

			if(!locationIndicator) %init(locationIndicatorGroup);
		}
	}
}