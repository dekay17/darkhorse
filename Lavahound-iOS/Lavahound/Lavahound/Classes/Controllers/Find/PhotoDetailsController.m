//
//  PhotoDetailsController.m
//  Lavahound
//
//  Created by Mark Allen on 4/29/11.
//  Copyright 2011 Transmogrify LLC. All rights reserved.
//

#import "PhotoDetailsController.h"
#import "UIViewController+Lavahound.h"
#import "TTModelViewController+Lavahound.h"
#import "PhotoDetailsModel.h"
#import "Constants.h"
#import "NSString+Lavahound.h"


@interface PhotoDetailsController(PrivateMethods)

//- (void)flipViewsWithAnimationTransition:(UIViewAnimationTransition)animationTransition;
- (void)EventToggleSelected:(UIButton*)SelectedButton;
- (void)Highlight:(UIButton*)Button;

@end

@implementation PhotoDetailsController

static int const TAG_PHOTO  = 2;
static int const TAG_INFO   = 1;
static int const TAG_MAP    = 3;

- (id)initWithPhotoId:(NSNumber *)photoId
{   
    if((self = [super initWithNibName:nil bundle:nil]))
    {
        _photoDetailFrontView = nil;
        _photoDetailBackView = nil;
        
        _photoId = [photoId retain];
        
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:nil
                                                                                 action:nil] autorelease];
        [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveLavahoundApiDataChangedNotification:) 
                                                     name:kLavahoundApiDataChangedNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];     

    TT_RELEASE_SAFELY(_photoDetailFrontView);
    TT_RELEASE_SAFELY(_photoDetailBackView);
    TT_RELEASE_SAFELY(_photoId);
    [btnPhoto removeFromSuperview];
    [btnPhoto release];
    btnPhoto = nil;
    [btnInfo removeFromSuperview];
    [btnInfo release];
    btnInfo = nil;
    [FlipView removeFromSuperview];
    [FlipView release];
    FlipView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad
{
    UIImageView * BackgroundImage   = nil;
    UIButton    * btnMap            = nil;
    
    [super viewDidLoad];

    BackgroundImage = [[UIImageView alloc] initWithImage:TTIMAGE(@"bundle://aboutPageBG.png")];
    btnPhoto        = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    btnInfo         = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    btnMap          = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

    [btnInfo    setFrame:CGRectMake(010.0f, 10.0f, 105.0f, 30.0f)];
    [btnPhoto   setFrame:CGRectMake(115.0f, 10.0f, 105.0f, 30.0f)];
    [btnMap     setFrame:CGRectMake(226.0f, 10.0f, 085.0f, 30.0f)];
    [btnInfo    setImage:[UIImage imageNamed:@"InfoInactv.png"]     forState:UIControlStateNormal];
    [btnInfo    setImage:[UIImage imageNamed:@"InfoActv.png"]       forState:UIControlStateSelected];
    [btnPhoto   setImage:[UIImage imageNamed:@"PhotoActv.png"]    forState:UIControlStateNormal];
    [btnPhoto   setImage:[UIImage imageNamed:@"PhotoActv.png"]      forState:UIControlStateSelected];
    [btnMap     setImage:[UIImage imageNamed:@"btnMapIt.png"]       forState:UIControlStateNormal];
    [btnPhoto   setTag:TAG_PHOTO];
    [btnInfo    setTag:TAG_INFO];
    [btnMap     setTag:TAG_MAP];
    [btnPhoto   setSelected:TRUE];
    [btnPhoto   addTarget:self action:@selector(EventToggleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [btnInfo    addTarget:self action:@selector(EventToggleSelected:) forControlEvents:UIControlEventTouchUpInside];
    [btnMap     addTarget:self action:@selector(EventToggleSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [_modelView addSubview:BackgroundImage];
    [_modelView addSubview:btnPhoto];
    [_modelView addSubview:btnInfo];
    [_modelView addSubview:btnMap];
    
    [BackgroundImage release];
    [btnMap release];
    
    FlipView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 320.0f, 317.0f)];
    
    _photoDetailFrontView = [[LoadingAwareImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, FlipView.frame.size.width, FlipView.frame.size.height)];
    
    _photoDetailBackView = [[PhotoDetailBackView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, FlipView.frame.size.width, FlipView.frame.size.height)];
    _photoDetailBackView.delegate = self;
    [_photoDetailBackView setHidden:TRUE];
    
    [FlipView addSubview:_photoDetailFrontView];
    [FlipView addSubview:_photoDetailBackView];
    [_modelView addSubview:FlipView];
}

- (void)EventToggleSelected:(UIButton*)SelectedButton
{
    if ((SelectedButton.tag == TAG_PHOTO) && (!btnPhoto.selected))
    {
        [UIView transitionWithView:FlipView
                          duration:0.4f
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseInOut
                        animations:^
                                 {
                                     [_photoDetailBackView setHidden:TRUE];
                                 }
                        completion:nil];
        
        [btnInfo    setImage:[UIImage imageNamed:@"InfoInactv.png"]     forState:UIControlStateNormal];
        [btnPhoto   setImage:[UIImage imageNamed:@"PhotoActv.png"]    forState:UIControlStateNormal];
        
        [self performSelector:@selector(Highlight:) withObject:SelectedButton afterDelay:0.0f];
        [btnInfo setSelected:FALSE];
    }
    else if ((SelectedButton.tag == TAG_INFO) && (!btnInfo.selected))
    {
        [UIView transitionWithView:FlipView
                          duration:0.4f
                           options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseInOut
                        animations:^
         {
             [_photoDetailBackView setHidden:FALSE];
         }
                        completion:nil];
        
        [btnInfo    setImage:[UIImage imageNamed:@"InfoActv.png"]     forState:UIControlStateNormal];
        [btnPhoto   setImage:[UIImage imageNamed:@"PhotoInactv.png"]    forState:UIControlStateNormal];

        [self performSelector:@selector(Highlight:) withObject:SelectedButton afterDelay:0.0f];
        [btnPhoto setSelected:FALSE];
    }
    else if (SelectedButton.tag == TAG_MAP)
    {
        KeepFoundItVisible = TRUE;
        Photo *photo = ((PhotoDetailsModel *)self.model).photo;
        [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[photo URLValueWithName:@"map-it"]] applyAnimated:YES]];
    }
}

