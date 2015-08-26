# FDCalendar
A custom calendar control in iOS

# Introduction

FDCalendar is a custom calendar control which includes world and chinese calendar date. It supports scrolling by left and right to jump to previous or next month date, also it can jump to the date which is selected. Otherwise it seems beautiful and good using. If you want to change some style of it, you need to fork it and modify the properties by yourself. If you think it is helpful, please star it.

## Preview

![preview](http://7xiamc.com1.z0.glb.clouddn.com/preview.gif)

## ScreenShot

![one](http://7xiamc.com1.z0.glb.clouddn.com/screenshot1.png)
![two](http://7xiamc.com1.z0.glb.clouddn.com/screenshot2.png)
![two](http://7xiamc.com1.z0.glb.clouddn.com/screenshot3.png)

# Get started

1. Download the source file in the folder FDCalendar.
2. Add the FDCalendar.h and FDCalendar.m files to your project.
3. Import the FDCalendar.h file where you want to use it. Jsut add a instance of it to your view as a subview.

# Usage

## FDCalendar

- The instance of it is init with a date, and you don't have to set it's frame but change it's frame's origin to show it at th position you like.

```Objective-C
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame = calendar.frame;
    frame.origin.y = 20;
    calendar.frame = frame;
    [self.view addSubview:calendar];
```

#License
  MIT
