# BunbunuCustom

###### 抽些空檔將這些年來做過的custom view 整理在這個專案

======
#### Circle Progress ImageView
###### 設定原圖片和準備加載圖片
```swift
demoCircleProgressImageView.image = old_image
demoCircleProgressImageView.newImage = new_image
```

###### 參數為 NSProgress
```swift
demoCircleProgressImageView.progress = progress
```

###### 自定義成功和失敗 closure
```swift
demoCircleProgressImageView.completion = {
  //what you want to do when upload succeed, this will execute the code block after the animtaion finished
}
demoCircleProgressImageView.failure = {
  //what you want to do when upload failed
}
```
###### Public Method
  * func progressSucceed()
  * func progressFailed()
  * func resetProgress()

###### 補充
1. 使用 CADisplayLink 補齊中間進度動畫
2. 進度動畫 100% 結束前已透過 progressSucceed() 指定成功狀態，則會在進度完成時自動運行成功動畫
3. 進度至 100% 仍未指定成功或失敗，則會停留在等待狀態，並不會預設成功
4. 中途更改狀態為失敗，會中止目前進度，立即開始失敗動畫將進度條歸零並回復原本圖片
5. ContentMode 只實做出 AspectFil 和 AspectFill

![CircleProgressImageView](https://cloud.githubusercontent.com/assets/3096210/16812199/a9c232f4-495e-11e6-80fd-ac1742e25be5.gif)

======
#### Toggle Button
![ToggleButton](https://cloud.githubusercontent.com/assets/3096210/16812215/b50f94d0-495e-11e6-8f40-dd2a8cf506fa.gif)

======
#### Style Button
![StyleButton](https://cloud.githubusercontent.com/assets/3096210/15464680/416bf128-2103-11e6-8ede-11af3645c6b8.png)

##License
This project is under MIT License. See LICENSE file for more information.