- (void) EventFoundItSelected
{
    LavahoundMarkPhotoFoundApi *lavahoundMarkPhotoFoundApi = [[[LavahoundMarkPhotoFoundApi alloc] init] autorelease];
    lavahoundMarkPhotoFoundApi.delegate = self;
    [lavahoundMarkPhotoFoundApi markFoundWithPhotoId:_photoId];
}

- (void)Highlight:(UIButton*)Button
{
    [Button setSelected:TRUE];
}

- (void)viewWillDisappear:(BOOL)animated
{
    TabBarController * TabController = nil;
    
    [super viewWillDisappear:animated];
    
    if (!KeepFoundItVisible)
    {
        TabController = (TabBarController*) self.tabBarController;
        [TabController setFoundItButtonVisibility:FALSE animated:TRUE];
    }
    
    KeepFoundItVisible = FALSE;
}

- (void)viewDidUnload
{
    [_photoDetailFrontView removeFromSuperview];
    TT_RELEASE_SAFELY(_photoDetailFrontView);
    [_photoDetailBackView removeFromSuperview];
    TT_RELEASE_SAFELY(_photoDetailBackView);    
    [btnPhoto removeFromSuperview];
    [btnPhoto release];
    btnPhoto = nil;
    [btnInfo removeFromSuperview];
    [btnInfo release];
    btnInfo = nil;
    [FlipView removeFromSuperview];
    [FlipView release];
    FlipView = nil;

    [super viewDidUnload];        
}

#pragma mark -
#pragma mark TTModelViewController

