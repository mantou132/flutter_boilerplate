# flutter_boilerplate

A new Flutter project.

## TODO

- env
- android file choose
- ios disable bouncing
- launch_background + MaterialAppBackgroundColor + WebViewBackground

## Note

### /android/app/src/main/AndroidManifest.xml
```
android:usesCleartextTraffic="true"
```

### /ios/Runner/Info.plist
```
<key>io.flutter.embedded_views_preview</key>
<true/>
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```