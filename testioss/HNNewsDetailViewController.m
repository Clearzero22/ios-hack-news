//
//  HNNewsDetailViewController.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNNewsDetailViewController.h"
#import <UIKit/UIKit.h>
#import "HNThemeManager.h"

@interface HNNewsDetailViewController ()

@property (nonatomic, strong) HNStory *story;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *metaLabel;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UIButton *openURLButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation HNNewsDetailViewController

- (instancetype)initWithStory:(HNStory *)story {
    self = [super init];
    if (self) {
        _story = story;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self applyHackerTheme];
    [self setupUI];
    [self configureWithStory];
}

- (void)applyHackerTheme {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    // Apply view-specific theme
    self.view.backgroundColor = themeManager.primaryBackgroundColor;
    
    // Update title with hacker style
    self.title = @"🟢 SYSTEM://DETAILS";
    
    // Set navigation appearance
    self.navigationController.navigationBar.backgroundColor = themeManager.primaryBackgroundColor;
    self.navigationController.navigationBar.barTintColor = themeManager.primaryBackgroundColor;
    
    // Force status bar to light content for dark theme
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupUI {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    self.view.backgroundColor = themeManager.primaryBackgroundColor;
    
    // Scroll View
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // Content View
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];
    
    // Card View for content
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = themeManager.cardBackgroundColor;
    cardView.layer.cornerRadius = 12;
    cardView.layer.masksToBounds = NO;
    cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:cardView];
    
    // Apply hacker theme effects
    [themeManager createHackerEffectsForView:cardView];
    
    // Title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:24];
    self.titleLabel.textColor = themeManager.primaryTextColor;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView addSubview:self.titleLabel];
    
    // URL Label
    self.urlLabel = [[UILabel alloc] init];
    self.urlLabel.font = [UIFont fontWithName:@"Courier" size:15];
    self.urlLabel.textColor = themeManager.accentColor;
    self.urlLabel.numberOfLines = 2;
    self.urlLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView addSubview:self.urlLabel];
    
    // Meta Container View
    UIView *metaContainer = [[UIView alloc] init];
    metaContainer.backgroundColor = themeManager.secondaryBackgroundColor;
    metaContainer.layer.cornerRadius = 8;
    metaContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView addSubview:metaContainer];
    
    // Apply hacker effects to meta container
    [themeManager createHackerEffectsForView:metaContainer];
    
    // Meta Label
    self.metaLabel = [[UILabel alloc] init];
    self.metaLabel.font = [UIFont fontWithName:@"Courier" size:15];
    self.metaLabel.textColor = themeManager.primaryTextColor;
    self.metaLabel.numberOfLines = 0;
    self.metaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [metaContainer addSubview:self.metaLabel];
    
    // Open URL Button
    self.openURLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.openURLButton setTitle:@"[ACCESS_TARGET]" forState:UIControlStateNormal];
    self.openURLButton.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:17];
    [self.openURLButton setTitleColor:themeManager.primaryBackgroundColor forState:UIControlStateNormal];
    self.openURLButton.backgroundColor = themeManager.accentColor;
    self.openURLButton.layer.cornerRadius = 8;
    self.openURLButton.layer.shadowColor = themeManager.shadowColor.CGColor;
    self.openURLButton.layer.shadowOffset = CGSizeMake(0, 0);
    self.openURLButton.layer.shadowRadius = 10;
    self.openURLButton.layer.shadowOpacity = 0.6;
    [self.openURLButton addTarget:self action:@selector(openURLButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.openURLButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView addSubview:self.openURLButton];
    
    // Apply hacker effects to button
    [themeManager createHackerEffectsForView:self.openURLButton];
    
    // Loading Indicator
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingIndicator.color = themeManager.accentColor;
    self.loadingIndicator.center = self.view.center;
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.loadingIndicator];
    
    // Apply hacker effects to loading indicator
    [themeManager createHackerEffectsForView:self.loadingIndicator];
    
    [self setupConstraintsWithCardView:cardView metaContainer:metaContainer];
}