- (void)createModel {
    self.model = [[[PhotoDetailsModel alloc] initWithPhotoId:_photoId] autorelease];  
}

- (void)didShowModel:(BOOL)firstTime
{
    TabBarController * TabController = nil;
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;
    
    if(photo.owner)
    {
        [self setTitleWithLavahoundFont:@"your photo"];
    }
    else
    {
        if(photo.found)
        {
            [self setTitleWithLavahoundFont:@"you found this!"];
        }
        else
        {
            [self setTitleWithLavahoundFont:@"find this!"];
            TabController = (TabBarController*) self.tabBarController;
            [TabController setFoundItButtonVisibility:TRUE animated:TRUE];
        }
    }
    
    _photoDetailFrontView.imageUrl = photo.imageUrl;    
    _photoDetailBackView.photo = photo;
}

#pragma mark -
#pragma mark LavahoundMarkPhotoFoundApiDelegate

- (void)lavahoundMarkPhotoFoundApi:(LavahoundMarkPhotoFoundApi *)lavahoundMarkPhotoFoundApi didMarkFoundWithMessage:(NSString *)message points:(NSNumber *)points {
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;    
    NSString *url = [NSString stringWithFormat:@"lavahound://found/%@/%@/%@", photo.photoId, [message urlEncode], points];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:url] applyAnimated:YES]];
}

#pragma mark -
#pragma mark PhotoDetailBackViewDelegate

- (void)photoDetailBackViewDidTouchUpInFlagButton:(PhotoDetailBackView *)photoDetailBackViewDelegate {
    KeepFoundItVisible = TRUE;
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[photo URLValueWithName:@"flag"]] applyAnimated:YES]];

}

- (void)photoDetailBackViewDidTouchUpInShareButton:(PhotoDetailBackView *)photoDetailBackViewDelegate {
    KeepFoundItVisible = TRUE;
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;    
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[photo URLValueWithName:@"share-modal"]] applyAnimated:YES]];
}

//- (void)flipViewsWithAnimationTransition:(UIViewAnimationTransition)animationTransition {
//    [_infoButton setSelected:[_flipContainerView.subviews objectAtIndex:0] == _photoDetailBackView];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [UIView beginAnimations:nil context:context];
//    [UIView setAnimationTransition:animationTransition forView:_flipContainerView cache:YES];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.6];
//    [_flipContainerView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
//    [UIView commitAnimations]; 
//}
//
//- (void)didTouchUpInInfoButton {
//    [self flipViewsWithAnimationTransition:UIViewAnimationTransitionFlipFromLeft];
//}
//
//- (void)didSwipeFlipContainerViewLeft:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
//    [self flipViewsWithAnimationTransition:UIViewAnimationTransitionFlipFromRight];
//}
//
//- (void)didSwipeFlipContainerViewRight:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
//    [self flipViewsWithAnimationTransition:UIViewAnimationTransitionFlipFromLeft];
//}

//- (void)didTouchUpInFoundButton {
//    LavahoundMarkPhotoFoundApi *lavahoundMarkPhotoFoundApi = [[[LavahoundMarkPhotoFoundApi alloc] init] autorelease];
//    lavahoundMarkPhotoFoundApi.delegate = self;
//    [lavahoundMarkPhotoFoundApi markFoundWithPhotoId:_photoId];    
//}

//- (void)didTouchUpInMapItButton
//{
//    Photo *photo = ((PhotoDetailsModel *)self.model).photo;
//    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:[photo URLValueWithName:@"map-it"]] applyAnimated:YES]];
//}

- (void)didReceiveLavahoundApiDataChangedNotification:(NSNotification *)notification
{
    TabBarController * TabController = nil;    
    Photo *photo = ((PhotoDetailsModel *)self.model).photo;
    
    if (!(photo.found || photo.owner))
    {
    }
    else
    {
        TabController = (TabBarController*) self.tabBarController;
        [TabController setFoundItButtonVisibility:FALSE animated:TRUE];
    }
}

@end