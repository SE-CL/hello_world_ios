# Hello World Flutter 应用

这是一个最小 Flutter 跨平台应用，启动后显示“我的第一个应用”和 `Hello World`。

## 在 Windows 电脑上运行

使用 Flutter 3.44.8 stable（不要使用 PATH 中的旧 master SDK）：

```powershell
$env:ANDROID_HOME = 'C:\Users\SE\AppData\Local\Android\Sdk'
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$flutter = 'E:\code\auto\sdk\flutter_windows_3.44.8-stable\flutter\bin\flutter.bat'
& $flutter pub get
& $flutter run -d chrome
```

也可以直接打开已构建的 Web 版本：

```powershell
python -m http.server 8080 --directory build\web
```

然后访问 <http://localhost:8080>。

## 平台说明

- Android 工程位于 `android/`，由 Gradle 构建；Maven 只能作为依赖仓库或 Java 项目工具，不能替代 Flutter Android 构建所需的 Gradle。
- iOS 工程位于 `ios/`。生成 IPA 必须在 macOS 上安装 Xcode，并配置 Apple 开发者签名；Windows 不能直接编译或签名 IPA。
- `windows/` 和 `web/` 已生成，可分别用于 Windows 桌面和浏览器运行。Windows 桌面构建还需要 Visual Studio 的“Desktop development with C++”工作负载。

## 使用 GitHub Actions 生成 iOS IPA

推送到 `main` 分支、提交面向 `main` 的 Pull Request，或在 GitHub 的 Actions 页面手动运行 `Build unsigned iOS IPA`，都会在 GitHub 的 macOS Runner 上执行 iOS 构建。

构建成功后，在对应的 Actions Run 页面下载名为 `hello_world_ios-unsigned-ipa` 的 Artifact。里面包含 `hello_world_ios-unsigned.ipa`。

该文件没有 Apple 签名，可用于确认 iOS 工程能够编译，但不能直接安装到普通 iPhone 或 iPad。要生成可安装的 IPA，需要 Apple Developer 证书、Provisioning Profile 和对应的 Bundle Identifier，并在工作流中配置签名。

当前项目的最低 iOS 部署版本为 iOS 13.0。

## 验证

```powershell
& $flutter analyze
& $flutter test
& $flutter build web
```
