//
//  ViewController.m
//  ios_zbar_test
//
//  Created by i404 on 15/10/22.
//  Copyright © 2015年 i404. All rights reserved.
//

#import "ViewController.h"
#include "zbar.h"
#include "iostream"
#include "opencv2.framework/Headers/opencv.hpp"

using namespace zbar;
using namespace cv;
using namespace std;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Enter Load\n");
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"png"];
    char *path = (char*)[filePath UTF8String];
    
    Mat img = imread(path);
    Mat qrcode_gray;
    if (img.empty())
    {
        cout << "打开图像失败！" << endl;
        return;
    }
    
    cv::cvtColor(img, qrcode_gray, CV_BGR2GRAY);
    
    ImageScanner scanner;
    scanner.set_config(ZBAR_NONE, ZBAR_CFG_ENABLE, 1);
    int width  = qrcode_gray.cols;
    int height = qrcode_gray.rows;
    uchar *raw = (uchar *)(qrcode_gray.data);
    
    cout<<width<<' '<<height<<endl;
    
    zbar::Image z_image(width, height, "Y800", raw, width * height);
    scanner.scan(z_image);
    cout<<"scan done"<<endl;

    for (Image::SymbolIterator symbol = z_image.symbol_begin(); symbol != z_image.symbol_end(); ++symbol)
    {
        cout<< "decoded " << symbol->get_type_name()
        << " symbol \"" << symbol->get_data() << '"' << endl;
    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