- (void)setupConstraintsWithCardView:(UIView *)cardView metaContainer:(UIView *)metaContainer {
    [NSLayoutConstraint activateConstraints:@[
        // Scroll View
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        // Content View
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
        
        // Card View
        [cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20],
        
        // Title Label
        [self.titleLabel.topAnchor constraintEqualToAnchor:cardView.topAnchor constant:24],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:24],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-24],
        
        // URL Label
        [self.urlLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:16],
        [self.urlLabel.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:24],
        [self.urlLabel.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-24],
        
        // Meta Container
        [metaContainer.topAnchor constraintEqualToAnchor:self.urlLabel.bottomAnchor constant:20],
        [metaContainer.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:24],
        [metaContainer.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-24],
        
        // Meta Label
        [self.metaLabel.topAnchor constraintEqualToAnchor:metaContainer.topAnchor constant:16],
        [self.metaLabel.leadingAnchor constraintEqualToAnchor:metaContainer.leadingAnchor constant:16],
        [self.metaLabel.trailingAnchor constraintEqualToAnchor:metaContainer.trailingAnchor constant:-16],
        [self.metaLabel.bottomAnchor constraintEqualToAnchor:metaContainer.bottomAnchor constant:-16],
        
        // Open URL Button
        [self.openURLButton.topAnchor constraintEqualToAnchor:metaContainer.bottomAnchor constant:24],
        [self.openURLButton.centerXAnchor constraintEqualToAnchor:cardView.centerXAnchor],
        [self.openURLButton.bottomAnchor constraintEqualToAnchor:cardView.bottomAnchor constant:-24],
        [self.openURLButton.heightAnchor constraintEqualToConstant:50],
        [self.openURLButton.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:24],
        [self.openURLButton.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-24]
    ]];
}

- (void)configureWithStory {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    // Format title with hacker style
    NSString *title = self.story.title ?: @"[NULL_DATA]";
    self.titleLabel.text = [NSString stringWithFormat:@"> DATA_ENTRY: %@", title];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    NSMutableAttributedString *metaInfo = [[NSMutableAttributedString alloc] init];
    
    // Author with hacker style
    NSString *author = self.story.author ?: @"anonymous";
    NSAttributedString *authorText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"[AUTHOR:%@]", author] 
                                                                      attributes:@{
                                                                          NSFontAttributeName: [UIFont fontWithName:@"Courier-Bold" size:15],
                                                                          NSForegroundColorAttributeName: themeManager.primaryTextColor
                                                                      }];
    [metaInfo appendAttributedString:authorText];
    
    // Score and Comments with hacker style
    NSAttributedString *statsText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n[KARMA:%@] [THREADS:%@]", self.story.score ?: @"0", self.story.commentCount ?: @"0"] 
                                                                      attributes:@{
                                                                          NSFontAttributeName: [UIFont fontWithName:@"Courier" size:15],
                                                                          NSForegroundColorAttributeName: themeManager.secondaryTextColor
                                                                      }];
    [metaInfo appendAttributedString:statsText];
    
    // Date with hacker style
    NSString *dateString = self.story.createdAt ? [formatter stringFromDate:self.story.createdAt] : @"UNKNOWN_TIMESTAMP";
    NSAttributedString *dateText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n[CREATED:%@]", dateString] 
                                                                    attributes:@{
                                                                        NSFontAttributeName: [UIFont fontWithName:@"Courier" size:15],
                                                                        NSForegroundColorAttributeName: themeManager.secondaryTextColor
                                                                    }];
    [metaInfo appendAttributedString:dateText];
    
    self.metaLabel.attributedText = metaInfo;
    
    if (self.story.url) {
        NSURL *url = [NSURL URLWithString:self.story.url];
        NSString *domain = url.host ?: @"unknown.host";
        if ([domain hasPrefix:@"www."]) {
            domain = [domain substringFromIndex:4];
        }
        self.urlLabel.text = [NSString stringWithFormat:@"[TARGET] %@/", domain];
        self.openURLButton.hidden = NO;
    } else {
        self.urlLabel.text = @"[SOURCE] local_system/";
        self.openURLButton.hidden = YES;
    }
}

- (void)openURLButtonTapped {
    if (!self.story.url) return;
    
    NSURL *url = [NSURL URLWithString:self.story.url];
    if (!url) return;
    
    // Add haptic feedback
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];
    
    // Open URL in Safari
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end