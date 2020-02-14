//
//  OpenCV.m
//  VTTF
//
//  Created by tyai on 2019/12/26.
//  Copyright © 2019 cm.is.ritsumei.ac.jp. All rights reserved.
//

//
//  OpenCV.m
//  final
//
//  Created by tyai on 2019/12/26.
//  Copyright © 2019 tyai. All rights reserved.
//

// OpenCV.mm

#import <opencv2/opencv.hpp>
#import <opencv2/highgui.hpp>
#import <opencv2/imgcodecs/ios.h>

#import "OpenCV.h" //ライブラリによってはNOマクロがバッティングするので，これは最後にimport

int counter = 0;
int threshold = 20;
std::vector<cv::KeyPoint> pre_keypoints; //特徴点
cv::Mat pre_descriptors; //特徴量

//初期パラメータ
int nfeatures = 50;
float scaleFactor = 1.2f;
int nlevels = 8;
int edgeThreshold = 31;
int firstLevel = 0;
int WTA_K = 4;
cv::ORB::ScoreType scoreType = cv::ORB::HARRIS_SCORE;
int patchSize = 31;
int fastThreshold = 20;

auto orb = cv::ORB::create(nfeatures,scaleFactor,nlevels,edgeThreshold,
                           firstLevel,WTA_K,scoreType,patchSize,fastThreshold);
@implementation OpenCV

float prev_dx = 0.0;
float prev_dy = 0.0;

- (CGPoint)toCoordinate:(UIImage*)img {
    cv::Mat grayed;
    float dx = prev_dx;
    float dy = prev_dy;
    if(counter == threshold) {
        UIImageToMat(img,grayed);
        cv::cvtColor(grayed, grayed, cv::COLOR_BGR2GRAY);
        cv::blur(grayed, grayed, cv::Size(15,15));
        orb->detect(grayed,pre_keypoints);
        orb->compute(grayed,pre_keypoints,pre_descriptors);
    } else if( counter > threshold ){
        UIImageToMat(img,grayed);
        cv::cvtColor(grayed, grayed, cv::COLOR_BGR2GRAY);
        cv::blur(grayed, grayed, cv::Size(15,15));
        
        std::vector<cv::KeyPoint> keypoints;
        cv::Mat descriptors;
        orb->detect(grayed,keypoints);
        orb->compute(grayed,keypoints,descriptors);

        std::vector<cv::DMatch> matches;
        cv::BFMatcher matcher(cv::NORM_HAMMING,true);
        // NSLog(@"pre_descriptors = %zu",pre_descriptors.total());
        // NSLog(@"descriptors = %zu",descriptors.total());
        if(descriptors.total() != 0){
            matcher.match(pre_descriptors, descriptors, matches);
        }
        
        std::vector<float> offsets;
        for(int i=0;i<matches.size();i++) {
            for(int j=i;j<matches.size();j++) {
                if(matches[i].distance > matches[j].distance) {
                    cv::DMatch tmp = matches[i];
                    matches[i] = matches[j];
                    matches[j] = tmp;
                }
            }
            float offset = std::sqrt(std::pow((keypoints[matches[i].trainIdx].pt.x - pre_keypoints[matches[i].queryIdx].pt.x), 2.0) + std::pow((keypoints[matches[i].trainIdx].pt.y - pre_keypoints[matches[i].queryIdx].pt.y), 2.0));
            offsets.push_back(offset);
            //NSLog(@"i = %d, distance = %f, offset = %f", i, matches[i].distance, offset);
        }
        
        NSLog(@"matches = %zu, avg = %f, stddev = %f", matches.size(), mean(offsets), stddev(offsets));

        if(matches.size() > 0) {
            float md = median(offsets);
            // float sd = stddev(offsets);
            int idx = -1;
            for(int i=0;i<offsets.size();i++) {
                if(offsets[i] <= md + 2.0 && offsets[i] >= md - 2.0) {
                    idx = i;
                    break;
                }
            }

            if(idx >= 0 && matches[idx].distance < 50) {
                float distance = matches[idx].distance;
            
                dx = keypoints[matches[idx].trainIdx].pt.x - pre_keypoints[matches[idx].queryIdx].pt.x;
                dy = keypoints[matches[idx].trainIdx].pt.y - pre_keypoints[matches[idx].queryIdx].pt.y;
                prev_dx = dx;
                prev_dy = dy;

                NSLog(@"distance = %f, coord = (%f, %f), offset = %f)", distance, dx, dy, offsets[idx]);
            }
        }

    }
    
    counter += 1;
    CGPoint point = CGPointMake(dx, dy);
    return point;
}

float mean(std::vector<float> v) {
    float m = 0;
    for(int i=0;i<v.size();i++) {
        m += v[i];
    }
    m /= v.size();
    return m;
}

float median(std::vector<float> v) {
  size_t size = v.size();
  float *t = new float[size];
  std::copy(v.begin(), v.end(), t);
  std::sort(t, &t[size]);
  float result = size%2 ? t[size/2] : (t[(size/2)-1]+t[size/2])/2;
  delete[] t;
  return result;
}

float variance(std::vector<float> v) {
    float m = mean(v);
    float sqdiff = 0;
    for(int i=0;i<v.size();i++) {
        sqdiff += (v[i]-m)*(v[i]-m);
    }
    float result = sqdiff/v.size();
    return result;
}

float stddev(std::vector<float> v) {
    return std::sqrt(variance(v));
}

- (void)resetCounter {
    counter = 0;
    prev_dx = 0.0;
    prev_dy = 0.0;
}

@end
